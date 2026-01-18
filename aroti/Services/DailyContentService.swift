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
    
    // Affirmation subtitles (stabilizing anchor, not advice)
    private let affirmationSubtitles: [String] = [
        "A grounding focus aligned with today",
        "A stabilizing thought for the day",
        "Mental support tuned to today's context",
        "A calm anchor for today's energy",
        "A centering focus aligned with today",
        "Psychological support for today's patterns",
        "A steadying thought aligned with today",
        "Mental grounding tuned to today",
        "A stabilizing anchor for today",
        "A calm focus aligned with today's context"
    ]
    
    // Reflection prompts database (interpretive, resonance-based)
    private let reflectionPrompts: [String] = [
        "How does this resonate with your day so far?",
        "Where do you notice this most today?",
        "What connection do you feel to today's insights?",
        "How does this align with what you're experiencing?",
        "What feels most present in relation to this?",
        "Where does this show up in your day?",
        "How does this reflect what you're noticing?",
        "What feels aligned with this today?",
        "How does this connect to your experience?",
        "Where do you see this pattern today?",
        "What feels most relevant about this?",
        "How does this relate to your day?",
        "What stands out in connection to this?",
        "How does this match what you're feeling?",
        "What feels true about this for you today?"
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
    
    // Horoscope previews by sign (observational, not directive)
    private let horoscopePreviews: [String: [String]] = [
        "Aries": ["Emotional intensity feels heightened today", "Action-oriented energy is more present", "Impulse plays a stronger role today"],
        "Taurus": ["Stability feels more grounding today", "Practical awareness is heightened", "Sensory perception feels more active"],
        "Gemini": ["Communication patterns become more noticeable", "Mental curiosity feels more active", "Social awareness is heightened today"],
        "Cancer": ["Emotional sensitivity is heightened today", "Intuition plays a stronger role today", "Inner awareness feels more active"],
        "Leo": ["Creative expression feels more natural", "Confidence surfaces more easily", "Self-expression feels more aligned"],
        "Virgo": ["Attention to detail becomes more noticeable", "Analytical thinking feels more active", "Order brings mental clarity today"],
        "Libra": ["Balance feels more accessible today", "Harmony plays a stronger role", "Aesthetic awareness is heightened"],
        "Scorpio": ["Emotional depth feels more present", "Transformation feels more accessible", "Intensity surfaces more easily"],
        "Sagittarius": ["Expansive thinking feels more active", "Optimism plays a stronger role", "Exploration feels more natural"],
        "Capricorn": ["Structure supports clear thinking", "Discipline feels more aligned", "Long-term focus becomes more noticeable"],
        "Aquarius": ["Innovation feels more accessible", "Unique perspective plays a stronger role", "Independence surfaces more easily"],
        "Pisces": ["Intuition plays a stronger role today", "Emotional sensitivity is heightened", "Spiritual awareness feels more active"]
    ]
    
    func getDayOfYear() -> Int {
        let calendar = Calendar.current
        return calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
    
    func generateTarotCard(dayOfYear: Int, userData: UserData) -> TarotCard {
        var index = (dayOfYear + (userData.name.hashValue % 100)) % tarotCards.count
        if index > tarotCards.count - 1 { return tarotCards[0] }
        if index < 0 { index = 0 }
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
            1: "Patterns of leadership become more noticeable",
            2: "Cooperation patterns feel more accessible",
            3: "Creative patterns surface more easily",
            4: "Structure supports clear thinking",
            5: "Change patterns become more noticeable",
            6: "Care patterns feel more aligned",
            7: "Introspection patterns play a stronger role",
            8: "Material patterns become more noticeable",
            9: "Completion patterns feel more accessible"
        ]
        
        return NumerologyInsight(number: number, preview: previews[number] ?? "Patterns become more noticeable today")
    }
    
    func generateRitual(dayOfYear: Int) -> Ritual {
        let index = dayOfYear % rituals.count
        return rituals[index]
    }
    
    func generateAffirmation(dayOfYear: Int) -> String {
        let index = dayOfYear % affirmations.count
        return affirmations[index]
    }
    
    func generateAffirmationSubtitle(dayOfYear: Int) -> String {
        let index = dayOfYear % affirmationSubtitles.count
        return affirmationSubtitles[index]
    }
    
    func generateReflectionPrompt(dayOfYear: Int) -> String {
        let index = dayOfYear % reflectionPrompts.count
        return reflectionPrompts[index]
    }
    
    // MARK: - Interpretation Generators
    
    func generateHoroscopeInterpretation(sign: String, dayOfYear: Int) -> String {
        // Planetary rulers for each sign
        let planetaryInfluences: [String: (planet: String, themes: String)] = [
            "Aries": ("Mars", "action-oriented energy and assertiveness"),
            "Taurus": ("Venus", "values, stability, and sensory awareness"),
            "Gemini": ("Mercury", "communication patterns and mental curiosity"),
            "Cancer": ("Moon", "emotional sensitivity and intuitive awareness"),
            "Leo": ("Sun", "creative expression and confidence"),
            "Virgo": ("Mercury", "analytical thinking and attention to detail"),
            "Libra": ("Venus", "harmony, balance, and aesthetic awareness"),
            "Scorpio": ("Pluto", "emotional depth and transformation"),
            "Sagittarius": ("Jupiter", "expansive thinking and exploration"),
            "Capricorn": ("Saturn", "structure, discipline, and long-term focus"),
            "Aquarius": ("Uranus", "innovation and unique perspective"),
            "Pisces": ("Neptune", "intuitive signals and spiritual awareness")
        ]
        
        let influence = planetaryInfluences[sign] ?? ("Moon", "emotional awareness")
        let variations = [
            "With your \(sign) sign influenced by \(influence.planet)-related themes today, \(influence.themes) tend to come into clearer focus. In astrological frameworks, this influence is associated with greater sensitivity to inner signals, making intuitive impressions easier to notice as the day unfolds.",
            "Today's astrological patterns align with your \(sign) nature, where \(influence.themes) play a stronger role. The \(influence.planet) influence suggests that these tendencies become more noticeable, offering a clearer lens through which to observe your daily experiences.",
            "Your \(sign) profile resonates with today's \(influence.planet)-related energies, where \(influence.themes) surface more easily. This alignment tends to heighten awareness of these patterns, making them more accessible throughout the day."
        ]
        
        let index = (dayOfYear + sign.hashValue) % variations.count
        return variations[index]
    }
    
    func generateNumerologyInterpretation(number: Int, dayOfYear: Int) -> String {
        let patternDescriptions: [Int: String] = [
            1: "leadership patterns and independent thinking",
            2: "cooperation patterns and harmonious connections",
            3: "creative patterns and expressive communication",
            4: "structural patterns and practical foundations",
            5: "change patterns and adaptive thinking",
            6: "care patterns and nurturing connections",
            7: "introspection patterns and analytical depth",
            8: "material patterns and achievement focus",
            9: "completion patterns and wisdom integration"
        ]
        
        let pattern = patternDescriptions[number] ?? "numerological patterns"
        let variations = [
            "Today's date calculation aligns with number \(number), where \(pattern) become more noticeable. In numerological frameworks, this number reflects cognitive and structural tendencies that tend to surface more clearly, offering insight into how mental patterns organize throughout the day.",
            "The number \(number) pattern emerges from today's date, suggesting that \(pattern) play a stronger role. This numerological influence tends to highlight how these cognitive patterns organize thinking and decision-making processes.",
            "Number \(number) patterns align with today's calculation, where \(pattern) feel more accessible. This influence tends to make these structural tendencies more noticeable, providing a lens through which to observe mental organization."
        ]
        
        let index = (dayOfYear + number) % variations.count
        return variations[index]
    }
    
    func generateAffirmationInterpretation(dayOfYear: Int) -> String {
        let variations = [
            "Today's affirmation aligns with patterns that support psychological grounding and mental stability. This statement serves as a stabilizing anchor, tuned to the day's contextual energies, offering a calm focus that helps maintain emotional balance throughout daily experiences.",
            "The affirmation selected for today reflects themes that support inner stability and mental clarity. Positioned as a psychological anchor rather than directive advice, it provides a steadying thought aligned with today's energetic patterns, helping to maintain a sense of centered awareness.",
            "This affirmation resonates with today's calculated profile, offering mental support tuned to the day's context. As a grounding focus, it serves as a calm anchor that helps stabilize emotional patterns and maintain psychological balance throughout daily activities."
        ]
        
        let index = dayOfYear % variations.count
        return variations[index]
    }
    
    func generateTarotInterpretation(card: TarotCard, dayOfYear: Int) -> String {
        let cardThemes = card.keywords.joined(separator: ", ")
        let variations = [
            "Today's card, \(card.name), reflects themes of \(cardThemes) that tend to surface more noticeably. In tarot frameworks, this card represents symbolic patterns that align with daily experiences, offering a lens through which to observe how these themes manifest throughout the day.",
            "The \(card.name) card aligns with today's draw, where \(cardThemes) become more accessible. This symbolic influence suggests that these patterns tend to emerge more clearly, providing insight into how archetypal energies organize daily experiences.",
            "Drawn for today, \(card.name) reflects \(cardThemes) that play a stronger role. This card's symbolic framework tends to highlight how these themes surface in daily patterns, offering a reflective lens through which to observe their manifestation."
        ]
        
        let index = (dayOfYear + card.id.hashValue) % variations.count
        return variations[index]
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

