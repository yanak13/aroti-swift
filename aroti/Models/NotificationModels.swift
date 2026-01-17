//
//  NotificationModels.swift
//  Aroti
//
//  Data models for notifications
//

import Foundation

// MARK: - Notification Type
enum NotificationType: String, Codable {
    // Auto-generated daily content
    case dailyTarotCard
    case dailyHoroscope
    case dailyNumerology
    case dailyAffirmation
    case dailyRitual
    
    // Auto-generated guidance
    case rightNowGuidance
    case newInsight
    case newReflection
    
    // Premium auto-updates
    case monthlyForecast
    case weeklyHoroscope
    case premiumFeatureUnlocked
    
    // Achievements (auto-generated)
    case newLevelUnlocked
}

// MARK: - Deep Link Destination
enum NotificationDestination: Codable, Equatable {
    case home
    case tarotDetail
    case horoscope
    case numerology
    case affirmation
    case coreGuidance(cardId: String)
    case practiceDetail(practiceId: String)
    case journey
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "home":
            self = .home
        case "tarotDetail":
            self = .tarotDetail
        case "horoscope":
            self = .horoscope
        case "numerology":
            self = .numerology
        case "affirmation":
            self = .affirmation
        case "journey":
            self = .journey
        case "coreGuidance":
            let id = try container.decode(String.self, forKey: .id)
            self = .coreGuidance(cardId: id)
        case "practiceDetail":
            let id = try container.decode(String.self, forKey: .id)
            self = .practiceDetail(practiceId: id)
        default:
            self = .home
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .home:
            try container.encode("home", forKey: .type)
        case .tarotDetail:
            try container.encode("tarotDetail", forKey: .type)
        case .horoscope:
            try container.encode("horoscope", forKey: .type)
        case .numerology:
            try container.encode("numerology", forKey: .type)
        case .affirmation:
            try container.encode("affirmation", forKey: .type)
        case .journey:
            try container.encode("journey", forKey: .type)
        case .coreGuidance(let id):
            try container.encode("coreGuidance", forKey: .type)
            try container.encode(id, forKey: .id)
        case .practiceDetail(let id):
            try container.encode("practiceDetail", forKey: .type)
            try container.encode(id, forKey: .id)
        }
    }
}

// MARK: - Notification Item
struct NotificationItem: Identifiable, Codable, Equatable {
    let id: String
    let type: NotificationType
    let title: String
    let body: String
    var isRead: Bool
    let createdAt: Date
    let destination: NotificationDestination
    
    init(
        id: String = UUID().uuidString,
        type: NotificationType,
        title: String,
        body: String,
        isRead: Bool = false,
        createdAt: Date = Date(),
        destination: NotificationDestination
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.isRead = isRead
        self.createdAt = createdAt
        self.destination = destination
    }
}
