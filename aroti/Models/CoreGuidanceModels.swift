//
//  CoreGuidanceModels.swift
//  Aroti
//
//  Data models for Core Guidance feature
//

import Foundation

// MARK: - Core Guidance Card Types
enum CoreGuidanceCardType: String, Codable, CaseIterable, Identifiable {
    case rightNow = "right_now"
    case thisPeriod = "this_period"
    case whereToFocus = "where_to_focus"
    case whatsComingUp = "whats_coming_up"
    case personalInsight = "personal_insight"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .rightNow: return "Right Now"
        case .thisPeriod: return "This Period"
        case .whereToFocus: return "Where to Focus"
        case .whatsComingUp: return "What's Coming Up"
        case .personalInsight: return "Your Personal Insight"
        }
    }
    
    var order: Int {
        switch self {
        case .rightNow: return 0
        case .thisPeriod: return 1
        case .whereToFocus: return 2
        case .whatsComingUp: return 3
        case .personalInsight: return 4
        }
    }
}

// MARK: - Expanded Guidance Content
struct ExpandedGuidanceContent: Codable, Equatable {
    // Minimal Premium V1 Structure
    let oneLineInsight: String // The most important line on the page (plain language, no astrology terms)
    let insightBullets: [String] // Exactly 3 bullets: Theme, Best use, Watch for
    let guidance: [String] // Exactly 3 items: Do, Try, Avoid
    let reflectionQuestions: [String] // Max 3 concrete questions
    
    // Legacy fields (kept for backward compatibility, but not used in V1)
    let contextSection: String? // Why this matters now (metadata only)
    let deeperInsight: String? // Removed in V1
    let practicalReflection: [String]? // Legacy reflection prompts
}

// MARK: - Core Guidance Card
struct CoreGuidanceCard: Codable, Identifiable, Equatable {
    let id: String
    let type: CoreGuidanceCardType
    let preview: String // Short preview text for card
    let fullInsight: String // Expanded insight for modal (kept for backward compatibility)
    let headline: String? // New: Card headline (e.g., "A Quiet Shift")
    let bodyLines: [String]? // New: Array of 2-4 short lines for line-by-line animation
    let lastUpdated: Date
    let contentVersion: String // Used to track if content has changed
    let contextInfo: String? // Explains why card updated (e.g., "Mercury retrograde", "New personal month")
    let astrologicalContext: String? // Current astrological influences
    let numerologyContext: String? // Current numerology influences
    let expandedContent: ExpandedGuidanceContent? // Optional deeper content
    let timeframeLabel: String? // e.g., "Daily Focus", "Monthly Focus"
    let summarySentence: String? // TL;DR - one sentence orientation
    
    // Custom Codable implementation for backward compatibility
    enum CodingKeys: String, CodingKey {
        case id, type, preview, fullInsight, headline, bodyLines, lastUpdated, contentVersion
        case contextInfo, astrologicalContext, numerologyContext, expandedContent
        case timeframeLabel, summarySentence
    }
    
    init(id: String, type: CoreGuidanceCardType, preview: String, fullInsight: String, headline: String?, bodyLines: [String]?, lastUpdated: Date, contentVersion: String, contextInfo: String? = nil, astrologicalContext: String? = nil, numerologyContext: String? = nil, expandedContent: ExpandedGuidanceContent? = nil, timeframeLabel: String? = nil, summarySentence: String? = nil) {
        self.id = id
        self.type = type
        self.preview = preview
        self.fullInsight = fullInsight
        self.headline = headline
        self.bodyLines = bodyLines
        self.lastUpdated = lastUpdated
        self.contentVersion = contentVersion
        self.contextInfo = contextInfo
        self.astrologicalContext = astrologicalContext
        self.numerologyContext = numerologyContext
        self.expandedContent = expandedContent
        self.timeframeLabel = timeframeLabel
        self.summarySentence = summarySentence
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(CoreGuidanceCardType.self, forKey: .type)
        preview = try container.decode(String.self, forKey: .preview)
        fullInsight = try container.decode(String.self, forKey: .fullInsight)
        headline = try container.decodeIfPresent(String.self, forKey: .headline)
        bodyLines = try container.decodeIfPresent([String].self, forKey: .bodyLines)
        lastUpdated = try container.decode(Date.self, forKey: .lastUpdated)
        contentVersion = try container.decode(String.self, forKey: .contentVersion)
        contextInfo = try container.decodeIfPresent(String.self, forKey: .contextInfo)
        astrologicalContext = try container.decodeIfPresent(String.self, forKey: .astrologicalContext)
        numerologyContext = try container.decodeIfPresent(String.self, forKey: .numerologyContext)
        expandedContent = try container.decodeIfPresent(ExpandedGuidanceContent.self, forKey: .expandedContent)
        timeframeLabel = try container.decodeIfPresent(String.self, forKey: .timeframeLabel)
        summarySentence = try container.decodeIfPresent(String.self, forKey: .summarySentence)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(preview, forKey: .preview)
        try container.encode(fullInsight, forKey: .fullInsight)
        try container.encodeIfPresent(headline, forKey: .headline)
        try container.encodeIfPresent(bodyLines, forKey: .bodyLines)
        try container.encode(lastUpdated, forKey: .lastUpdated)
        try container.encode(contentVersion, forKey: .contentVersion)
        try container.encodeIfPresent(contextInfo, forKey: .contextInfo)
        try container.encodeIfPresent(astrologicalContext, forKey: .astrologicalContext)
        try container.encodeIfPresent(numerologyContext, forKey: .numerologyContext)
        try container.encodeIfPresent(expandedContent, forKey: .expandedContent)
        try container.encodeIfPresent(timeframeLabel, forKey: .timeframeLabel)
        try container.encodeIfPresent(summarySentence, forKey: .summarySentence)
    }
    
