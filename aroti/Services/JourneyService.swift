//
//  JourneyService.swift
//  Aroti
//
//  Mock API service for journey summary data
//

import Foundation

class JourneyService {
    static let shared = JourneyService()
    
    private let activityHistoryKey = "aroti_activity_history"
    private let todayActivityKey = "aroti_today_activity"
    private let todayActivityDateKey = "aroti_today_activity_date"
    
    private init() {}
    
    // MARK: - Level System
    
    private let levelThresholds: [(points: Int, name: String, reward: String?)] = [
        (0, "Welcome", nil),
        (100, "Seeker", "Unlock 1 spread"),
        (300, "Explorer", "Unlock theme"),
        (600, "Oracle", "Unlock weekly insight"),
        (1000, "Master", "Unlock advanced routine"),
        (2000, "Sage", "Unlock special spread"),
        (3000, "Enlightened", "Unlock rare theme")
    ]
    
    func getLevelInfo(lifetimePoints: Int) -> LevelInfo {
        var currentLevel = 1
        var currentLevelName = "Welcome"
        var nextLevel = 2
        var nextLevelThreshold = 100
        var pointsToNextLevel = 100
        
        for (index, threshold) in levelThresholds.enumerated() {
            if lifetimePoints >= threshold.points {
                currentLevel = index + 1
                currentLevelName = threshold.name
                
                if index + 1 < levelThresholds.count {
                    nextLevel = index + 2
                    nextLevelThreshold = levelThresholds[index + 1].points
                    pointsToNextLevel = max(0, nextLevelThreshold - lifetimePoints)
                } else {
                    nextLevel = currentLevel
                    nextLevelThreshold = threshold.points
                    pointsToNextLevel = 0
                }
            } else {
                break
            }
        }
        
        return LevelInfo(
            currentLevel: currentLevel,
            currentLevelName: currentLevelName,
            nextLevel: nextLevel,
            nextLevelThreshold: nextLevelThreshold,
            pointsToNextLevel: pointsToNextLevel
        )
    }
    
    // MARK: - Journey Summary
    
    func getJourneySummary() -> JourneySummary {
        let balance = PointsService.shared.getBalance()
        let levelInfo = getLevelInfo(lifetimePoints: balance.lifetimePoints)
        let today = getTodayProgress()
        let last7Days = getLast7Days()
        let milestones = getMilestones(lifetimePoints: balance.lifetimePoints)
        let recentUnlocks = getRecentUnlocks()
        
        return JourneySummary(
            totalPoints: balance.totalPoints,
            lifetimePoints: balance.lifetimePoints,
            currentLevel: levelInfo.currentLevel,
            currentLevelName: levelInfo.currentLevelName,
            nextLevel: levelInfo.nextLevel,
            nextLevelThreshold: levelInfo.nextLevelThreshold,
            pointsToNextLevel: levelInfo.pointsToNextLevel,
            today: today,
            last7Days: last7Days,
            milestones: milestones,
            recentUnlocks: recentUnlocks
        )
    }
    
    // MARK: - Today's Progress
    
    private func getTodayProgress() -> TodayProgress {
        let calendar = Calendar.current
        let today = Date()
        let savedDate = UserDefaults.standard.object(forKey: todayActivityDateKey) as? Date
        
        // Reset if different day
        if let savedDate = savedDate, !calendar.isDate(savedDate, inSameDayAs: today) {
            resetTodayActivity()
        }
        
        let activity = getTodayActivity()
        let streakDays = getStreakDays()
        
        return TodayProgress(
            points: activity["points"] as? Int ?? 0,
            completedPractices: activity["practices"] as? Int ?? 0,
            completedSpreads: activity["spreads"] as? Int ?? 0,
            completedQuizzes: activity["quizzes"] as? Int ?? 0,
            streakDays: streakDays
        )
    }
    
    func recordActivity(type: String, points: Int = 0) {
        var activity = getTodayActivity()
        let calendar = Calendar.current
        let today = Date()
        let savedDate = UserDefaults.standard.object(forKey: todayActivityDateKey) as? Date
        
        // Reset if different day
        if let savedDate = savedDate, !calendar.isDate(savedDate, inSameDayAs: today) {
            resetTodayActivity()
            activity = [:]
        }
        
        // Update activity
        switch type {
        case "practice":
            activity["practices"] = (activity["practices"] as? Int ?? 0) + 1
        case "spread":
            activity["spreads"] = (activity["spreads"] as? Int ?? 0) + 1
        case "quiz":
            activity["quizzes"] = (activity["quizzes"] as? Int ?? 0) + 1
        default:
            break
        }
        
        activity["points"] = (activity["points"] as? Int ?? 0) + points
        activity["date"] = today
        
        saveTodayActivity(activity)
        recordActivityHistory(type: type, points: points)
    }
    
