//
//  IdentityContentGenerator.swift
//  Aroti
//
//  Generates user-friendly content for identity profiles
//

import Foundation

class IdentityContentGenerator {
    static let shared = IdentityContentGenerator()
    
    private init() {}
    
    // MARK: - Astrology Free Summary
    func generateAstrologyFreeSummary(
        sunSign: String,
        moonSign: String,
        risingSign: String,
        dominantElement: Element
    ) -> String {
        let elementDescription = getElementDescription(dominantElement)
        return "Your \(sunSign) Sun, \(moonSign) Moon, and \(risingSign) Rising create a unique cosmic signature. \(elementDescription) You tend to move through the world with a blend of these energies, expressing your identity through your sun sign, processing emotions through your moon sign, and presenting yourself to others through your rising sign."
    }
    
    private func getElementDescription(_ element: Element) -> String {
        switch element {
        case .fire:
            return "Your dominant fire element brings passion, action, and inspiration to your nature."
        case .earth:
            return "Your dominant earth element brings stability, practicality, and groundedness to your nature."
        case .air:
            return "Your dominant air element brings communication, intellect, and social connection to your nature."
        case .water:
            return "Your dominant water element brings emotion, intuition, and depth to your nature."
        }
    }
    
    // MARK: - Numerology Free Summary
    func generateNumerologyFreeSummary(
        lifePath: Int,
        archetype: String
    ) -> String {
        return "Your Life Path \(lifePath) reveals you as \(archetype). This number represents your core journey and the lessons you're here to learn. You tend to express these qualities naturally, though they may evolve as you grow and develop throughout your life."
    }
    
    // MARK: - Elemental Insight
    func generateElementalInsight(
        dominant: [Element],
        deficient: [Element]
    ) -> String {
        let dominantText = dominant.map { $0.rawValue }.joined(separator: " and ")
        let deficientText = deficient.isEmpty ? "none" : deficient.map { $0.rawValue }.joined(separator: " or ")
        
        if deficient.isEmpty {
            return "Your chart shows a strong emphasis on \(dominantText) energy. This creates a balanced elemental foundation that supports your natural expression and life path."
        } else {
            return "Your chart emphasizes \(dominantText) energy, while \(deficientText) elements appear less frequently. This pattern often shows where you naturally excel and where you may seek balance through life experiences."
        }
    }
    
    // MARK: - Life Focus Area Title
    func generateLifeFocusAreaTitle(houseIndex: Int) -> String {
        let houseNames: [Int: String] = [
            1: "Identity & Self",
            2: "Resources & Values",
            3: "Communication & Learning",
            4: "Home & Foundation",
            5: "Creativity & Expression",
            6: "Service & Health",
            7: "Partnerships & Relationships",
            8: "Transformation & Shared Resources",
            9: "Philosophy & Expansion",
            10: "Career & Purpose",
            11: "Community & Vision",
            12: "Spirituality & Completion"
        ]
        
        return houseNames[houseIndex] ?? "Life Area \(houseIndex)"
    }
    
    // MARK: - Familiar Patterns Description
    func generateFamiliarPatternsDescription(sign: String) -> String {
        let patterns: [String: String] = [
            "Aries": "You may naturally fall into patterns of independence and taking action first. These familiar ways of being can feel comfortable but may limit your growth.",
            "Taurus": "You may naturally fall into patterns of seeking security and stability. These familiar ways of being can feel grounding but may resist necessary change.",
            "Gemini": "You may naturally fall into patterns of communication and mental activity. These familiar ways of being can feel engaging but may avoid deeper emotional work.",
            "Cancer": "You may naturally fall into patterns of emotional sensitivity and nurturing. These familiar ways of being can feel safe but may create dependency.",
            "Leo": "You may naturally fall into patterns of seeking recognition and expressing creativity. These familiar ways of being can feel empowering but may rely too much on external validation.",
            "Virgo": "You may naturally fall into patterns of analysis and service. These familiar ways of being can feel useful but may lead to perfectionism.",
            "Libra": "You may naturally fall into patterns of seeking harmony and partnership. These familiar ways of being can feel balanced but may avoid necessary conflict.",
            "Scorpio": "You may naturally fall into patterns of intensity and transformation. These familiar ways of being can feel powerful but may create unnecessary drama.",
            "Sagittarius": "You may naturally fall into patterns of exploration and philosophy. These familiar ways of being can feel freeing but may avoid commitment.",
            "Capricorn": "You may naturally fall into patterns of structure and achievement. These familiar ways of being can feel responsible but may prioritize work over relationships.",
            "Aquarius": "You may naturally fall into patterns of independence and innovation. These familiar ways of being can feel progressive but may detach from emotions.",
            "Pisces": "You may naturally fall into patterns of compassion and spirituality. These familiar ways of being can feel intuitive but may create boundaries issues."
        ]
        
        return patterns[sign] ?? "You have familiar patterns that feel comfortable but may limit your growth potential."
    }
    
