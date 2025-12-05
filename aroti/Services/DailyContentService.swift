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
        TarotCard(id: "fool", name: "The Fool", keywords: ["New beginnings", "Innocence", "Adventure"], interpretation: "A new beginning, innocence, spontaneity, and a free spirit. Embrace new opportunities with an open heart.", guidance: ["Trust your instincts", "Take a leap of faith", "Embrace the unknown"], imageName: "tarot-fool"),
        TarotCard(id: "magician", name: "The Magician", keywords: ["Manifestation", "Power", "Will"], interpretation: "Manifestation, resourcefulness, power, and inspired action. You have all the tools you need to succeed.", guidance: ["Focus your energy", "Use all available resources", "Take decisive action"], imageName: "tarot-magician"),
        TarotCard(id: "priestess", name: "The High Priestess", keywords: ["Intuition", "Mystery", "Wisdom"], interpretation: "Intuition, mystery, and inner wisdom. Trust your inner voice and look beyond the surface.", guidance: ["Listen to your intuition", "Seek inner knowledge", "Trust the unknown"], imageName: "tarot-priestess"),
        TarotCard(id: "empress", name: "The Empress", keywords: ["Fertility", "Abundance", "Nature"], interpretation: "Fertility, abundance, and nurturing energy. Connect with nature and embrace your creative power.", guidance: ["Nurture yourself and others", "Embrace abundance", "Connect with nature"], imageName: "tarot-empress"),
        TarotCard(id: "emperor", name: "The Emperor", keywords: ["Authority", "Structure", "Control"], interpretation: "Authority, structure, and stability. Take control and establish order in your life.", guidance: ["Set clear boundaries", "Take leadership", "Build solid foundations"], imageName: "tarot-emperor"),
        TarotCard(id: "hierophant", name: "The Hierophant", keywords: ["Tradition", "Spirituality", "Guidance"], interpretation: "Tradition, spirituality, and seeking guidance. Connect with established wisdom and spiritual practices.", guidance: ["Seek spiritual guidance", "Honor traditions", "Find a mentor"], imageName: "tarot-hierophant"),
        TarotCard(id: "lovers", name: "The Lovers", keywords: ["Love", "Harmony", "Choices"], interpretation: "Love, harmony, and important choices. Balance your heart and mind in decisions.", guidance: ["Follow your heart", "Seek harmony", "Make conscious choices"], imageName: "tarot-lovers"),
        TarotCard(id: "chariot", name: "The Chariot", keywords: ["Victory", "Willpower", "Control"], interpretation: "Victory, willpower, and determination. Harness opposing forces to move forward.", guidance: ["Stay focused", "Use your willpower", "Overcome obstacles"], imageName: "tarot-chariot"),
        TarotCard(id: "strength", name: "Strength", keywords: ["Courage", "Patience", "Inner strength"], interpretation: "Courage, patience, and inner strength. True power comes from gentleness and self-control.", guidance: ["Be patient", "Show compassion", "Trust your inner strength"], imageName: "tarot-strength"),
        TarotCard(id: "hermit", name: "The Hermit", keywords: ["Introspection", "Guidance", "Solitude"], interpretation: "Introspection, guidance, and inner wisdom. Take time for solitude and reflection.", guidance: ["Seek inner guidance", "Take time alone", "Reflect on your path"], imageName: "tarot-hermit"),
        TarotCard(id: "wheel", name: "Wheel of Fortune", keywords: ["Change", "Cycles", "Destiny"], interpretation: "Change, cycles, and destiny. Life is in constant motion, embrace the turning wheel.", guidance: ["Accept change", "Trust the cycle", "Go with the flow"], imageName: "tarot-wheel"),
        TarotCard(id: "justice", name: "Justice", keywords: ["Balance", "Fairness", "Truth"], interpretation: "Balance, fairness, and truth. Seek justice and make decisions with integrity.", guidance: ["Seek truth", "Make fair decisions", "Take responsibility"], imageName: "tarot-justice"),
        TarotCard(id: "hanged", name: "The Hanged Man", keywords: ["Surrender", "Letting go", "New perspective"], interpretation: "Surrender, letting go, and new perspectives. Sometimes you must pause to see clearly.", guidance: ["Let go of control", "See things differently", "Embrace waiting"], imageName: "tarot-hanged"),
        TarotCard(id: "death", name: "Death", keywords: ["Transformation", "Endings", "Rebirth"], interpretation: "Transformation, endings, and rebirth. Let go of what no longer serves to make room for new growth.", guidance: ["Embrace endings", "Allow transformation", "Release the old"], imageName: "tarot-death"),
        TarotCard(id: "temperance", name: "Temperance", keywords: ["Balance", "Moderation", "Harmony"], interpretation: "Balance, moderation, and harmony. Find the middle path and blend opposites.", guidance: ["Seek balance", "Practice moderation", "Blend opposites"], imageName: "tarot-temperance"),
        TarotCard(id: "devil", name: "The Devil", keywords: ["Bondage", "Materialism", "Shadow"], interpretation: "Bondage, materialism, and shadow aspects. Recognize what holds you back and break free.", guidance: ["Examine attachments", "Face your shadows", "Break free from limitations"], imageName: "tarot-devil"),
        TarotCard(id: "tower", name: "The Tower", keywords: ["Sudden change", "Revelation", "Breakthrough"], interpretation: "Sudden change, revelation, and breakthrough. Sometimes destruction clears the way for truth.", guidance: ["Embrace sudden change", "Let go of false structures", "Welcome revelation"], imageName: "tarot-tower"),
        TarotCard(id: "star", name: "The Star", keywords: ["Hope", "Inspiration", "Healing"], interpretation: "Hope, inspiration, and healing. After darkness comes light and renewed faith.", guidance: ["Have hope", "Find inspiration", "Heal and renew"], imageName: "tarot-star"),
        TarotCard(id: "moon", name: "The Moon", keywords: ["Illusion", "Intuition", "Unconscious"], interpretation: "Illusion, intuition, and the unconscious. Trust your intuition but beware of deception.", guidance: ["Trust your intuition", "Face your fears", "Look beyond illusions"], imageName: "tarot-moon"),
        TarotCard(id: "sun", name: "The Sun", keywords: ["Joy", "Success", "Vitality"], interpretation: "Joy, success, and vitality. Embrace positivity and let your light shine brightly.", guidance: ["Embrace joy", "Celebrate success", "Radiate positivity"], imageName: "tarot-sun"),
        TarotCard(id: "judgement", name: "Judgement", keywords: ["Reflection", "Awakening", "Forgiveness"], interpretation: "Reflection, awakening, and forgiveness. It's time to evaluate your past and rise to a higher calling.", guidance: ["Reflect on your path", "Awaken to new purpose", "Practice forgiveness"], imageName: "tarot-judgement"),
        TarotCard(id: "world", name: "The World", keywords: ["Completion", "Achievement", "Fulfillment"], interpretation: "Completion, achievement, and fulfillment. You've reached a milestone and are ready for new beginnings.", guidance: ["Celebrate completion", "Acknowledge achievement", "Prepare for new cycles"], imageName: "tarot-world")
    ]
    
    // Rituals database
    private let rituals: [Ritual] = [
        Ritual(id: "1", title: "Grounding Breath", description: "A simple breathing practice to center yourself and reconnect with your body.", duration: "3 min", type: "Grounding", intention: "This ritual helps you ground your energy and reconnect with your body after a busy day.", steps: ["Find a quiet space and sit comfortably.", "Take three slow, deep breaths.", "Place your hand over your heart and set your intention.", "Repeat the affirmation silently three times."], affirmation: "I am grounded, centered, and at peace.", benefits: ["Reduces stress and anxiety", "Improves focus", "Regulates nervous system", "Promotes relaxation"]),
        Ritual(id: "2", title: "Morning Intention", description: "Set a meaningful intention for your day with this gentle morning practice.", duration: "5 min", type: "Intention", intention: "This ritual helps you start your day with clarity and purpose.", steps: ["Sit comfortably with your back straight.", "Take three deep breaths, inhaling through your nose and exhaling through your mouth.", "Bring to mind three things you're grateful for today.", "Ask yourself: 'What is one intention I want to set for today?'", "Visualize yourself embodying this intention throughout your day."], affirmation: "I move through my day with intention and grace.", benefits: ["Increases focus and clarity", "Aligns actions with values", "Reduces morning anxiety", "Creates positive momentum"]),
        Ritual(id: "3", title: "Evening Gratitude", description: "End your day with gratitude and reflection.", duration: "4 min", type: "Gratitude", intention: "This ritual helps you reflect on your day and cultivate gratitude.", steps: ["Find a comfortable seated or lying position.", "Close your eyes and take five deep breaths.", "Think of three things from today you're grateful for.", "Allow yourself to feel the warmth of gratitude in your heart.", "Set an intention for restful sleep."], affirmation: "I am grateful for all the blessings in my life.", benefits: ["Boosts mood and happiness", "Shifts perspective positively", "Reduces negative thinking", "Improves sleep quality"])
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
    
    // Get all tarot cards for reading spreads
    func getAllTarotCards() -> [TarotCard] {
        return tarotCards
    }
}

