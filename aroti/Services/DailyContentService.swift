//
//  DailyContentService.swift
//  Aroti
//
//  Service for generating daily content based on day of year
//

import Foundation

class DailyContentService {
    static let shared = DailyContentService()
    
    private init() {}
    
    // Tarot cards database
    private let tarotCards: [TarotCard] = [
        TarotCard(id: "fool", name: "The Fool", keywords: ["New beginnings", "Innocence", "Adventure"], interpretation: nil, guidance: nil),
        TarotCard(id: "magician", name: "The Magician", keywords: ["Manifestation", "Power", "Will"], interpretation: nil, guidance: nil),
        TarotCard(id: "priestess", name: "The High Priestess", keywords: ["Intuition", "Mystery", "Wisdom"], interpretation: nil, guidance: nil),
        TarotCard(id: "empress", name: "The Empress", keywords: ["Fertility", "Abundance", "Nature"], interpretation: nil, guidance: nil),
        TarotCard(id: "emperor", name: "The Emperor", keywords: ["Authority", "Structure", "Control"], interpretation: nil, guidance: nil),
        TarotCard(id: "hierophant", name: "The Hierophant", keywords: ["Tradition", "Spirituality", "Guidance"], interpretation: nil, guidance: nil),
        TarotCard(id: "lovers", name: "The Lovers", keywords: ["Love", "Harmony", "Choices"], interpretation: nil, guidance: nil),
        TarotCard(id: "chariot", name: "The Chariot", keywords: ["Victory", "Willpower", "Control"], interpretation: nil, guidance: nil),
        TarotCard(id: "strength", name: "Strength", keywords: ["Courage", "Patience", "Inner strength"], interpretation: nil, guidance: nil),
        TarotCard(id: "hermit", name: "The Hermit", keywords: ["Introspection", "Guidance", "Solitude"], interpretation: nil, guidance: nil),
        TarotCard(id: "wheel", name: "Wheel of Fortune", keywords: ["Change", "Cycles", "Destiny"], interpretation: nil, guidance: nil),
        TarotCard(id: "justice", name: "Justice", keywords: ["Balance", "Fairness", "Truth"], interpretation: nil, guidance: nil),
        TarotCard(id: "hanged", name: "The Hanged Man", keywords: ["Surrender", "Letting go", "New perspective"], interpretation: nil, guidance: nil),
        TarotCard(id: "death", name: "Death", keywords: ["Transformation", "Endings", "Rebirth"], interpretation: nil, guidance: nil),
        TarotCard(id: "temperance", name: "Temperance", keywords: ["Balance", "Moderation", "Harmony"], interpretation: nil, guidance: nil),
        TarotCard(id: "devil", name: "The Devil", keywords: ["Bondage", "Materialism", "Shadow"], interpretation: nil, guidance: nil),
        TarotCard(id: "tower", name: "The Tower", keywords: ["Sudden change", "Revelation", "Breakthrough"], interpretation: nil, guidance: nil),
        TarotCard(id: "star", name: "The Star", keywords: ["Hope", "Inspiration", "Healing"], interpretation: nil, guidance: nil),
        TarotCard(id: "moon", name: "The Moon", keywords: ["Illusion", "Intuition", "Unconscious"], interpretation: nil, guidance: nil),
        TarotCard(id: "sun", name: "The Sun", keywords: ["Joy", "Success", "Vitality"], interpretation: nil, guidance: nil),
        TarotCard(id: "judgement", name: "Judgement", keywords: ["Reflection", "Awakening", "Forgiveness"], interpretation: nil, guidance: nil),
        TarotCard(id: "world", name: "The World", keywords: ["Completion", "Achievement", "Fulfillment"], interpretation: nil, guidance: nil)
    ]
    
    // Rituals database
    private let rituals: [Ritual] = [
        Ritual(id: "1", title: "Grounding Breath", description: "A simple breathing practice to center yourself and reconnect with your body.", duration: "3 min", type: "Grounding", intention: "This ritual helps you ground your energy and reconnect with your body after a busy day.", steps: ["Find a quiet space and sit comfortably.", "Take three slow, deep breaths.", "Place your hand over your heart and set your intention.", "Repeat the affirmation silently three times."], affirmation: "I am grounded, centered, and at peace."),
        Ritual(id: "2", title: "Morning Intention", description: "Set a meaningful intention for your day with this gentle morning practice.", duration: "5 min", type: "Intention", intention: "This ritual helps you start your day with clarity and purpose.", steps: ["Sit comfortably with your back straight.", "Take three deep breaths, inhaling through your nose and exhaling through your mouth.", "Bring to mind three things you're grateful for today.", "Ask yourself: 'What is one intention I want to set for today?'", "Visualize yourself embodying this intention throughout your day."], affirmation: "I move through my day with intention and grace."),
        Ritual(id: "3", title: "Evening Gratitude", description: "End your day with gratitude and reflection.", duration: "4 min", type: "Gratitude", intention: "This ritual helps you reflect on your day and cultivate gratitude.", steps: ["Find a comfortable seated or lying position.", "Close your eyes and take five deep breaths.", "Think of three things from today you're grateful for.", "Allow yourself to feel the warmth of gratitude in your heart.", "Set an intention for restful sleep."], affirmation: "I am grateful for all the blessings in my life.")
    ]
    
