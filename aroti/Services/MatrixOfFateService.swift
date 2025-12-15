//
//  MatrixOfFateService.swift
//  Aroti
//
//  Service for calculating Matrix of Fate identity
//

import Foundation

class MatrixOfFateService {
    static let shared = MatrixOfFateService()
    
    private init() {}
    
    // MARK: - Calculate Matrix Identity
    func calculateMatrix(birthDate: Date) -> MatrixIdentity {
        let coreDestinyNumber = calculateCoreDestinyNumber(birthDate: birthDate)
        let matrixVisual = generateMatrixVisual(coreNumber: coreDestinyNumber)
        let freeThemes = generateFreeThemes(coreNumber: coreDestinyNumber)
        
        // Premium content (will be computed if needed)
        let strengthZones = calculateStrengthZones(coreNumber: coreDestinyNumber)
        let challengeZones = calculateChallengeZones(coreNumber: coreDestinyNumber)
        let karmicLessons = calculateKarmicLessons(birthDate: birthDate)
        let repeatingPatterns = calculateRepeatingPatterns(birthDate: birthDate)
        let premiumInterpretation = generatePremiumInterpretation(
            coreNumber: coreDestinyNumber,
            strengths: strengthZones,
            challenges: challengeZones
        )
        
        return MatrixIdentity(
            coreDestinyNumber: coreDestinyNumber,
            freeThemes: freeThemes,
            matrixVisual: matrixVisual,
            strengthZones: strengthZones,
            challengeZones: challengeZones,
            karmicLessons: karmicLessons,
            repeatingPatterns: repeatingPatterns,
            premiumInterpretation: premiumInterpretation
        )
    }
    
    // MARK: - Core Destiny Number
    func calculateCoreDestinyNumber(birthDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate)
        let year = components.year ?? 1990
        let month = components.month ?? 1
        let day = components.day ?? 1
        
        // Sum all digits
        let yearSum = reduceToSingleDigit(year)
        let monthSum = reduceToSingleDigit(month)
        let daySum = reduceToSingleDigit(day)
        
