//
//  PointsModels.swift
//  Aroti
//
//  Data models for points system
//

import Foundation

struct PointsBalance: Codable {
    let totalPoints: Int
    let lifetimePoints: Int
}

struct LevelInfo: Codable {
    let currentLevel: Int
    let currentLevelName: String
    let nextLevel: Int
    let nextLevelThreshold: Int
    let pointsToNextLevel: Int
}

struct PointsTransaction: Codable {
    let event: String
    let points: Int
    let timestamp: Date
}

struct PointsEarnResult: Codable {
    let success: Bool
    let newBalance: Int
    let newLifetimePoints: Int
    let message: String?
}

struct PointsSpendResult: Codable {
    let success: Bool
    let newBalance: Int
    let message: String?
}