    // Affirmations database
    private let affirmations: [String] = [
        "I am worthy of love and abundance",
        "I honor my needs and create boundaries that protect my energy",
        "I trust my intuition and follow my inner guidance",
        "I am open to receiving all the good things life has to offer",
        "I embrace change and welcome new opportunities",
        "I am at peace with who I am and where I am",
        "I radiate confidence and attract positive energy",
        "I am grateful for all the blessings in my life",
        "I trust the journey and believe in my path",
        "I am strong, resilient, and capable of overcoming any challenge"
    ]
    
    // Horoscope previews by sign
    private let horoscopePreviews: [String: [String]] = [
        "Aries": ["Energy is high today, take bold action", "Your fiery nature is heightened, channel it wisely", "New beginnings await, trust your instincts"],
        "Taurus": ["Ground yourself in stability today", "Your practical nature guides you forward", "Focus on building lasting foundations"],
        "Gemini": ["Communication flows easily today", "Your curious mind is active, explore new ideas", "Social connections bring joy"],
        "Cancer": ["Emotional depth guides your day", "Nurture yourself and those you love", "Intuition is strong, trust your feelings"],
        "Leo": ["Your creative energy shines bright", "Express yourself authentically today", "Confidence and charisma are your strengths"],
        "Virgo": ["Attention to detail serves you well", "Organize and refine your approach", "Practical wisdom guides your decisions"],
        "Libra": ["Balance and harmony are your focus", "Seek beauty and connection today", "Your diplomatic nature creates peace"],
        "Scorpio": ["Transformation and depth call to you", "Your intensity is a source of power", "Trust in your ability to regenerate"],
        "Sagittarius": ["Adventure and expansion await", "Your optimistic spirit lifts others", "Seek knowledge and new experiences"],
        "Capricorn": ["Discipline and ambition drive you", "Build toward long-term goals", "Your determination creates success"],
        "Aquarius": ["Innovation and freedom inspire you", "Your unique perspective is valuable", "Connect with like-minded souls"],
        "Pisces": ["Intuitive nature heightened today", "Spiritual practices recommended", "Your compassion touches many hearts"]
    ]
    
    func getDayOfYear() -> Int {
        let calendar = Calendar.current
        return calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
    
    func generateTarotCard(dayOfYear: Int, userData: UserData) -> TarotCard {
        let index = (dayOfYear + (userData.name.hashValue % 100)) % tarotCards.count
        return tarotCards[index]
    }
    
    func generateHoroscope(sunSign: String, dayOfYear: Int) -> String {
        let previews = horoscopePreviews[sunSign] ?? ["Your energy today is shifting gently"]
        let index = dayOfYear % previews.count
        return previews[index]
    }
    
    func generateNumerology(birthDate: Date?, dayOfYear: Int) -> NumerologyInsight {
        let baseNumber = dayOfYear % 9 + 1
        let number = baseNumber == 0 ? 9 : baseNumber
        
        let previews: [Int: String] = [
            1: "Leadership and new beginnings",
            2: "Cooperation and harmony",
            3: "Creativity and expression",
            4: "Stability and foundation",
            5: "Freedom and adventure",
            6: "Love and responsibility",
            7: "Spiritual focus and introspection",
            8: "Material success and power",
            9: "Completion and wisdom"
        ]
        
        return NumerologyInsight(number: number, preview: previews[number] ?? "Energy is shifting")
    }
    
    func generateRitual(dayOfYear: Int) -> Ritual {
        let index = dayOfYear % rituals.count
        return rituals[index]
    }
    
    func generateAffirmation(dayOfYear: Int) -> String {
        let index = dayOfYear % affirmations.count
        return affirmations[index]
    }
    
    func generateDailyInsight(userData: UserData) -> DailyInsight {
        let dayOfYear = getDayOfYear()
        let tarotCard = generateTarotCard(dayOfYear: dayOfYear, userData: userData)
        let horoscope = generateHoroscope(sunSign: userData.sunSign, dayOfYear: dayOfYear)
        let numerology = generateNumerology(birthDate: userData.birthDate, dayOfYear: dayOfYear)
        let ritual = generateRitual(dayOfYear: dayOfYear)
        let affirmation = generateAffirmation(dayOfYear: dayOfYear)
        
        return DailyInsight(
            tarotCard: tarotCard,
            horoscope: horoscope,
            numerology: numerology,
            ritual: ritual,
            affirmation: affirmation,
            date: Date()
        )
    }
}