        let total = yearSum + monthSum + daySum
        return reduceToSingleDigit(total)
    }
    
    private func reduceToSingleDigit(_ num: Int) -> Int {
        var result = num
        while result > 9 && result != 11 && result != 22 && result != 33 {
            result = String(result).compactMap { Int(String($0)) }.reduce(0, +)
        }
        return result
    }
    
    // MARK: - Matrix Visual
    func generateMatrixVisual(coreNumber: Int) -> MatrixVisual {
        // Generate a 3x3 matrix with the core destiny number highlighted
        var cells: [MatrixCell] = []
        let gridSize = 3
        
        // Fill matrix with numbers 1-9, placing core number in center
        for y in 0..<gridSize {
            for x in 0..<gridSize {
                let index = y * gridSize + x + 1
                let value: Int?
                
                if index == 5 { // Center position
                    value = coreNumber
                } else {
                    // Place numbers around the core
                    let offset = (index < 5) ? index : index - 1
                    value = (offset <= 9) ? offset : nil
                }
                
                cells.append(MatrixCell(x: x, y: y, value: value))
            }
        }
        
        return MatrixVisual(cells: cells, gridSize: gridSize)
    }
    
    // MARK: - Free Themes
    private func generateFreeThemes(coreNumber: Int) -> [String] {
        let themes: [Int: [String]] = [
            1: ["Leadership", "Independence"],
            2: ["Partnership", "Harmony"],
            3: ["Creativity", "Expression"],
            4: ["Structure", "Foundation"],
            5: ["Freedom", "Change"],
            6: ["Service", "Nurturing"],
            7: ["Wisdom", "Spirituality"],
            8: ["Achievement", "Power"],
            9: ["Completion", "Humanitarianism"],
            11: ["Intuition", "Inspiration"],
            22: ["Master Building", "Vision"],
            33: ["Master Teaching", "Compassion"]
        ]
        
        return themes[coreNumber] ?? ["Destiny", "Purpose"]
    }
    
    // MARK: - Strength Zones
    func calculateStrengthZones(coreNumber: Int) -> [MatrixZone] {
        let strengths: [Int: [(String, String)]] = [
            1: [
                ("Initiative", "You naturally take the lead and start new projects"),
                ("Independence", "You work best when following your own path")
            ],
            2: [
                ("Cooperation", "You excel at bringing people together"),
                ("Intuition", "You sense what others need and respond accordingly")
            ],
            3: [
                ("Communication", "You express ideas clearly and creatively"),
                ("Optimism", "You bring light and joy to situations")
            ],
            4: [
                ("Reliability", "Others can count on you to build solid foundations"),
                ("Practicality", "You turn ideas into tangible results")
            ],
            5: [
                ("Adaptability", "You thrive in changing environments"),
                ("Curiosity", "You seek new experiences and knowledge")
            ],
            6: [
                ("Compassion", "You naturally care for others' wellbeing"),
                ("Responsibility", "You take care of what matters most")
            ],
            7: [
                ("Analysis", "You see patterns others miss"),
                ("Depth", "You seek truth and understanding")
            ],
            8: [
                ("Ambition", "You achieve material success through determination"),
                ("Authority", "You naturally take charge when needed")
            ],
            9: [
                ("Wisdom", "You understand the bigger picture"),
                ("Service", "You help others complete their journeys")
            ]
        ]
        
        let zoneData = strengths[coreNumber] ?? [("Strength", "Your natural abilities")]
        return zoneData.enumerated().map { index, data in
            MatrixZone(id: "strength-\(index)", title: data.0, shortMeaning: data.1)
        }
    }
    
    // MARK: - Challenge Zones
    func calculateChallengeZones(coreNumber: Int) -> [MatrixZone] {
        let challenges: [Int: [(String, String)]] = [
            1: [
                ("Impatience", "You may rush ahead without considering others"),
                ("Isolation", "You might struggle to ask for help")
            ],
            2: [
                ("Indecision", "You may struggle to choose your own path"),
                ("Over-sensitivity", "You might take things too personally")
            ],
            3: [
                ("Scattered Energy", "You may struggle to focus on one thing"),
                ("Superficiality", "You might avoid deeper emotional work")
            ],
            4: [
                ("Rigidity", "You may resist necessary changes"),
                ("Overwork", "You might forget to rest and enjoy life")
            ],
            5: [
                ("Restlessness", "You may struggle with commitment"),
                ("Impulsivity", "You might act before thinking")
            ],
            6: [
                ("Over-responsibility", "You may take on others' problems"),
                ("Perfectionism", "You might be too hard on yourself")
            ],
            7: [
                ("Isolation", "You may withdraw from others too much"),
                ("Skepticism", "You might doubt what you can't analyze")
            ],
            8: [
                ("Material Focus", "You may prioritize success over relationships"),
                ("Control", "You might struggle to let go")
            ],
            9: [
                ("Idealism", "You may expect too much from others"),
                ("Completion", "You might struggle to let things end")
            ]
        ]
        
        let zoneData = challenges[coreNumber] ?? [("Growth Area", "Areas for development")]
        return zoneData.enumerated().map { index, data in
            MatrixZone(id: "challenge-\(index)", title: data.0, shortMeaning: data.1)
        }
    }
    
    // MARK: - Karmic Lessons
    func calculateKarmicLessons(birthDate: Date) -> [String] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate)
        
        // Check for missing digits 1-9 in birth date
        let dateString = "\(components.year ?? 0)\(components.month ?? 0)\(components.day ?? 0)"
        var presentDigits = Set<Character>()
        for char in dateString {
            if char.isNumber {
                presentDigits.insert(char)
            }
        }
        
        let allDigits = Set("123456789")
        let missingDigits = allDigits.subtracting(presentDigits)
        
        if missingDigits.isEmpty {
            return ["No major karmic lessons detected"]
        }
        
        let karmicMeanings: [Character: String] = [
            "1": "Learn independence and leadership",
            "2": "Develop cooperation and patience",
            "3": "Cultivate creativity and expression",
            "4": "Build structure and discipline",
            "5": "Embrace change and freedom",
            "6": "Practice service and responsibility",
            "7": "Seek wisdom and spirituality",
            "8": "Balance material and spiritual",
            "9": "Complete cycles and serve others"
        ]
        
        return missingDigits.compactMap { karmicMeanings[$0] }
    }
    
    // MARK: - Repeating Patterns
    func calculateRepeatingPatterns(birthDate: Date) -> [String] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate)
        let dateString = "\(components.year ?? 0)\(components.month ?? 0)\(components.day ?? 0)"
        
        // Count digit frequencies
        var digitCounts: [Character: Int] = [:]
        for char in dateString {
            if char.isNumber {
                digitCounts[char, default: 0] += 1
            }
        }
        
        // Find digits that appear 2+ times
        let repeating = digitCounts.filter { $0.value >= 2 }
            .sorted { $0.value > $1.value }
            .prefix(3)
        
        let patternMeanings: [Character: String] = [
            "1": "Leadership and independence themes",
            "2": "Partnership and harmony themes",
            "3": "Creativity and expression themes",
            "4": "Structure and foundation themes",
            "5": "Change and freedom themes",
            "6": "Service and responsibility themes",
            "7": "Wisdom and analysis themes",
            "8": "Achievement and power themes",
            "9": "Completion and service themes",
            "0": "Potential and cycles themes"
        ]
        
        return repeating.compactMap { digit, count in
            if let meaning = patternMeanings[digit] {
                return "\(meaning) (appears \(count) times)"
            }
            return nil
        }
    }
    
    // MARK: - Premium Interpretation
    private func generatePremiumInterpretation(
        coreNumber: Int,
        strengths: [MatrixZone],
        challenges: [MatrixZone]
    ) -> String {
        let interpretations: [Int: String] = [
            1: "Your destiny path centers on leadership and independence. You're here to pioneer new ways and inspire others through your initiative. Your strength lies in taking action, while your growth comes from learning to collaborate and consider others' perspectives.",
            2: "Your destiny path centers on partnership and harmony. You're here to bring people together and create balance. Your strength lies in your intuitive understanding of others, while your growth comes from developing your own voice and making independent decisions.",
            3: "Your destiny path centers on creativity and expression. You're here to inspire others through your communication and artistic gifts. Your strength lies in your optimism and ability to see beauty, while your growth comes from focusing your energy and going deeper.",
            4: "Your destiny path centers on building solid foundations. You're here to create structure and bring practical solutions. Your strength lies in your reliability and methodical approach, while your growth comes from embracing change and finding flexibility.",
            5: "Your destiny path centers on freedom and experience. You're here to explore life fully and embrace change. Your strength lies in your adaptability and curiosity, while your growth comes from finding commitment and depth in your pursuits.",
            6: "Your destiny path centers on service and nurturing. You're here to care for others and create harmony. Your strength lies in your compassion and responsibility, while your growth comes from setting boundaries and caring for yourself.",
            7: "Your destiny path centers on wisdom and understanding. You're here to seek truth and develop spiritual insight. Your strength lies in your analytical mind and depth, while your growth comes from connecting with others and trusting intuition.",
            8: "Your destiny path centers on achievement and material success. You're here to build power and create tangible results. Your strength lies in your ambition and authority, while your growth comes from balancing material and spiritual values.",
            9: "Your destiny path centers on completion and humanitarian service. You're here to help others complete their journeys and serve the greater good. Your strength lies in your wisdom and compassion, while your growth comes from accepting endings and letting go."
        ]
        
        return interpretations[coreNumber] ?? "Your destiny path is unique and evolving. Focus on your strengths while remaining open to growth in areas that challenge you."
    }
}
