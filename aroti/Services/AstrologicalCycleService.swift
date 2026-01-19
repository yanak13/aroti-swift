//
//  AstrologicalCycleService.swift
//  Aroti
//
//  Service for calculating astrological cycles and events
//

import Foundation

enum MoonPhase: String {
    case new = "New Moon"
    case waxing = "Waxing Moon"
    case full = "Full Moon"
    case waning = "Waning Moon"
}

struct RetrogradePeriod {
    let planet: String
    let startDate: Date
    let endDate: Date
    let isActive: Bool
}

struct PlanetaryAspect {
    let planet1: String
    let planet2: String
    let aspect: String // "conjunction", "opposition", "trine", "square"
    let date: Date
}

class AstrologicalCycleService {
    static let shared = AstrologicalCycleService()
    
    private init() {}
    
    // MARK: - Moon Phases
    
    /// Get current moon phase
    func getCurrentMoonPhase() -> MoonPhase {
        let calendar = Calendar.current
        let now = Date()
        
        // Simplified moon phase calculation (approximate 29.5 day cycle)
        // Using a reference date for New Moon (Jan 1, 2024 was approximately New Moon)
        let referenceNewMoon = calendar.date(from: DateComponents(year: 2024, month: 1, day: 11))!
        let daysSinceNewMoon = calendar.dateComponents([.day], from: referenceNewMoon, to: now).day ?? 0
        let daysInCycle = (daysSinceNewMoon % 30 + 30) % 30 // Normalize to 0-29
        
        switch daysInCycle {
        case 0..<7:
            return .new
        case 7..<15:
            return .waxing
        case 15..<22:
            return .full
        default:
            return .waning
        }
    }
    
    /// Get moon phase description
    func getMoonPhaseDescription() -> String {
        let phase = getCurrentMoonPhase()
        switch phase {
        case .new:
            return "New Moon phase"
        case .waxing:
            return "Waxing Moon phase"
        case .full:
            return "Full Moon phase"
        case .waning:
            return "Waning Moon phase"
        }
    }
    
    // MARK: - Mercury Retrograde
    
    /// Get Mercury retrograde periods for current year
    func getMercuryRetrogradePeriods() -> [RetrogradePeriod] {
        let calendar = Calendar.current
        let now = Date()
        let year = calendar.component(.year, from: now)
        
        // Approximate Mercury retrograde dates (3-4 times per year, ~3 weeks each)
        // These are approximate - in production, use accurate ephemeris data
        var periods: [RetrogradePeriod] = []
        
        // Typical Mercury retrograde periods (approximate)
        let retrogradeDates: [(month: Int, startDay: Int, endDay: Int)] = [
            (1, 1, 21),   // January
            (4, 1, 25),   // April
            (8, 23, 15),  // August-September
            (12, 13, 31)  // December
        ]
        
        for retrograde in retrogradeDates {
            if let startDate = calendar.date(from: DateComponents(year: year, month: retrograde.month, day: retrograde.startDay)),
               let endDate = calendar.date(from: DateComponents(year: year, month: retrograde.month, day: retrograde.endDay)) {
                let isActive = now >= startDate && now <= endDate
                periods.append(RetrogradePeriod(planet: "Mercury", startDate: startDate, endDate: endDate, isActive: isActive))
            }
        }
        
        return periods
    }
    
    /// Check if Mercury is currently retrograde
    func isMercuryRetrograde() -> Bool {
        return getMercuryRetrogradePeriods().contains { $0.isActive }
    }
    
    /// Get next Mercury retrograde period
    func getNextMercuryRetrograde() -> RetrogradePeriod? {
        let now = Date()
        return getMercuryRetrogradePeriods().first { $0.startDate > now }
    }
    
    // MARK: - Venus Transits
    
    /// Get significant Venus transit periods (simplified)
    func getVenusTransitPeriods() -> [RetrogradePeriod] {
        // Venus retrograde occurs less frequently (~every 18 months, ~40 days)
        // For V1, return empty array - can be enhanced later
        return []
    }
    
    // MARK: - Saturn Transits
    
    /// Get Saturn return/transit information
    func getSaturnTransitInfo(userBirthDate: Date) -> (isInSaturnReturn: Bool, yearsUntilReturn: Int, description: String) {
        let calendar = Calendar.current
        let now = Date()
        let birthYear = calendar.component(.year, from: userBirthDate)
        let currentYear = calendar.component(.year, from: now)
        let age = currentYear - birthYear
        
        // Saturn return occurs approximately every 29.5 years
        // Note: firstReturn and secondReturn are calculated but not used in current logic
        // They're kept for potential future enhancements
        
        if age >= 27 && age <= 32 {
            return (true, 0, "Saturn Return period")
        } else if age < 27 {
            let yearsUntil = 29 - age
            return (false, yearsUntil, "Approaching first Saturn Return")
        } else if age >= 55 && age <= 60 {
            return (true, 0, "Second Saturn Return period")
        } else {
            let nextReturn = age < 58 ? 58 - age : 87 - age
            return (false, nextReturn, "Between Saturn Returns")
        }
    }
    
    // MARK: - Planetary Aspects
    
    /// Get significant planetary aspects for current week
    func getWeeklyPlanetaryAspects() -> [PlanetaryAspect] {
        // Simplified - in production, calculate actual planetary positions
        // For V1, return empty array or use approximate calculations
        return []
    }
    
    /// Get major transits for current month
    func getMonthlyTransits() -> [String] {
        var transits: [String] = []
        
        if isMercuryRetrograde() {
            transits.append("Mercury retrograde")
        }
        
        let moonPhase = getCurrentMoonPhase()
        transits.append(moonPhase.rawValue)
        
        return transits
    }
    
    /// Get upcoming significant transits
    func getUpcomingTransits(monthsAhead: Int = 2) -> [String] {
        var upcoming: [String] = []
        
        if let nextMercuryRetro = getNextMercuryRetrograde() {
            let calendar = Calendar.current
            let monthsUntil = calendar.dateComponents([.month], from: Date(), to: nextMercuryRetro.startDate).month ?? 0
            if monthsUntil <= monthsAhead {
                upcoming.append("Mercury retrograde begins in \(monthsUntil) month\(monthsUntil == 1 ? "" : "s")")
            }
        }
        
        return upcoming
    }
    
    // MARK: - Current Astrological Context
    
    /// Get current astrological context string
    func getCurrentContext() -> String {
        var context: [String] = []
        
        let moonPhase = getCurrentMoonPhase()
        context.append(moonPhase.rawValue)
        
        if isMercuryRetrograde() {
            context.append("Mercury retrograde")
        }
        
        return context.joined(separator: " • ")
    }
}
