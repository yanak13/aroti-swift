//
//  IdentityProfileService.swift
//  Aroti
//
//  Service for computing and caching user identity profiles
//

import Foundation

class IdentityProfileService {
    static let shared = IdentityProfileService()
    
    private let cacheKey = "aroti_identity_profile"
    private let contentGenerator = IdentityContentGenerator.shared
    private let matrixService = MatrixOfFateService.shared
    
    private init() {}
    
    // MARK: - Compute Identity Profile
    func computeIdentityProfile(from userData: UserData) -> UserIdentityProfile? {
        guard let birthDate = userData.birthDate else {
            return nil
        }
        
        // Get base blueprint
        guard let blueprint = BlueprintService.shared.calculateBlueprint(from: userData) else {
            return nil
        }
        
        let hasAccurateBirthTime = userData.birthTime != nil
        let hasAccurateBirthPlace = userData.birthLocation != nil
        
        // Compute Astrology Identity
        let astrology = computeAstrologyIdentity(
            blueprint: blueprint.astrology,
            hasAccurateTime: hasAccurateBirthTime,
            hasAccuratePlace: hasAccurateBirthPlace,
            birthDate: birthDate
        )
        
        // Compute Numerology Identity
        let numerology = computeNumerologyIdentity(blueprint: blueprint.numerology)
        
        // Compute Matrix Identity
        let matrix = matrixService.calculateMatrix(birthDate: birthDate)
        
        // Compute Elemental Identity
        let elements = computeElementalIdentity(astrology: blueprint.astrology, numerology: numerology)
        
        return UserIdentityProfile(
            astrology: astrology,
            numerology: numerology,
            matrix: matrix,
            elements: elements,
            computedAt: Date(),
            version: UserIdentityProfile.currentVersion
        )
    }
    
    // MARK: - Cache Management
    func getCachedIdentityProfile() -> UserIdentityProfile? {
        guard let data = UserDefaults.standard.data(forKey: cacheKey) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode(UserIdentityProfile.self, from: data)
    }
    