    // MARK: - Growth Direction Description
    func generateGrowthDirectionDescription(sign: String) -> String {
        let directions: [String: String] = [
            "Aries": "Your growth comes from learning to collaborate and consider others' perspectives before acting. Balance your independence with partnership.",
            "Taurus": "Your growth comes from embracing change and letting go of what no longer serves you. Balance your need for security with flexibility.",
            "Gemini": "Your growth comes from going deeper and developing emotional depth. Balance your mental activity with feeling and intuition.",
            "Cancer": "Your growth comes from developing independence and emotional boundaries. Balance your nurturing nature with self-care.",
            "Leo": "Your growth comes from finding inner validation and serving others without needing recognition. Balance your self-expression with humility.",
            "Virgo": "Your growth comes from accepting imperfection and trusting the process. Balance your analytical nature with spontaneity.",
            "Libra": "Your growth comes from making independent decisions and embracing necessary conflict. Balance your harmony-seeking with assertiveness.",
            "Scorpio": "Your growth comes from releasing control and trusting the natural flow. Balance your intensity with lightness.",
            "Sagittarius": "Your growth comes from finding depth and commitment in your pursuits. Balance your exploration with focus.",
            "Capricorn": "Your growth comes from prioritizing relationships and emotional connection. Balance your achievement with presence.",
            "Aquarius": "Your growth comes from connecting with your emotions and personal relationships. Balance your independence with intimacy.",
            "Pisces": "Your growth comes from setting boundaries and grounding your spirituality. Balance your compassion with practical action."
        ]
        
        return directions[sign] ?? "Your growth direction involves balancing your natural tendencies with their complementary qualities."
    }
    
    // MARK: - Element Imbalance Signals
    func generateImbalanceSignals(deficient: [Element]) -> [String] {
        var signals: [String] = []
        
        for element in deficient {
            switch element {
            case .fire:
                signals.append("You may struggle with motivation or taking initiative")
            case .earth:
                signals.append("You may feel ungrounded or struggle with practical matters")
            case .air:
                signals.append("You may struggle with communication or feel mentally scattered")
            case .water:
                signals.append("You may struggle with emotional expression or intuition")
            }
        }
        
        return signals.isEmpty ? ["Your elemental balance appears harmonious"] : signals
    }
    
    // MARK: - Supporting Elements
    func generateSupportingElements(dominant: [Element]) -> [ElementRelationship] {
        var relationships: [ElementRelationship] = []
        
        for element in dominant {
            let meaning: String
            switch element {
            case .fire:
                meaning = "Fire supports your passion and drive, helping you take action and inspire others"
            case .earth:
                meaning = "Earth supports your stability and practicality, helping you build lasting foundations"
            case .air:
                meaning = "Air supports your communication and intellect, helping you connect and share ideas"
            case .water:
                meaning = "Water supports your intuition and depth, helping you feel and process emotions"
            }
            
            relationships.append(ElementRelationship(
                id: "supporting-\(element.rawValue)",
                element: element,
                meaning: meaning
            ))
        }
        
        return relationships
    }
    
