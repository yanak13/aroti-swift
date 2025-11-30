//
//  BookingModels.swift
//  Aroti
//
//  Booking-related data models matching React structure
//

import Foundation

struct Specialist: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let specialty: String
    let categories: [String]
    let country: String
    let countryFlag: String
    let rating: Double
    let reviewCount: Int
    let sessionCount: Int
    let price: Int
    let bio: String
    let yearsOfPractice: Int
    let photo: String
    let available: Bool
    let languages: [String]
    let addedDate: String?
}

struct Review: Identifiable, Codable {
    let id: String
    let specialistId: String
    let userName: String
    let rating: Int
    let comment: String
    let date: String
}

struct Session: Identifiable, Codable {
    let id: String
    let specialistId: String
    let specialistName: String
    let specialistPhoto: String
    let specialty: String
    let date: String
    let time: String
    let duration: Int
    let price: Int
    let status: String // "upcoming", "completed", "pending"
    let meetingLink: String?
    let preparationNotes: String?
}

struct FilterState {
    var availability: String?
    var priceMin: Int?
    var priceMax: Int?
    var rating: String?
    var languages: [String] = []
    var yearsOfExperience: String?
}

// Navigation destination enum for NavigationStack
enum BookingDestination: Hashable {
    case specialist(Specialist)
    case schedule(Specialist)
    case payment(Specialist, Date, String) // specialist, date, time
    case confirmation(Specialist, Date, String)
    case sessionDetail(String) // session id
    case history
}

// Mock data service
class BookingDataService {
    static let shared = BookingDataService()
    
    var specialists: [Specialist] = []
    var reviews: [Review] = []
    var mockSessions: [Session] = []
    
    private init() {
        loadMockData()
    }
    
    private func loadMockData() {
        // Mock specialists data
        specialists = [
            Specialist(
                id: "1",
                name: "Raluca",
                specialty: "Astrologer",
                categories: ["Astrology", "Moon Cycles", "Emotional Healing"],
                country: "Romania",
                countryFlag: "🇷🇴",
                rating: 4.9,
                reviewCount: 128,
                sessionCount: 150,
                price: 40,
                bio: "15 years of holistic practice focusing on emotional balance and lunar guidance. I help people reconnect with their inner wisdom through astrological insights.",
                yearsOfPractice: 15,
                photo: "specialist-1",
                available: true,
                languages: ["Romanian", "English"],
                addedDate: "2024-01-15"
            ),
            Specialist(
                id: "2",
                name: "Marcus",
                specialty: "Holistic Therapist",
                categories: ["Therapy", "Mindfulness", "Life Coaching"],
                country: "USA",
                countryFlag: "🇺🇸",
                rating: 4.8,
                reviewCount: 96,
                sessionCount: 120,
                price: 55,
                bio: "Compassionate therapist specializing in mindfulness-based approaches to emotional wellness and personal transformation.",
                yearsOfPractice: 12,
                photo: "specialist-2",
                available: true,
                languages: ["English", "Spanish"],
                addedDate: "2024-03-20"
            ),
            Specialist(
                id: "3",
                name: "Sophia",
                specialty: "Numerologist",
                categories: ["Numerology", "Life Path", "Career Guidance"],
                country: "Greece",
                countryFlag: "🇬🇷",
                rating: 4.9,
                reviewCount: 142,
                sessionCount: 200,
                price: 35,
                bio: "Expert in numerology with a focus on life path discovery and career alignment through numbers and cosmic patterns.",
                yearsOfPractice: 18,
                photo: "specialist-3",
                available: true,
                languages: ["Greek", "English"],
                addedDate: "2023-11-10"
            ),
            Specialist(
                id: "4",
                name: "Kai",
                specialty: "Reiki Master",
                categories: ["Reiki", "Energy Healing", "Chakra Balance"],
                country: "Japan",
                countryFlag: "🇯🇵",
                rating: 5.0,
                reviewCount: 87,
                sessionCount: 95,
                price: 50,
                bio: "Traditional Reiki master offering energy healing sessions to restore balance, clarity, and inner peace.",
                yearsOfPractice: 10,
                photo: "specialist-4",
                available: true,
                languages: ["Japanese", "English"],
                addedDate: "2024-06-05"
            )
        ]
        
        // Mock reviews
        reviews = [
            Review(
                id: "1",
                specialistId: "1",
                userName: "Emma",
                rating: 5,
                comment: "Raluca helped me understand my moon cycle patterns. Truly transformative session.",
                date: "2025-09-15"
            ),
            Review(
                id: "2",
                specialistId: "1",
                userName: "Oliver",
                rating: 5,
                comment: "Her insights were incredibly accurate and deeply resonant. Highly recommend!",
                date: "2025-09-10"
            )
        ]
        
        // Mock sessions
        mockSessions = [
            Session(
                id: "s1",
                specialistId: "1",
                specialistName: "Raluca",
                specialistPhoto: "specialist-1",
                specialty: "Astrologer",
                date: "2025-11-05",
                time: "14:00",
                duration: 50,
                price: 40,
                status: "upcoming",
                meetingLink: "https://meet.aroti.app/session-123",
                preparationNotes: "Please have your birth chart details ready (date, time, and place of birth). Find a quiet, comfortable space where you can reflect openly. I recommend having a notebook to write down insights during our session."
            )
        ]
    }
    
    func getSpecialist(by id: String) -> Specialist? {
        return specialists.first { $0.id == id }
    }
    
    func getReviews(for specialistId: String) -> [Review] {
        return reviews.filter { $0.specialistId == specialistId }
    }
    
    func getUpcomingSessions() -> [Session] {
        return mockSessions.filter { $0.status == "upcoming" }
    }
}

