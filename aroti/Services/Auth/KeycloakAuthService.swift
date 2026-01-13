//
//  KeycloakAuthService.swift
//  Aroti
//
//  OAuth PKCE flow implementation for Keycloak authentication
//

import Foundation
import UIKit
import AuthenticationServices
import CryptoKit

class KeycloakAuthService: NSObject {
    static let shared = KeycloakAuthService()
    
    private var authSession: ASWebAuthenticationSession?
    private var codeVerifier: String?
    
    private init() {
        super.init()
    }
    
    // MARK: - OAuth Configuration
    
    private var authorizationURL: URL {
        let baseURL = APIConfiguration.keycloakURL
        var components = URLComponents(string: "\(baseURL)/realms/aroti/protocol/openid-connect/auth")!
        
        // Generate PKCE parameters
        let (codeVerifier, codeChallenge) = generatePKCE()
        self.codeVerifier = codeVerifier
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "aroti-ios"),
            URLQueryItem(name: "redirect_uri", value: "com.aroti.app://oauth/callback"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "openid profile email offline_access"),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "state", value: generateState())
        ]
        
        return components.url!
    }
    
    private var tokenURL: URL {
        let baseURL = APIConfiguration.keycloakURL
        return URL(string: "\(baseURL)/realms/aroti/protocol/openid-connect/token")!
    }
    
    // MARK: - PKCE Generation
    
    private func generatePKCE() -> (verifier: String, challenge: String) {
        // Generate code verifier (43-128 characters, URL-safe)
        let verifier = generateRandomString(length: 64)
        
        // Generate code challenge (SHA256 hash of verifier, base64url encoded)
        let challenge = sha256Base64URL(verifier)
        
        return (verifier, challenge)
    }
    
    private func generateRandomString(length: Int) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        return String((0..<length).map { _ in characters.randomElement()! })
    }
    
    private func sha256Base64URL(_ string: String) -> String {
        let data = Data(string.utf8)
        let hash = SHA256.hash(data: data)
        let base64 = Data(hash).base64EncodedString()
        
        // Convert to base64url (replace + with -, / with _, remove = padding)
        return base64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    private func generateState() -> String {
        return generateRandomString(length: 32)
    }
    
    // MARK: - OAuth Flow
    
    func startAuthFlow() async throws -> AuthToken {
        return try await withCheckedThrowingContinuation { continuation in
            let authSession = ASWebAuthenticationSession(
                url: authorizationURL,
                callbackURLScheme: "com.aroti.app"
            ) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: AuthError.authFlowFailed(error.localizedDescription))
                    return
                }
                
                guard let callbackURL = callbackURL,
                      let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                      let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                    continuation.resume(throwing: AuthError.authFlowFailed("No authorization code received"))
                    return
                }
                
                // Exchange code for tokens
                Task {
                    do {
                        let token = try await self.exchangeCodeForToken(code: code)
                        continuation.resume(returning: token)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = true
            
            self.authSession = authSession
            
            DispatchQueue.main.async {
                authSession.start()
            }
        }
    }
    
    // MARK: - Token Exchange
    
    private func exchangeCodeForToken(code: String) async throws -> AuthToken {
        guard let codeVerifier = codeVerifier else {
            throw AuthError.authFlowFailed("Code verifier not found")
        }
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "client_id", value: "aroti-ios"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "com.aroti.app://oauth/callback"),
            URLQueryItem(name: "code_verifier", value: codeVerifier)
        ]
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.authFlowFailed("Token exchange failed")
        }
        
        let decoder = JSONDecoder()
        let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
        
        // Calculate expiration date
        let expiresAt = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
        
        return AuthToken(
            accessToken: tokenResponse.accessToken,
            refreshToken: tokenResponse.refreshToken,
            expiresAt: expiresAt
        )
    }
    
    // MARK: - Token Refresh
    
    func refreshToken(refreshToken: String) async throws -> AuthToken {
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "client_id", value: "aroti-ios"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.refreshFailed("Token refresh failed")
        }
        
        let decoder = JSONDecoder()
        let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
        
        // Calculate expiration date
        let expiresAt = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
        
        return AuthToken(
            accessToken: tokenResponse.accessToken,
            refreshToken: tokenResponse.refreshToken ?? refreshToken, // Use new refresh token if provided
            expiresAt: expiresAt
        )
    }
}

// MARK: - ASWebAuthenticationPresentationContextProviding

extension KeycloakAuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // Return the main window
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}

// MARK: - Token Response Model

private struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

