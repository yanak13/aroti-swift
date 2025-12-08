//
//  BlueprintService.swift
//  Aroti
//
//  Service for calculating user blueprints from birth details
//

import Foundation

class BlueprintService {
    static let shared = BlueprintService()
    
    private init() {}
    
    // MARK: - Mock Birth Details
    static let mockBirthDate: Date = {
        var components = DateComponents()
        components.year = 1990
        components.month = 3
        components.day = 15
        components.hour = 10
        components.minute = 30
        return Calendar.current.date(from: components) ?? Date()
    }()
    
    static let mockBirthLocation = "San Francisco, CA"
    
    // MARK: - Calculate Blueprint
    func calculateBlueprint(from userData: UserData) -> UserBlueprint? {
        guard let birthDate = userData.birthDate else {
            return nil
        }
        
        let birthTime = userData.birthTime ?? birthDate
        let birthLocation = userData.birthLocation ?? Self.mockBirthLocation
        
        let astrology = calculateAstrologyBlueprint(
            birthDate: birthDate,
            birthTime: birthTime,
            birthLocation: birthLocation
        )
        
        let numerology = calculateNumerologyBlueprint(
            birthDate: birthDate,
            name: userData.name
        )
        
        let chineseZodiac = calculateChineseZodiacBlueprint(birthDate: birthDate)
        
        return UserBlueprint(
            astrology: astrology,
            numerology: numerology,
            chineseZodiac: chineseZodiac
        )
    }
    
