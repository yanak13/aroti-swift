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
}

