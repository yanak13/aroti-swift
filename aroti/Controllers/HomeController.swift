//
//  HomeController.swift
//  Aroti
//
//  Home page data controller
//

import Foundation
import SwiftUI

@MainActor
class HomeController: BaseController {
    @Published var dailyInsight: DailyInsight?
    @Published var userData: UserData = UserData.default
    @Published var userPoints: Int = 0
    
    // MARK: - Daily Insights
    
    func fetchDailyInsights(forceRefresh: Bool = false) async {
        do {
            let endpoint = HomeEndpoint.getDailyInsights
            let key = cacheKey(for: endpoint)
            
            // Try cache first if not forcing refresh
            if !forceRefresh, let cached: DailyInsight = getCached(key, as: DailyInsight.self) {
                // Check if cached insight is for today
                let calendar = Calendar.current
                if calendar.isDateInToday(cached.date) {
                    dailyInsight = cached
                    loadingState = .loaded
                    return
                }
            }
            
            // Fetch from API
            let response: DailyInsight = try await requestWithCache(
                endpoint,
                responseType: DailyInsight.self,
                useCache: true,
                cacheTTL: 86400 // 24 hours (daily content)
            )
            
            dailyInsight = response
        } catch {
            // Error already handled in base class
        }
    }
    
    // MARK: - User Data
    
    func fetchUserData(forceRefresh: Bool = false) async {
        do {
            let endpoint = HomeEndpoint.getUserData
            let key = cacheKey(for: endpoint)
            
            // Try cache first if not forcing refresh
            if !forceRefresh, let cached: UserData = getCached(key, as: UserData.self) {
                userData = cached
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
            
            userData = response
        } catch {
            // Error already handled in base class
        }
    }
}
