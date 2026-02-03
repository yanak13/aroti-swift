//
//  PremiumEventDetector.swift
//  Aroti
//
//  Service for detecting active premium events that should trigger dynamic cards
//

import Foundation

class PremiumEventDetector {
    static let shared = PremiumEventDetector()
    
    private let astroService = AstrologicalCycleService.shared
    private let numerologyService = NumerologyCycleService.shared
    private let blueprintService = BlueprintService.shared
    
    private init() {}
    
    // MARK: - Main Detection Method
    
    /// Detect all active premium events for a user
    /// Returns top 2 events by priority
    func detectActiveEvents(userData: UserData) -> [PremiumEvent] {
        var events: [PremiumEvent] = []
        
        // Check all event types (in priority order)
        if let saturnReturn = detectSaturnReturn(userData: userData) {
            events.append(saturnReturn)
        }
        
        if let mercuryRetro = detectMercuryRetrograde(userData: userData) {
            events.append(mercuryRetro)
        }
        
        if let monthlyHoroscope = detectMonthlyHoroscope(userData: userData) {
            events.append(monthlyHoroscope)
        }
        
        if let personalMonth = detectPersonalMonthChange(userData: userData) {
            events.append(personalMonth)
        }
        
        if let focusArea = detectFocusArea(userData: userData) {
            events.append(focusArea)
        }
        
        if let favorableDates = detectFavorableDates(userData: userData) {
            events.append(favorableDates)
        }
        
        if let moonPhase = detectMoonPhase(userData: userData) {
            events.append(moonPhase)
        }
        
        // Sort by priority, return top 2 (max 2 cards)
        let sortedEvents = events.sorted { $0.priority > $1.priority }
        return Array(sortedEvents.prefix(2))
    }
    
    // MARK: - Individual Event Detectors
    
    /// Detect Saturn Return (highest priority)
    private func detectSaturnReturn(userData: UserData) -> PremiumEvent? {
        guard let birthDate = userData.birthDate else { return nil }
        
        let (isInSaturnReturn, _, _) = astroService.getSaturnTransitInfo(userBirthDate: birthDate)
        guard isInSaturnReturn else { return nil }
        
        let calendar = Calendar.current
        let age = calendar.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        let isFirstReturn = age >= 27 && age <= 32
        
        let compellingTitle = isFirstReturn 
            ? "Your Saturn Return Journey"
            : "Your Second Saturn Return"
        
        return PremiumEvent(
            id: "saturn_return_\(Date().timeIntervalSince1970)",
            type: .saturnReturn,
            priority: 10,
            startDate: Date(),
            endDate: nil, // Saturn Return lasts for years
            title: compellingTitle,
            preview: isFirstReturn 
                ? "Discover insights for your first Saturn Return - a major life transition period (ages 27-32)"
                : "Explore guidance for your second Saturn Return - a period of wisdom and legacy (ages 55-60)",
            isActive: true,
            personalizationData: EventPersonalization(
                userSunSign: userData.sunSign,
                userAge: age,
                relevantTransits: ["Saturn Return"],
                additionalData: ["isFirstReturn": isFirstReturn]
            )
        )
    }
    
    /// Detect Mercury Retrograde
    private func detectMercuryRetrograde(userData: UserData) -> PremiumEvent? {
        guard astroService.isMercuryRetrograde() else { return nil }
        
        let periods = astroService.getMercuryRetrogradePeriods()
        guard let activePeriod = periods.first(where: { $0.isActive }) else { return nil }
        
        // Get user's Mercury sign from blueprint
        let blueprint = blueprintService.calculateBlueprint(from: userData)
        let mercurySign = blueprint?.astrology.mercury?.sign ?? userData.sunSign
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let startDateStr = dateFormatter.string(from: activePeriod.startDate)
        let endDateStr = dateFormatter.string(from: activePeriod.endDate)
        
        return PremiumEvent(
            id: "mercury_retrograde_\(activePeriod.startDate.timeIntervalSince1970)",
            type: .mercuryRetrograde,
            priority: 9,
            startDate: activePeriod.startDate,
            endDate: activePeriod.endDate,
            title: "How Mercury Retrograde Affects You",
            preview: "Discover how this retrograde period impacts your \(mercurySign) communication style and what to focus on.",
            isActive: true,
            personalizationData: EventPersonalization(
                userSunSign: userData.sunSign,
                userMercurySign: mercurySign,
                relevantTransits: ["Mercury Retrograde • \(startDateStr) - \(endDateStr)"]
            )
        )
    }
    
