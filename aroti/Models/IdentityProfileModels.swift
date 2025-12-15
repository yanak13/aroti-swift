//
//  IdentityProfileModels.swift
//  Aroti
//
//  Data models for user identity profile (V1)
//

import Foundation

// MARK: - Main Identity Profile Container
struct UserIdentityProfile: Codable {
    let astrology: AstrologyIdentity?
    let numerology: NumerologyIdentity?
    let matrix: MatrixIdentity?
    let elements: ElementalIdentity?
    let computedAt: Date
    let version: String
    
    static let currentVersion = "v1"
}

// MARK: - Astrology Identity
struct AstrologyIdentity: Codable {
    // Free content
    let sunSign: String
    let moonSign: String
    let risingSign: String
    let dominantElement: Element
    let freeSummary: String
    
    // Premium content
    let lifeFocusAreas: [LifeFocusArea]?
    let familiarPatterns: FamiliarPattern?
    let growthDirection: GrowthDirection?
    let strengths: [String]?
    let blindSpots: [String]?
    let premiumSummary: String?
    
    // Meta
    let hasAccurateBirthTime: Bool
    let hasAccurateBirthPlace: Bool
}

struct LifeFocusArea: Codable, Identifiable {
    let id: Int // house index (1-12)
    let title: String
    let shortMeaning: String
}

struct FamiliarPattern: Codable {
    let title: String
    let shortMeaning: String
}

struct GrowthDirection: Codable {
    let title: String
    let shortMeaning: String
}

// MARK: - Numerology Identity
struct NumerologyIdentity: Codable {
    // Free content
    let lifePath: Int
    let archetypeLabel: String
    let freeSummary: String
    
    // Premium content
    let destinyExpression: Int?
    let soulUrge: Int?
    let personality: Int?
    let karmicDebt: [Int]?
    let premiumSynthesis: String?
}

// MARK: - Matrix Identity
struct MatrixIdentity: Codable {
    // Free content
    let coreDestinyNumber: Int
    let freeThemes: [String]
    let matrixVisual: MatrixVisual
    
    // Premium content
    let strengthZones: [MatrixZone]?
    let challengeZones: [MatrixZone]?
    let karmicLessons: [String]?
    let repeatingPatterns: [String]?
    let premiumInterpretation: String?
}

struct MatrixVisual: Codable {
    let cells: [MatrixCell]
    let gridSize: Int // 3 or 4
}

struct MatrixCell: Codable {
    let x: Int
    let y: Int
    let value: Int?
}

struct MatrixZone: Codable, Identifiable {
    let id: String
    let title: String
    let shortMeaning: String
}

// MARK: - Elemental Identity
struct ElementalIdentity: Codable {
    // Free content
    let dominant: [Element]
    let deficient: [Element]
    let freeInsight: String
    
    // Premium content
    let imbalanceSignals: [String]?
    let supportingElements: [ElementRelationship]?
    let drainingElements: [ElementRelationship]?
    let crossSystemInfluence: String?
    let balanceGuidance: String?
}

struct ElementRelationship: Codable, Identifiable {
    let id: String
    let element: Element
    let meaning: String
}

// MARK: - Element Enum
enum Element: String, Codable, CaseIterable {
    case fire = "Fire"
    case earth = "Earth"
    case air = "Air"
    case water = "Water"
}
