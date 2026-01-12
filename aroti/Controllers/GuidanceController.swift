//
//  GuidanceController.swift
//  Aroti
//
//  Guidance features controller
//

import Foundation
import SwiftUI

// Note: These models would need to be defined based on your API structure
struct GuidanceMessage: Codable, Identifiable {
    let id: String
    let message: String
    let response: String?
    let timestamp: Date
}

struct GuidanceResponse: Codable {
    let messages: [GuidanceMessage]
}

@MainActor
class GuidanceController: BaseController {
    @Published var messages: [GuidanceMessage] = []
    @Published var currentGuidance: GuidanceResponse?
    
    // MARK: - Guidance
    
    func fetchGuidance(forceRefresh: Bool = false) async {
        do {
            let endpoint = GuidanceEndpoint.getGuidance
            let key = cacheKey(for: endpoint)
            
            if !forceRefresh, let cached: GuidanceResponse = getCached(key, as: GuidanceResponse.self) {
                currentGuidance = cached
                messages = cached.messages
                loadingState = .loaded
                return
            }
            
            let response: GuidanceResponse = try await requestWithCache(
                endpoint,
                responseType: GuidanceResponse.self,
                useCache: true,
                cacheTTL: 300 // 5 minutes
            )
            
            currentGuidance = response
            messages = response.messages
        } catch {
            // Error already handled in base class
        }
    }
    
    func sendMessage(_ message: String) async throws -> GuidanceMessage {
        let endpoint = GuidanceEndpoint.sendMessage(message: message)
        
        do {
            let response: GuidanceMessage = try await request(
                endpoint,
                responseType: GuidanceMessage.self
            )
            
            // Add to messages
            messages.append(response)
            
            // Invalidate guidance cache
            let guidanceKey = cacheKey(for: GuidanceEndpoint.getGuidance)
            cacheManager.remove(guidanceKey)
            
            return response
        } catch {
            throw error
        }
    }
}