    // Equatable conformance - use only id for sheet presentation
    // This ensures SwiftUI's sheet(item:) modifier can detect changes properly
    static func == (lhs: CoreGuidanceCard, rhs: CoreGuidanceCard) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hasNewContent: Bool {
        // This will be managed by the service based on user interaction
        false
    }
    
    // Computed properties for backward compatibility
    var displayHeadline: String {
        headline ?? type.title
    }
    
    var displayBody: String {
        if let bodyLines = bodyLines, !bodyLines.isEmpty {
            return bodyLines.joined(separator: "\n")
        }
        return fullInsight
    }
    
    var displayBodyLines: [String] {
        if let bodyLines = bodyLines, !bodyLines.isEmpty {
            return bodyLines
        }
        // Fallback: split fullInsight by sentences for line-by-line animation
        return fullInsight.components(separatedBy: ". ").filter { !$0.isEmpty }
    }
}

// MARK: - Core Guidance State
struct CoreGuidanceState: Codable {
    var cards: [CoreGuidanceCard]
    var lastOpenedDates: [String: Date] // Card ID -> Last opened date
    var contentVersions: [String: String] // Card ID -> Last seen version
    
    static func `default`() -> CoreGuidanceState {
        CoreGuidanceState(
            cards: [],
            lastOpenedDates: [:],
            contentVersions: [:]
        )
    }
}

// MARK: - Premium Event Models
enum PremiumEventType: String, Codable {
    case mercuryRetrograde = "mercury_retrograde"
    case monthlyHoroscope = "monthly_horoscope"
    case personalMonthChange = "personal_month_change"
    case saturnReturn = "saturn_return"
    case favorableDates = "favorable_dates"
    case focusArea = "focus_area"
    case moonPhase = "moon_phase"
}

struct PremiumEvent: Identifiable {
    let id: String
    let type: PremiumEventType
    let priority: Int // 1-10, higher = more important
    let startDate: Date
    let endDate: Date?
    let title: String
    let preview: String
    let isActive: Bool
    let personalizationData: EventPersonalization
    
    var cardId: String {
        "premium_event_\(type.rawValue)_\(id)"
    }
}

struct EventPersonalization {
    let userSunSign: String
    let userMoonSign: String?
    let userMercurySign: String?
    let userPersonalMonth: Int?
    let userPersonalYear: Int?
    let userAge: Int?
    let relevantTransits: [String]
    let additionalData: [String: Any]?
    
    init(
        userSunSign: String,
        userMoonSign: String? = nil,
        userMercurySign: String? = nil,
        userPersonalMonth: Int? = nil,
        userPersonalYear: Int? = nil,
        userAge: Int? = nil,
        relevantTransits: [String] = [],
        additionalData: [String: Any]? = nil
    ) {
        self.userSunSign = userSunSign
        self.userMoonSign = userMoonSign
        self.userMercurySign = userMercurySign
        self.userPersonalMonth = userPersonalMonth
        self.userPersonalYear = userPersonalYear
        self.userAge = userAge
        self.relevantTransits = relevantTransits
        self.additionalData = additionalData
    }
}
