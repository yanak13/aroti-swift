//
//  DailyStateManager.swift
//  Aroti
//
//  Manager for daily state persistence
//

import Foundation

class DailyStateManager {
    static let shared = DailyStateManager()
    
    private let dailyStateKey = "aroti_daily_state"
    private let userDataKey = "aroti_user_data"
    private let reflectionKey = "aroti_reflection"
    
    private init() {}
    
    func loadUserData() -> UserData? {
        guard let data = UserDefaults.standard.data(forKey: userDataKey),
              let userData = try? JSONDecoder().decode(UserData.self, from: data) else {
            return UserData.default
        }
        return userData
    }
    
    func saveUserData(_ userData: UserData) {
        if let encoded = try? JSONEncoder().encode(userData) {
            UserDefaults.standard.set(encoded, forKey: userDataKey)
        }
    }
    
    func loadDailyState() -> DailyState? {
        guard let data = UserDefaults.standard.data(forKey: dailyStateKey),
              let state = try? JSONDecoder().decode(DailyState.self, from: data) else {
            return nil
        }
        return state
    }
    
    func saveDailyState(_ state: DailyState) {
        if let encoded = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(encoded, forKey: dailyStateKey)
        }
    }
    
    func shouldResetDailyState() -> Bool {
        guard let state = loadDailyState() else {
            return true
        }
        
        let calendar = Calendar.current
        let today = Date()
        let stateDate = state.date
        
        return !calendar.isDate(stateDate, inSameDayAs: today)
    }
    
    func resetDailyState() -> DailyState {
        let newState = DailyState.default(for: Date())
        saveDailyState(newState)
        return newState
    }
    
    func hasFlippedCardToday() -> Bool {
        guard let state = loadDailyState() else {
            return false
        }
        
        let calendar = Calendar.current
        let today = Date()
        let stateDate = state.date
        
        if calendar.isDate(stateDate, inSameDayAs: today) {
            return state.tarotCardFlipped
        }
        
        return false
    }
    
    func markCardFlipped() {
        var state = loadDailyState() ?? DailyState.default(for: Date())
        
        let calendar = Calendar.current
        let today = Date()
        let stateDate = state.date
        
        if !calendar.isDate(stateDate, inSameDayAs: today) {
            state = DailyState.default(for: today)
        }
        
        var updatedState = state
        updatedState = DailyState(
            date: updatedState.date,
            tarotCardFlipped: true,
            affirmationShuffled: updatedState.affirmationShuffled,
            affirmationShuffleCount: updatedState.affirmationShuffleCount
        )
        
        saveDailyState(updatedState)
    }
    
    func canShuffleAffirmation() -> Bool {
        guard let state = loadDailyState() else {
            return true
        }
        
        let calendar = Calendar.current
        let today = Date()
        let stateDate = state.date
        
        if !calendar.isDate(stateDate, inSameDayAs: today) {
            return true
        }
        
        return state.affirmationShuffleCount < 2
    }
    
    func markAffirmationShuffled() {
        var state = loadDailyState() ?? DailyState.default(for: Date())
        
        let calendar = Calendar.current
        let today = Date()
        let stateDate = state.date
        
        if !calendar.isDate(stateDate, inSameDayAs: today) {
            state = DailyState.default(for: today)
        }
        
        var updatedState = state
        updatedState = DailyState(
            date: updatedState.date,
            tarotCardFlipped: updatedState.tarotCardFlipped,
            affirmationShuffled: true,
            affirmationShuffleCount: updatedState.affirmationShuffleCount + 1
        )
        
        saveDailyState(updatedState)
    }
    
    // MARK: - Streak Tracking for Points
    
    func checkAndAwardStreakBonus() {
        // Check if user has activity today (for streak bonus)
        // This is called when user completes any activity
        // The actual streak calculation and bonus awarding is handled by JourneyService
        let journeyService = JourneyService.shared
        let streakDays = journeyService.getStreakDays()
        
        // Award streak bonus if this is a new streak day
        // This logic ensures we only award once per day
        let lastStreakBonusDate = UserDefaults.standard.string(forKey: "aroti_last_streak_bonus_date")
        let todayString = formatDate(Date())
        
        if lastStreakBonusDate != todayString && streakDays > 0 {
            // Award 5 bonus points for maintaining streak
            _ = PointsService.shared.earnPoints(event: "streak_bonus", points: 5)
            JourneyService.shared.recordActivity(type: "streak", points: 5)
            UserDefaults.standard.set(todayString, forKey: "aroti_last_streak_bonus_date")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    // MARK: - Reflection Storage (Multiple reflections per day)
    
    func saveTodayReflection(_ text: String) {
        var entries = loadTodayReflections()
        let entry = ReflectionEntry(
            text: text,
            timestamp: Date(),
            date: Date()
        )
        entries.append(entry)
        
        if let encoded = try? JSONEncoder().encode(entries) {
            let key = "\(reflectionKey)_\(formatDate(Date()))"
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func updateReflection(at index: Int, text: String) {
        var entries = loadTodayReflections()
        guard index < entries.count else { return }
        
        let updatedEntry = ReflectionEntry(
            text: text,
            timestamp: entries[index].timestamp, // Keep original timestamp
            date: Date()
        )
        entries[index] = updatedEntry
        
        if let encoded = try? JSONEncoder().encode(entries) {
            let key = "\(reflectionKey)_\(formatDate(Date()))"
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func loadTodayReflections() -> [ReflectionEntry] {
        let key = "\(reflectionKey)_\(formatDate(Date()))"
        guard let data = UserDefaults.standard.data(forKey: key),
              let entries = try? JSONDecoder().decode([ReflectionEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    func loadTodayReflection() -> ReflectionEntry? {
        // For backward compatibility - returns the most recent reflection
        let entries = loadTodayReflections()
        return entries.last
    }
    
    func hasReflectionToday() -> Bool {
        return !loadTodayReflections().isEmpty
    }
}