    // MARK: - Astrology Calculations
    private func calculateAstrologyBlueprint(
        birthDate: Date,
        birthTime: Date,
        birthLocation: String
    ) -> AstrologyBlueprint {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day], from: birthDate)
        let month = components.month ?? 1
        let day = components.day ?? 1
        
        // Calculate Sun Sign
        let sun = calculateSunSign(month: month, day: day)
        
        // Calculate Moon Sign (simplified - based on sun sign offset)
        let moon = calculateMoonSign(sunSign: sun.sign, birthTime: birthTime)
        
        // Calculate Rising Sign (simplified - based on birth time)
        let rising = calculateRisingSign(birthTime: birthTime)
        
        // Additional planets (premium features)
        let venus = calculateVenusSign(sunSign: sun.sign)
        let mars = calculateMarsSign(sunSign: sun.sign)
        let mercury = calculateMercurySign(sunSign: sun.sign)
        let jupiter = calculateJupiterSign(sunSign: sun.sign)
        let saturn = calculateSaturnSign(sunSign: sun.sign)
        let uranus = calculateUranusSign(sunSign: sun.sign)
        let neptune = calculateNeptuneSign(sunSign: sun.sign)
        let pluto = calculatePlutoSign(sunSign: sun.sign)
        
        return AstrologyBlueprint(
            sun: sun,
            moon: moon,
            rising: rising,
            venus: venus,
            mars: mars,
            mercury: mercury,
            jupiter: jupiter,
            saturn: saturn,
            uranus: uranus,
            neptune: neptune,
            pluto: pluto
        )
    }
    
    private func calculateSunSign(month: Int, day: Int) -> PlanetaryPlacement {
        let sign: String
        let description: String
        let meaning: String
        
        switch (month, day) {
        case (3, 1...20), (2, 20...29):
            sign = "Pisces"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Pisces reflects a deeply intuitive, compassionate nature. You move through the world with empathy and creativity, often feeling connected to the spiritual and emotional realms."
        case (3, 21...31), (4, 1...19):
            sign = "Aries"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Aries reflects a bold, pioneering nature. You move through the world with confidence and initiative, always ready to take on new challenges and lead the way."
        case (4, 20...30), (5, 1...20):
            sign = "Taurus"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Taurus reflects a stable, grounded nature. You move through the world with patience and determination, valuing security, beauty, and the pleasures of life."
        case (5, 21...31), (6, 1...20):
            sign = "Gemini"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Gemini reflects a curious, communicative nature. You move through the world with versatility and wit, always seeking to learn and share knowledge."
        case (6, 21...30), (7, 1...22):
            sign = "Cancer"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Cancer reflects a nurturing, emotional nature. You move through the world with sensitivity and care, deeply connected to home, family, and your inner world."
        case (7, 23...31), (8, 1...22):
            sign = "Leo"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Leo reflects a confident, creative nature. You move through the world with warmth and generosity, naturally drawing attention and inspiring others."
        case (8, 23...31), (9, 1...22):
            sign = "Virgo"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Virgo reflects a practical, analytical nature. You move through the world with attention to detail and a desire to be of service, finding meaning in organization and improvement."
        case (9, 23...30), (10, 1...22):
            sign = "Libra"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Libra reflects a harmonious, diplomatic nature. You move through the world seeking balance and beauty, naturally drawn to partnerships and aesthetic experiences."
        case (10, 23...31), (11, 1...21):
            sign = "Scorpio"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Scorpio reflects an intense, transformative nature. You move through the world with depth and passion, seeking truth and meaningful connections."
        case (11, 22...30), (12, 1...21):
            sign = "Sagittarius"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Sagittarius reflects an adventurous, philosophical nature. You move through the world with optimism and a thirst for knowledge, always seeking new horizons."
        case (12, 22...31), (1, 1...19):
            sign = "Capricorn"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Capricorn reflects an ambitious, disciplined nature. You move through the world with determination and responsibility, building lasting structures and achieving long-term goals."
        case (1, 20...31), (2, 1...19):
            sign = "Aquarius"
            description = "Identity • How you move through the world"
            meaning = "Your Sun in Aquarius reflects an innovative, humanitarian nature. You move through the world with originality and a vision for the future, valuing freedom and progress."
        default:
            sign = "Pisces"
            description = "Identity • How you move through the world"
            meaning = "Your Sun sign reflects your core identity and how you express yourself in the world."
        }
        
        return PlanetaryPlacement(
            planet: "Sun",
            sign: sign,
            description: description,
            meaning: meaning,
            house: nil
        )
    }
    
    private func calculateMoonSign(sunSign: String, birthTime: Date) -> PlanetaryPlacement {
        // Simplified moon sign calculation - typically 2-3 signs ahead of sun
        let moonSigns: [String: String] = [
            "Aries": "Gemini",
            "Taurus": "Cancer",
            "Gemini": "Leo",
            "Cancer": "Virgo",
            "Leo": "Libra",
            "Virgo": "Scorpio",
            "Libra": "Sagittarius",
            "Scorpio": "Capricorn",
            "Sagittarius": "Aquarius",
            "Capricorn": "Pisces",
            "Aquarius": "Aries",
            "Pisces": "Taurus"
        ]
        
        let sign = moonSigns[sunSign] ?? "Cancer"
        let moonMeanings: [String: String] = [
            "Aries": "Your Moon in Aries reveals an impulsive, passionate emotional nature. You process feelings quickly and directly, with a need for independence and action.",
            "Taurus": "Your Moon in Taurus reveals a stable, sensual emotional nature. You process feelings through comfort and security, valuing consistency and material pleasures.",
            "Gemini": "Your Moon in Gemini reveals a curious, communicative emotional nature. You process feelings through conversation and mental stimulation, needing variety and intellectual connection.",
            "Cancer": "Your Moon in Cancer reveals a nurturing, sensitive emotional nature. You process feelings through intuition and memory, deeply connected to home and family.",
            "Leo": "Your Moon in Leo reveals a warm, expressive emotional nature. You process feelings with drama and creativity, needing recognition and appreciation.",
            "Virgo": "Your Moon in Virgo reveals an analytical, practical emotional nature. You process feelings through service and organization, finding comfort in routine and helpfulness.",
            "Libra": "Your Moon in Libra reveals a harmonious, diplomatic emotional nature. You process feelings through relationships and beauty, needing balance and partnership.",
            "Scorpio": "Your Moon in Scorpio reveals an intense, transformative emotional nature. You process feelings with depth and passion, experiencing emotions at their fullest intensity.",
            "Sagittarius": "Your Moon in Sagittarius reveals an optimistic, adventurous emotional nature. You process feelings through exploration and philosophy, needing freedom and expansion.",
            "Capricorn": "Your Moon in Capricorn reveals a disciplined, reserved emotional nature. You process feelings through structure and achievement, valuing tradition and responsibility.",
            "Aquarius": "Your Moon in Aquarius reveals an independent, innovative emotional nature. You process feelings through detachment and originality, needing freedom and intellectual stimulation.",
            "Pisces": "Your Moon in Pisces reveals a deeply intuitive and empathetic emotional nature. You process feelings through imagination and compassion, often absorbing the emotions of those around you."
        ]
        
        return PlanetaryPlacement(
            planet: "Moon",
            sign: sign,
            description: "Inner world • How you feel and process emotion",
            meaning: moonMeanings[sign] ?? "Your Moon sign reveals your emotional nature and inner world.",
            house: nil
        )
    }
    
    private func calculateRisingSign(birthTime: Date) -> PlanetaryPlacement {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: birthTime)
        
        // Simplified rising sign calculation based on birth hour
        let risingSigns = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
                          "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]
        let signIndex = (hour / 2) % 12
        let sign = risingSigns[signIndex]
        
        let risingMeanings: [String: String] = [
            "Aries": "Your Rising in Aries means you present with energy and confidence. Others see your boldness and initiative first.",
            "Taurus": "Your Rising in Taurus means you present with stability and grace. Others see your calm, grounded presence first.",
            "Gemini": "Your Rising in Gemini means you present with curiosity and charm. Others see your quick wit and communication skills first.",
            "Cancer": "Your Rising in Cancer means you present with warmth and sensitivity. Others see your nurturing, caring nature first.",
            "Leo": "Your Rising in Leo means you present with warmth and confidence. Others see your natural radiance and charisma first.",
            "Virgo": "Your Rising in Virgo means you present with precision and modesty. Others see your attention to detail and helpfulness first.",
            "Libra": "Your Rising in Libra means you present with harmony and elegance. Others see your diplomatic nature and aesthetic sense first.",
            "Scorpio": "Your Rising in Scorpio means you present with intensity and mystery. Others see your depth and magnetic presence first.",
            "Sagittarius": "Your Rising in Sagittarius means you present with optimism and enthusiasm. Others see your adventurous spirit and philosophical nature first.",
            "Capricorn": "Your Rising in Capricorn means you present with maturity and ambition. Others see your responsible, goal-oriented nature first.",
            "Aquarius": "Your Rising in Aquarius means you present with originality and independence. Others see your unique perspective and humanitarian ideals first.",
            "Pisces": "Your Rising in Pisces means you present with dreaminess and compassion. Others see your intuitive, artistic nature first."
        ]
        
        return PlanetaryPlacement(
            planet: "Rising",
            sign: sign,
            description: "First impression • The energy you project to others",
            meaning: risingMeanings[sign] ?? "Your Rising sign represents how others perceive you.",
            house: nil
        )
    }
    
    private func calculateVenusSign(sunSign: String) -> PlanetaryPlacement {
        let venusSigns: [String: String] = [
            "Aries": "Libra", "Taurus": "Scorpio", "Gemini": "Sagittarius",
            "Cancer": "Capricorn", "Leo": "Aquarius", "Virgo": "Pisces",
            "Libra": "Aries", "Scorpio": "Taurus", "Sagittarius": "Gemini",
            "Capricorn": "Cancer", "Aquarius": "Leo", "Pisces": "Virgo"
        ]
        let sign = venusSigns[sunSign] ?? "Libra"
        return PlanetaryPlacement(
            planet: "Venus",
            sign: sign,
            description: "Love • How you give and receive affection",
            meaning: "Your Venus in \(sign) influences how you experience love, beauty, and relationships.",
            house: nil
        )
    }
    
    private func calculateMarsSign(sunSign: String) -> PlanetaryPlacement {
        let marsSigns: [String: String] = [
            "Aries": "Scorpio", "Taurus": "Sagittarius", "Gemini": "Capricorn",
            "Cancer": "Aquarius", "Leo": "Pisces", "Virgo": "Aries",
            "Libra": "Taurus", "Scorpio": "Gemini", "Sagittarius": "Cancer",
            "Capricorn": "Leo", "Aquarius": "Virgo", "Pisces": "Libra"
        ]
        let sign = marsSigns[sunSign] ?? "Aries"
        return PlanetaryPlacement(
            planet: "Mars",
            sign: sign,
            description: "Action • How you assert yourself and pursue desires",
            meaning: "Your Mars in \(sign) influences how you take action, assert yourself, and pursue your goals.",
            house: nil
        )
    }
    
    private func calculateMercurySign(sunSign: String) -> PlanetaryPlacement {
        // Mercury is usually close to the sun sign
        return PlanetaryPlacement(
            planet: "Mercury",
            sign: sunSign,
            description: "Communication • How you think and express ideas",
            meaning: "Your Mercury in \(sunSign) influences how you communicate, think, and process information.",
            house: nil
        )
    }
    
    private func calculateJupiterSign(sunSign: String) -> PlanetaryPlacement {
        let jupiterSigns: [String: String] = [
            "Aries": "Sagittarius", "Taurus": "Capricorn", "Gemini": "Aquarius",
            "Cancer": "Pisces", "Leo": "Aries", "Virgo": "Taurus",
            "Libra": "Gemini", "Scorpio": "Cancer", "Sagittarius": "Leo",
            "Capricorn": "Virgo", "Aquarius": "Libra", "Pisces": "Scorpio"
        ]
        let sign = jupiterSigns[sunSign] ?? "Sagittarius"
        return PlanetaryPlacement(
            planet: "Jupiter",
            sign: sign,
            description: "Expansion • Your philosophy and growth",
            meaning: "Your Jupiter in \(sign) influences your beliefs, opportunities for growth, and how you expand your horizons.",
            house: nil
        )
    }
    
    private func calculateSaturnSign(sunSign: String) -> PlanetaryPlacement {
        let saturnSigns: [String: String] = [
            "Aries": "Capricorn", "Taurus": "Aquarius", "Gemini": "Pisces",
            "Cancer": "Aries", "Leo": "Taurus", "Virgo": "Gemini",
            "Libra": "Cancer", "Scorpio": "Leo", "Sagittarius": "Virgo",
            "Capricorn": "Libra", "Aquarius": "Scorpio", "Pisces": "Sagittarius"
        ]
        let sign = saturnSigns[sunSign] ?? "Capricorn"
        return PlanetaryPlacement(
            planet: "Saturn",
            sign: sign,
            description: "Structure • Your challenges and discipline",
            meaning: "Your Saturn in \(sign) influences your sense of responsibility, discipline, and areas where you face challenges and build structure.",
            house: nil
        )
    }
    
    private func calculateUranusSign(sunSign: String) -> PlanetaryPlacement {
        return PlanetaryPlacement(
            planet: "Uranus",
            sign: "Aquarius",
            description: "Innovation • Your uniqueness and rebellion",
            meaning: "Your Uranus in Aquarius influences your need for freedom, innovation, and breaking from tradition.",
            house: nil
        )
    }
    
    private func calculateNeptuneSign(sunSign: String) -> PlanetaryPlacement {
        return PlanetaryPlacement(
            planet: "Neptune",
            sign: "Pisces",
            description: "Dreams • Your intuition and spirituality",
            meaning: "Your Neptune in Pisces influences your connection to the spiritual, your dreams, and your intuitive abilities.",
            house: nil
        )
    }
    
    private func calculatePlutoSign(sunSign: String) -> PlanetaryPlacement {
        return PlanetaryPlacement(
            planet: "Pluto",
            sign: "Scorpio",
            description: "Transformation • Your power and regeneration",
            meaning: "Your Pluto in Scorpio influences your capacity for transformation, deep psychological insight, and regeneration.",
            house: nil
        )
    }
    
    // MARK: - Numerology Calculations
    private func calculateNumerologyBlueprint(birthDate: Date, name: String) -> NumerologyBlueprint {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthDate)
        let year = components.year ?? 1990
        let month = components.month ?? 1
        let day = components.day ?? 1
        
        let lifePath = calculateLifePathNumber(year: year, month: month, day: day)
        let destiny = calculateDestinyNumber(name: name)
        let expression = calculateExpressionNumber(name: name)
        let soulUrge = calculateSoulUrgeNumber(name: name)
        let birthday = calculateBirthdayNumber(day: day)
        
        return NumerologyBlueprint(
            lifePath: lifePath,
            destiny: destiny,
            expression: expression,
            soulUrge: soulUrge,
            birthday: birthday,
            karmicLessons: nil
        )
    }
    
    private func calculateLifePathNumber(year: Int, month: Int, day: Int) -> NumerologyNumber {
        func reduceToSingleDigit(_ num: Int) -> Int {
            var result = num
            while result > 9 && result != 11 && result != 22 && result != 33 {
                result = String(result).compactMap { Int(String($0)) }.reduce(0, +)
            }
            return result
        }
        
        let yearSum = reduceToSingleDigit(year)
        let monthSum = reduceToSingleDigit(month)
        let daySum = reduceToSingleDigit(day)
        let total = yearSum + monthSum + daySum
        let lifePath = reduceToSingleDigit(total)
        
        return getLifePathNumberDetails(number: lifePath)
    }
    
    private func getLifePathNumberDetails(number: Int) -> NumerologyNumber {
        let lifePathMeanings: [Int: (name: String, description: String, meaning: String, traits: [String])] = [
            1: ("The Leader", "Independence • Innovation • Leadership", "You're here to lead, innovate, and create new paths. Independence is your strength, and you're meant to pioneer new ways of thinking and being.", ["Independent", "Innovative", "Ambitious", "Determined"]),
            2: ("The Diplomat", "Cooperation • Harmony • Partnership", "You're here to bring people together, create harmony, and work through partnerships. Your sensitivity and intuition guide you in building bridges.", ["Cooperative", "Intuitive", "Diplomatic", "Patient"]),
            3: ("The Connector", "Creative energy • Expression • Communication", "You're here to express, inspire, and bring people together through creativity and communication. Joy is your natural state.", ["Creative", "Expressive", "Optimistic", "Social"]),
            4: ("The Builder", "Stability • Structure • Practicality", "You're here to build solid foundations, create structure, and bring practical solutions. Your reliability and methodical approach create lasting results.", ["Practical", "Reliable", "Organized", "Disciplined"]),
            5: ("The Adventurer", "Freedom • Change • Experience", "You're here to experience life fully, embrace change, and seek freedom. Your curiosity and adaptability lead you to diverse experiences.", ["Adventurous", "Curious", "Flexible", "Energetic"]),
            6: ("The Nurturer", "Responsibility • Care • Service", "You're here to nurture, care for others, and create harmony in your environment. Your compassion and sense of responsibility guide you.", ["Nurturing", "Responsible", "Caring", "Harmonious"]),
            7: ("The Seeker", "Spirituality • Analysis • Wisdom", "You're here to seek truth, develop wisdom, and connect with the spiritual. Your analytical mind and intuition lead you to deeper understanding.", ["Analytical", "Spiritual", "Introspective", "Wise"]),
            8: ("The Achiever", "Material success • Authority • Power", "You're here to achieve material success, exercise authority, and build power. Your ambition and business acumen create tangible results.", ["Ambitious", "Authoritative", "Materially focused", "Powerful"]),
            9: ("The Humanitarian", "Compassion • Service • Completion", "You're here to serve humanity, show compassion, and complete cycles. Your universal love and wisdom inspire others.", ["Compassionate", "Humanitarian", "Wise", "Completing"]),
            11: ("The Intuitive", "Inspiration • Intuition • Illumination", "You're a master number with heightened intuition and spiritual insight. You're here to inspire and illuminate others.", ["Intuitive", "Inspiring", "Spiritual", "Illuminating"]),
            22: ("The Master Builder", "Practical idealism • Large-scale achievement", "You're a master number with the ability to turn grand visions into reality. You build on a large scale.", ["Visionary", "Practical", "Achieving", "Masterful"]),
            33: ("The Master Teacher", "Compassion • Healing • Teaching", "You're a master number with the gift of teaching and healing through compassion. You uplift humanity.", ["Compassionate", "Teaching", "Healing", "Uplifting"])
        ]
        
        let details = lifePathMeanings[number] ?? (
            name: "The Pathfinder",
            description: "Your unique journey",
            meaning: "Your life path number represents your journey and the lessons you're here to learn.",
            traits: ["Unique", "Evolving"]
        )
        
        return NumerologyNumber(
            number: number,
            name: details.name,
            description: details.description,
            meaning: details.meaning,
            traits: details.traits
        )
    }
    
    private func calculateDestinyNumber(name: String) -> NumerologyNumber? {
        // Simplified - use life path calculation method for name
        let number = calculateNameNumber(name: name)
        return NumerologyNumber(
            number: number,
            name: "Destiny Number",
            description: "Your life's purpose and potential",
            meaning: "Your Destiny Number reveals your life's purpose and the potential you're meant to fulfill.",
            traits: ["Purposeful", "Potential", "Fulfillment"]
        )
    }
    
    private func calculateExpressionNumber(name: String) -> NumerologyNumber? {
        let number = calculateNameNumber(name: name)
        return NumerologyNumber(
            number: number,
            name: "Expression Number",
            description: "Your natural talents and abilities",
            meaning: "Your Expression Number reveals your natural talents, abilities, and how you express yourself in the world.",
            traits: ["Talented", "Expressive", "Natural"]
        )
    }
    
    private func calculateSoulUrgeNumber(name: String) -> NumerologyNumber? {
        // Simplified - vowels only
        let vowels = "AEIOU"
        let vowelCount = name.uppercased().filter { vowels.contains($0) }.count
        let number = reduceToSingleDigit(vowelCount * 3)
        return NumerologyNumber(
            number: number,
            name: "Soul Urge",
            description: "Your inner desires and motivations",
            meaning: "Your Soul Urge reveals your innermost desires, what motivates you, and what your heart truly wants.",
            traits: ["Desire-driven", "Motivated", "Heart-centered"]
        )
    }
    
    private func calculateBirthdayNumber(day: Int) -> NumerologyNumber? {
        let number = reduceToSingleDigit(day)
        return NumerologyNumber(
            number: number,
            name: "Birthday Number",
            description: "Your natural gifts and talents",
            meaning: "Your Birthday Number reveals the natural gifts and talents you were born with.",
            traits: ["Gifted", "Talented", "Natural"]
        )
    }
    
    private func calculateNameNumber(name: String) -> Int {
        let letterValues: [Character: Int] = [
            "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8, "I": 9,
            "J": 1, "K": 2, "L": 3, "M": 4, "N": 5, "O": 6, "P": 7, "Q": 8, "R": 9,
            "S": 1, "T": 2, "U": 3, "V": 4, "W": 5, "X": 6, "Y": 7, "Z": 8
        ]
        
        let sum = name.uppercased().compactMap { letterValues[$0] }.reduce(0, +)
        return reduceToSingleDigit(sum)
    }
    
    private func reduceToSingleDigit(_ num: Int) -> Int {
        var result = num
        while result > 9 && result != 11 && result != 22 && result != 33 {
            result = String(result).compactMap { Int(String($0)) }.reduce(0, +)
        }
        return result
    }
    
    // MARK: - Chinese Zodiac Calculations
    private func calculateChineseZodiacBlueprint(birthDate: Date) -> ChineseZodiacBlueprint {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: birthDate)
        
        let animals = ["Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
                      "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"]
        let elements = ["Metal", "Water", "Wood", "Fire", "Earth"]
        
        let animalIndex = (year - 1900) % 12
        let elementIndex = ((year - 1900) / 2) % 5
        
        let animal = animals[animalIndex]
        let element = elements[elementIndex]
        
        let zodiacData = getChineseZodiacData(animal: animal, element: element)
        
        return ChineseZodiacBlueprint(
            animal: animal,
            element: element,
            year: year,
            description: zodiacData.description,
            traits: zodiacData.traits,
            compatibility: zodiacData.compatibility,
            luckyNumbers: zodiacData.luckyNumbers,
            luckyColors: zodiacData.luckyColors
        )
    }
    
    private func getChineseZodiacData(animal: String, element: String) -> (
        description: String,
        traits: [String],
        compatibility: [String],
        luckyNumbers: [Int],
        luckyColors: [String]
    ) {
        let data: [String: (description: String, traits: [String], compatibility: [String], luckyNumbers: [Int], luckyColors: [String])] = [
            "Rat": ("Clever and resourceful, Rats are quick-witted and adaptable. You excel in social situations and have a natural charm.", ["Clever", "Resourceful", "Adaptable", "Charming"], ["Dragon", "Monkey", "Ox"], [2, 3, 6], ["Blue", "Gold", "Green"]),
            "Ox": ("Diligent and dependable, Oxen are strong and methodical. You value hard work and are known for your reliability.", ["Diligent", "Dependable", "Strong", "Methodical"], ["Snake", "Rooster", "Rat"], [1, 4, 8], ["Red", "Yellow", "Green"]),
            "Tiger": ("Brave and confident, Tigers are natural leaders with a strong sense of justice. You're passionate and adventurous.", ["Brave", "Confident", "Passionate", "Adventurous"], ["Horse", "Dog", "Dragon"], [1, 3, 4], ["Blue", "Grey", "Orange"]),
            "Rabbit": ("Gentle and elegant, Rabbits are peaceful and artistic. You value harmony and have refined taste.", ["Gentle", "Elegant", "Peaceful", "Artistic"], ["Goat", "Pig", "Dog"], [3, 4, 6], ["Red", "Pink", "Purple"]),
            "Dragon": ("Ambitious and energetic, Dragons are powerful and charismatic. You're a natural leader with great vision.", ["Ambitious", "Energetic", "Powerful", "Charismatic"], ["Rat", "Monkey", "Rooster"], [1, 6, 7], ["Gold", "Silver", "Grey"]),
            "Snake": ("Wise and intuitive, Snakes are mysterious and philosophical. You have deep insight and value wisdom.", ["Wise", "Intuitive", "Mysterious", "Philosophical"], ["Ox", "Rooster", "Monkey"], [2, 8, 9], ["Red", "Yellow", "Black"]),
            "Horse": ("Energetic and independent, Horses are free-spirited and adventurous. You value freedom and have a strong will.", ["Energetic", "Independent", "Free-spirited", "Adventurous"], ["Tiger", "Dog", "Goat"], [2, 3, 7], ["Brown", "Yellow", "Green"]),
            "Goat": ("Creative and gentle, Goats are artistic and peaceful. You value beauty and have a calm, nurturing nature.", ["Creative", "Gentle", "Artistic", "Peaceful"], ["Rabbit", "Horse", "Pig"], [2, 7, 8], ["Green", "Red", "Purple"]),
            "Monkey": ("Witty and intelligent, Monkeys are clever and playful. You're quick-thinking and have a great sense of humor.", ["Witty", "Intelligent", "Clever", "Playful"], ["Rat", "Dragon", "Snake"], [4, 9], ["White", "Blue", "Gold"]),
            "Rooster": ("Confident and observant, Roosters are organized and detail-oriented. You're punctual and value precision.", ["Confident", "Observant", "Organized", "Detail-oriented"], ["Ox", "Snake", "Dragon"], [5, 7, 8], ["Gold", "Brown", "Yellow"]),
            "Dog": ("Loyal and honest, Dogs are faithful and protective. You value justice and have a strong sense of duty.", ["Loyal", "Honest", "Faithful", "Protective"], ["Tiger", "Horse", "Rabbit"], [3, 4, 9], ["Red", "Green", "Purple"]),
            "Pig": ("Generous and sincere, Pigs are compassionate and easygoing. You value peace and have a warm heart.", ["Generous", "Sincere", "Compassionate", "Easygoing"], ["Rabbit", "Goat", "Tiger"], [2, 5, 8], ["Yellow", "Grey", "Brown"])
        ]
        
        return data[animal] ?? (
            description: "Your Chinese zodiac sign reflects your personality and characteristics.",
            traits: ["Unique", "Balanced"],
            compatibility: ["All signs"],
            luckyNumbers: [1, 2, 3],
            luckyColors: ["Red", "Gold"]
        )
    }
}

