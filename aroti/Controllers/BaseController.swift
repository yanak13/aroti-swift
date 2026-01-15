//
//  BaseController.swift
//  Aroti
//
//  Base class with common patterns for loading states and error handling
//

import Foundation
import SwiftUI

@MainActor
class BaseController: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var error: APIError?
    
    let apiClient = APIClient.shared
    let cacheManager = CacheManager.shared
    
    // MARK: - Error Handling
    
    func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            self.error = apiError
            self.loadingState = .error(apiError)
        } else {
            let apiError = APIError.unknown(error)
            self.error = apiError
            self.loadingState = .error(apiError)
        }
    }
    
    func clearError() {
        error = nil
        if case .error = loadingState {
            loadingState = .idle
        }
    }
    
    // MARK: - Cache Helper
    
    func getCached<T: Codable>(_ key: String, as type: T.Type) -> T? {
        return cacheManager.get(key, as: type)
    }
    
    func setCached<T: Codable>(_ key: String, value: T, ttl: TimeInterval = APIConfiguration.defaultCacheTTL) {
        cacheManager.set(key, value: value, ttl: ttl)
    }
    
    func cacheKey(for endpoint: APIEndpoint) -> String {
        return cacheManager.cacheKey(for: endpoint)
    }
    
    // MARK: - Request with Cache
    
    func requestWithCache<T: Codable>(
        _ endpoint: APIEndpoint,
        responseType: T.Type,
        useCache: Bool = true,
        cacheTTL: TimeInterval = APIConfiguration.defaultCacheTTL
    ) async throws -> T {
        let key = cacheKey(for: endpoint)
        
        // Try cache first if enabled
        if useCache, let cached: T = getCached(key, as: T.self) {
            return cached
        }
        
        // Make network request
        loadingState = .loading
        
        do {
            // Use auto-refresh for authenticated endpoints
            let response: T
            if endpoint.requiresAuth {
                response = try await apiClient.requestWithAutoRefresh(endpoint, responseType: T.self)
            } else {
                response = try await apiClient.request(endpoint, responseType: T.self)
            }
            
            // Cache the response
            if useCache {
                setCached(key, value: response, ttl: cacheTTL)
            }
            
            loadingState = .loaded
            return response
        } catch {
            handleError(error)
            throw error
        }
    }
    
    // MARK: - Request without Cache
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        responseType: T.Type
    ) async throws -> T {
        loadingState = .loading
        
        do {
            // Use auto-refresh for authenticated endpoints
            let response: T
            if endpoint.requiresAuth {
                response = try await apiClient.requestWithAutoRefresh(endpoint, responseType: T.self)
            } else {
                response = try await apiClient.request(endpoint, responseType: T.self)
            }
            loadingState = .loaded
            return response
        } catch {
            handleError(error)
            throw error
        }
    }
    
    // MARK: - Request without Response
    
    func request(_ endpoint: APIEndpoint) async throws {
        loadingState = .loading
        
        do {
            try await apiClient.request(endpoint)
            loadingState = .loaded
        } catch {
            handleError(error)
            throw error
        }
    }
}
