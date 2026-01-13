//
//  DiskCache.swift
//  Aroti
//
//  Persistent disk cache using FileManager
//

import Foundation

class DiskCache {
    static let shared = DiskCache()
    
    private let cacheDirectory: URL
    private let queue = DispatchQueue(label: "com.aroti.diskcache", attributes: .concurrent)
    private let maxSize: Int
    
    init(maxSize: Int = APIConfiguration.maxDiskCacheSize) {
        self.maxSize = maxSize
        
        // Create cache directory
        let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cachesDir.appendingPathComponent("com.aroti.api.cache", isDirectory: true)
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        // Cleanup expired entries on init
        cleanupExpired()
    }
    
    // MARK: - Get
    
    func get<T: Codable>(_ key: String, as type: T.Type) -> T? {
        return queue.sync {
            let fileURL = fileURL(for: key)
            
            guard FileManager.default.fileExists(atPath: fileURL.path),
                  let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            
            do {
                let entry = try JSONDecoder().decode(CacheEntry<T>.self, from: data)
                
                if entry.isExpired {
                    try? FileManager.default.removeItem(at: fileURL)
                    return nil
                }
                
                return entry.data
            } catch {
                // Corrupted cache file, remove it
                try? FileManager.default.removeItem(at: fileURL)
                return nil
            }
        }
    }
    
    // MARK: - Set
    
    func set<T: Codable>(_ key: String, value: T, ttl: TimeInterval = APIConfiguration.defaultCacheTTL) {
        queue.async(flags: .barrier) {
            let entry = CacheEntry(data: value, ttl: ttl)
            let fileURL = self.fileURL(for: key)
            
            do {
                let data = try JSONEncoder().encode(entry)
                try data.write(to: fileURL)
                
                // Check size and evict if needed
                self.evictIfNeeded()
            } catch {
                // Failed to write cache, ignore
                print("Failed to write cache for key: \(key), error: \(error)")
            }
        }
    }
    
    // MARK: - Remove
    
    func remove(_ key: String) {
        queue.async(flags: .barrier) {
            let fileURL = self.fileURL(for: key)
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
    
    func removeAll() {
        queue.async(flags: .barrier) {
            try? FileManager.default.removeItem(at: self.cacheDirectory)
            try? FileManager.default.createDirectory(at: self.cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Cleanup
    
    func cleanupExpired() {
        queue.async(flags: .barrier) {
            guard let files = try? FileManager.default.contentsOfDirectory(at: self.cacheDirectory, includingPropertiesForKeys: nil) else {
                return
            }
            
            for fileURL in files {
                guard let data = try? Data(contentsOf: fileURL) else {
                    continue
                }
                
                // Try to decode as CacheEntry to check expiration
                if let entry = try? JSONDecoder().decode(CacheEntry<Data>.self, from: data),
                   entry.isExpired {
                    try? FileManager.default.removeItem(at: fileURL)
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func fileURL(for key: String) -> URL {
        // Sanitize key for filename
        let sanitizedKey = key.replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
            .replacingOccurrences(of: "?", with: "_")
        return cacheDirectory.appendingPathComponent("\(sanitizedKey).json")
    }
    
    private func evictIfNeeded() {
        guard let files = try? FileManager.default.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.fileSizeKey, .contentModificationDateKey]) else {
            return
        }
        
        // Calculate total size
        var totalSize: Int = 0
        var fileInfos: [(url: URL, size: Int, date: Date)] = []
        
        for fileURL in files {
            guard let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey, .contentModificationDateKey]),
                  let size = resourceValues.fileSize,
                  let date = resourceValues.contentModificationDate else {
                continue
            }
            
            totalSize += size
            fileInfos.append((url: fileURL, size: size, date: date))
        }
        
        // If over limit, remove oldest files
        if totalSize > maxSize {
            let sortedFiles = fileInfos.sorted { $0.date < $1.date }
            var removedSize = 0
            
            for fileInfo in sortedFiles {
                if totalSize - removedSize <= maxSize {
                    break
                }
                
                try? FileManager.default.removeItem(at: fileInfo.url)
                removedSize += fileInfo.size
            }
        }
    }
}
