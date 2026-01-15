//
//  BookingController.swift
//  Aroti
//
//  Booking-related operations controller
//

import Foundation
import SwiftUI

@MainActor
class BookingController: BaseController {
    @Published var specialists: [Specialist] = []
    @Published var sessions: [Session] = []
    @Published var reviews: [String: [Review]] = [:] // Keyed by specialistId
    
    // MARK: - Specialists
    
    func fetchSpecialists(forceRefresh: Bool = false) async {
        // Check if mock mode is enabled
        if MockModeService.shared.isEnabled {
            specialists = MockModeService.mockSpecialists
            loadingState = .loaded
            return
        }
        
        do {
            let endpoint = BookingEndpoint.getSpecialists
            let key = cacheKey(for: endpoint)
            
            // Try cache first if not forcing refresh
            if !forceRefresh, let cached: [Specialist] = getCached(key, as: [Specialist].self) {
                specialists = cached
                loadingState = .loaded
                return
            }
            
            // Fetch from API
            let response: [Specialist] = try await requestWithCache(
                endpoint,
                responseType: [Specialist].self,
                useCache: true,
                cacheTTL: 300 // 5 minutes
            )
            
            specialists = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func fetchSpecialist(id: String) async -> Specialist? {
        // Check if mock mode is enabled
        if MockModeService.shared.isEnabled {
            return BookingDataService.shared.getSpecialist(by: id)
        }
        
        do {
            let endpoint = BookingEndpoint.getSpecialist(id: id)
            let specialist: Specialist = try await requestWithCache(
                endpoint,
                responseType: Specialist.self,
                useCache: true,
                cacheTTL: 600 // 10 minutes for individual specialist
            )
            
            // Update in specialists list if exists
            if let index = specialists.firstIndex(where: { $0.id == id }) {
                specialists[index] = specialist
            }
            
            return specialist
        } catch {
            return nil
        }
    }
    
    // MARK: - Sessions
    
    func fetchSessions(forceRefresh: Bool = false) async {
        // Check if mock mode is enabled
        if MockModeService.shared.isEnabled {
            sessions = MockModeService.mockSessions
            loadingState = .loaded
            return
        }
        
        do {
            let endpoint = BookingEndpoint.getSessions
            let key = cacheKey(for: endpoint)
            
            // Try cache first if not forcing refresh
            if !forceRefresh, let cached: [Session] = getCached(key, as: [Session].self) {
                sessions = cached
                loadingState = .loaded
                return
            }
            
            // Fetch from API
            let response: [Session] = try await requestWithCache(
                endpoint,
                responseType: [Session].self,
                useCache: true,
                cacheTTL: 60 // 1 minute for sessions (more dynamic)
            )
            
            sessions = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func getUpcomingSessions() -> [Session] {
        return sessions.filter { $0.status == "upcoming" }
    }
    
    func getPastSessions() -> [Session] {
        return sessions.filter { $0.status == "completed" }
    }
    
    // MARK: - Booking
    
    func bookSession(specialistId: String, date: Date, time: String) async throws -> Session {
        let endpoint = BookingEndpoint.bookSession(specialistId: specialistId, date: date, time: time)
        
        do {
            let session: Session = try await request(
                endpoint,
                responseType: Session.self
            )
            
            // Add to sessions list
            sessions.append(session)
            
            // Invalidate sessions cache
            let sessionsKey = cacheKey(for: BookingEndpoint.getSessions)
            cacheManager.remove(sessionsKey)
            
            return session
        } catch {
            throw error
        }
    }
    
    func updateSession(id: String, date: Date?, time: String?) async throws -> Session {
        let endpoint = BookingEndpoint.updateSession(id: id, date: date, time: time)
        
        do {
            let session: Session = try await request(
                endpoint,
                responseType: Session.self
            )
            
            // Update in sessions list
            if let index = sessions.firstIndex(where: { $0.id == id }) {
                sessions[index] = session
            }
            
            // Invalidate sessions cache
            let sessionsKey = cacheKey(for: BookingEndpoint.getSessions)
            cacheManager.remove(sessionsKey)
            
            return session
        } catch {
            throw error
        }
    }
    
    func cancelSession(id: String) async throws {
        let endpoint = BookingEndpoint.cancelSession(id: id)
        
        do {
            try await request(endpoint)
            
            // Remove from sessions list
            sessions.removeAll { $0.id == id }
            
            // Invalidate sessions cache
            let sessionsKey = cacheKey(for: BookingEndpoint.getSessions)
            cacheManager.remove(sessionsKey)
        } catch {
            throw error
        }
    }
    
    // MARK: - Reviews
    
    func fetchReviews(for specialistId: String, forceRefresh: Bool = false) async {
        // Check if mock mode is enabled
        if MockModeService.shared.isEnabled {
            reviews[specialistId] = BookingDataService.shared.getReviews(for: specialistId)
            return
        }
        
        do {
            let endpoint = BookingEndpoint.getReviews(specialistId: specialistId)
            let key = cacheKey(for: endpoint)
            
            // Try cache first if not forcing refresh
            if !forceRefresh, let cached: [Review] = getCached(key, as: [Review].self) {
                reviews[specialistId] = cached
                return
            }
            
            // Fetch from API
            let response: [Review] = try await requestWithCache(
                endpoint,
                responseType: [Review].self,
                useCache: true,
                cacheTTL: 600 // 10 minutes
            )
            
            reviews[specialistId] = response
        } catch {
            // Error already handled in base class
        }
    }
    
    func getReviews(for specialistId: String) -> [Review] {
        // Check if mock mode is enabled
        if MockModeService.shared.isEnabled {
            return BookingDataService.shared.getReviews(for: specialistId)
        }
        return reviews[specialistId] ?? []
    }
}
