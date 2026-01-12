//
//  AccessModels.swift
//  Aroti
//
//  Data models for access control
//

import Foundation

enum AccessStatus: Codable, Equatable {
    case free
    case unlockableWithPoints(cost: Int)
    case premiumOnly
    case unlocked
}

struct ContentAccess: Codable {
    let contentId: String
    let contentType: ContentType
    let status: AccessStatus
    let isUnlocked: Bool
}

enum ContentType: String, Codable {
    case aiChat
    case dailyPractice
    case tarotSpread
    case article
    case quiz
    case numerologyLayer
    case theme
    case premiumForecast
    case learningLesson
    case dailyRitual
    case course
}

struct AccessRule: Codable {
    let contentId: String
    let contentType: ContentType
    let freeAccess: Bool
    let premiumAccess: Bool
    let unlockCost: Int?
    let permanentUnlockCost: Int?
    let isPremiumOnly: Bool
}

