//
//  AccessControlService.swift
//  Aroti
//
//  Access rule evaluation and content gating - V1 Implementation
//

import Foundation

class AccessControlService {
    static let shared = AccessControlService()
    
    // MARK: - UserDefaults Keys
    
    // Tarot Reading Usage
    private let quickDrawUsedKey = "aroti_quick_draw_used"
    private let quickDrawDateKey = "aroti_quick_draw_date"
    private let threeCardUsedKey = "aroti_three_card_used"
    private let threeCardDateKey = "aroti_three_card_date"
    
    // Daily Ritual Usage
    private let dailyRitualUsedKey = "aroti_daily_ritual_used"
    private let dailyRitualDateKey = "aroti_daily_ritual_date"
    
    // Learning Lesson Usage
    private let learningLessonsCompletedKey = "aroti_learning_lessons_completed"
    private let learningLessonsDateKey = "aroti_learning_lessons_date"
    private let learningLessonsWithPointsKey = "aroti_learning_lessons_with_points"
    private let adWatchedKey = "aroti_ad_watched"
    private let adWatchedDateKey = "aroti_ad_watched_date"
    
    // AI Chat Usage
    private let aiMessagesUsedKey = "aroti_ai_messages_used"
    private let aiMessagesDateKey = "aroti_ai_messages_date"
    
    // Tarot Enhancements (Extra Card)
    private let extraCardUsedKey = "aroti_extra_card_used"
    private let extraCardDateKey = "aroti_extra_card_date"
    
    // Unlocked Content
    private let unlockedContentKey = "aroti_unlocked_content"
    
    // MARK: - Constants
    
    // Tarot Spread IDs
    private let quickDrawSpreadId = "quick-draw" // or "one-card" - maps to Quick Draw
    private let threeCardSpreadId = "three-card" // or "past-present-future"
    private let celticCrossSpreadId = "celtic-cross"
    private let relationshipSpreadId = "relationship"
    private let careerPathSpreadId = "career-path"
    
    // Point Costs (V1)
    private let celticCrossPointsCost = 30
    private let relationshipSpreadPointsCost = 25
    private let careerPathSpreadPointsCost = 25
    private let extraCardPointsCost = 5
    private let extraAIMessagePointsCost = 3
    
    private init() {}
    
    // MARK: - Premium Status
    
    var isPremium: Bool {
        UserSubscriptionService.shared.isPremium
    }
    
    // MARK: - Premium Forecast Access
    
    /// Premium Forecast is premium-only, but always visible (blurred for free users)
    func canAccessPremiumForecast() -> (allowed: Bool, isBlurred: Bool) {
        if isPremium {
            return (true, false)
        }
        return (false, true) // Visible but blurred
    }
    
    // MARK: - Tarot Reading Access
    
    /// Check if user can access a tarot spread (legacy method for backward compatibility)
    func canAccessSpread(spreadId: String) -> (allowed: Bool, cost: Int?, permanentCost: Int?, isPremiumOnly: Bool) {
        let (allowed, cost, isPremiumOnly, _) = canAccessTarotSpread(spreadId: spreadId)
        // V1 spec: Premium spreads are one-time permanent unlocks only (no temporary unlocks)
        return (allowed, nil, cost, isPremiumOnly)
    }
    
