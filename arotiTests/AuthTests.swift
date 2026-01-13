//
//  AuthTests.swift
//  ArotiTests
//
//  Tests for OAuth flow and token refresh
//

import XCTest
@testable import aroti

final class AuthTests: XCTestCase {
    
    var authManager: AuthManager!
    
    override func setUp() {
        super.setUp()
        authManager = AuthManager.shared
        // Clear any existing tokens
        try? authManager.deleteToken()
    }
    
    override func tearDown() {
        // Clean up
        try? authManager.deleteToken()
        super.tearDown()
    }
    
    func testTokenExpiration() {
        // Create a token that expires in the past
        let expiredToken = AuthToken(
            accessToken: "test-token",
            refreshToken: "refresh-token",
            expiresAt: Date().addingTimeInterval(-3600) // 1 hour ago
        )
        
        XCTAssertTrue(expiredToken.isExpired, "Token should be expired")
    }
    
    func testTokenNotExpired() {
        // Create a token that expires in the future
        let validToken = AuthToken(
            accessToken: "test-token",
            refreshToken: "refresh-token",
            expiresAt: Date().addingTimeInterval(3600) // 1 hour from now
        )
        
        XCTAssertFalse(validToken.isExpired, "Token should not be expired")
    }
    
    func testTokenSaveAndRetrieve() throws {
        let token = AuthToken(
            accessToken: "test-access-token",
            refreshToken: "test-refresh-token",
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        // Save token
        try authManager.saveToken(token)
        
        // Retrieve token
        let retrieved = try authManager.getToken()
        
        XCTAssertNotNil(retrieved, "Token should be retrievable")
        XCTAssertEqual(retrieved?.accessToken, "test-access-token")
        XCTAssertEqual(retrieved?.refreshToken, "test-refresh-token")
    }
    
    func testHasValidToken() {
        // Initially no token
        XCTAssertFalse(authManager.hasValidToken(), "Should not have valid token initially")
        
        // Save a valid token
        let token = AuthToken(
            accessToken: "test-token",
            refreshToken: "refresh-token",
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        try? authManager.saveToken(token)
        XCTAssertTrue(authManager.hasValidToken(), "Should have valid token after saving")
    }
    
    func testDeleteToken() throws {
        // Save a token first
        let token = AuthToken(
            accessToken: "test-token",
            refreshToken: "refresh-token",
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        try authManager.saveToken(token)
        XCTAssertTrue(authManager.hasValidToken())
        
        // Delete token
        try authManager.deleteToken()
        
        // Verify token is deleted
        let retrieved = try authManager.getToken()
        XCTAssertNil(retrieved, "Token should be nil after deletion")
        XCTAssertFalse(authManager.hasValidToken(), "Should not have valid token after deletion")
    }
    
    // Note: OAuth flow tests would require mocking ASWebAuthenticationSession
    // which is complex. In a real test suite, you would use a testing framework
    // that can mock system frameworks.
}