    // MARK: - Draining Elements
    func generateDrainingElements(deficient: [Element]) -> [ElementRelationship] {
        var relationships: [ElementRelationship] = []
        
        for element in deficient {
            let meaning: String
            switch element {
            case .fire:
                meaning = "You may find fire energy draining when you need to slow down or be patient"
            case .earth:
                meaning = "You may find earth energy draining when you need flexibility or spontaneity"
            case .air:
                meaning = "You may find air energy draining when you need emotional depth or quiet"
            case .water:
                meaning = "You may find water energy draining when you need objectivity or detachment"
            }
            
            relationships.append(ElementRelationship(
                id: "draining-\(element.rawValue)",
                element: element,
                meaning: meaning
            ))
        }
        
        return relationships
    }
    
    // MARK: - Cross-System Influence
    func generateCrossSystemInfluence(
        dominantElement: Element,
        lifePath: Int
    ) -> String {
        let elementInfluence = getElementDescription(dominantElement)
        return "Your dominant \(dominantElement.rawValue) element influences how you express your Life Path \(lifePath) energy. \(elementInfluence) This creates a unique blend of numerological and astrological energies that shapes your approach to life."
    }
    
    // MARK: - Balance Guidance
    func generateBalanceGuidance(
        dominant: [Element],
        deficient: [Element]
    ) -> String {
        if deficient.isEmpty {
            return "Your elemental balance is harmonious. Continue to honor all elements in your life, allowing each to support you as needed."
        }
        
        let deficientText = deficient.map { $0.rawValue.lowercased() }.joined(separator: " and ")
        return "To find greater balance, consider incorporating more \(deficientText) energy into your life. This doesn't mean changing who you are, but rather allowing these qualities to complement your natural strengths."
    }
    
    // MARK: - Core Theme Generation
    
    func generateAstrologyCoreTheme(
        sunSign: String,
        moonSign: String,
        risingSign: String,
        dominantElement: Element
    ) -> String {
        let elementTheme: String
        switch dominantElement {
        case .fire:
            elementTheme = "Your fire-dominant nature brings passion and action to everything you do."
        case .earth:
            elementTheme = "Your earth-dominant nature brings stability and practicality to your approach to life."
        case .air:
            elementTheme = "Your air-dominant nature brings communication and intellectual curiosity to your interactions."
        case .water:
            elementTheme = "Your water-dominant nature brings emotional depth and intuition to your experiences."
        }
        
        return "Together, your \(sunSign) Sun, \(moonSign) Moon, and \(risingSign) Rising create a unique cosmic signature. \(elementTheme) This combination shapes how you express yourself, process emotions, and connect with others."
    }
    
    func generateNumerologyCoreTheme(
        lifePath: Int,
        archetype: String
    ) -> String {
        return "Your Life Path \(lifePath) as \(archetype) represents your core journey and the fundamental lessons you're here to learn. This number reflects your natural tendencies and the path that will bring you the most fulfillment and growth."
    }
    
    func generateMatrixCoreTheme(
        coreDestinyNumber: Int,
        themes: [String]
    ) -> String {
        let themesText = themes.joined(separator: " and ")
        return "Your Core Destiny \(coreDestinyNumber) centers on \(themesText). This number reveals the primary themes and energies that shape your life path and the lessons you're meant to master."
    }
    
    func generateElementalCoreTheme(
        dominant: [Element],
        deficient: [Element]
    ) -> String {
        let dominantText = dominant.map { $0.rawValue }.joined(separator: " and ")
        
        if deficient.isEmpty {
            return "Your elemental profile shows a strong emphasis on \(dominantText) energy, creating a balanced foundation that supports your natural expression and life path."
        } else {
            let deficientText = deficient.map { $0.rawValue }.joined(separator: " and ")
            return "Your elemental profile emphasizes \(dominantText) energy, while \(deficientText) elements appear less frequently. This pattern often shows where you naturally excel and where you may seek balance through life experiences."
        }
    }
}
