//
//  AuthToken.swift
//  Aroti
//
//  Authentication token model
//

import Foundation

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String?
    let expiresAt: Date?
    
    var isExpired: Bool {
        guard let expiresAt = expiresAt else {
            return false // No expiration means token is valid
        }
        return Date() >= expiresAt
    }
}