    private func getTodayActivity() -> [String: Any] {
        return UserDefaults.standard.dictionary(forKey: todayActivityKey) ?? [:]
    }
    
    private func saveTodayActivity(_ activity: [String: Any]) {
        UserDefaults.standard.set(activity, forKey: todayActivityKey)
        if let date = activity["date"] as? Date {
            UserDefaults.standard.set(date, forKey: todayActivityDateKey)
        }
    }
    
    private func resetTodayActivity() {
        UserDefaults.standard.removeObject(forKey: todayActivityKey)
        UserDefaults.standard.set(Date(), forKey: todayActivityDateKey)
    }
    
    // MARK: - Last 7 Days
    
    private func getLast7Days() -> [DailyPoints] {
        let history = getActivityHistory()
        let calendar = Calendar.current
        let today = Date()
        var dailyPoints: [String: Int] = [:]
        
        // Initialize last 7 days
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let dateString = formatDate(date)
                dailyPoints[dateString] = 0
            }
        }
        
        // Sum points by date
        for entry in history {
            if let date = entry["date"] as? Date,
               let points = entry["points"] as? Int {
                let dateString = formatDate(date)
                if dailyPoints[dateString] != nil {
                    dailyPoints[dateString] = (dailyPoints[dateString] ?? 0) + points
                }
            }
        }
        
        // Convert to array and sort
        return dailyPoints.map { DailyPoints(date: $0.key, points: $0.value) }
            .sorted { $0.date > $1.date }
    }
    
    private func recordActivityHistory(type: String, points: Int) {
        var history = getActivityHistory()
        history.append([
            "type": type,
            "points": points,
            "date": Date()
        ])
        
        // Keep only last 30 days
        let calendar = Calendar.current
        let cutoffDate = calendar.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        history = history.filter { entry in
            if let date = entry["date"] as? Date {
                return date >= cutoffDate
            }
            return false
        }
        
        saveActivityHistory(history)
    }
    
    func getActivityHistory() -> [[String: Any]] {
        guard let data = UserDefaults.standard.data(forKey: activityHistoryKey),
              let history = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return []
        }
        return history
    }
    
    private func saveActivityHistory(_ history: [[String: Any]]) {
        if let data = try? JSONSerialization.data(withJSONObject: history) {
            UserDefaults.standard.set(data, forKey: activityHistoryKey)
        }
    }
    
    // MARK: - Milestones
    
    private func getMilestones(lifetimePoints: Int) -> [Milestone] {
        return levelThresholds.enumerated().map { index, threshold in
            Milestone(
                id: "milestone-\(index + 1)",
                level: index + 1,
                requiredPoints: threshold.points,
                label: threshold.reward ?? "Level \(index + 1)",
                completed: lifetimePoints >= threshold.points,
                reward: threshold.reward
            )
        }
    }
    
    // MARK: - Recent Unlocks
    
    private func getRecentUnlocks() -> [Unlock] {
        let unlocked = AccessControlService.shared.getUnlockedContent()
        var unlocks: [Unlock] = []
        
        for (key, value) in unlocked {
            if let unlockData = value as? [String: Any],
               let timestamp = unlockData["timestamp"] as? TimeInterval {
                let components = key.components(separatedBy: ":")
                if components.count == 2 {
                    unlocks.append(Unlock(
                        id: key,
                        type: components[0],
                        contentId: components[1],
                        timestamp: Date(timeIntervalSince1970: timestamp)
                    ))
                }
            }
        }
        
        return unlocks.sorted { $0.timestamp > $1.timestamp }.prefix(5).map { $0 }
    }
    
    // MARK: - Streak
    
    func getStreakDays() -> Int {
        let history = getActivityHistory()
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        
        // Check consecutive days with activity
        while streak < 365 { // Max 365 day streak
            let dateString = formatDate(currentDate)
            let hasActivity = history.contains { entry in
                if let date = entry["date"] as? Date {
                    return formatDate(date) == dateString && (entry["points"] as? Int ?? 0) > 0
                }
                return false
            }
            
            if hasActivity {
                streak += 1
                if let prevDate = calendar.date(byAdding: .day, value: -1, to: currentDate) {
                    currentDate = prevDate
                } else {
                    break
                }
            } else {
                break
            }
        }
        
        return streak
    }
    
    // MARK: - Helpers
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}