    func saveIdentityProfile(_ profile: UserIdentityProfile) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(profile) {
            UserDefaults.standard.set(data, forKey: cacheKey)
        }
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cacheKey)
    }
    
    func shouldRecompute(userData: UserData) -> Bool {
        guard let cached = getCachedIdentityProfile() else {
            return true
        }
        
        // Check version
        if cached.version != UserIdentityProfile.currentVersion {
            return true
        }
        
        // Check if birth data changed (simplified check)
        // In a real app, you'd compare actual values
        return false
    }
    
    // MARK: - Astrology Identity
    private func computeAstrologyIdentity(
        blueprint: AstrologyBlueprint,
        hasAccurateTime: Bool,
        hasAccuratePlace: Bool,
        birthDate: Date
    ) -> AstrologyIdentity {
        let sunSign = blueprint.sun.sign
        let moonSign = blueprint.moon.sign
        let risingSign = blueprint.rising.sign
        
        // Calculate dominant element
        let dominantElement = calculateDominantElement(blueprint: blueprint)
        
        // Generate free summary
        let freeSummary = contentGenerator.generateAstrologyFreeSummary(
            sunSign: sunSign,
            moonSign: moonSign,
            risingSign: risingSign,
            dominantElement: dominantElement
        )
        
        // Premium content (only if accurate birth time/place)
        let lifeFocusAreas = hasAccurateTime && hasAccuratePlace
            ? calculateLifeFocusAreas(blueprint: blueprint)
            : nil
        
        let familiarPatterns = hasAccurateTime
            ? calculateFamiliarPatterns(blueprint: blueprint, birthDate: birthDate)
            : nil
        
        let growthDirection = hasAccurateTime
            ? calculateGrowthDirection(blueprint: blueprint, birthDate: birthDate)
            : nil
        
        let strengths = generateStrengths(blueprint: blueprint)
        let blindSpots = generateBlindSpots(blueprint: blueprint)
        let premiumSummary = generatePremiumAstrologySummary(blueprint: blueprint)
        
        return AstrologyIdentity(
            sunSign: sunSign,
            moonSign: moonSign,
            risingSign: risingSign,
            dominantElement: dominantElement,
            freeSummary: freeSummary,
            lifeFocusAreas: lifeFocusAreas,
            familiarPatterns: familiarPatterns,
            growthDirection: growthDirection,
            strengths: strengths,
            blindSpots: blindSpots,
            premiumSummary: premiumSummary,
            hasAccurateBirthTime: hasAccurateTime,
            hasAccurateBirthPlace: hasAccuratePlace
        )
    }
    
    // MARK: - Dominant Element
    private func calculateDominantElement(blueprint: AstrologyBlueprint) -> Element {
        var elementCounts: [Element: Int] = [.fire: 0, .earth: 0, .air: 0, .water: 0]
        
        // Count elements from Sun, Moon, Rising
        let placements = [blueprint.sun, blueprint.moon, blueprint.rising]
        
        for placement in placements {
            if let element = getElementFromSign(placement.sign) {
                elementCounts[element, default: 0] += 1
            }
        }
        
        // Find dominant
        let dominant = elementCounts.max { $0.value < $1.value }?.key ?? .fire
        return dominant
    }
    
    private func getElementFromSign(_ sign: String) -> Element? {
        switch sign {
        case "Aries", "Leo", "Sagittarius":
            return .fire
        case "Taurus", "Virgo", "Capricorn":
            return .earth
        case "Gemini", "Libra", "Aquarius":
            return .air
        case "Cancer", "Scorpio", "Pisces":
            return .water
        default:
            return nil
        }
    }
    
    // MARK: - Life Focus Areas (Houses)
    private func calculateLifeFocusAreas(blueprint: AstrologyBlueprint) -> [LifeFocusArea]? {
        var houseScores: [Int: Int] = [:]
        
        // Score each house
        for i in 1...12 {
            houseScores[i] = scoreHouse(houseIndex: i, blueprint: blueprint)
        }
        
        // Select top houses
        let topHouses = selectTopHouses(scores: houseScores, maxCount: 3)
        
        return topHouses.map { houseIndex in
            LifeFocusArea(
                id: houseIndex,
                title: contentGenerator.generateLifeFocusAreaTitle(houseIndex: houseIndex),
                shortMeaning: generateHouseMeaning(houseIndex: houseIndex)
            )
        }
    }
    
    private func scoreHouse(houseIndex: Int, blueprint: AstrologyBlueprint) -> Int {
        var score = 0
        
        // Count planets in house (simplified - using house from placements if available)
        let placements = blueprint.allPlacements
        for placement in placements {
            if let house = placement.house, house == houseIndex {
                score += 3
                
                // Extra weight for Sun/Moon/Rising
                if placement.planet == "Sun" || placement.planet == "Moon" || placement.planet == "Rising" {
                    score += 1
                }
            }
        }
        
        // Angular houses bonus (1, 4, 7, 10)
        if [1, 4, 7, 10].contains(houseIndex) && score > 0 {
            score += 4
        }
        
        // Chart ruler bonus (simplified - rising sign's house)
        if let risingHouse = blueprint.rising.house, risingHouse == houseIndex {
            score += 2
        }
        
        return score
    }
    
    private func selectTopHouses(scores: [Int: Int], maxCount: Int) -> [Int] {
        let sorted = scores.sorted { $0.value > $1.value }
        
        guard sorted.count >= 2 else {
            return sorted.prefix(maxCount).map { $0.key }
        }
        
        let top2 = Array(sorted.prefix(2))
        var result = top2.map { $0.key }
        
        // Include #3 if within 70% of #2
        if sorted.count >= 3 {
            let score2 = top2[1].value
            let score3 = sorted[2].value
            if score3 >= Int(Double(score2) * 0.7) {
                result.append(sorted[2].key)
            }
        }
        
        return Array(result.prefix(maxCount))
    }
    
    private func generateHouseMeaning(houseIndex: Int) -> String {
        let meanings: [Int: String] = [
            1: "This area of life focuses on your identity, self-expression, and how you present yourself to the world.",
            2: "This area of life focuses on your values, resources, and what you find meaningful and valuable.",
            3: "This area of life focuses on communication, learning, and your immediate environment.",
            4: "This area of life focuses on home, family, roots, and your emotional foundation.",
            5: "This area of life focuses on creativity, self-expression, romance, and joy.",
            6: "This area of life focuses on service, health, daily routines, and work habits.",
            7: "This area of life focuses on partnerships, relationships, and how you relate to others.",
            8: "This area of life focuses on transformation, shared resources, and deep psychological work.",
            9: "This area of life focuses on philosophy, higher learning, travel, and expansion.",
            10: "This area of life focuses on career, public image, and your life purpose.",
            11: "This area of life focuses on community, friendships, hopes, and visions for the future.",
            12: "This area of life focuses on spirituality, completion, and the unconscious."
        ]
        
        return meanings[houseIndex] ?? "This area of life represents important themes in your journey."
    }
    
    // MARK: - Familiar Patterns (South Node)
    private func calculateFamiliarPatterns(blueprint: AstrologyBlueprint, birthDate: Date) -> FamiliarPattern? {
        // Simplified: South Node is opposite of North Node
        // North Node calculation simplified based on birth date
        let northNodeSign = calculateNorthNodeSign(birthDate: birthDate)
        let southNodeSign = getOppositeSign(northNodeSign)
        
        return FamiliarPattern(
            title: "Familiar Patterns",
            shortMeaning: contentGenerator.generateFamiliarPatternsDescription(sign: southNodeSign)
        )
    }
    
    private func calculateNorthNodeSign(birthDate: Date) -> String {
        // Simplified calculation - in real app would use proper astrological calculation
        let calendar = Calendar.current
        let day = calendar.component(.day, from: birthDate)
        let signs = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
                    "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
        return signs[(day - 1) % 12]
    }
    
    private func getOppositeSign(_ sign: String) -> String {
        let opposites: [String: String] = [
            "Aries": "Libra", "Taurus": "Scorpio", "Gemini": "Sagittarius",
            "Cancer": "Capricorn", "Leo": "Aquarius", "Virgo": "Pisces",
            "Libra": "Aries", "Scorpio": "Taurus", "Sagittarius": "Gemini",
            "Capricorn": "Cancer", "Aquarius": "Leo", "Pisces": "Virgo"
        ]
        return opposites[sign] ?? sign
    }
    
    // MARK: - Growth Direction (North Node)
    private func calculateGrowthDirection(blueprint: AstrologyBlueprint, birthDate: Date) -> GrowthDirection? {
        let northNodeSign = calculateNorthNodeSign(birthDate: birthDate)
        
        return GrowthDirection(
            title: "Growth Direction",
            shortMeaning: contentGenerator.generateGrowthDirectionDescription(sign: northNodeSign)
        )
    }
    
    // MARK: - Strengths & Blind Spots
    private func generateStrengths(blueprint: AstrologyBlueprint) -> [String] {
        var strengths: [String] = []
        
        // Sun sign strengths
        let sunStrengths: [String: [String]] = [
            "Aries": ["Bold leadership", "Initiative", "Courage"],
            "Taurus": ["Stability", "Reliability", "Patience"],
            "Gemini": ["Communication", "Curiosity", "Adaptability"],
            "Cancer": ["Nurturing", "Intuition", "Emotional depth"],
            "Leo": ["Confidence", "Creativity", "Generosity"],
            "Virgo": ["Attention to detail", "Service", "Practicality"],
            "Libra": ["Harmony", "Diplomacy", "Aesthetic sense"],
            "Scorpio": ["Depth", "Transformation", "Intensity"],
            "Sagittarius": ["Optimism", "Philosophy", "Adventure"],
            "Capricorn": ["Ambition", "Discipline", "Structure"],
            "Aquarius": ["Innovation", "Independence", "Humanitarianism"],
            "Pisces": ["Compassion", "Intuition", "Creativity"]
        ]
        
        if let sunStrengthsList = sunStrengths[blueprint.sun.sign] {
            strengths.append(contentsOf: sunStrengthsList.prefix(2))
        }
        
        return strengths.isEmpty ? ["Your natural strengths are unique to you"] : strengths
    }
    
    private func generateBlindSpots(blueprint: AstrologyBlueprint) -> [String] {
        var blindSpots: [String] = []
        
        let blindSpotMap: [String: [String]] = [
            "Aries": ["May rush without considering others", "Can be impatient"],
            "Taurus": ["May resist necessary change", "Can be stubborn"],
            "Gemini": ["May avoid deeper emotions", "Can be scattered"],
            "Cancer": ["May be overly sensitive", "Can create dependency"],
            "Leo": ["May need external validation", "Can be prideful"],
            "Virgo": ["May be overly critical", "Can be perfectionistic"],
            "Libra": ["May avoid conflict", "Can be indecisive"],
            "Scorpio": ["May be controlling", "Can be secretive"],
            "Sagittarius": ["May avoid commitment", "Can be tactless"],
            "Capricorn": ["May prioritize work over relationships", "Can be rigid"],
            "Aquarius": ["May detach from emotions", "Can be aloof"],
            "Pisces": ["May lack boundaries", "Can be escapist"]
        ]
        
        if let blindSpotsList = blindSpotMap[blueprint.sun.sign] {
            blindSpots.append(contentsOf: blindSpotsList.prefix(2))
        }
        
        return blindSpots.isEmpty ? ["Growth areas are unique to your journey"] : blindSpots
    }
    
    private func generatePremiumAstrologySummary(blueprint: AstrologyBlueprint) -> String {
        return "Your astrological blueprint reveals a complex interplay of energies. Your \(blueprint.sun.sign) Sun provides your core identity, while your \(blueprint.moon.sign) Moon shapes your emotional nature. Your \(blueprint.rising.sign) Rising influences how others perceive you. Together, these placements create a unique cosmic signature that influences your life path, relationships, and personal growth."
    }
    
    // MARK: - Numerology Identity
    private func computeNumerologyIdentity(blueprint: NumerologyBlueprint) -> NumerologyIdentity {
        let lifePath = blueprint.lifePath.number
        let archetype = blueprint.lifePath.name
        
        let freeSummary = contentGenerator.generateNumerologyFreeSummary(
            lifePath: lifePath,
            archetype: archetype
        )
        
        // Premium content
        let destinyExpression = blueprint.destiny?.number ?? blueprint.expression?.number
        let soulUrge = blueprint.soulUrge?.number
        let personality = blueprint.birthday?.number
        let karmicDebt = blueprint.karmicLessons
        let premiumSynthesis = generateNumerologySynthesis(blueprint: blueprint)
        
        return NumerologyIdentity(
            lifePath: lifePath,
            archetypeLabel: archetype,
            freeSummary: freeSummary,
            destinyExpression: destinyExpression,
            soulUrge: soulUrge,
            personality: personality,
            karmicDebt: karmicDebt,
            premiumSynthesis: premiumSynthesis
        )
    }
    
    private func generateNumerologySynthesis(blueprint: NumerologyBlueprint) -> String {
        var parts: [String] = []
        
        parts.append("Your Life Path \(blueprint.lifePath.number) represents your core journey.")
        
        if let destiny = blueprint.destiny {
            parts.append("Your Destiny Number \(destiny.number) reveals your life's purpose.")
        }
        
        if let expression = blueprint.expression {
            parts.append("Your Expression Number \(expression.number) shows your natural talents.")
        }
        
        if let soulUrge = blueprint.soulUrge {
            parts.append("Your Soul Urge \(soulUrge.number) reflects your inner desires.")
        }
        
        return parts.joined(separator: " ") + " Together, these numbers create a complete picture of your numerological identity."
    }
    
    // MARK: - Elemental Identity
    private func computeElementalIdentity(
        astrology: AstrologyBlueprint,
        numerology: NumerologyIdentity
    ) -> ElementalIdentity {
        // Count elements from placements
        var elementCounts: [Element: Int] = [.fire: 0, .earth: 0, .air: 0, .water: 0]
        
        let placements = [astrology.sun, astrology.moon, astrology.rising]
        for placement in placements {
            if let element = getElementFromSign(placement.sign) {
                elementCounts[element, default: 0] += 1
            }
        }
        
        // Identify dominant and deficient
        let sorted = elementCounts.sorted { $0.value > $1.value }
        let dominant = sorted.filter { $0.value == sorted.first?.value }.map { $0.key }
        let deficient = sorted.filter { $0.value == 0 }.map { $0.key }
        
        // Generate content
        let freeInsight = contentGenerator.generateElementalInsight(
            dominant: dominant,
            deficient: deficient
        )
        
        let imbalanceSignals = contentGenerator.generateImbalanceSignals(deficient: deficient)
        let supportingElements = contentGenerator.generateSupportingElements(dominant: dominant)
        let drainingElements = contentGenerator.generateDrainingElements(deficient: deficient)
        
        let dominantElement = dominant.first ?? .fire
        let crossSystemInfluence = contentGenerator.generateCrossSystemInfluence(
            dominantElement: dominantElement,
            lifePath: numerology.lifePath
        )
        
        let balanceGuidance = contentGenerator.generateBalanceGuidance(
            dominant: dominant,
            deficient: deficient
        )
        
        return ElementalIdentity(
            dominant: dominant,
            deficient: deficient,
            freeInsight: freeInsight,
            imbalanceSignals: imbalanceSignals,
            supportingElements: supportingElements,
            drainingElements: drainingElements,
            crossSystemInfluence: crossSystemInfluence,
            balanceGuidance: balanceGuidance
        )
    }
}
