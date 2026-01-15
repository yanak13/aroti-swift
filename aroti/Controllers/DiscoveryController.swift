//
//  DiscoveryController.swift
//  Aroti
//
//  Discovery content controller
//

import Foundation
import SwiftUI

// Note: These models would need to be defined based on your API structure
// For now, using placeholder types

struct DiscoveryArticle: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let imageUrl: String?
}

struct DiscoveryCourse: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String?
}

struct DiscoveryPractice: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String?
}

@MainActor
class DiscoveryController: BaseController {
    @Published var articles: [DiscoveryArticle] = []
    @Published var courses: [DiscoveryCourse] = []
    @Published var practices: [DiscoveryPractice] = []
    
    // MARK: - Articles
    
    func fetchArticles(forceRefresh: Bool = false) async {
        do {
            let endpoint = DiscoveryEndpoint.getArticles
            let key = cacheKey(for: endpoint)
            
            if !forceRefresh, let cached: [DiscoveryArticle] = getCached(key, as: [DiscoveryArticle].self) {
                articles = cached
                loadingState = .loaded
                return
            }
            
            let response: [DiscoveryArticle] = try await requestWithCache(
                endpoint,
                responseType: [DiscoveryArticle].self,
                useCache: true,
                cacheTTL: 1800 // 30 minutes
            )
            
            articles = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func fetchArticle(id: String) async -> DiscoveryArticle? {
        do {
            let endpoint = DiscoveryEndpoint.getArticle(id: id)
            let article: DiscoveryArticle = try await requestWithCache(
                endpoint,
                responseType: DiscoveryArticle.self,
                useCache: true,
                cacheTTL: 3600 // 1 hour
            )
            
            return article
        } catch {
            return nil
        }
    }
    
    // MARK: - Courses
    
    func fetchCourses(forceRefresh: Bool = false) async {
        do {
            let endpoint = DiscoveryEndpoint.getCourses
            let key = cacheKey(for: endpoint)
            
            if !forceRefresh, let cached: [DiscoveryCourse] = getCached(key, as: [DiscoveryCourse].self) {
                courses = cached
                loadingState = .loaded
                return
            }
            
            let response: [DiscoveryCourse] = try await requestWithCache(
                endpoint,
                responseType: [DiscoveryCourse].self,
                useCache: true,
                cacheTTL: 1800 // 30 minutes
            )
            
            courses = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func fetchCourse(id: String) async -> DiscoveryCourse? {
        do {
            let endpoint = DiscoveryEndpoint.getCourse(id: id)
            let course: DiscoveryCourse = try await requestWithCache(
                endpoint,
                responseType: DiscoveryCourse.self,
                useCache: true,
                cacheTTL: 3600 // 1 hour
            )
            
            return course
        } catch {
            return nil
        }
    }
    
    // MARK: - Practices
    
    func fetchPractices(forceRefresh: Bool = false) async {
        do {
            let endpoint = DiscoveryEndpoint.getPractices
            let key = cacheKey(for: endpoint)
            
            if !forceRefresh, let cached: [DiscoveryPractice] = getCached(key, as: [DiscoveryPractice].self) {
                practices = cached
                loadingState = .loaded
                return
            }
            
            let response: [DiscoveryPractice] = try await requestWithCache(
                endpoint,
                responseType: [DiscoveryPractice].self,
                useCache: true,
                cacheTTL: 1800 // 30 minutes
            )
            
            practices = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func fetchPractice(id: String) async -> DiscoveryPractice? {
        do {
            let endpoint = DiscoveryEndpoint.getPractice(id: id)
            let practice: DiscoveryPractice = try await requestWithCache(
                endpoint,
                responseType: DiscoveryPractice.self,
                useCache: true,
                cacheTTL: 3600 // 1 hour
            )
            
            return practice
        } catch {
            return nil
        }
    }
}
