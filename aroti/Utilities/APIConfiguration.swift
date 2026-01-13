//
//  APIConfiguration.swift
//  Aroti
//
//  API configuration settings
//

import Foundation

struct APIConfiguration {
    #if DEBUG
    static let baseURL = "http://localhost:8888"
    static let keycloakURL = "http://localhost:8080"
    #else
    static let baseURL = "https://api.aroti.com"
    static let keycloakURL = "https://auth.aroti.com"
    #endif
    
    static let defaultTimeout: TimeInterval = 30.0
    static let debugLogging: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()
    
    // Cache configuration
    static let defaultCacheTTL: TimeInterval = 300 // 5 minutes
    static let maxMemoryCacheSize: Int = 50 * 1024 * 1024 // 50 MB
    static let maxDiskCacheSize: Int = 100 * 1024 * 1024 // 100 MB
}