    /// Check if user can access a tarot spread
    func canAccessTarotSpread(spreadId: String) -> (allowed: Bool, cost: Int?, isPremiumOnly: Bool, reason: String?) {
        // Premium users get unlimited access to all spreads
        if isPremium {
            return (true, nil, false, nil)
        }
        
        // Quick Draw: 1 per day free
        if spreadId == quickDrawSpreadId || spreadId == "one-card" {
            let (used, date) = getQuickDrawUsage()
            let calendar = Calendar.current
            let today = Date()
            
            if !calendar.isDate(date, inSameDayAs: today) {
                return (true, nil, false, nil)
            }
            
            if used < 1 {
                return (true, nil, false, nil)
            }
            
            // Can unlock with points for today only
            return (false, extraCardPointsCost, false, "You've used your free Quick Draw today. Unlock another for \(extraCardPointsCost) points?")
        }
        
        // Three Card Spread: 1 per day free
        if spreadId == threeCardSpreadId || spreadId == "past-present-future" {
            let (used, date) = getThreeCardUsage()
            let calendar = Calendar.current
            let today = Date()
            
            if !calendar.isDate(date, inSameDayAs: today) {
                return (true, nil, false, nil)
            }
            
            if used < 1 {
                return (true, nil, false, nil)
            }
            
            // Can unlock with points for today only
            return (false, extraCardPointsCost, false, "You've used your free Three Card Spread today. Unlock another for \(extraCardPointsCost) points?")
        }
        
        // Premium spreads: Celtic Cross, Relationship, Career Path
        if spreadId == celticCrossSpreadId {
            if isContentUnlocked(contentId: celticCrossSpreadId, contentType: .tarotSpread) {
                return (true, nil, false, nil)
            }
            return (false, celticCrossPointsCost, false, "Unlock Celtic Cross with \(celticCrossPointsCost) points or upgrade to Premium")
        }
        
        if spreadId == relationshipSpreadId {
            if isContentUnlocked(contentId: relationshipSpreadId, contentType: .tarotSpread) {
                return (true, nil, false, nil)
            }
            return (false, relationshipSpreadPointsCost, false, "Unlock Relationship Spread with \(relationshipSpreadPointsCost) points or upgrade to Premium")
        }
        
        if spreadId == careerPathSpreadId {
            if isContentUnlocked(contentId: careerPathSpreadId, contentType: .tarotSpread) {
                return (true, nil, false, nil)
            }
            return (false, careerPathSpreadPointsCost, false, "Unlock Career Path Spread with \(careerPathSpreadPointsCost) points or upgrade to Premium")
        }
        
        // Other spreads default to premium-only
        return (false, nil, true, "Premium only")
    }
    
    /// Record tarot spread usage
    func recordTarotSpreadUsage(spreadId: String) {
        if isPremium { return }
        
        if spreadId == quickDrawSpreadId || spreadId == "one-card" {
            recordQuickDrawUsage()
        } else if spreadId == threeCardSpreadId || spreadId == "past-present-future" {
            recordThreeCardUsage()
        }
    }
    
    // MARK: - Tarot Enhancement: Extra Card
    
    /// Check if user can add an extra card today
    func canAddExtraCard() -> (allowed: Bool, cost: Int?) {
        if isPremium {
            return (true, nil)
        }
        
        let (used, date) = getExtraCardUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            return (true, extraCardPointsCost)
        }
        
        if used < 1 {
            return (true, extraCardPointsCost)
        }
        
