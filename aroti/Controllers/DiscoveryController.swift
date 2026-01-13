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

struct Article: Codable, Identifiable {
    let id: String
    let title: String
    let content: String
    let imageUrl: String?
}

struct Course: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String?
}

struct Practice: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String?
}

@MainActor
class DiscoveryController: BaseController {
    @Published var articles: [Article] = []
    @Published var courses: [Course] = []
    @Published var practices: [Practice] = []
    
    // MARK: - Articles
    
    func fetchArticles(forceRefresh: Bool = false) async {
        do {
            let endpoint = DiscoveryEndpoint.getArticles
            let key = cacheKey(for: endpoint)
            
            if !forceRefresh, let cached: [Article] = getCached(key, as: [Article].self) {
                articles = cached
                loadingState = .loaded
                return
            }
            
            let response: [Article] = try await requestWithCache(
                endpoint,
                responseType: [Article].self,
                useCache: true,
                cacheTTL: 1800 // 30 minutes
            )
            
            articles = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func fetchArticle(id: String) async -> Article? {
        do {
            let endpoint = DiscoveryEndpoint.getArticle(id: id)
            let article: Article = try await requestWithCache(
                endpoint,
                responseType: Article.self,
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
            
            if !forceRefresh, let cached: [Course] = getCached(key, as: [Course].self) {
                courses = cached
                loadingState = .loaded
                return
            }
            
            let response: [Course] = try await requestWithCache(
                endpoint,
                responseType: [Course].self,
                useCache: true,
                cacheTTL: 1800 // 30 minutes
            )
            
            courses = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func fetchCourse(id: String) async -> Course? {
        do {
            let endpoint = DiscoveryEndpoint.getCourse(id: id)
            let course: Course = try await requestWithCache(
                endpoint,
                responseType: Course.self,
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
            
            if !forceRefresh, let cached: [Practice] = getCached(key, as: [Practice].self) {
                practices = cached
                loadingState = .loaded
                return
            }
            
            let response: [Practice] = try await requestWithCache(
                endpoint,
                responseType: [Practice].self,
                useCache: true,
                cacheTTL: 1800 // 30 minutes
            )
            
            practices = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func fetchPractice(id: String) async -> Practice? {
        do {
            let endpoint = DiscoveryEndpoint.getPractice(id: id)
            let practice: Practice = try await requestWithCache(
                endpoint,
                responseType: Practice.self,
                useCache: true,
                cacheTTL: 3600 // 1 hour
            )
            
            return practice
        } catch {
            return nil
        }
    }
}
