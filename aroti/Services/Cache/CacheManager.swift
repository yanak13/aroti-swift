//
//  CacheManager.swift
//  Aroti
//
//  Unified cache interface combining memory and disk cache
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private let memoryCache = MemoryCache.shared
    private let diskCache = DiskCache.shared
    
    private init() {
        // Periodic cleanup of expired entries
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            self.cleanupExpired()
        }
    }
    
    // MARK: - Get (Cache-first strategy)
    
    func get<T: Codable>(_ key: String, as type: T.Type) -> T? {
        // Try memory cache first
        if let value = memoryCache.get(key, as: type) {
            return value
        }
        
        // Try disk cache
        if let value = diskCache.get(key, as: type) {
            // Restore to memory cache
            memoryCache.set(key, value: value)
            return value
        }
        
        return nil
    }
    
    // MARK: - Set (Write to both caches)
    
    func set<T: Codable>(_ key: String, value: T, ttl: TimeInterval = APIConfiguration.defaultCacheTTL) {
        memoryCache.set(key, value: value, ttl: ttl)
        diskCache.set(key, value: value, ttl: ttl)
    }
    
    // MARK: - Remove
    
    func remove(_ key: String) {
        memoryCache.remove(key)
        diskCache.remove(key)
    }
    
    func removeAll() {
        memoryCache.removeAll()
        diskCache.removeAll()
    }
    
    // MARK: - Cache Key Generation
    
    func cacheKey(for endpoint: APIEndpoint) -> String {
        var key = endpoint.path
        
        if let queryParams = endpoint.queryParameters {
            let sortedParams = queryParams.sorted { $0.key < $1.key }
            let paramString = sortedParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            key += "?\(paramString)"
        }
        
        return key
    }
    
    // MARK: - Cleanup
    
    func cleanupExpired() {
        memoryCache.cleanupExpired()
        diskCache.cleanupExpired()
    }
}
