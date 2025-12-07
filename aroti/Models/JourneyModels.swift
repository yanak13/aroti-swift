//
//  JourneyModels.swift
//  Aroti
//
//  Data models for journey tracking
//

import Foundation

struct JourneySummary: Codable {
    let totalPoints: Int
    let lifetimePoints: Int
    let currentLevel: Int
    let currentLevelName: String
    let nextLevel: Int
    let nextLevelThreshold: Int
    let pointsToNextLevel: Int
    let today: TodayProgress
    let last7Days: [DailyPoints]
    let milestones: [Milestone]
    let recentUnlocks: [Unlock]
}

struct TodayProgress: Codable {
    let points: Int
    let completedPractices: Int
    let completedSpreads: Int
    let completedQuizzes: Int
    let streakDays: Int
}

struct DailyPoints: Codable {
    let date: String
    let points: Int
}

struct Milestone: Codable, Identifiable {
    let id: String
    let level: Int
    let requiredPoints: Int
    let label: String
    let completed: Bool
    let reward: String?
}

struct Unlock: Codable, Identifiable {
    let id: String
    let type: String
    let contentId: String
    let timestamp: Date
}

