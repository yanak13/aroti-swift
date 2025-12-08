//
//  AccessControlService.swift
//  Aroti
//
//  Access rule evaluation and content gating
//

import Foundation

class AccessControlService {
    static let shared = AccessControlService()
    
    private let freeMessagesKey = "aroti_free_messages_used"
    private let freeMessagesDateKey = "aroti_free_messages_date"
    private let freePracticesKey = "aroti_free_practices_used"
    private let freePracticesDateKey = "aroti_free_practices_date"
    private let freeQuizzesKey = "aroti_free_quizzes_used"
    private let freeQuizzesDateKey = "aroti_free_quizzes_date"
    private let freeCompatibilityKey = "aroti_free_compatibility_used"
    private let freeCompatibilityDateKey = "aroti_free_compatibility_date"
    private let unlockedContentKey = "aroti_unlocked_content"
    
    private let freeMessagesLimit = 3
    private let freePracticesLimit = 1
    private let freeQuizzesLimit = 1
    private let freeCompatibilityLimit = 1
    private let compatibilityPointsCost = 50
    
    private init() {}
    
    // MARK: - Premium Status
    
    var isPremium: Bool {
        UserSubscriptionService.shared.isPremium
    }
    
    // MARK: - Free Messages Limit
    
    var freeMessagesLimitValue: Int {
        return freeMessagesLimit
    }
    
    func getFreeMessagesRemaining() -> Int {
        if isPremium {
            return Int.max // Unlimited for premium
        }
        
        let (used, date) = getFreeMessagesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        // Reset if different day
        if !calendar.isDate(date, inSameDayAs: today) {
            return freeMessagesLimit
        }
        
        let remaining = freeMessagesLimit - used
        return max(0, remaining)
    }
    
    // MARK: - AI Chat Access
    
    func canAccessAIChat() -> (allowed: Bool, cost: Int?) {
        if isPremium {
            return (true, nil)
        }
        
        let (used, date) = getFreeMessagesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        // Reset if different day
        if !calendar.isDate(date, inSameDayAs: today) {
            resetFreeMessagesUsage()
            return (true, nil)
        }
        
        if used < freeMessagesLimit {
            return (true, nil)
        }
        
        return (false, 20) // 20 points per message after limit
    }
    
