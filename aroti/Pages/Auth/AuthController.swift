//
//  AuthController.swift
//  Aroti
//
//  Authentication state management
//

import Foundation
import SwiftUI

@MainActor
class AuthController: ObservableObject {
    static let shared = AuthController()
    
    @Published var isAuthenticated: Bool = false
    
    private init() {
        // Check if user is already authenticated
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        isAuthenticated = AuthManager.shared.hasValidToken()
    }
    
    func signIn() async throws {
        // Start OAuth flow
        let token = try await KeycloakAuthService.shared.startAuthFlow()
        
        // Save token
        try AuthManager.shared.saveToken(token)
        
        // Update authentication status
        isAuthenticated = true
    }
    
    func signOut() throws {
        // Delete token
        try AuthManager.shared.deleteToken()
        
        // Update authentication status
        isAuthenticated = false
    }
}
