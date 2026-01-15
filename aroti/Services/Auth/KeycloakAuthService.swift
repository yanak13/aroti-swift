//
//  KeycloakAuthService.swift
//  Aroti
//
//  OAuth PKCE flow implementation for Keycloak
//

import Foundation
import AuthenticationServices
import CryptoKit

@MainActor
class KeycloakAuthService {
    static let shared = KeycloakAuthService()
    
    private let clientId = "aroti-ios"
    private let redirectURI = "com.aroti.app://oauth/callback"
    private let scopes = "openid profile email offline_access"
    
    private init() {}
    
    // MARK: - PKCE Generation
    
    private func generateCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        return Data(buffer).base64URLEncodedString()
    }
    
    private func generateCodeChallenge(verifier: String) -> String {
        let data = verifier.data(using: .utf8)!
        let hash = SHA256.hash(data: data)
        return Data(hash).base64URLEncodedString()
    }
    
    // MARK: - OAuth Flow
    
    func startAuthFlow() async throws -> AuthToken {
        // Generate PKCE parameters
        let codeVerifier = generateCodeVerifier()
        let codeChallenge = generateCodeChallenge(verifier: codeVerifier)
        let state = UUID().uuidString
        
        // Build authorization URL
        var components = URLComponents(string: "\(APIConfiguration.keycloakURL)/realms/aroti/protocol/openid-connect/auth")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scopes),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "state", value: state)
        ]
        
        guard let authURL = components.url else {
            throw AuthError.authFlowFailed("Invalid authorization URL")
        }
        
        // Perform authentication
        let authCode = try await performAuthentication(url: authURL, state: state)
        
        // Exchange code for tokens
        let token = try await exchangeCodeForTokens(code: authCode, codeVerifier: codeVerifier)
        
        return token
    }
    
    private func performAuthentication(url: URL, state: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            let presentationContextProvider = AuthPresentationContextProvider()
            let session = ASWebAuthenticationSession(
                url: url,
                callbackURLScheme: "com.aroti.app"
            ) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let callbackURL = callbackURL,
                      let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
                      let queryItems = components.queryItems else {
                    continuation.resume(throwing: AuthError.authFlowFailed("Invalid callback URL"))
                    return
                }
                
                // Verify state
                guard let returnedState = queryItems.first(where: { $0.name == "state" })?.value,
                      returnedState == state else {
                    continuation.resume(throwing: AuthError.authFlowFailed("State mismatch"))
                    return
                }
                
                // Extract authorization code
                guard let code = queryItems.first(where: { $0.name == "code" })?.value else {
                    continuation.resume(throwing: AuthError.authFlowFailed("No authorization code"))
                    return
                }
                
                continuation.resume(returning: code)
            }
            
            session.presentationContextProvider = presentationContextProvider
            session.start()
        }
    }
    
    private func exchangeCodeForTokens(code: String, codeVerifier: String) async throws -> AuthToken {
        let tokenURL = URL(string: "\(APIConfiguration.keycloakURL)/realms/aroti/protocol/openid-connect/token")!
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "grant_type": "authorization_code",
            "client_id": clientId,
            "code": code,
            "redirect_uri": redirectURI,
            "code_verifier": codeVerifier
        ]
        
        request.httpBody = body.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
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
        let tokenURL = URL(string: "\(APIConfiguration.keycloakURL)/realms/aroti/protocol/openid-connect/token")!
        
        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = [
            "grant_type": "refresh_token",
            "client_id": clientId,
            "refresh_token": refreshToken
        ]
        
        request.httpBody = body.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw AuthError.refreshFailed("Token refresh failed")
        }
        
        let decoder = JSONDecoder()
        let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
        
        let expiresAt = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
        
        return AuthToken(
            accessToken: tokenResponse.accessToken,
            refreshToken: tokenResponse.refreshToken ?? refreshToken,
            expiresAt: expiresAt
        )
    }
}

// MARK: - Supporting Types

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

// MARK: - Presentation Context Provider

private class AuthPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}

// MARK: - Base64 URL Encoding Extension

extension Data {
    func base64URLEncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
    }
}