    func recordAIChatMessage() {
        if isPremium { return }
        
        let (used, date) = getFreeMessagesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            resetFreeMessagesUsage()
            UserDefaults.standard.set(1, forKey: freeMessagesKey)
            UserDefaults.standard.set(today, forKey: freeMessagesDateKey)
        } else {
            UserDefaults.standard.set(used + 1, forKey: freeMessagesKey)
        }
    }
    
    private func getFreeMessagesUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: freeMessagesKey)
        let date = UserDefaults.standard.object(forKey: freeMessagesDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func resetFreeMessagesUsage() {
        UserDefaults.standard.set(0, forKey: freeMessagesKey)
        UserDefaults.standard.set(Date(), forKey: freeMessagesDateKey)
    }
    
    // MARK: - Testing Helpers
    
    /// Reset free messages for testing (refills to full limit)
    func resetFreeMessagesForTesting() {
        resetFreeMessagesUsage()
    }
    
    // MARK: - Daily Practice Access
    
    func canAccessDailyPractice(practiceId: String) -> (allowed: Bool, cost: Int?, reason: String?) {
        if isPremium {
            return (true, nil, nil)
        }
        
        let (used, date) = getFreePracticesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        // Reset if different day
        if !calendar.isDate(date, inSameDayAs: today) {
            resetFreePracticesUsage()
            return (true, nil, nil)
        }
        
        if used < freePracticesLimit {
            return (true, nil, nil)
        }
        
        return (false, 10, "You've used your free practice today. Unlock another for 10 points?")
    }
    
    func recordDailyPractice() {
        if isPremium { return }
        
        let (used, date) = getFreePracticesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            resetFreePracticesUsage()
            UserDefaults.standard.set(1, forKey: freePracticesKey)
            UserDefaults.standard.set(today, forKey: freePracticesDateKey)
        } else {
            UserDefaults.standard.set(used + 1, forKey: freePracticesKey)
        }
    }
    
    private func getFreePracticesUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: freePracticesKey)
        let date = UserDefaults.standard.object(forKey: freePracticesDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func resetFreePracticesUsage() {
        UserDefaults.standard.set(0, forKey: freePracticesKey)
        UserDefaults.standard.set(Date(), forKey: freePracticesDateKey)
    }
    
    // MARK: - Tarot Spread Access
    
    func canAccessSpread(spreadId: String) -> (allowed: Bool, cost: Int?, permanentCost: Int?, isPremiumOnly: Bool) {
        // Basic spreads are free
        let basicSpreads = ["three-card", "one-card", "past-present-future"]
        if basicSpreads.contains(spreadId) {
            return (true, nil, nil, false)
        }
        
        if isPremium {
            // Premium users get all normal spreads
            let premiumOnlySpreads = ["shadow-work", "deep-relationship"] // Example premium-only
            if premiumOnlySpreads.contains(spreadId) {
                return (false, nil, nil, true)
            }
            return (true, nil, nil, false)
        }
        
        // Check if permanently unlocked
        if isContentUnlocked(contentId: spreadId, contentType: .tarotSpread) {
            return (true, nil, nil, false)
        }
        
        // Check if temporarily unlocked (24 hours)
        if isContentTemporarilyUnlocked(contentId: spreadId) {
            return (true, nil, nil, false)
        }
        
        // Can be unlocked
        return (false, 40, 150, false) // 40 points temp, 150 points permanent
    }
    
    // MARK: - Quiz Access
    
    func canAccessQuiz() -> (allowed: Bool, cost: Int?) {
        if isPremium {
            return (true, nil)
        }
        
        let (used, date) = getFreeQuizzesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        // Reset if different day
        if !calendar.isDate(date, inSameDayAs: today) {
            resetFreeQuizzesUsage()
            return (true, nil)
        }
        
        if used < freeQuizzesLimit {
            return (true, nil)
        }
        
        return (false, 10) // 10 points per extra quiz
    }
    
    func recordQuiz() {
        if isPremium { return }
        
        let (used, date) = getFreeQuizzesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            resetFreeQuizzesUsage()
            UserDefaults.standard.set(1, forKey: freeQuizzesKey)
            UserDefaults.standard.set(today, forKey: freeQuizzesDateKey)
        } else {
            UserDefaults.standard.set(used + 1, forKey: freeQuizzesKey)
        }
    }
    
    private func getFreeQuizzesUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: freeQuizzesKey)
        let date = UserDefaults.standard.object(forKey: freeQuizzesDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func resetFreeQuizzesUsage() {
        UserDefaults.standard.set(0, forKey: freeQuizzesKey)
        UserDefaults.standard.set(Date(), forKey: freeQuizzesDateKey)
    }
    
    // MARK: - Article Access
    
    func canAccessArticle(articleId: String) -> (allowed: Bool, isPreviewOnly: Bool) {
        if isPremium {
            return (true, false)
        }
        
        // Check if unlocked
        if isContentUnlocked(contentId: articleId, contentType: .article) {
            return (true, false)
        }
        
        // Free users get preview only
        return (true, true)
    }
    
    // MARK: - Content Unlocking
    
    func unlockContent(contentId: String, contentType: ContentType, permanent: Bool = true) {
        var unlocked = getUnlockedContent()
        let key = "\(contentType.rawValue):\(contentId)"
        
        if permanent {
            unlocked[key] = ["permanent": true, "timestamp": Date().timeIntervalSince1970]
        } else {
            // Temporary unlock (24 hours)
            unlocked[key] = ["permanent": false, "timestamp": Date().timeIntervalSince1970]
        }
        
        saveUnlockedContent(unlocked)
    }
    
    func isContentUnlocked(contentId: String, contentType: ContentType) -> Bool {
        let unlocked = getUnlockedContent()
        let key = "\(contentType.rawValue):\(contentId)"
        
        if let unlockData = unlocked[key] as? [String: Any],
           let permanent = unlockData["permanent"] as? Bool,
           permanent {
            return true
        }
        
        return false
    }
    
    func isContentTemporarilyUnlocked(contentId: String) -> Bool {
        let unlocked = getUnlockedContent()
        
        for (key, value) in unlocked {
            if key.contains(contentId),
               let unlockData = value as? [String: Any],
               let permanent = unlockData["permanent"] as? Bool,
               !permanent,
               let timestamp = unlockData["timestamp"] as? TimeInterval {
                // Check if within 24 hours
                let unlockDate = Date(timeIntervalSince1970: timestamp)
                let hoursSinceUnlock = Date().timeIntervalSince(unlockDate) / 3600
                return hoursSinceUnlock < 24
            }
        }
        
        return false
    }
    
    func getUnlockedContent() -> [String: Any] {
        return UserDefaults.standard.dictionary(forKey: unlockedContentKey) ?? [:]
    }
    
    private func saveUnlockedContent(_ content: [String: Any]) {
        UserDefaults.standard.set(content, forKey: unlockedContentKey)
    }
    
    // MARK: - Generic Access Check
    
    func checkAccess(contentId: String, contentType: ContentType) -> AccessStatus {
        switch contentType {
        case .aiChat:
            let (allowed, cost) = canAccessAIChat()
            if allowed {
                return .free
            } else if let cost = cost {
                return .unlockableWithPoints(cost: cost)
            }
            return .premiumOnly
            
        case .dailyPractice:
            let (allowed, cost, _) = canAccessDailyPractice(practiceId: contentId)
            if allowed {
                return .free
            } else if let cost = cost {
                return .unlockableWithPoints(cost: cost)
            }
            return .premiumOnly
            
        case .tarotSpread:
            let (allowed, cost, _, isPremiumOnly) = canAccessSpread(spreadId: contentId)
            if allowed {
                return .unlocked
            } else if isPremiumOnly {
                return .premiumOnly
            } else if let cost = cost {
                return .unlockableWithPoints(cost: cost)
            }
            return .premiumOnly
            
        case .article:
            let (allowed, isPreviewOnly) = canAccessArticle(articleId: contentId)
            if allowed && !isPreviewOnly {
                return .unlocked
            } else if isPreviewOnly {
                return .unlockableWithPoints(cost: 20) // Example cost
            }
            return .premiumOnly
            
        case .quiz:
            let (allowed, cost) = canAccessQuiz()
            if allowed {
                return .free
            } else if let cost = cost {
                return .unlockableWithPoints(cost: cost)
            }
            return .premiumOnly
            
        case .numerologyLayer, .theme:
            if isPremium {
                return .unlocked
            }
            return .unlockableWithPoints(cost: 30) // Example cost
        }
    }
    
    // MARK: - Compatibility Access
    
    func getFreeCompatibilityRemaining() -> Int {
        if isPremium {
            return Int.max // Unlimited for premium
        }
        
        let (used, date) = getFreeCompatibilityUsage()
        let calendar = Calendar.current
        let today = Date()
        
        // Reset if different day
        if !calendar.isDate(date, inSameDayAs: today) {
            return freeCompatibilityLimit
        }
        
        let remaining = freeCompatibilityLimit - used
        return max(0, remaining)
    }
    
    func canAccessCompatibility() -> (allowed: Bool, type: CompatibilityAccessType, cost: Int?) {
        if isPremium {
            return (true, .premium, nil)
        }
        
        let freeRemaining = getFreeCompatibilityRemaining()
        if freeRemaining > 0 {
            return (true, .free, nil)
        }
        
        let balance = PointsService.shared.balance.totalPoints
        if balance >= compatibilityPointsCost {
            return (true, .points, compatibilityPointsCost)
        }
        
        return (false, .denied, compatibilityPointsCost)
    }
    
    func recordCompatibilityCheck() -> Bool {
        let access = canAccessCompatibility()
        
        guard access.allowed else {
            return false
        }
        
        if access.type == .premium {
            // Premium users don't need to record
            return true
        }
        
        if access.type == .free {
            // Record free check usage
            let (used, date) = getFreeCompatibilityUsage()
            let calendar = Calendar.current
            let today = Date()
            
            if !calendar.isDate(date, inSameDayAs: today) {
                UserDefaults.standard.set(1, forKey: freeCompatibilityKey)
                UserDefaults.standard.set(today, forKey: freeCompatibilityDateKey)
            } else {
                UserDefaults.standard.set(used + 1, forKey: freeCompatibilityKey)
            }
            return true
        }
        
        if access.type == .points, let cost = access.cost {
            // Spend points
            let result = PointsService.shared.spendPoints(event: "compatibility_check", cost: cost)
            return result.success
        }
        
        return false
    }
    
    func getCompatibilityPointsCost() -> Int {
        return compatibilityPointsCost
    }
    
    private func getFreeCompatibilityUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: freeCompatibilityKey)
        let date = UserDefaults.standard.object(forKey: freeCompatibilityDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func resetFreeCompatibilityUsage() {
        UserDefaults.standard.set(0, forKey: freeCompatibilityKey)
        UserDefaults.standard.set(Date(), forKey: freeCompatibilityDateKey)
    }
}

// MARK: - Compatibility Access Type

enum CompatibilityAccessType {
    case free
    case points
    case premium
    case denied
}

