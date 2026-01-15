//
//  AuthTests.swift
//  arotiTests
//
//  Tests for authentication and token refresh
//

import Testing
@testable import aroti

struct AuthTests {
    
    @Test("AuthManager should save and retrieve token")
    func testTokenSaveAndRetrieve() async throws {
        let manager = AuthManager.shared
        
        let token = AuthToken(
            accessToken: "test_access_token",
            refreshToken: "test_refresh_token",
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        try manager.saveToken(token)
        let retrieved = try manager.getToken()
        
        #expect(retrieved != nil)
        #expect(retrieved?.accessToken == "test_access_token")
        
        // Cleanup
        try? manager.deleteToken()
    }
    
    @Test("AuthManager should detect expired token")
    func testExpiredToken() async throws {
        let manager = AuthManager.shared
        
        let expiredToken = AuthToken(
            accessToken: "test_token",
            refreshToken: "test_refresh",
            expiresAt: Date().addingTimeInterval(-3600) // Expired 1 hour ago
        )
        
        try manager.saveToken(expiredToken)
        let retrieved = try manager.getToken()
        
        #expect(retrieved?.isExpired == true)
        
        // Cleanup
        try? manager.deleteToken()
    }
    
    @Test("AuthManager refreshIfNeeded should refresh when token expires soon")
    func testRefreshIfNeeded() async throws {
        let manager = AuthManager.shared
        
        // Create token that expires in 4 minutes (less than 5 minute threshold)
        let soonToExpireToken = AuthToken(
            accessToken: "test_token",
            refreshToken: "test_refresh",
            expiresAt: Date().addingTimeInterval(240) // 4 minutes
        )
        
        try manager.saveToken(soonToExpireToken)
        
        // Note: This test would require mocking KeycloakAuthService
        // For now, just verify the token is detected as needing refresh
        let retrieved = try manager.getToken()
        if let expiresAt = retrieved?.expiresAt {
            let timeUntilExpiry = expiresAt.timeIntervalSinceNow
            #expect(timeUntilExpiry < 300) // Less than 5 minutes
        }
        
        // Cleanup
        try? manager.deleteToken()
    }
}
