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
    
    // Affirmations organized by Numerology Number themes
    private let numerologyAffirmations: [Int: [String]] = [
        1: [
            "I trust my ability to lead and create new paths",
            "I embrace my independence and take bold action",
            "I am a natural leader and pioneer",
            "I confidently step into new beginnings",
            "I honor my unique identity and express it authentically"
        ],
        2: [
            "I create harmony in all my relationships",
            "I honor cooperation and partnership",
            "I trust the power of collaboration",
            "I find balance through connection with others",
            "I am patient and diplomatic in all interactions"
        ],
        3: [
            "I express my creativity freely and joyfully",
            "I communicate with clarity and inspiration",
            "I bring joy and creativity to everything I do",
            "I share my gifts with the world",
            "I embrace my natural optimism and enthusiasm"
        ],
        4: [
            "I build solid foundations for my dreams",
            "I create structure that supports my growth",
            "I am practical and reliable in all I do",
            "I organize my life with intention and care",
            "I honor discipline and methodical progress"
        ],
        5: [
            "I embrace change as an opportunity for growth",
            "I am free to explore new experiences",
            "I adapt gracefully to life's changes",
            "I welcome adventure and new possibilities",
            "I trust my ability to navigate transitions"
        ],
        6: [
            "I nurture myself and others with love",
            "I create harmony in my home and relationships",
            "I am responsible and caring in all I do",
            "I find fulfillment through service and care",
            "I honor my need to give and receive love"
        ],
        7: [
            "I trust my inner wisdom and intuition",
            "I seek truth and deeper understanding",
            "I honor my need for reflection and solitude",
            "I connect with my spiritual nature",
            "I am open to receiving spiritual guidance"
        ],
        8: [
            "I manifest abundance and success",
            "I use my power wisely and responsibly",
            "I achieve my goals through focused action",
            "I am capable of creating material abundance",
            "I balance material success with spiritual growth"
        ],
        9: [
            "I complete cycles with grace and wisdom",
            "I serve others with compassion and love",
            "I release what no longer serves me",
            "I embrace endings as new beginnings",
            "I honor my humanitarian nature"
        ],
        11: [
            "I trust my intuitive insights and spiritual guidance",
            "I am a channel for inspiration and illumination",
            "I honor my heightened sensitivity and awareness",
            "I share my spiritual gifts with the world",
            "I embrace my role as an intuitive messenger"
        ],
        22: [
            "I turn my grand visions into practical reality",
            "I build something meaningful and lasting",
            "I combine idealism with practical action",
            "I manifest my dreams on a large scale",
            "I am a master builder of lasting structures"
        ],
        33: [
            "I teach and heal through compassion",
            "I uplift others with my wisdom and love",
            "I serve humanity with my gifts",
            "I am a master teacher and healer",
            "I express universal love through my actions"
        ]
    ]
    
    // Affirmations organized by Horoscope Sign themes
    private let horoscopeAffirmations: [String: [String]] = [
        "Aries": [
            "I take bold action aligned with my truth",
            "I trust my courage and initiative",
            "I lead with confidence and authenticity",
            "I honor my pioneering spirit"
        ],
        "Taurus": [
            "I create stability and security in my life",
            "I honor my values and appreciate beauty",
            "I move at my own steady pace",
            "I find joy in life's simple pleasures"
        ],
        "Gemini": [
            "I communicate clearly and authentically",
            "I embrace learning and new perspectives",
            "I express myself with curiosity and wit",
            "I honor my need for mental stimulation"
        ],
        "Cancer": [
            "I honor my emotions and intuition",
            "I create a safe and nurturing home",
            "I trust my inner wisdom and feelings",
            "I protect my energy with healthy boundaries"
        ],
        "Leo": [
            "I shine my light confidently and authentically",
            "I express my creativity and warmth freely",
            "I am worthy of recognition and appreciation",
            "I share my joy and generosity with others"
        ],
        "Virgo": [
            "I serve others with attention and care",
            "I organize my life with practical wisdom",
            "I improve myself and my surroundings daily",
            "I honor my need for order and efficiency"
        ],
        "Libra": [
            "I create harmony and balance in all areas",
            "I honor beauty and partnership",
            "I make decisions from a place of peace",
            "I seek fairness and justice in all things"
        ],
        "Scorpio": [
            "I embrace transformation and deep truth",
            "I trust my power and intensity",
            "I transform challenges into wisdom",
            "I honor my depth and emotional strength"
        ],
        "Sagittarius": [
            "I explore life with optimism and adventure",
            "I seek truth and expand my horizons",
            "I trust my philosophical nature",
            "I embrace freedom and new experiences"
        ],
        "Capricorn": [
            "I build lasting structures with discipline",
            "I achieve my goals through patience",
            "I honor tradition while creating progress",
            "I trust my ability to manifest long-term success"
        ],
        "Aquarius": [
            "I honor my unique perspective and freedom",
            "I contribute to humanity with innovation",
            "I embrace my independence and originality",
            "I trust my vision for a better future"
        ],
        "Pisces": [
            "I trust my intuition and spiritual connection",
            "I express compassion and creativity",
            "I honor my sensitivity and empathy",
            "I connect with the universal flow of life"
        ]
    ]
    
    // Moon Phase specific affirmations
    private let moonPhaseAffirmations: [MoonPhase: [String]] = [
        .new: [
            "I set clear intentions for new beginnings",
            "I plant seeds for what I want to manifest",
            "I embrace fresh starts with open arms",
            "I trust the cycle of new beginnings"
        ],
        .waxing: [
            "I take action toward my goals",
            "I build momentum and grow steadily",
            "I move forward with confidence",
            "I nurture what I've begun"
        ],
        .full: [
            "I release what no longer serves me",
            "I celebrate my achievements and growth",
            "I honor the completion of cycles",
            "I let go with gratitude and grace"
        ],
        .waning: [
            "I let go with grace and trust",
            "I reflect on lessons learned",
            "I prepare for new beginnings",
            "I honor the wisdom of release"
        ]
    ]
    
    // Fallback affirmations (generic, used when no specific match)
    private let fallbackAffirmations: [String] = [
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
    
    // Horoscope previews by sign (expanded to 12-15 variations per sign for context-aware selection)
    private let horoscopePreviews: [String: [String]] = [
        "Aries": [
            "Emotional intensity feels heightened today",
            "Action-oriented energy is more present",
            "Impulse plays a stronger role today",
            "Your natural assertiveness surfaces more easily",
            "Taking initiative feels more aligned with today's energy",
            "Competitive drive becomes more noticeable",
            "Bold decisions feel more accessible",
            "Physical energy feels more active",
            "Leadership qualities surface more naturally",
            "Spontaneity plays a stronger role",
            "Courage feels more present in your actions",
            "Pioneering spirit becomes more accessible",
            "Direct communication feels more natural",
            "Independence feels more aligned",
            "Your fire energy is more active today"
        ],
        "Taurus": [
            "Stability feels more grounding today",
            "Practical awareness is heightened",
            "Sensory perception feels more active",
            "Material comfort becomes more important",
            "Patience feels more natural",
            "Beauty and aesthetics feel more accessible",
            "Physical sensations become more noticeable",
            "Security needs feel more present",
            "Steady progress feels more aligned",
            "Sensual experiences feel more available",
            "Practical solutions surface more easily",
            "Consistency feels more supportive",
            "Nature connection feels stronger",
            "Value systems become clearer",
            "Your earth energy is more stabilizing today"
        ],
        "Gemini": [
            "Communication patterns become more noticeable",
            "Mental curiosity feels more active",
            "Social awareness is heightened today",
            "Learning opportunities feel more accessible",
            "Conversation feels more natural",
            "Mental agility becomes more present",
            "Information gathering feels more aligned",
            "Social connections feel more important",
            "Adaptability surfaces more easily",
            "Wit and humor feel more accessible",
            "Dual perspectives become clearer",
            "Networking feels more natural",
            "Mental stimulation feels more available",
            "Quick thinking becomes more noticeable",
            "Your air energy is more communicative today"
        ],
        "Cancer": [
            "Emotional sensitivity is heightened today",
            "Intuition plays a stronger role today",
            "Inner awareness feels more active",
            "Nurturing instincts feel more present",
            "Home and family feel more important",
            "Emotional memory becomes more accessible",
            "Protective instincts surface more easily",
            "Compassion feels more natural",
            "Mood sensitivity becomes more noticeable",
            "Caring for others feels more aligned",
            "Emotional depth feels more present",
            "Nostalgia may surface more easily",
            "Intuitive impressions feel stronger",
            "Security through connection feels more important",
            "Your water energy is more emotional today"
        ],
        "Leo": [
            "Creative expression feels more natural",
            "Confidence surfaces more easily",
            "Self-expression feels more aligned",
            "Dramatic flair becomes more noticeable",
            "Generosity feels more present",
            "Leadership through inspiration feels accessible",
            "Playfulness surfaces more easily",
            "Recognition needs feel more important",
            "Creative projects feel more aligned",
            "Warmth and radiance feel more natural",
            "Performance energy becomes more active",
            "Pride in achievements feels stronger",
            "Joyful expression feels more available",
            "Heart-centered actions feel more aligned",
            "Your fire energy is more radiant today"
        ],
        "Virgo": [
            "Attention to detail becomes more noticeable",
            "Analytical thinking feels more active",
            "Order brings mental clarity today",
            "Service to others feels more aligned",
            "Practical problem-solving feels more accessible",
            "Health awareness becomes more present",
            "Organization feels more natural",
            "Perfectionist tendencies may surface",
            "Helpful actions feel more important",
            "Mental precision becomes clearer",
            "Routine feels more supportive",
            "Critique and improvement feel more accessible",
            "Efficiency feels more aligned",
            "Practical skills feel more available",
            "Your earth energy is more analytical today"
        ],
        "Libra": [
            "Balance feels more accessible today",
            "Harmony plays a stronger role",
            "Aesthetic awareness is heightened",
            "Partnership needs feel more present",
            "Diplomacy feels more natural",
            "Beauty and art feel more important",
            "Fairness becomes more noticeable",
            "Social grace feels more accessible",
            "Cooperation feels more aligned",
            "Peaceful solutions surface more easily",
            "Romantic connections feel more available",
            "Artistic expression feels more natural",
            "Compromise feels more important",
            "Elegance becomes more present",
            "Your air energy is more harmonious today"
        ],
        "Scorpio": [
            "Emotional depth feels more present",
            "Transformation feels more accessible",
            "Intensity surfaces more easily",
            "Power dynamics become more noticeable",
            "Psychological insight feels stronger",
            "Intimate connections feel more important",
            "Mystery and depth feel more accessible",
            "Regenerative energy becomes more active",
            "Passion feels more present",
            "Truth-seeking feels more aligned",
            "Hidden motivations become clearer",
            "Emotional intensity feels more natural",
            "Transformation opportunities surface",
            "Deep connections feel more available",
            "Your water energy is more intense today"
        ],
        "Sagittarius": [
            "Expansive thinking feels more active",
            "Optimism plays a stronger role",
            "Exploration feels more natural",
            "Philosophical insights become clearer",
            "Adventure feels more accessible",
            "Learning through experience feels aligned",
            "Freedom needs feel more present",
            "Big picture thinking becomes easier",
            "Travel and expansion feel more important",
            "Enthusiasm surfaces more naturally",
            "Truth-seeking feels more active",
            "Optimistic outlook becomes stronger",
            "Broad perspectives feel more accessible",
            "Spiritual exploration feels aligned",
            "Your fire energy is more expansive today"
        ],
        "Capricorn": [
            "Structure supports clear thinking",
            "Discipline feels more aligned",
            "Long-term focus becomes more noticeable",
            "Ambition feels more present",
            "Responsibility feels more natural",
            "Achievement goals become clearer",
            "Practical planning feels more accessible",
            "Authority feels more aligned",
            "Tradition feels more supportive",
            "Career focus becomes more important",
            "Building structures feels more natural",
            "Patience with goals feels stronger",
            "Maturity feels more present",
            "Strategic thinking becomes easier",
            "Your earth energy is more structured today"
        ],
        "Aquarius": [
            "Innovation feels more accessible",
            "Unique perspective plays a stronger role",
            "Independence surfaces more easily",
            "Humanitarian concerns feel more important",
            "Friendship networks feel more active",
            "Original thinking becomes clearer",
            "Future vision feels more accessible",
            "Unconventional approaches feel aligned",
            "Group connections feel more important",
            "Intellectual freedom feels stronger",
            "Progressive ideas surface more easily",
            "Detached objectivity becomes clearer",
            "Social causes feel more aligned",
            "Inventive solutions feel more accessible",
            "Your air energy is more innovative today"
        ],
        "Pisces": [
            "Intuition plays a stronger role today",
            "Emotional sensitivity is heightened",
            "Spiritual awareness feels more active",
            "Compassion feels more present",
            "Imagination becomes more accessible",
            "Artistic inspiration feels stronger",
            "Empathy surfaces more naturally",
            "Dreams and visions feel more important",
            "Spiritual connection feels aligned",
            "Boundaries may feel more fluid",
            "Creative expression feels more natural",
            "Mystical experiences feel more accessible",
            "Healing energy becomes more present",
            "Universal love feels more aligned",
            "Your water energy is more intuitive today"
        ]
    ]
    
    func getDayOfYear() -> Int {
        let calendar = Calendar.current
        return calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
    
    // MARK: - Astrological Context Helpers
    
    /// Get current season based on date
    func getSeason(for date: Date) -> Season {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        switch month {
        case 3...5:
            return .spring
        case 6...8:
            return .summer
        case 9...11:
            return .autumn
        default:
            return .winter
        }
    }
    
    /// Apply moon phase influence to base horoscope
    private func applyMoonPhaseInfluence(baseHoroscope: String, moonPhase: MoonPhase) -> String {
        let phaseInfluences: [MoonPhase: String] = [
            .new: "With the New Moon energy, ",
            .waxing: "As the Moon waxes, ",
            .full: "Under the Full Moon's influence, ",
            .waning: "As the Moon wanes, "
        ]
        
        if let influence = phaseInfluences[moonPhase] {
            return influence + baseHoroscope.lowercased()
        }
        return baseHoroscope
    }
    
    /// Apply retrograde influence when Mercury is retrograde
    private func applyRetrogradeInfluence(baseHoroscope: String, isRetrograde: Bool) -> String {
        if isRetrograde {
            return baseHoroscope + " During Mercury retrograde, communication and technology may require extra attention."
        }
        return baseHoroscope
    }
    
    /// Select horoscope variation based on multiple factors (deterministic)
    private func selectHoroscopeVariation(
        sunSign: String,
        moonSign: String?,
        dayOfYear: Int,
        moonPhase: MoonPhase,
        isMercuryRetrograde: Bool,
        season: Season,
        previews: [String]
    ) -> Int {
        // Deterministic seeding: same inputs = same output
        // Use a combination of factors to create a unique seed
        var seed = dayOfYear
        seed = seed &* 31 &+ abs(sunSign.hashValue)
        if let moonSign = moonSign {
            seed = seed &* 31 &+ abs(moonSign.hashValue)
        }
        seed = seed &* 31 &+ abs(moonPhase.rawValue.hashValue)
        seed = seed &* 31 &+ (isMercuryRetrograde ? 1000 : 0)
        seed = seed &* 31 &+ season.hashValue * 100
        
        // Ensure positive index
        var index = seed % previews.count
        if index < 0 {
            index = (index + previews.count) % previews.count
        }
        return index
    }
    
    func generateTarotCard(dayOfYear: Int, userData: UserData) -> TarotCard {
        var index = (dayOfYear + (userData.name.hashValue % 100)) % tarotCards.count
        if index > tarotCards.count - 1 { return tarotCards[0] }
        if index < 0 { index = 0 }
        return tarotCards[index]
    }
    
    func generateHoroscope(
        sunSign: String,
        moonSign: String?,
        dayOfYear: Int,
        moonPhase: MoonPhase,
        isMercuryRetrograde: Bool,
        season: Season
    ) -> String {
        let previews = horoscopePreviews[sunSign] ?? ["Your energy today is shifting gently"]
        
        // Select base horoscope using deterministic algorithm
        let index = selectHoroscopeVariation(
            sunSign: sunSign,
            moonSign: moonSign,
            dayOfYear: dayOfYear,
            moonPhase: moonPhase,
            isMercuryRetrograde: isMercuryRetrograde,
            season: season,
            previews: previews
        )
        
        var horoscope = previews[index]
        
        // Apply moon phase influence (subtle, not always applied to avoid repetition)
        // Only apply if it enhances the message naturally
        if dayOfYear % 3 == 0 { // Apply to 1/3 of horoscopes to avoid overuse
            horoscope = applyMoonPhaseInfluence(baseHoroscope: horoscope, moonPhase: moonPhase)
        }
        
        // Apply retrograde influence when active
        if isMercuryRetrograde {
            horoscope = applyRetrogradeInfluence(baseHoroscope: horoscope, isRetrograde: true)
        }
        
        return horoscope
    }
    
    func generateNumerology(birthDate: Date?, dayOfYear: Int) -> NumerologyInsight {
        let currentDate = Date()
        let numerologyService = NumerologyCycleService.shared
        
        // If birth date is available, use Personal Day Number (correct numerology method)
        if let birthDate = birthDate {
            let personalDayNumber = numerologyService.getPersonalDayNumber(
                birthDate: birthDate,
                currentDate: currentDate
            )
            let preview = numerologyService.getPersonalDayDescription(
                birthDate: birthDate,
                currentDate: currentDate
            )
            
            return NumerologyInsight(number: personalDayNumber, preview: preview)
        }
        
        // Fallback: Use universal day number if birth date is not available
        let universalDayNumber = numerologyService.getDayNumber(date: currentDate)
        let previews: [Int: String] = [
            1: "Patterns of leadership become more noticeable",
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
        
        return NumerologyInsight(
            number: universalDayNumber,
            preview: previews[universalDayNumber] ?? "Patterns become more noticeable today"
        )
    }
    
    func generateRitual(dayOfYear: Int) -> Ritual {
        let index = dayOfYear % rituals.count
        return rituals[index]
    }
    
    func generateAffirmation(
        numerologyNumber: Int,
        sunSign: String,
        horoscope: String,
        moonPhase: MoonPhase,
        isMercuryRetrograde: Bool,
        dayOfYear: Int
    ) -> String {
        // Collect all relevant affirmations with weights
        var allOptions: [(String, Int)] = []
        
        // Priority 1: Numerology-based affirmations (highest weight - most personal)
        if let numerologyOptions = numerologyAffirmations[numerologyNumber] {
            for option in numerologyOptions {
                allOptions.append((option, 3)) // Weight: 3
            }
        }
        
        // Priority 2: Horoscope-based affirmations (medium weight)
        if let horoscopeOptions = horoscopeAffirmations[sunSign] {
            for option in horoscopeOptions {
                allOptions.append((option, 2)) // Weight: 2
            }
        }
        
        // Priority 3: Moon phase affirmations (lower weight but still relevant)
        if let moonOptions = moonPhaseAffirmations[moonPhase] {
            for option in moonOptions {
                allOptions.append((option, 1)) // Weight: 1
            }
        }
        
        // If Mercury is retrograde, add communication-focused affirmations
        if isMercuryRetrograde {
            allOptions.append(("I communicate with clarity and patience", 1))
            allOptions.append(("I double-check important details and information", 1))
            allOptions.append(("I trust that delays serve a higher purpose", 1))
        }
        
        // If no specific options found, use fallback
        if allOptions.isEmpty {
            let index = dayOfYear % fallbackAffirmations.count
            return fallbackAffirmations[index]
        }
        
        // Create weighted selection pool (add each option multiple times based on weight)
        var weightedPool: [String] = []
        for (affirmation, weight) in allOptions {
            for _ in 0..<weight {
                weightedPool.append(affirmation)
            }
        }
        
        // Deterministic selection: same inputs = same output
        // Use combination of dayOfYear, numerologyNumber, and sunSign for seed
        var seed = dayOfYear
        seed = seed &* 31 &+ numerologyNumber
        seed = seed &* 31 &+ abs(sunSign.hashValue)
        seed = seed &* 31 &+ abs(moonPhase.rawValue.hashValue)
        seed = seed &* 31 &+ (isMercuryRetrograde ? 1 : 0)
        
        let index = abs(seed) % weightedPool.count
        return weightedPool[index]
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
        
        var index = (dayOfYear + sign.hashValue) % variations.count
        if index < 0 {
            index = (index + variations.count) % variations.count
        }
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
            9: "completion patterns and wisdom integration",
            11: "intuitive patterns and spiritual illumination",
            22: "master building patterns and practical idealism",
            33: "master teaching patterns and compassionate healing"
        ]
        
        let pattern = patternDescriptions[number] ?? "numerological patterns"
        let numberType = (number == 11 || number == 22 || number == 33) ? "master number" : "number"
        
        let variations = [
            "Today's Personal Day \(numberType) \(number) aligns with patterns where \(pattern) become more noticeable. In numerological frameworks, this \(numberType) reflects cognitive and structural tendencies that tend to surface more clearly, offering insight into how mental patterns organize throughout the day.",
            "The Personal Day \(numberType) \(number) pattern emerges today, suggesting that \(pattern) play a stronger role. This numerological influence tends to highlight how these cognitive patterns organize thinking and decision-making processes.",
            "Personal Day \(numberType) \(number) patterns align with today's calculation, where \(pattern) feel more accessible. This influence tends to make these structural tendencies more noticeable, providing a lens through which to observe mental organization."
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
        
        var index = (dayOfYear + card.id.hashValue) % variations.count
        if index < 0 {
            index = (index + variations.count) % variations.count
        }
        return variations[index]
    }
    
    func generateDailyInsight(userData: UserData) -> DailyInsight {
        let dayOfYear = getDayOfYear()
        let currentDate = Date()
        
        // Fetch astrological context
        let cycleService = AstrologicalCycleService.shared
        let moonPhase = cycleService.getCurrentMoonPhase()
        let isMercuryRetrograde = cycleService.isMercuryRetrograde()
        let season = getSeason(for: currentDate)
        
        // Generate insights with context
        let tarotCard = generateTarotCard(dayOfYear: dayOfYear, userData: userData)
        let horoscope = generateHoroscope(
            sunSign: userData.sunSign,
            moonSign: userData.moonSign,
            dayOfYear: dayOfYear,
            moonPhase: moonPhase,
            isMercuryRetrograde: isMercuryRetrograde,
            season: season
        )
        let numerology = generateNumerology(birthDate: userData.birthDate, dayOfYear: dayOfYear)
        let ritual = generateRitual(dayOfYear: dayOfYear)
        let affirmation = generateAffirmation(
            numerologyNumber: numerology.number,
            sunSign: userData.sunSign,
            horoscope: horoscope,
            moonPhase: moonPhase,
            isMercuryRetrograde: isMercuryRetrograde,
            dayOfYear: dayOfYear
        )
        
        return DailyInsight(
            tarotCard: tarotCard,
            horoscope: horoscope,
            numerology: numerology,
            ritual: ritual,
            affirmation: affirmation,
            date: currentDate
        )
    }
    
    // Get all tarot cards for reading spreads
    func getAllTarotCards() -> [TarotCard] {
        return tarotCards
    }
}