    /// Detect Monthly Horoscope (first 7 days of month)
    private func detectMonthlyHoroscope(userData: UserData) -> PremiumEvent? {
        let calendar = Calendar.current
        let now = Date()
        let day = calendar.component(.day, from: now)
        
        // Show in first 7 days of month
        guard day <= 7 else { return nil }
        
        let monthName = getMonthName(from: now)
        
        return PremiumEvent(
            id: "monthly_horoscope_\(calendar.component(.year, from: now))_\(calendar.component(.month, from: now))",
            type: .monthlyHoroscope,
            priority: 8,
            startDate: calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now,
            endDate: calendar.date(byAdding: .day, value: 7, to: now),
            title: "Your \(monthName) Horoscope Forecast",
            preview: "Get personalized insights for \(monthName) based on your sign and current cycles.",
            isActive: true,
            personalizationData: EventPersonalization(
                userSunSign: userData.sunSign,
                userMoonSign: userData.moonSign,
                userPersonalYear: userData.birthDate != nil ? numerologyService.getPersonalYearNumber(birthDate: userData.birthDate!, currentDate: now) : nil,
                relevantTransits: [monthName]
            )
        )
    }
    
    /// Detect Personal Month Change (first 3 days of month)
    private func detectPersonalMonthChange(userData: UserData) -> PremiumEvent? {
        guard let birthDate = userData.birthDate else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        let day = calendar.component(.day, from: now)
        
        // Show in first 3 days of month
        guard day <= 3 else { return nil }
        
        let currentPersonalMonth = numerologyService.getPersonalMonthNumber(birthDate: birthDate, currentDate: now)
        
        // Check if this is a new Personal Month (compare with previous month)
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: now) else { return nil }
        let previousPersonalMonth = numerologyService.getPersonalMonthNumber(birthDate: birthDate, currentDate: previousMonth)
        
        guard currentPersonalMonth != previousPersonalMonth else { return nil }
        
        let personalMonthDesc = numerologyService.getPersonalMonthDescription(birthDate: birthDate, currentDate: now)
        
