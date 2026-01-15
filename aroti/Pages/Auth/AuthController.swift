//
//  AuthController.swift
//  Aroti
//
//  Authentication state management
//

import Foundation

@MainActor
class AuthController: ObservableObject {
    static let shared = AuthController()
    
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: AuthError?
    
    private init() {
        checkAuthStatus()
    }
    
    // MARK: - Auth Status
    
    func checkAuthStatus() {
        do {
            if let token = try AuthManager.shared.getToken(), !token.isExpired {
                isAuthenticated = true
            } else {
                isAuthenticated = false
            }
        } catch {
            isAuthenticated = false
        }
    }
    
    // MARK: - Login
    
    func login() async {
        isLoading = true
        error = nil
        
        do {
            let token = try await KeycloakAuthService.shared.startAuthFlow()
            try AuthManager.shared.saveToken(token)
            isAuthenticated = true
        } catch let authError as AuthError {
            error = authError
            isAuthenticated = false
        } catch let err {
            error = AuthError.authFlowFailed(err.localizedDescription)
            isAuthenticated = false
        }
        
        isLoading = false
    }
    
    // MARK: - Skip Auth (Development/Testing)
    
    func skipAuth() {
        // Create a mock token for development/testing
        let mockToken = AuthToken(
            accessToken: "skip-auth-mock-token-\(UUID().uuidString)",
            refreshToken: "skip-auth-mock-refresh-\(UUID().uuidString)",
            expiresAt: Date().addingTimeInterval(86400 * 365) // 1 year from now
        )
        
        do {
            try AuthManager.shared.saveToken(mockToken)
            isAuthenticated = true
            self.error = nil
        } catch {
            // If saving fails, still set as authenticated for development
            isAuthenticated = true
            self.error = nil
        }
    }
    
    // MARK: - Logout
    
    func logout() {
        do {
            try AuthManager.shared.deleteToken()
            isAuthenticated = false
        } catch {
            // Log error but still set authenticated to false
            isAuthenticated = false
        }
    }
}
