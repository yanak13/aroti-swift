//
//  CacheEntry.swift
//  Aroti
//
//  Cache entry model with expiration
//

import Foundation

struct CacheEntry<T: Codable>: Codable {
    let data: T
    let timestamp: Date
    let ttl: TimeInterval
    
    var isExpired: Bool {
        Date().timeIntervalSince(timestamp) > ttl
    }
    
    init(data: T, ttl: TimeInterval = APIConfiguration.defaultCacheTTL) {
        self.data = data
        self.timestamp = Date()
        self.ttl = ttl
    }
}
