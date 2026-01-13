//
//  ProfileController.swift
//  Aroti
//
//  Profile operations controller
//

import Foundation
import SwiftUI

@MainActor
class ProfileController: BaseController {
    @Published var profile: UserData?
    
    // MARK: - Profile
    
    func fetchProfile(forceRefresh: Bool = false) async {
        do {
            let endpoint = ProfileEndpoint.getProfile
            let key = cacheKey(for: endpoint)
            
            // Try cache first if not forcing refresh
            if !forceRefresh, let cached: UserData = getCached(key, as: UserData.self) {
                profile = cached
                loadingState = .loaded
                return
            }
            
            // Fetch from API
            let response: UserData = try await requestWithCache(
                endpoint,
                responseType: UserData.self,
                useCache: true,
                cacheTTL: 300 // 5 minutes
            )
            
            profile = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func updateProfile(name: String?, location: String?) async throws -> UserData {
        let endpoint = ProfileEndpoint.updateProfile(name: name, location: location)
        
        do {
            let updated: UserData = try await request(
                endpoint,
                responseType: UserData.self
            )
            
            profile = updated
            
            // Invalidate profile cache
            let profileKey = cacheKey(for: ProfileEndpoint.getProfile)
            cacheManager.remove(profileKey)
            
            return updated
        } catch {
            throw error
        }
    }
    
    func deleteAccount() async throws {
        let endpoint = ProfileEndpoint.deleteAccount
        
        do {
            try await request(endpoint)
            
            // Clear profile
            profile = nil
            
            // Clear all caches
            cacheManager.removeAll()
            
            // Clear auth token
            try? AuthManager.shared.deleteToken()
        } catch {
            throw error
        }
    }
}
