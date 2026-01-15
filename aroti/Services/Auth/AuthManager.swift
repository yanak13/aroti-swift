//
//  AuthManager.swift
//  Aroti
//
//  Token storage and management using Keychain
//

import Foundation
import Security

class AuthManager {
    static let shared = AuthManager()
    
    private let keychainService = "com.aroti.app"
    private let tokenKey = "auth_token"
    
    private init() {}
    
    // MARK: - Token Management
    
    func saveToken(_ token: AuthToken) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(token)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: data
        ]
        
        // Delete existing item first
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw AuthError.saveFailed
        }
        
        // Update APIClient with token
        APIClient.shared.setAuthToken(token.accessToken)
    }
    
    func getToken() throws -> AuthToken? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data else {
            if status == errSecItemNotFound {
                return nil
            }
            throw AuthError.retrieveFailed
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let token = try decoder.decode(AuthToken.self, from: data)
            
            // Check if token is expired
            if token.isExpired {
                // Token expired, remove it
                try? deleteToken()
                return nil
            }
            
            // Update APIClient with current token
            APIClient.shared.setAuthToken(token.accessToken)
            
            return token
        } catch {
            throw AuthError.decodeFailed
        }
    }
    
    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: tokenKey
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AuthError.deleteFailed
        }
        
        // Clear token from APIClient
        APIClient.shared.setAuthToken(nil)
    }
    
    func hasValidToken() -> Bool {
        guard let token = try? getToken() else {
            return false
        }
        return !token.isExpired
    }
    
    // MARK: - Current Token Access
    
    var currentToken: String? {
        guard let token = try? getToken() else {
            return nil
        }
        return token.accessToken
    }
    
    // MARK: - Token Refresh
    
    func refreshToken() async throws -> AuthToken {
        guard let currentToken = try getToken(),
              let refreshToken = currentToken.refreshToken else {
            throw AuthError.noRefreshToken
        }
        
        // Use KeycloakAuthService to refresh token
        let newToken = try await KeycloakAuthService.shared.refreshToken(refreshToken: refreshToken)
        
        // Save new token
        try saveToken(newToken)
        
        return newToken
    }
    
    func refreshIfNeeded() async throws {
        guard let token = try getToken() else {
            return // No token to refresh
        }
        
        // Check if token expires in less than 5 minutes
        if let expiresAt = token.expiresAt {
            let timeUntilExpiry = expiresAt.timeIntervalSinceNow
            if timeUntilExpiry < 300 { // 5 minutes
                _ = try await refreshToken()
            }
        }
    }
}

// MARK: - Auth Errors

enum AuthError: Error, LocalizedError {
    case saveFailed
    case retrieveFailed
    case deleteFailed
    case decodeFailed
    case noRefreshToken
    case refreshFailed(String)
    case authFlowFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save authentication token"
        case .retrieveFailed:
            return "Failed to retrieve authentication token"
        case .deleteFailed:
            return "Failed to delete authentication token"
        case .decodeFailed:
            return "Failed to decode authentication token"
        case .noRefreshToken:
            return "No refresh token available"
        case .refreshFailed(let message):
            return "Token refresh failed: \(message)"
        case .authFlowFailed(let message):
            return "Authentication flow failed: \(message)"
        }
    }
}
