//
//  HomeModels.swift
//  Aroti
//
//  Data models for home page content
//

import Foundation

struct UserData: Codable {
    let name: String
    let sunSign: String
    let moonSign: String?
    let birthDate: Date?
    let traits: [String]?
    
    static let `default` = UserData(
        name: "Yana",
        sunSign: "Pisces",
        moonSign: "Cancer",
        birthDate: nil,
        traits: ["Intuitive", "Spiritual"]
    )
}

struct TarotCard: Codable, Identifiable {
    let id: String
    let name: String
    let keywords: [String]
    let interpretation: String?
    let guidance: [String]?
    let imageName: String?  // Maps to asset name in app bundle
}

struct Ritual: Codable {
    let id: String
    let title: String
    let description: String
    let duration: String
    let type: String
    let intention: String?
    let steps: [String]?
    let affirmation: String?
    let benefits: [String]?
}

struct NumerologyInsight: Codable {
    let number: Int
    let preview: String
}

struct DailyInsight: Codable {
    let tarotCard: TarotCard?
    let horoscope: String
    let numerology: NumerologyInsight
    let ritual: Ritual
    let affirmation: String
    let date: Date
}

struct DailyState: Codable {
    let date: Date
    let tarotCardFlipped: Bool
    let affirmationShuffled: Bool
    let affirmationShuffleCount: Int
    
    static func `default`(for date: Date) -> DailyState {
        DailyState(
            date: date,
            tarotCardFlipped: false,
            affirmationShuffled: false,
            affirmationShuffleCount: 0
        )
    }
}

