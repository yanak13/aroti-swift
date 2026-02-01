//
//  NumerologyCycleService.swift
//  Aroti
//
//  Service for calculating numerology cycles and patterns
//

import Foundation

struct NumerologyCycle {
    let type: String // "Personal Year", "Personal Month", "Universal Year", etc.
    let number: Int
    let description: String
    let startDate: Date
    let endDate: Date
}

class NumerologyCycleService {
    static let shared = NumerologyCycleService()
    
    private init() {}
    
    // MARK: - Personal Year
    
    /// Calculate personal year number (1-9)
    func getPersonalYearNumber(birthDate: Date, currentDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        let birthComponents = calendar.dateComponents([.month, .day], from: birthDate)
        let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        guard let birthMonth = birthComponents.month,
              let birthDay = birthComponents.day,
              let currentYear = currentComponents.year else {
            return 1
        }
        
        // Personal year = (birth month + birth day + current year) reduced to single digit
        let sum = birthMonth + birthDay + currentYear
        return reduceToSingleDigit(sum)
    }
    
    /// Get personal year description
    func getPersonalYearDescription(birthDate: Date, currentDate: Date = Date()) -> String {
        let number = getPersonalYearNumber(birthDate: birthDate, currentDate: currentDate)
        let descriptions: [Int: String] = [
            1: "New beginnings and independence",
            2: "Cooperation and partnership",
            3: "Creativity and expression",
            4: "Structure and building",
            5: "Change and freedom",
            6: "Responsibility and care",
            7: "Introspection and seeking",
            8: "Achievement and material focus",
            9: "Completion and service"
        ]
        return descriptions[number] ?? "Personal growth"
    }
    
    // MARK: - Personal Month
    
    /// Calculate personal month number (1-9)
    func getPersonalMonthNumber(birthDate: Date, currentDate: Date = Date()) -> Int {
        let personalYear = getPersonalYearNumber(birthDate: birthDate, currentDate: currentDate)
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentDate)
        
        // Personal month = (personal year + current month) reduced to single digit
        let sum = personalYear + month
        return reduceToSingleDigit(sum)
    }
    
    /// Get personal month description
    func getPersonalMonthDescription(birthDate: Date, currentDate: Date = Date()) -> String {
        let number = getPersonalMonthNumber(birthDate: birthDate, currentDate: currentDate)
        let descriptions: [Int: String] = [
            1: "New initiatives",
            2: "Partnership focus",
            3: "Creative expression",
            4: "Building foundations",
            5: "Embracing change",
            6: "Nurturing others",
            7: "Inner reflection",
            8: "Material achievement",
            9: "Completing cycles"
        ]
        return descriptions[number] ?? "Personal growth"
    }
    
    // MARK: - Universal Year
    
    /// Calculate universal year number (1-9)
    func getUniversalYearNumber(date: Date = Date()) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return reduceToSingleDigit(year)
    }
    
    /// Get universal year description
    func getUniversalYearDescription(date: Date = Date()) -> String {
        let number = getUniversalYearNumber(date: date)
        let descriptions: [Int: String] = [
            1: "Global new beginnings",
            2: "Global cooperation",
            3: "Global creativity",
            4: "Global structure",
            5: "Global change",
            6: "Global responsibility",
            7: "Global introspection",
            8: "Global achievement",
            9: "Global completion"
        ]
        return descriptions[number] ?? "Universal energy"
    }
    
    // MARK: - Universal Month
    
    /// Calculate universal month number (1-9)
    func getUniversalMonthNumber(date: Date = Date()) -> Int {
        let universalYear = getUniversalYearNumber(date: date)
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        // Universal month = (universal year + current month) reduced to single digit
        let sum = universalYear + month
        return reduceToSingleDigit(sum)
    }
    
    // MARK: - Personal Day
    
    /// Calculate personal day number (1-9)
    /// Formula: (Personal Month + Current Day) reduced to single digit
    func getPersonalDayNumber(birthDate: Date, currentDate: Date = Date()) -> Int {
        let personalMonth = getPersonalMonthNumber(birthDate: birthDate, currentDate: currentDate)
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentDate)
        
        // Personal day = (personal month + current day) reduced to single digit
        let sum = personalMonth + day
        return reduceToSingleDigit(sum)
    }
    
    /// Get personal day description
    func getPersonalDayDescription(birthDate: Date, currentDate: Date = Date()) -> String {
        let number = getPersonalDayNumber(birthDate: birthDate, currentDate: currentDate)
        let descriptions: [Int: String] = [
            1: "Leadership patterns become more noticeable",
            2: "Cooperation patterns feel more accessible",
            3: "Creative patterns surface more easily",
            4: "Structure supports clear thinking",
            5: "Change patterns become more noticeable",
            6: "Care patterns feel more aligned",
            7: "Introspection patterns play a stronger role",
            8: "Material patterns become more noticeable",
            9: "Completion patterns feel more accessible",
            11: "Intuitive patterns are heightened",
            22: "Master building patterns are active",
            33: "Master teaching patterns are present"
        ]
        return descriptions[number] ?? "Numerological patterns become more noticeable"
    }
    
    // MARK: - Day Number
    
    /// Calculate day number for numerology
    func getDayNumber(date: Date = Date()) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day else {
            return 1
        }
        
        // Day number = (year + month + day) reduced to single digit
        let sum = year + month + day
        return reduceToSingleDigit(sum)
    }
    
    // MARK: - Significant Periods
    
    /// Get significant numerology periods (when cycles shift)
    func getSignificantNumerologyPeriods(birthDate: Date) -> [NumerologyCycle] {
        var cycles: [NumerologyCycle] = []
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        
        // Personal year changes on birthday
        let birthComponents = calendar.dateComponents([.month, .day], from: birthDate)
        if let birthMonth = birthComponents.month, let birthDay = birthComponents.day {
            if let nextBirthday = calendar.date(from: DateComponents(year: currentYear, month: birthMonth, day: birthDay)) {
                let personalYear = getPersonalYearNumber(birthDate: birthDate, currentDate: now)
                let nextPersonalYear = getPersonalYearNumber(birthDate: birthDate, currentDate: nextBirthday)
                
                if personalYear != nextPersonalYear {
                    cycles.append(NumerologyCycle(
                        type: "Personal Year",
                        number: nextPersonalYear,
                        description: "New Personal Year \(nextPersonalYear)",
                        startDate: nextBirthday,
                        endDate: calendar.date(byAdding: .year, value: 1, to: nextBirthday) ?? nextBirthday
                    ))
                }
            }
        }
        
        return cycles
    }
    
    // MARK: - Current Numerology Context
    
    /// Get current numerology context string
    func getCurrentContext(birthDate: Date?) -> String {
        var context: [String] = []
        
        if let birthDate = birthDate {
            let personalYear = getPersonalYearNumber(birthDate: birthDate)
            context.append("Personal Year \(personalYear)")
            
            let personalMonth = getPersonalMonthNumber(birthDate: birthDate)
            context.append("Personal Month \(personalMonth)")
        }
        
        let universalYear = getUniversalYearNumber()
        context.append("Universal Year \(universalYear)")
        
        return context.joined(separator: " • ")
    }
    
    // MARK: - Helper
    
    private func reduceToSingleDigit(_ num: Int) -> Int {
        var result = num
        while result > 9 && result != 11 && result != 22 && result != 33 {
            result = String(result).compactMap { Int(String($0)) }.reduce(0, +)
        }
        return result
    }
}
