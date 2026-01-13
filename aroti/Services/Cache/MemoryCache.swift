//
//  MemoryCache.swift
//  Aroti
//
//  In-memory cache with TTL
//

import Foundation

class MemoryCache {
    static let shared = MemoryCache()
    
    private var cache: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.aroti.memorycache", attributes: .concurrent)
    private let maxSize: Int
    
    init(maxSize: Int = APIConfiguration.maxMemoryCacheSize) {
        self.maxSize = maxSize
    }
    
    // MARK: - Get
    
    func get<T: Codable>(_ key: String, as type: T.Type) -> T? {
        return queue.sync {
            guard let entry = cache[key] as? CacheEntry<T> else {
                return nil
            }
            
            if entry.isExpired {
                cache.removeValue(forKey: key)
                return nil
            }
            
            return entry.data
        }
    }
    
    // MARK: - Set
    
    func set<T: Codable>(_ key: String, value: T, ttl: TimeInterval = APIConfiguration.defaultCacheTTL) {
        queue.async(flags: .barrier) {
            let entry = CacheEntry(data: value, ttl: ttl)
            self.cache[key] = entry
            
            // Check size and evict if needed
            self.evictIfNeeded()
        }
    }
    
    // MARK: - Remove
    
    func remove(_ key: String) {
        queue.async(flags: .barrier) {
            self.cache.removeValue(forKey: key)
        }
    }
    
    func removeAll() {
        queue.async(flags: .barrier) {
            self.cache.removeAll()
        }
    }
    
    // MARK: - Cleanup
    
    func cleanupExpired() {
        queue.async(flags: .barrier) {
            let keysToRemove = self.cache.keys.filter { key in
                if let entry = self.cache[key] as? (any CacheEntryProtocol) {
                    return entry.isExpired
                }
                return false
            }
            
            for key in keysToRemove {
                self.cache.removeValue(forKey: key)
            }
        }
    }
    
    // MARK: - Private
    
    private func evictIfNeeded() {
        // Simple LRU eviction - remove oldest entries if cache is too large
        // In a production app, you'd want more sophisticated eviction
        if cache.count > 100 { // Limit number of entries
            let sortedKeys = cache.keys.sorted { key1, key2 in
                if let entry1 = cache[key1] as? (any CacheEntryProtocol),
                   let entry2 = cache[key2] as? (any CacheEntryProtocol) {
                    return entry1.timestamp < entry2.timestamp
                }
                return false
            }
            
            // Remove oldest 10% of entries
            let removeCount = max(1, sortedKeys.count / 10)
            for i in 0..<removeCount {
                cache.removeValue(forKey: sortedKeys[i])
            }
        }
    }
}

// Protocol to check expiration without knowing the generic type
private protocol CacheEntryProtocol {
    var timestamp: Date { get }
    var ttl: TimeInterval { get }
    var isExpired: Bool { get }
}

extension CacheEntry: CacheEntryProtocol {}