        return PremiumEvent(
            id: "personal_month_\(calendar.component(.year, from: now))_\(calendar.component(.month, from: now))",
            type: .personalMonthChange,
            priority: 7,
            startDate: calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now,
            endDate: calendar.date(byAdding: .day, value: 3, to: now),
            title: "Your Personal Month \(currentPersonalMonth) Begins",
            preview: "Discover what Personal Month \(currentPersonalMonth) means for you: \(personalMonthDesc)",
            isActive: true,
            personalizationData: EventPersonalization(
                userSunSign: userData.sunSign,
                userPersonalMonth: currentPersonalMonth,
                userPersonalYear: numerologyService.getPersonalYearNumber(birthDate: birthDate, currentDate: now)
            )
        )
    }
    
    /// Detect Focus Area based on Personal Month
    private func detectFocusArea(userData: UserData) -> PremiumEvent? {
        guard let birthDate = userData.birthDate else { return nil }
        
        let personalMonth = numerologyService.getPersonalMonthNumber(birthDate: birthDate)
        
        // Map Personal Month numbers to life focus areas
        let focusAreas: [Int: (area: String, reason: String)] = [
            1: ("New Projects", "Personal Month 1 emphasizes new beginnings and fresh starts"),
            2: ("Relationships", "Personal Month 2 focuses on partnership and cooperation"),
            3: ("Creative Expression", "Personal Month 3 emphasizes creativity and communication"),
            4: ("Structure & Planning", "Personal Month 4 focuses on building foundations"),
            5: ("Change & Freedom", "Personal Month 5 emphasizes adaptation and exploration"),
            6: ("Home & Family", "Personal Month 6 focuses on care and responsibility"),
            7: ("Inner Reflection", "Personal Month 7 emphasizes introspection and seeking"),
            8: ("Career & Achievement", "Personal Month 8 focuses on material success"),
            9: ("Completion & Service", "Personal Month 9 emphasizes endings and service")
        ]
        
        guard let focus = focusAreas[personalMonth] else { return nil }
        
        return PremiumEvent(
            id: "focus_area_\(personalMonth)_\(Date().timeIntervalSince1970)",
            type: .focusArea,
            priority: 7,
            startDate: Date(),
            endDate: nil, // Valid for entire month
            title: "Where to Focus This Month",
            preview: "Discover what to focus on this month: \(focus.area). \(focus.reason)",
            isActive: true,
            personalizationData: EventPersonalization(
                userSunSign: userData.sunSign,
                userPersonalMonth: personalMonth,
                relevantTransits: ["Personal Month \(personalMonth)"]
            )
        )
    }
    
    /// Detect Favorable Decision Dates (within 7 days)
    private func detectFavorableDates(userData: UserData) -> PremiumEvent? {
        guard let birthDate = userData.birthDate else { return nil }
        
        let favorableDates = calculateFavorableDates(birthDate: birthDate, daysAhead: 14)
        let calendar = Calendar.current
        let now = Date()
        
        let upcomingDates = favorableDates.filter { date in
            let daysUntil = calendar.dateComponents([.day], from: now, to: date).day ?? 0
            return daysUntil <= 7 && daysUntil >= 0
        }
        
        guard !upcomingDates.isEmpty else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let datesStr = upcomingDates.prefix(3).map { dateFormatter.string(from: $0) }.joined(separator: ", ")
        
        return PremiumEvent(
            id: "favorable_dates_\(now.timeIntervalSince1970)",
            type: .favorableDates,
            priority: 6,
            startDate: now,
            endDate: upcomingDates.last,
            title: "Best Dates for Important Decisions",
            preview: "Discover the best dates this week (\(datesStr)) for making important decisions based on your numerology.",
            isActive: true,
            personalizationData: EventPersonalization(
                userSunSign: userData.sunSign,
                relevantTransits: ["Favorable Numerology Dates"],
                additionalData: ["dates": upcomingDates.map { $0.timeIntervalSince1970 }]
            )
        )
    }
    
    /// Detect New/Full Moon Impact
    private func detectMoonPhase(userData: UserData) -> PremiumEvent? {
        let moonPhase = astroService.getCurrentMoonPhase()
        
        // Only show for New Moon and Full Moon
        guard moonPhase == .new || moonPhase == .full else { return nil }
        
        let moonSign = userData.moonSign ?? "emotional"
        
        let compellingTitle = moonPhase == .new 
            ? "New Moon Energy for You"
            : "Full Moon Release Guidance"
        
        return PremiumEvent(
            id: "moon_phase_\(moonPhase.rawValue)_\(Date().timeIntervalSince1970)",
            type: .moonPhase,
            priority: 5,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            title: compellingTitle,
            preview: "Discover how the \(moonPhase.rawValue) affects your \(moonSign) nature and what to focus on.",
            isActive: true,
            personalizationData: EventPersonalization(
                userSunSign: userData.sunSign,
                userMoonSign: userData.moonSign,
                relevantTransits: [moonPhase.rawValue]
            )
        )
    }
    
    // MARK: - Helper Methods
    
    private func getMonthName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    private func calculateFavorableDates(birthDate: Date, daysAhead: Int) -> [Date] {
        var favorableDates: [Date] = []
        let calendar = Calendar.current
        let now = Date()
        
        // Favorable numbers for decisions: 1 (new beginnings), 3 (creativity), 6 (harmony), 8 (achievement)
        let favorableNumbers = [1, 3, 6, 8]
        
        // Check next 14 days
        for dayOffset in 0..<daysAhead {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: now) else { continue }
            
            let personalDay = numerologyService.getPersonalDayNumber(birthDate: birthDate, currentDate: date)
            let personalYear = numerologyService.getPersonalYearNumber(birthDate: birthDate, currentDate: date)
            
            // Favorable if Personal Day is in favorable numbers
            if favorableNumbers.contains(personalDay) {
                favorableDates.append(date)
            }
            
            // Also favorable if Personal Day matches Personal Year (alignment)
            if personalDay == personalYear {
                favorableDates.append(date)
            }
        }
        
        return favorableDates
    }
    
    private func getMoonPhaseImpact(moonPhase: MoonPhase) -> String {
        switch moonPhase {
        case .new:
            return "Set clear intentions for new beginnings"
        case .full:
            return "Release what no longer serves you"
        default:
            return "Lunar energy influences your emotional patterns"
        }
    }
}