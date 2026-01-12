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

// MARK: - Core Guidance Card
struct CoreGuidanceCard: Codable, Identifiable {
    let id: String
    let type: CoreGuidanceCardType
    let preview: String // Short preview text for card
    let fullInsight: String // Expanded insight for modal (kept for backward compatibility)
    let headline: String? // New: Card headline (e.g., "A Quiet Shift")
    let bodyLines: [String]? // New: Array of 2-4 short lines for line-by-line animation
    let lastUpdated: Date
    let contentVersion: String // Used to track if content has changed
    
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