        return (false, nil) // Already used today
    }
    
    /// Record extra card usage
    func recordExtraCard() -> Bool {
        if isPremium {
            return true
        }
        
        let (used, date) = getExtraCardUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            // Spend points for today
            let result = PointsService.shared.spendPoints(event: "extra_tarot_card", cost: extraCardPointsCost)
            if result.success {
                UserDefaults.standard.set(1, forKey: extraCardUsedKey)
                UserDefaults.standard.set(today, forKey: extraCardDateKey)
                return true
            }
            return false
        }
        
        if used < 1 {
            let result = PointsService.shared.spendPoints(event: "extra_tarot_card", cost: extraCardPointsCost)
            if result.success {
                UserDefaults.standard.set(used + 1, forKey: extraCardUsedKey)
                return true
            }
            return false
        }
        
        return false
    }
    
    // MARK: - Daily Ritual Access
    
    /// Check if user can access a daily ritual
    func canAccessDailyRitual(ritualId: String) -> (allowed: Bool, reason: String?) {
        if isPremium {
            return (true, nil)
        }
        
        let (used, date) = getDailyRitualUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            return (true, nil)
        }
        
        if used < 1 {
            return (true, nil)
        }
        
        return (false, "You've completed your free ritual today. Upgrade to Premium for unlimited access.")
    }
    
    /// Record daily ritual usage
    func recordDailyRitual() {
        if isPremium { return }
        
        let (used, date) = getDailyRitualUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            UserDefaults.standard.set(1, forKey: dailyRitualUsedKey)
            UserDefaults.standard.set(today, forKey: dailyRitualDateKey)
        } else {
            UserDefaults.standard.set(used + 1, forKey: dailyRitualUsedKey)
        }
    }
    
    // MARK: - Daily Practice Access (Legacy Support - Maps to Daily Rituals)
    
    /// Check if user can access a daily practice (legacy method, maps to daily ritual)
    func canAccessDailyPractice(practiceId: String) -> (allowed: Bool, cost: Int?, reason: String?) {
        // Daily practices are the same as daily rituals in V1
        let (allowed, reason) = canAccessDailyRitual(ritualId: practiceId)
        
        if allowed {
            return (true, nil, nil)
        }
        
        // Can unlock with points (10 points for today only)
        return (false, 10, reason ?? "You've used your free practice today. Unlock another for 10 points?")
    }
    
    /// Record daily practice usage (legacy method, maps to daily ritual)
    func recordDailyPractice() {
        recordDailyRitual()
    }
    
    // MARK: - Learning Lesson Access
    
    /// Check if user can access a learning lesson
    /// Returns: (allowed, canEarnPoints, pointsCost, reason)
    func canAccessLearningLesson(lessonId: String, category: String, isIntro: Bool) -> (allowed: Bool, canEarnPoints: Bool, pointsCost: Int?, reason: String?) {
        // Premium users: unlimited access, unlimited points
        if isPremium {
            return (true, true, nil, nil)
        }
        
        // Free users: can always read lessons (never blocked)
        // But points are limited
        
        // Intro lessons: free, but limited points (1/day + 1 via ad)
        if isIntro {
            let canEarn = canEarnPointsFromLearning()
            return (true, canEarn, nil, canEarn ? nil : "Points reset tomorrow or unlock Premium for unlimited progress")
        }
        
        // Advanced lessons: unlockable with points (one-time unlock per lesson)
        if isContentUnlocked(contentId: lessonId, contentType: .learningLesson) {
            let canEarn = canEarnPointsFromLearning()
            return (true, canEarn, nil, canEarn ? nil : "Points reset tomorrow or unlock Premium for unlimited progress")
        }
        
        // Can unlock with points
        return (true, false, 1, "Unlock with points or upgrade to Premium")
    }
    
    /// Check if user can earn points from learning today
    func canEarnPointsFromLearning() -> Bool {
        if isPremium {
            return true
        }
        
        let (withPoints, date) = getLearningLessonsWithPoints()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            return true // Reset for new day
        }
        
        // Can earn from 1 lesson per day + 1 via ad
        let adWatched = hasWatchedAdToday()
        let maxLessons = adWatched ? 2 : 1
        
        return withPoints < maxLessons
    }
    
    /// Record learning lesson completion
    func recordLearningLesson(lessonId: String, category: String, isIntro: Bool, earnedPoints: Bool) -> Bool {
        if isPremium {
            // Premium users always earn points
            if earnedPoints {
                PointsService.shared.earnPoints(event: "learning_lesson", points: 1)
            }
            return true
        }
        
        // Free users: record completion
        let (completed, date) = getLearningLessonsCompleted()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            UserDefaults.standard.set(1, forKey: learningLessonsCompletedKey)
            UserDefaults.standard.set(today, forKey: learningLessonsDateKey)
        } else {
            UserDefaults.standard.set(completed + 1, forKey: learningLessonsCompletedKey)
        }
        
        // Record points earning if applicable
        if earnedPoints && canEarnPointsFromLearning() {
            let (withPoints, _) = getLearningLessonsWithPoints()
            if !calendar.isDate(date, inSameDayAs: today) {
                UserDefaults.standard.set(1, forKey: learningLessonsWithPointsKey)
                UserDefaults.standard.set(today, forKey: learningLessonsDateKey)
            } else {
                UserDefaults.standard.set(withPoints + 1, forKey: learningLessonsWithPointsKey)
            }
            PointsService.shared.earnPoints(event: "learning_lesson", points: 1)
            return true
        }
        
        // Unlock advanced lesson if spending points
        if !isIntro {
            unlockContent(contentId: lessonId, contentType: .learningLesson, permanent: true)
        }
        
        return true
    }
    
    /// Record ad watch for extra learning points
    func recordAdWatch() -> Bool {
        if isPremium {
            return false // Premium users don't need ads
        }
        
        let calendar = Calendar.current
        let today = Date()
        let (_, date) = getAdWatchUsage()
        
        if calendar.isDate(date, inSameDayAs: today) {
            return false // Already watched today
        }
        
        UserDefaults.standard.set(true, forKey: adWatchedKey)
        UserDefaults.standard.set(today, forKey: adWatchedDateKey)
        return true
    }
    
    /// Check if user has watched ad today
    func hasWatchedAdToday() -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let (watched, date) = getAdWatchUsage()
        return watched && calendar.isDate(date, inSameDayAs: today)
    }
    
    // MARK: - AI Chat Access
    
    private let freeMessagesLimit = 3
    
    /// Get remaining free messages for today
    func getFreeMessagesRemaining() -> Int {
        if isPremium {
            return Int.max // Unlimited for premium
        }
        
        let (used, date) = getAIMessagesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        // Reset if different day
        if !calendar.isDate(date, inSameDayAs: today) {
            return freeMessagesLimit
        }
        
        let remaining = freeMessagesLimit - used
        return max(0, remaining)
    }
    
    /// Check if user can send an AI message
    func canAccessAIChat() -> (allowed: Bool, cost: Int?) {
        if isPremium {
            return (true, nil)
        }
        
        // Free users get 3 messages per day (from old implementation, keeping for now)
        // After limit, can unlock with points
        let (used, date) = getAIMessagesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            return (true, nil)
        }
        
        // Assuming 3 free messages per day (adjust if spec changes)
        if used < freeMessagesLimit {
            return (true, nil)
        }
        
        return (false, extraAIMessagePointsCost)
    }
    
    /// Record AI chat message
    func recordAIChatMessage() {
        if isPremium { return }
        
        let (used, date) = getAIMessagesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            UserDefaults.standard.set(1, forKey: aiMessagesUsedKey)
            UserDefaults.standard.set(today, forKey: aiMessagesDateKey)
        } else {
            UserDefaults.standard.set(used + 1, forKey: aiMessagesUsedKey)
        }
    }
    
    /// Unlock extra AI message with points
    func unlockExtraAIMessage() -> Bool {
        if isPremium {
            return true
        }
        
        let result = PointsService.shared.spendPoints(event: "extra_ai_message", cost: extraAIMessagePointsCost)
        return result.success
    }
    
    // MARK: - Testing Helpers
    
    /// Reset free messages for testing (refills to full limit)
    func resetFreeMessagesForTesting() {
        UserDefaults.standard.set(0, forKey: aiMessagesUsedKey)
        UserDefaults.standard.set(Date(), forKey: aiMessagesDateKey)
    }
    
    // MARK: - Article Access (Legacy Support)
    
    /// Check if user can access an article
    /// Articles are part of learning content - free users get preview, premium get full access
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
    
    // MARK: - Compatibility Access (Legacy Support)
    
    /// Check if user can access compatibility feature
    func canAccessCompatibility() -> (allowed: Bool, type: CompatibilityAccessType, cost: Int?) {
        if isPremium {
            return (true, .premium, nil)
        }
        
        let freeRemaining = getFreeCompatibilityRemaining()
        if freeRemaining > 0 {
            return (true, .free, nil)
        }
        
        let balance = PointsService.shared.balance.totalPoints
        let compatibilityPointsCost = 50
        if balance >= compatibilityPointsCost {
            return (true, .points, compatibilityPointsCost)
        }
        
        return (false, .denied, compatibilityPointsCost)
    }
    
    /// Get remaining free compatibility checks
    func getFreeCompatibilityRemaining() -> Int {
        if isPremium {
            return Int.max // Unlimited for premium
        }
        
        let (used, date) = getFreeCompatibilityUsage()
        let calendar = Calendar.current
        let today = Date()
        
        // Reset if different day
        if !calendar.isDate(date, inSameDayAs: today) {
            return 1 // 1 free per day
        }
        
        let remaining = 1 - used
        return max(0, remaining)
    }
    
    /// Record compatibility check usage
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
    
    private let freeCompatibilityKey = "aroti_free_compatibility_used"
    private let freeCompatibilityDateKey = "aroti_free_compatibility_date"
    private let freeCompatibilityLimit = 1
    
    private func getFreeCompatibilityUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: freeCompatibilityKey)
        let date = UserDefaults.standard.object(forKey: freeCompatibilityDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    /// Get the points cost for a compatibility check
    func getCompatibilityPointsCost() -> Int {
        return 50
    }
    
    // MARK: - Quiz Access (Legacy Support)
    
    private let freeQuizzesKey = "aroti_free_quizzes_used"
    private let freeQuizzesDateKey = "aroti_free_quizzes_date"
    private let freeQuizzesLimit = 1
    private let quizPointsCost = 10
    
    /// Check if user can access quiz
    func canAccessQuiz() -> (allowed: Bool, cost: Int?) {
        if isPremium {
            return (true, nil)
        }
        
        let (used, date) = getFreeQuizzesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        // Reset if different day
        if !calendar.isDate(date, inSameDayAs: today) {
            return (true, nil)
        }
        
        if used < freeQuizzesLimit {
            return (true, nil)
        }
        
        return (false, quizPointsCost) // 10 points per extra quiz
    }
    
    /// Record quiz completion
    func recordQuiz() {
        if isPremium { return }
        
        let (used, date) = getFreeQuizzesUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
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
    
    // MARK: - Course Access
    
    /// Courses are paid separately, not included in Premium
    func canAccessCourse(courseId: String) -> (allowed: Bool, isPreviewOnly: Bool) {
        // Both free and premium users see preview only
        // Courses are paid separately
        return (true, true)
    }
    
    // MARK: - Content Unlocking
    
    func unlockContent(contentId: String, contentType: ContentType, permanent: Bool = true) {
        var unlocked = getUnlockedContent()
        let key = "\(contentType.rawValue):\(contentId)"
        
        unlocked[key] = ["permanent": permanent, "timestamp": Date().timeIntervalSince1970]
        
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
    
    // MARK: - Generic Access Check
    
    func checkAccess(contentId: String, contentType: ContentType) -> AccessStatus {
        switch contentType {
        case .premiumForecast:
            let (allowed, _) = canAccessPremiumForecast()
            return allowed ? .unlocked : .premiumOnly
            
        case .tarotSpread:
            let (allowed, cost, isPremiumOnly, _) = canAccessTarotSpread(spreadId: contentId)
            if allowed {
                return .unlocked
            } else if isPremiumOnly {
                return .premiumOnly
            } else if let cost = cost {
                return .unlockableWithPoints(cost: cost)
            }
            return .premiumOnly
            
        case .dailyRitual:
            let (allowed, _) = canAccessDailyRitual(ritualId: contentId)
            return allowed ? .free : .premiumOnly
            
        case .learningLesson:
            // Learning lessons are always readable
            return .free
            
        case .course:
            let (_, isPreviewOnly) = canAccessCourse(courseId: contentId)
            return isPreviewOnly ? .premiumOnly : .unlocked
            
        case .aiChat:
            let (allowed, cost) = canAccessAIChat()
            if allowed {
                return .free
            } else if let cost = cost {
                return .unlockableWithPoints(cost: cost)
            }
            return .premiumOnly
            
        case .dailyPractice:
            // Legacy support
            return .free
            
        case .article, .quiz, .numerologyLayer, .theme:
            // Legacy content types - default to free for now
            return .free
        }
    }
    
    // MARK: - Points Earning (V1)
    
    /// Earn points from completing a learning lesson (max 1/day + 1 via ad)
    func earnPointsFromLearning() -> PointsEarnResult {
        if isPremium {
            // Premium users don't need to track this separately
            return PointsService.shared.earnPoints(event: "learning_lesson", points: 1)
        }
        
        if canEarnPointsFromLearning() {
            return PointsService.shared.earnPoints(event: "learning_lesson", points: 1)
        }
        
        return PointsEarnResult(
            success: false,
            newBalance: PointsService.shared.balance.totalPoints,
            newLifetimePoints: PointsService.shared.balance.lifetimePoints,
            message: "Daily point limit reached. Watch an ad for one more lesson or upgrade to Premium."
        )
    }
    
    /// Earn points from completing a daily ritual
    func earnPointsFromRitual() -> PointsEarnResult {
        return PointsService.shared.earnPoints(event: "daily_ritual", points: 1)
    }
    
    // MARK: - Points Spending (V1)
    
    /// Unlock tarot spread with points
    func unlockTarotSpreadWithPoints(spreadId: String) -> PointsSpendResult {
        if isPremium {
            return PointsSpendResult(success: true, newBalance: PointsService.shared.balance.totalPoints, message: "Already unlocked with Premium")
        }
        
        let (_, cost, _, _) = canAccessTarotSpread(spreadId: spreadId)
        
        guard let cost = cost else {
            return PointsSpendResult(success: false, newBalance: PointsService.shared.balance.totalPoints, message: "Cannot unlock this spread")
        }
        
        let result = PointsService.shared.spendPoints(event: "unlock_tarot_spread", cost: cost)
        
        if result.success {
            // For premium spreads, unlock permanently
            if spreadId == celticCrossSpreadId || spreadId == relationshipSpreadId || spreadId == careerPathSpreadId {
                unlockContent(contentId: spreadId, contentType: .tarotSpread, permanent: true)
            }
        }
        
        return result
    }
    
    // MARK: - Private Helpers
    
    private func getQuickDrawUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: quickDrawUsedKey)
        let date = UserDefaults.standard.object(forKey: quickDrawDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func recordQuickDrawUsage() {
        let (used, date) = getQuickDrawUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            UserDefaults.standard.set(1, forKey: quickDrawUsedKey)
            UserDefaults.standard.set(today, forKey: quickDrawDateKey)
        } else {
            UserDefaults.standard.set(used + 1, forKey: quickDrawUsedKey)
        }
    }
    
    private func getThreeCardUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: threeCardUsedKey)
        let date = UserDefaults.standard.object(forKey: threeCardDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func recordThreeCardUsage() {
        let (used, date) = getThreeCardUsage()
        let calendar = Calendar.current
        let today = Date()
        
        if !calendar.isDate(date, inSameDayAs: today) {
            UserDefaults.standard.set(1, forKey: threeCardUsedKey)
            UserDefaults.standard.set(today, forKey: threeCardDateKey)
        } else {
            UserDefaults.standard.set(used + 1, forKey: threeCardUsedKey)
        }
    }
    
    private func getDailyRitualUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: dailyRitualUsedKey)
        let date = UserDefaults.standard.object(forKey: dailyRitualDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func getLearningLessonsCompleted() -> (completed: Int, date: Date) {
        let completed = UserDefaults.standard.integer(forKey: learningLessonsCompletedKey)
        let date = UserDefaults.standard.object(forKey: learningLessonsDateKey) as? Date ?? Date()
        return (completed, date)
    }
    
    private func getLearningLessonsWithPoints() -> (withPoints: Int, date: Date) {
        let withPoints = UserDefaults.standard.integer(forKey: learningLessonsWithPointsKey)
        let date = UserDefaults.standard.object(forKey: learningLessonsDateKey) as? Date ?? Date()
        return (withPoints, date)
    }
    
    private func getAIMessagesUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: aiMessagesUsedKey)
        let date = UserDefaults.standard.object(forKey: aiMessagesDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func getExtraCardUsage() -> (used: Int, date: Date) {
        let used = UserDefaults.standard.integer(forKey: extraCardUsedKey)
        let date = UserDefaults.standard.object(forKey: extraCardDateKey) as? Date ?? Date()
        return (used, date)
    }
    
    private func getAdWatchUsage() -> (watched: Bool, date: Date) {
        let watched = UserDefaults.standard.bool(forKey: adWatchedKey)
        let date = UserDefaults.standard.object(forKey: adWatchedDateKey) as? Date ?? Date()
        return (watched, date)
    }
    
    func getUnlockedContent() -> [String: Any] {
        return UserDefaults.standard.dictionary(forKey: unlockedContentKey) ?? [:]
    }
    
    private func saveUnlockedContent(_ content: [String: Any]) {
        UserDefaults.standard.set(content, forKey: unlockedContentKey)
    }
    
    // MARK: - Testing Helpers
    
    func resetAllDailyUsage() {
        let today = Date()
        UserDefaults.standard.set(0, forKey: quickDrawUsedKey)
        UserDefaults.standard.set(today, forKey: quickDrawDateKey)
        UserDefaults.standard.set(0, forKey: threeCardUsedKey)
        UserDefaults.standard.set(today, forKey: threeCardDateKey)
        UserDefaults.standard.set(0, forKey: dailyRitualUsedKey)
        UserDefaults.standard.set(today, forKey: dailyRitualDateKey)
        UserDefaults.standard.set(0, forKey: learningLessonsCompletedKey)
        UserDefaults.standard.set(today, forKey: learningLessonsDateKey)
        UserDefaults.standard.set(0, forKey: learningLessonsWithPointsKey)
        UserDefaults.standard.set(0, forKey: aiMessagesUsedKey)
        UserDefaults.standard.set(today, forKey: aiMessagesDateKey)
        UserDefaults.standard.set(0, forKey: extraCardUsedKey)
        UserDefaults.standard.set(today, forKey: extraCardDateKey)
        UserDefaults.standard.set(false, forKey: adWatchedKey)
        UserDefaults.standard.set(today, forKey: adWatchedDateKey)
    }
}

// MARK: - Compatibility Access Type

enum CompatibilityAccessType {
    case free
    case points
    case premium
    case denied
}

