//
//  MockModeService.swift
//  Aroti
//
//  Service for managing mock mode (development/testing)
//

import Foundation

class MockModeService {
    static let shared = MockModeService()
    
    private let userDefaultsKey = "aroti_mock_mode_enabled"
    
    private init() {}
    
    var isEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: userDefaultsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
            NotificationCenter.default.post(name: .mockModeChanged, object: nil)
        }
    }
    
    func toggle() {
        isEnabled.toggle()
    }
    
    // MARK: - Mock Data
    
    static let mockUserData = UserData(
        name: "Mock User",
        sunSign: "Pisces",
        moonSign: "Cancer",
        birthDate: Date().addingTimeInterval(-86400 * 365 * 30), // 30 years ago
        birthTime: Date().addingTimeInterval(-86400 * 365 * 30),
        birthLocation: "San Francisco, CA",
        traits: ["Intuitive", "Spiritual", "Creative"],
        isPremium: true
    )
    
    static var mockSpecialists: [Specialist] {
        BookingDataService.shared.specialists
    }
    
    static var mockReviews: [Review] {
        BookingDataService.shared.reviews
    }
    
    static var mockSessions: [Session] {
        BookingDataService.shared.mockSessions
    }
    
    static let mockDailyInsight = DailyInsight(
        tarotCard: TarotCard(
            id: "mock-fool",
            name: "The Fool",
            keywords: ["New beginnings", "Adventure", "Innocence"],
            interpretation: "This is mock data. A new journey awaits you with fresh perspectives and unlimited potential.",
            guidance: ["Trust your instincts", "Embrace the unknown", "Take a leap of faith"],
            imageName: "tarot-fool"
        ),
        horoscope: "This is mock horoscope data. Today brings opportunities for growth and reflection. Trust your intuition and be open to new experiences that align with your cosmic path.",
        numerology: NumerologyInsight(
            number: 7,
            preview: "A day of introspection and spiritual growth (Mock Data)"
        ),
        ritual: Ritual(
            id: "mock-1",
            title: "Morning Meditation",
            description: "Start your day with a 10-minute meditation (Mock Data)",
            duration: "10 min",
            type: "Meditation",
            intention: "Set positive intentions for the day",
            steps: ["Find a quiet space", "Sit comfortably", "Focus on your breath", "Set your intention"],
            affirmation: "I am open to the wisdom of the universe",
            benefits: ["Clarity", "Peace", "Focus"]
        ),
        affirmation: "I trust the journey and embrace each moment with gratitude (Mock Data)",
        date: Date()
    )
}

extension Notification.Name {
    static let mockModeChanged = Notification.Name("mockModeChanged")
}
