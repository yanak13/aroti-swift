//
//  CoreGuidanceContentGenerator.swift
//  Aroti
//
//  Service for generating personalized Core Guidance content
//  Premium UX Writing System: Distilled, Intentional, Emotional Progression
//

import Foundation

struct GeneratedContent {
    let preview: String
    let fullInsight: String
    let headline: String
    let bodyLines: [String]
    let contextInfo: String?
    let astrologicalContext: String?
    let numerologyContext: String?
    let expandedContent: ExpandedGuidanceContent?
    let timeframeLabel: String // e.g., "Daily Focus", "Monthly Focus"
    let summarySentence: String // TL;DR - one sentence orientation
}

class CoreGuidanceContentGenerator {
    static let shared = CoreGuidanceContentGenerator()
    
    private let astroCycleService = AstrologicalCycleService.shared
    private let numerologyService = NumerologyCycleService.shared
    private let blueprintService = BlueprintService.shared
    
    private init() {}
    
    // MARK: - Main Generation Method
    
    func generateContent(
        cardType: CoreGuidanceCardType,
        userData: UserData
    ) -> GeneratedContent {
        let astroContext = astroCycleService.getCurrentContext()
        let numContext = numerologyService.getCurrentContext(birthDate: userData.birthDate)
        
        switch cardType {
        case .rightNow:
            return generateRightNowContent(userData: userData, astroContext: astroContext, numContext: numContext)
        case .thisPeriod:
            return generateThisPeriodContent(userData: userData, astroContext: astroContext, numContext: numContext)
        case .whereToFocus:
            return generateWhereToFocusContent(userData: userData, astroContext: astroContext, numContext: numContext)
        case .whatsComingUp:
            return generateWhatsComingUpContent(userData: userData, astroContext: astroContext, numContext: numContext)
        case .personalInsight:
            return generatePersonalInsightContent(userData: userData, astroContext: astroContext, numContext: numContext)
        }
    }
    
    // MARK: - Right Now (48-72 hours)
    
    private func generateRightNowContent(
        userData: UserData,
        astroContext: String,
        numContext: String
    ) -> GeneratedContent {
        let moonPhase = astroCycleService.getCurrentMoonPhase()
        let dayNumber = numerologyService.getDayNumber()
        
        let sign = userData.sunSign
        let moonPhaseDesc = moonPhase.rawValue
        
        // Planetary influences
        let planetaryInfluences: [String: (planet: String, themes: String)] = [
            "Aries": ("Mars", "action-oriented energy"),
            "Taurus": ("Venus", "values and stability"),
            "Gemini": ("Mercury", "communication patterns"),
            "Cancer": ("Moon", "emotional sensitivity"),
            "Leo": ("Sun", "creative expression"),
            "Virgo": ("Mercury", "analytical thinking"),
            "Libra": ("Venus", "harmony and balance"),
            "Scorpio": ("Pluto", "emotional depth"),
            "Sagittarius": ("Jupiter", "expansive thinking"),
            "Capricorn": ("Saturn", "structure and discipline"),
            "Aquarius": ("Uranus", "innovation"),
            "Pisces": ("Neptune", "intuitive signals")
        ]
        
        let influence = planetaryInfluences[sign] ?? ("Moon", "emotional awareness")
        
        let headlines = [
            "A Quiet Shift",
            "Present Awareness",
            "Subtle Changes",
            "Current Patterns"
        ]
        
        let headline = headlines[dayNumber % headlines.count]
        
        // Minimal Premium V1 Structure
        // One-line insight (plain language, no astrology terms)
        let oneLineInsight: String
        switch influence.themes {
        case "action-oriented energy":
            oneLineInsight = "Take action on what matters most today."
        case "values and stability":
            oneLineInsight = "Focus on what feels stable and valuable."
        case "communication patterns":
            oneLineInsight = "Notice how you communicate and listen."
        case "emotional sensitivity":
            oneLineInsight = "Pay attention to what you're feeling."
        case "creative expression":
            oneLineInsight = "Express yourself authentically."
        case "analytical thinking":
            oneLineInsight = "Use clear thinking to solve problems."
        case "harmony and balance":
            oneLineInsight = "Find balance in your relationships."
        case "emotional depth":
            oneLineInsight = "Go deeper into what you're experiencing."
        case "expansive thinking":
            oneLineInsight = "Think bigger about your possibilities."
        case "structure and discipline":
            oneLineInsight = "Build structure that supports you."
        case "innovation":
            oneLineInsight = "Try something new or different."
        case "intuitive signals":
            oneLineInsight = "Trust your instincts and inner signals."
        default:
            oneLineInsight = "Pay attention to what surfaces today."
        }
        
        // 3 bullets: Theme, Best use, Watch for
        let insightBullets: [String]
        switch influence.themes {
        case "action-oriented energy":
            insightBullets = [
                "Theme: taking action",
                "Best use: moving forward on one priority",
                "Watch for: rushing without direction"
            ]
        case "values and stability":
            insightBullets = [
                "Theme: what matters most",
                "Best use: grounding yourself in your values",
                "Watch for: avoiding necessary change"
            ]
        case "communication patterns":
            insightBullets = [
                "Theme: how you connect",
                "Best use: clear, honest conversations",
                "Watch for: miscommunication or assumptions"
            ]
        case "emotional sensitivity":
            insightBullets = [
                "Theme: your feelings",
                "Best use: acknowledging what you feel",
                "Watch for: getting overwhelmed by emotions"
            ]
        case "creative expression":
            insightBullets = [
                "Theme: expressing yourself",
                "Best use: sharing your authentic voice",
                "Watch for: holding back or self-censoring"
            ]
        case "analytical thinking":
            insightBullets = [
                "Theme: clear thinking",
                "Best use: solving problems methodically",
                "Watch for: overthinking or analysis paralysis"
            ]
        case "harmony and balance":
            insightBullets = [
                "Theme: relationships and balance",
                "Best use: finding middle ground",
                "Watch for: people-pleasing or avoiding conflict"
            ]
        case "emotional depth":
            insightBullets = [
                "Theme: deeper understanding",
                "Best use: exploring what's beneath the surface",
                "Watch for: getting stuck in intensity"
            ]
        case "expansive thinking":
            insightBullets = [
                "Theme: bigger possibilities",
                "Best use: considering new options",
                "Watch for: losing focus or spreading too thin"
            ]
        case "structure and discipline":
            insightBullets = [
                "Theme: building systems",
                "Best use: creating routines that work",
                "Watch for: rigidity or perfectionism"
            ]
        case "innovation":
            insightBullets = [
                "Theme: trying new approaches",
                "Best use: experimenting with different methods",
                "Watch for: change for its own sake"
            ]
        case "intuitive signals":
            insightBullets = [
                "Theme: inner guidance",
                "Best use: trusting your instincts",
                "Watch for: ignoring practical considerations"
            ]
        default:
            insightBullets = [
                "Theme: awareness",
                "Best use: noticing what's present",
                "Watch for: getting lost in thoughts"
            ]
        }
        
        // Guidance: Do, Try, Avoid (3 items)
        let guidance: [String]
        switch influence.themes {
        case "action-oriented energy":
            guidance = [
                "Do: pick one thing and move forward",
                "Try: breaking a big task into small steps",
                "Avoid: starting multiple things at once"
            ]
        case "values and stability":
            guidance = [
                "Do: identify what truly matters to you",
                "Try: making decisions aligned with your values",
                "Avoid: compromising on what's important"
            ]
        case "communication patterns":
            guidance = [
                "Do: listen before responding",
                "Try: asking clarifying questions",
                "Avoid: making assumptions about others"
            ]
        case "emotional sensitivity":
            guidance = [
                "Do: acknowledge your feelings",
                "Try: naming what you're experiencing",
                "Avoid: suppressing or ignoring emotions"
            ]
        case "creative expression":
            guidance = [
                "Do: share your authentic voice",
                "Try: expressing yourself without self-censoring",
                "Avoid: comparing yourself to others"
            ]
        case "analytical thinking":
            guidance = [
                "Do: break problems into parts",
                "Try: using logic to find solutions",
                "Avoid: overthinking simple decisions"
            ]
        case "harmony and balance":
            guidance = [
                "Do: find middle ground",
                "Try: considering others' perspectives",
                "Avoid: avoiding necessary conflict"
            ]
        case "emotional depth":
            guidance = [
                "Do: explore what's beneath the surface",
                "Try: journaling or reflecting",
                "Avoid: getting stuck in intense feelings"
            ]
        case "expansive thinking":
            guidance = [
                "Do: consider bigger possibilities",
                "Try: brainstorming without limits",
                "Avoid: losing focus on what's actionable"
            ]
        case "structure and discipline":
            guidance = [
                "Do: create routines that work",
                "Try: building one habit at a time",
                "Avoid: rigid systems that don't fit"
            ]
        case "innovation":
            guidance = [
                "Do: try something new",
                "Try: experimenting with different approaches",
                "Avoid: change for its own sake"
            ]
        case "intuitive signals":
            guidance = [
                "Do: trust your instincts",
                "Try: noticing what feels right",
                "Avoid: ignoring practical considerations"
            ]
        default:
            guidance = [
                "Do: pay attention to what's present",
                "Try: noticing without judgment",
                "Avoid: getting lost in thoughts"
            ]
        }
        
        // Reflection questions (max 3, concrete)
        let reflectionQuestions: [String]
        switch influence.themes {
        case "action-oriented energy":
            reflectionQuestions = [
                "What one thing needs action today?",
                "What would moving forward look like?",
                "What's stopping you from starting?"
            ]
        case "values and stability":
            reflectionQuestions = [
                "What values matter most to you right now?",
                "What decisions align with those values?",
                "Where are you compromising too much?"
            ]
        case "communication patterns":
            reflectionQuestions = [
                "How do you communicate best?",
                "What conversations need to happen?",
                "Where are you making assumptions?"
            ]
        case "emotional sensitivity":
            reflectionQuestions = [
                "What are you feeling right now?",
                "What do those feelings tell you?",
                "What do you need to acknowledge?"
            ]
        case "creative expression":
            reflectionQuestions = [
                "How do you want to express yourself?",
                "What are you holding back?",
                "What would sharing authentically look like?"
            ]
        case "analytical thinking":
            reflectionQuestions = [
                "What problem needs solving?",
                "What information do you need?",
                "What's the simplest solution?"
            ]
        case "harmony and balance":
            reflectionQuestions = [
                "Where do you need balance?",
                "What relationships need attention?",
                "What conflict are you avoiding?"
            ]
        case "emotional depth":
            reflectionQuestions = [
                "What's beneath the surface?",
                "What do you need to explore?",
                "What are you avoiding feeling?"
            ]
        case "expansive thinking":
            reflectionQuestions = [
                "What bigger possibilities exist?",
                "What are you limiting yourself to?",
                "What would thinking bigger look like?"
            ]
        case "structure and discipline":
            reflectionQuestions = [
                "What structure do you need?",
                "What routine would help?",
                "What's too rigid or too loose?"
            ]
        case "innovation":
            reflectionQuestions = [
                "What needs a new approach?",
                "What are you doing out of habit?",
                "What would trying differently look like?"
            ]
        case "intuitive signals":
            reflectionQuestions = [
                "What do your instincts tell you?",
                "What feels right but doesn't make sense?",
                "What are you ignoring that you know?"
            ]
        default:
            reflectionQuestions = [
                "What needs your attention today?",
                "What are you noticing?",
                "What wants to surface?"
            ]
        }
        
        let preview = oneLineInsight
        let bodyLines = [oneLineInsight]
        let fullInsight = oneLineInsight
        let contextInfo = "\(moonPhaseDesc) · Day Number \(dayNumber)"
        let summarySentence = oneLineInsight
        
        return GeneratedContent(
            preview: preview,
            fullInsight: fullInsight,
            headline: headline,
            bodyLines: bodyLines,
            contextInfo: contextInfo,
            astrologicalContext: astroContext,
            numerologyContext: numContext,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: reflectionQuestions,
                contextSection: contextInfo,
                deeperInsight: nil,
                practicalReflection: reflectionQuestions
            ),
            timeframeLabel: "Daily Focus",
            summarySentence: summarySentence
        )
    }
    
    // MARK: - This Period (Weekly)
    
    private func generateThisPeriodContent(
        userData: UserData,
        astroContext: String,
        numContext: String
    ) -> GeneratedContent {
        let sign = userData.sunSign
        let _ = userData.moonSign ?? sign
        
        let isMercuryRetro = astroCycleService.isMercuryRetrograde()
        let personalMonth = userData.birthDate != nil ? numerologyService.getPersonalMonthNumber(birthDate: userData.birthDate!) : 5
        
        let planetaryInfluences: [String: (planet: String, themes: String)] = [
            "Aries": ("Mars", "action and assertiveness"),
            "Taurus": ("Venus", "values and relationships"),
            "Gemini": ("Mercury", "communication and curiosity"),
            "Cancer": ("Moon", "emotional sensitivity"),
            "Leo": ("Sun", "creative expression"),
            "Virgo": ("Mercury", "analytical thinking"),
            "Libra": ("Venus", "harmony and partnership"),
            "Scorpio": ("Pluto", "transformation"),
            "Sagittarius": ("Jupiter", "expansion and exploration"),
            "Capricorn": ("Saturn", "structure and discipline"),
            "Aquarius": ("Uranus", "innovation and independence"),
            "Pisces": ("Neptune", "intuition and spiritual awareness")
        ]
        
        let influence = planetaryInfluences[sign] ?? ("Moon", "emotional awareness")
        
        let headlines = [
            "Re-Evaluating Priorities",
            "Shifting Focus",
            "Current Patterns",
            "Present Awareness"
        ]
        
        let headline = headlines[personalMonth % headlines.count]
        
        // Minimal Premium V1 Structure
        // One-line insight (plain language, no astrology terms)
        let oneLineInsight: String
        if isMercuryRetro {
            oneLineInsight = "Slow down and reflect on how you communicate."
        } else {
            switch influence.themes {
            case "action and assertiveness":
                oneLineInsight = "Take action on what matters this week."
            case "values and relationships":
                oneLineInsight = "Focus on relationships that matter."
            case "communication and curiosity":
                oneLineInsight = "Communicate clearly and stay curious."
            case "emotional sensitivity":
                oneLineInsight = "Pay attention to your feelings this week."
            case "creative expression":
                oneLineInsight = "Express yourself authentically."
            case "analytical thinking":
                oneLineInsight = "Use clear thinking to solve problems."
            case "harmony and partnership":
                oneLineInsight = "Find balance in your partnerships."
            case "transformation":
                oneLineInsight = "Notice what's changing."
            case "expansion and exploration":
                oneLineInsight = "Think bigger about your possibilities."
            case "structure and discipline":
                oneLineInsight = "Build structure that supports you."
            case "innovation and independence":
                oneLineInsight = "Try something new or different."
            case "intuition and spiritual awareness":
                oneLineInsight = "Trust your instincts and inner signals."
            default:
                oneLineInsight = "Pay attention to what surfaces this week."
            }
        }
        
        // 3 bullets: Theme, Best use, Watch for
        let insightBullets: [String]
        if isMercuryRetro {
            insightBullets = [
                "Theme: communication and reflection",
                "Best use: reviewing past conversations",
                "Watch for: miscommunication or assumptions"
            ]
        } else {
            switch influence.themes {
            case "action and assertiveness":
                insightBullets = [
                    "Theme: taking action",
                    "Best use: moving forward on priorities",
                    "Watch for: rushing without direction"
                ]
            case "values and relationships":
                insightBullets = [
                    "Theme: what matters most",
                    "Best use: investing in important relationships",
                    "Watch for: neglecting your own needs"
                ]
            case "communication and curiosity":
                insightBullets = [
                    "Theme: how you connect",
                    "Best use: clear, honest conversations",
                    "Watch for: assumptions or miscommunication"
                ]
            case "emotional sensitivity":
                insightBullets = [
                    "Theme: your feelings",
                    "Best use: acknowledging what you feel",
                    "Watch for: getting overwhelmed"
                ]
            case "creative expression":
                insightBullets = [
                    "Theme: expressing yourself",
                    "Best use: sharing your authentic voice",
                    "Watch for: holding back or self-censoring"
                ]
            case "analytical thinking":
                insightBullets = [
                    "Theme: clear thinking",
                    "Best use: solving problems methodically",
                    "Watch for: overthinking"
                ]
            case "harmony and partnership":
                insightBullets = [
                    "Theme: relationships and balance",
                    "Best use: finding middle ground",
                    "Watch for: avoiding necessary conflict"
                ]
            case "transformation":
                insightBullets = [
                    "Theme: change",
                    "Best use: noticing what's shifting",
                    "Watch for: resisting necessary change"
                ]
            case "expansion and exploration":
                insightBullets = [
                    "Theme: bigger possibilities",
                    "Best use: considering new options",
                    "Watch for: losing focus"
                ]
            case "structure and discipline":
                insightBullets = [
                    "Theme: building systems",
                    "Best use: creating routines that work",
                    "Watch for: rigidity"
                ]
            case "innovation and independence":
                insightBullets = [
                    "Theme: trying new approaches",
                    "Best use: experimenting with different methods",
                    "Watch for: change for its own sake"
                ]
            case "intuition and spiritual awareness":
                insightBullets = [
                    "Theme: inner guidance",
                    "Best use: trusting your instincts",
                    "Watch for: ignoring practical considerations"
                ]
            default:
                insightBullets = [
                    "Theme: awareness",
                    "Best use: noticing what's present",
                    "Watch for: getting lost in thoughts"
                ]
            }
        }
        
        // Guidance: Do, Try, Avoid (3 items)
        let guidance: [String]
        if isMercuryRetro {
            guidance = [
                "Do: review recent conversations",
                "Try: clarifying misunderstandings",
                "Avoid: making assumptions"
            ]
        } else {
            switch influence.themes {
            case "action and assertiveness":
                guidance = [
                    "Do: pick one priority and move forward",
                    "Try: breaking big tasks into steps",
                    "Avoid: starting multiple things at once"
                ]
            case "values and relationships":
                guidance = [
                    "Do: invest in important relationships",
                    "Try: making decisions aligned with values",
                    "Avoid: neglecting your own needs"
                ]
            case "communication and curiosity":
                guidance = [
                    "Do: listen before responding",
                    "Try: asking clarifying questions",
                    "Avoid: making assumptions"
                ]
            case "emotional sensitivity":
                guidance = [
                    "Do: acknowledge your feelings",
                    "Try: naming what you're experiencing",
                    "Avoid: suppressing emotions"
                ]
            case "creative expression":
                guidance = [
                    "Do: share your authentic voice",
                    "Try: expressing without self-censoring",
                    "Avoid: comparing yourself to others"
                ]
            case "analytical thinking":
                guidance = [
                    "Do: break problems into parts",
                    "Try: using logic to find solutions",
                    "Avoid: overthinking simple decisions"
                ]
            case "harmony and partnership":
                guidance = [
                    "Do: find middle ground",
                    "Try: considering others' perspectives",
                    "Avoid: avoiding necessary conflict"
                ]
            case "transformation":
                guidance = [
                    "Do: notice what's changing",
                    "Try: accepting necessary shifts",
                    "Avoid: resisting change"
                ]
            case "expansion and exploration":
                guidance = [
                    "Do: consider bigger possibilities",
                    "Try: brainstorming without limits",
                    "Avoid: losing focus"
                ]
            case "structure and discipline":
                guidance = [
                    "Do: create routines that work",
                    "Try: building one habit at a time",
                    "Avoid: rigid systems"
                ]
            case "innovation and independence":
                guidance = [
                    "Do: try something new",
                    "Try: experimenting with approaches",
                    "Avoid: change for its own sake"
                ]
            case "intuition and spiritual awareness":
                guidance = [
                    "Do: trust your instincts",
                    "Try: noticing what feels right",
                    "Avoid: ignoring practical considerations"
                ]
            default:
                guidance = [
                    "Do: pay attention to what's present",
                    "Try: noticing without judgment",
                    "Avoid: getting lost in thoughts"
                ]
            }
        }
        
        // Reflection questions (max 3, concrete)
        let reflectionQuestions: [String]
        if isMercuryRetro {
            reflectionQuestions = [
                "What conversations need clarification?",
                "What assumptions are you making?",
                "What needs to be said differently?"
            ]
        } else {
            reflectionQuestions = [
                "What needs your attention this week?",
                "What would progress look like?",
                "What are you avoiding?"
            ]
        }
        
        let preview = oneLineInsight
        let bodyLines = [oneLineInsight]
        let fullInsight = oneLineInsight
        let contextInfo = isMercuryRetro ? "Mercury retrograde" : "Personal Month \(personalMonth)"
        let summarySentence = oneLineInsight
        
        return GeneratedContent(
            preview: preview,
            fullInsight: fullInsight,
            headline: headline,
            bodyLines: bodyLines,
            contextInfo: contextInfo,
            astrologicalContext: astroContext,
            numerologyContext: numContext,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: reflectionQuestions,
                contextSection: contextInfo,
                deeperInsight: nil,
                practicalReflection: reflectionQuestions
            ),
            timeframeLabel: "Weekly Focus",
            summarySentence: summarySentence
        )
    }
    
    // MARK: - Where to Focus (Monthly)
    
    private func generateWhereToFocusContent(
        userData: UserData,
        astroContext: String,
        numContext: String
    ) -> GeneratedContent {
        let _ = userData.sunSign
        guard let birthDate = userData.birthDate else {
            return generateDefaultFocusContent(userData: userData, astroContext: astroContext, numContext: numContext)
        }
        
        let personalYear = numerologyService.getPersonalYearNumber(birthDate: birthDate)
        let personalMonth = numerologyService.getPersonalMonthNumber(birthDate: birthDate)
        let saturnInfo = astroCycleService.getSaturnTransitInfo(userBirthDate: birthDate)
        
        let _ = getLifePathNumber(userData: userData)
        
        let headlines = [
            "Honest Conversations",
            "Building Foundations",
            "Structured Growth",
            "Focused Direction"
        ]
        
        let headline = headlines[personalMonth % headlines.count]
        
        // Minimal Premium V1 Structure
        // One-line insight (plain language, no astrology terms)
        let oneLineInsight: String
        if saturnInfo.isInSaturnReturn {
            oneLineInsight = "Focus on steady progress rather than rushing forward."
        } else {
            switch personalMonth {
            case 1, 4, 7:
                oneLineInsight = "Build the structure that will support you long-term."
            case 2, 5, 8:
                oneLineInsight = "Create systems that make your life easier."
            case 3, 6, 9:
                oneLineInsight = "Focus on one area that needs more organization."
            default:
                oneLineInsight = "Build the structure that will support you long-term."
            }
        }
        
        // 3 bullets: Theme, Best use, Watch for
        let insightBullets: [String]
        if saturnInfo.isInSaturnReturn {
            insightBullets = [
                "Theme: responsibility and routine",
                "Best use: steady progress on one priority",
                "Watch for: rushing or overcommitting"
            ]
        } else {
            insightBullets = [
                "Theme: building foundations",
                "Best use: creating systems that last",
                "Watch for: perfectionism or rigidity"
            ]
        }
        
        // Guidance: Do, Try, Avoid (3 items)
        let guidance: [String]
        if saturnInfo.isInSaturnReturn {
            guidance = [
                "Do: simplify your plan",
                "Try: one daily commitment you can keep",
                "Avoid: adding new pressure"
            ]
        } else {
            guidance = [
                "Do: focus on one area that needs structure",
                "Try: building routines gradually",
                "Avoid: trying to fix everything at once"
            ]
        }
        
        // Reflection questions (max 3, concrete)
        let reflectionQuestions: [String]
        if saturnInfo.isInSaturnReturn {
            reflectionQuestions = [
                "What area needs structure most this month?",
                "What would steady progress look like for you?",
                "What can move slower without breaking?"
            ]
        } else {
            reflectionQuestions = [
                "What structure do you need most?",
                "What would building gradually look like?",
                "What's too rigid or too loose?"
            ]
        }
        
        let preview = oneLineInsight
        let bodyLines = [oneLineInsight]
        let fullInsight = oneLineInsight
        let contextInfo = saturnInfo.isInSaturnReturn ? "Saturn Return · Personal Year \(personalYear)" : "Personal Year \(personalYear) · Personal Month \(personalMonth)"
        let summarySentence = oneLineInsight
        
        return GeneratedContent(
            preview: preview,
            fullInsight: fullInsight,
            headline: headline,
            bodyLines: bodyLines,
            contextInfo: contextInfo,
            astrologicalContext: astroContext,
            numerologyContext: numContext,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: reflectionQuestions,
                contextSection: contextInfo,
                deeperInsight: nil,
                practicalReflection: reflectionQuestions
            ),
            timeframeLabel: "Monthly Focus",
            summarySentence: summarySentence
        )
    }
    
    // MARK: - What's Coming Up (1-2 months)
    
    private func generateWhatsComingUpContent(
        userData: UserData,
        astroContext: String,
        numContext: String
    ) -> GeneratedContent {
        let _ = userData.sunSign
        let _ = userData.moonSign ?? userData.sunSign
        
        let upcomingTransits = astroCycleService.getUpcomingTransits(monthsAhead: 2)
        let nextMercuryRetro = astroCycleService.getNextMercuryRetrograde()
        
        let headlines = [
            "An Emotional Window",
            "Upcoming Shifts",
            "Approaching Changes",
            "Coming Patterns"
        ]
        
        let headline = headlines[(upcomingTransits.count) % headlines.count]
        
        // Minimal Premium V1 Structure
        // One-line insight (plain language, no astrology terms)
        let oneLineInsight: String
        let contextInfo: String
        
        if nextMercuryRetro != nil {
            oneLineInsight = "Prepare for shifts in how you communicate."
            contextInfo = "Mercury retrograde approaching"
        } else {
            oneLineInsight = "Notice patterns that are shifting."
            contextInfo = "Upcoming transits"
        }
        
        // 3 bullets: Theme, Best use, Watch for
        let insightBullets: [String]
        if nextMercuryRetro != nil {
            insightBullets = [
                "Theme: communication and reflection",
                "Best use: reviewing and clarifying",
                "Watch for: miscommunication or assumptions"
            ]
        } else {
            insightBullets = [
                "Theme: upcoming changes",
                "Best use: preparing for shifts",
                "Watch for: resisting necessary change"
            ]
        }
        
        // Guidance: Do, Try, Avoid (3 items)
        let guidance: [String]
        if nextMercuryRetro != nil {
            guidance = [
                "Do: review recent conversations",
                "Try: clarifying misunderstandings",
                "Avoid: making assumptions"
            ]
        } else {
            guidance = [
                "Do: notice what's shifting",
                "Try: preparing for changes",
                "Avoid: resisting necessary shifts"
            ]
        }
        
        // Reflection questions (max 3, concrete)
        let reflectionQuestions: [String]
        if nextMercuryRetro != nil {
            reflectionQuestions = [
                "What communication patterns need attention?",
                "What needs to be clarified?",
                "How can you prepare for shifts?"
            ]
        } else {
            reflectionQuestions = [
                "What patterns are changing?",
                "What shifts are coming?",
                "How can you prepare?"
            ]
        }
        
        let preview = oneLineInsight
        let bodyLines = [oneLineInsight]
        let fullInsight = oneLineInsight
        let summarySentence = oneLineInsight
        
        return GeneratedContent(
            preview: preview,
            fullInsight: fullInsight,
            headline: headline,
            bodyLines: bodyLines,
            contextInfo: contextInfo,
            astrologicalContext: astroContext,
            numerologyContext: numContext,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: reflectionQuestions,
                contextSection: contextInfo,
                deeperInsight: nil,
                practicalReflection: reflectionQuestions
            ),
            timeframeLabel: "Upcoming",
            summarySentence: summarySentence
        )
    }
    
    // MARK: - Personal Insight (Monthly/Quarterly)
    
    private func generatePersonalInsightContent(
        userData: UserData,
        astroContext: String,
        numContext: String
    ) -> GeneratedContent {
        let _ = userData.sunSign
        guard let birthDate = userData.birthDate else {
            return generateDefaultPersonalContent(userData: userData, astroContext: astroContext, numContext: numContext)
        }
        
        let personalYear = numerologyService.getPersonalYearNumber(birthDate: birthDate)
        let personalYearDesc = numerologyService.getPersonalYearDescription(birthDate: birthDate)
        let lifePath = getLifePathNumber(userData: userData)
        
        let headlines = [
            "Certainty Before Action",
            "Your Personal Pattern",
            "Inner Guidance",
            "Personal Insight"
        ]
        
        let headline = headlines[personalYear % headlines.count]
        
        // Minimal Premium V1 Structure
        // One-line insight (plain language, no astrology terms)
        let oneLineInsight: String
        switch personalYearDesc.lowercased() {
        case "new beginnings":
            oneLineInsight = "This is a time for starting fresh and setting intentions."
        case "partnership":
            oneLineInsight = "Focus on relationships and collaboration this cycle."
        case "creativity":
            oneLineInsight = "Express yourself authentically and share your voice."
        case "stability":
            oneLineInsight = "Build foundations and create structure that lasts."
        case "change":
            oneLineInsight = "Notice what's shifting and embrace necessary changes."
        case "love":
            oneLineInsight = "Deepen connections while maintaining healthy boundaries."
        case "spirituality":
            oneLineInsight = "Explore deeper meaning while staying grounded."
        case "achievement":
            oneLineInsight = "Focus on goals and make steady progress forward."
        case "completion":
            oneLineInsight = "Finish what you started and let go of what's done."
        default:
            oneLineInsight = "Notice patterns in your personal growth cycle."
        }
        
        // 3 bullets: Theme, Best use, Watch for
        let insightBullets: [String]
        switch personalYearDesc.lowercased() {
        case "new beginnings":
            insightBullets = [
                "Theme: starting fresh",
                "Best use: setting new intentions",
                "Watch for: rushing into things"
            ]
        case "partnership":
            insightBullets = [
                "Theme: relationships and collaboration",
                "Best use: building connections",
                "Watch for: losing yourself in others"
            ]
        case "creativity":
            insightBullets = [
                "Theme: self-expression",
                "Best use: sharing your voice",
                "Watch for: holding back"
            ]
        case "stability":
            insightBullets = [
                "Theme: building foundations",
                "Best use: creating structure",
                "Watch for: rigidity"
            ]
        case "change":
            insightBullets = [
                "Theme: transformation",
                "Best use: embracing shifts",
                "Watch for: resisting change"
            ]
        case "love":
            insightBullets = [
                "Theme: relationships and connection",
                "Best use: deepening bonds",
                "Watch for: losing boundaries"
            ]
        case "spirituality":
            insightBullets = [
                "Theme: inner growth",
                "Best use: exploring deeper meaning",
                "Watch for: avoiding practical matters"
            ]
        case "achievement":
            insightBullets = [
                "Theme: reaching goals",
                "Best use: focused effort",
                "Watch for: burnout"
            ]
        case "completion":
            insightBullets = [
                "Theme: finishing cycles",
                "Best use: completing what you started",
                "Watch for: avoiding endings"
            ]
        default:
            insightBullets = [
                "Theme: personal growth",
                "Best use: noticing patterns",
                "Watch for: ignoring what surfaces"
            ]
        }
        
        // Guidance: Do, Try, Avoid (3 items)
        let guidance: [String]
        switch personalYearDesc.lowercased() {
        case "new beginnings":
            guidance = [
                "Do: set clear intentions",
                "Try: starting one new thing",
                "Avoid: rushing into everything"
            ]
        case "partnership":
            guidance = [
                "Do: invest in relationships",
                "Try: collaborating with others",
                "Avoid: losing your own voice"
            ]
        case "creativity":
            guidance = [
                "Do: express yourself",
                "Try: sharing your work",
                "Avoid: self-censoring"
            ]
        case "stability":
            guidance = [
                "Do: build structure",
                "Try: creating routines",
                "Avoid: rigidity"
            ]
        case "change":
            guidance = [
                "Do: embrace shifts",
                "Try: accepting change",
                "Avoid: resisting"
            ]
        case "love":
            guidance = [
                "Do: deepen connections",
                "Try: being vulnerable",
                "Avoid: losing boundaries"
            ]
        case "spirituality":
            guidance = [
                "Do: explore deeper meaning",
                "Try: reflecting on purpose",
                "Avoid: avoiding practical matters"
            ]
        case "achievement":
            guidance = [
                "Do: focus on goals",
                "Try: making steady progress",
                "Avoid: burnout"
            ]
        case "completion":
            guidance = [
                "Do: finish what you started",
                "Try: letting go of what's done",
                "Avoid: avoiding endings"
            ]
        default:
            guidance = [
                "Do: notice patterns",
                "Try: reflecting on growth",
                "Avoid: ignoring what surfaces"
            ]
        }
        
        // Reflection questions (max 3, concrete)
        let reflectionQuestions: [String]
        switch personalYearDesc.lowercased() {
        case "new beginnings":
            reflectionQuestions = [
                "What do you want to start?",
                "What intentions matter most?",
                "What would beginning look like?"
            ]
        case "partnership":
            reflectionQuestions = [
                "What relationships need attention?",
                "How can you collaborate better?",
                "Where are you losing yourself?"
            ]
        case "creativity":
            reflectionQuestions = [
                "How do you want to express yourself?",
                "What are you holding back?",
                "What would sharing look like?"
            ]
        case "stability":
            reflectionQuestions = [
                "What structure do you need?",
                "What routines would help?",
                "What's too rigid?"
            ]
        case "change":
            reflectionQuestions = [
                "What's shifting?",
                "What change is needed?",
                "What are you resisting?"
            ]
        case "love":
            reflectionQuestions = [
                "What relationships need attention?",
                "How can you deepen connections?",
                "Where are boundaries needed?"
            ]
        case "spirituality":
            reflectionQuestions = [
                "What deeper meaning calls you?",
                "What purpose matters?",
                "What practical matters need attention?"
            ]
        case "achievement":
            reflectionQuestions = [
                "What goals matter most?",
                "What progress can you make?",
                "How can you avoid burnout?"
            ]
        case "completion":
            reflectionQuestions = [
                "What needs to be finished?",
                "What can you let go of?",
                "What endings are you avoiding?"
            ]
        default:
            reflectionQuestions = [
                "What patterns do you notice?",
                "What growth is happening?",
                "What needs attention?"
            ]
        }
        
        let preview = oneLineInsight
        let bodyLines = [oneLineInsight]
        let fullInsight = oneLineInsight
        let contextInfo = "Personal Year \(personalYear) · Life Path \(lifePath)"
        let summarySentence = oneLineInsight
        
        return GeneratedContent(
            preview: preview,
            fullInsight: fullInsight,
            headline: headline,
            bodyLines: bodyLines,
            contextInfo: contextInfo,
            astrologicalContext: astroContext,
            numerologyContext: numContext,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: reflectionQuestions,
                contextSection: contextInfo,
                deeperInsight: nil,
                practicalReflection: reflectionQuestions
            ),
            timeframeLabel: "Personal Cycle",
            summarySentence: summarySentence
        )
    }
    
    // MARK: - Helper Methods
    
    private func getLifePathNumber(userData: UserData) -> Int {
        let blueprint = blueprintService.calculateBlueprint(from: userData)
        return blueprint?.numerology.lifePath.number ?? 5
    }
    
    private func generateDefaultFocusContent(
        userData: UserData,
        astroContext: String,
        numContext: String
    ) -> GeneratedContent {
        let _ = userData.sunSign
        let oneLineInsight = "Build the structure that will support you long-term."
        let insightBullets = [
            "Theme: building foundations",
            "Best use: creating systems that last",
            "Watch for: perfectionism or rigidity"
        ]
        let guidance = [
            "Do: focus on one area that needs structure",
            "Try: building routines gradually",
            "Avoid: trying to fix everything at once"
        ]
        let reflectionQuestions = [
            "What structure do you need most?",
            "What would building gradually look like?",
            "What's too rigid or too loose?"
        ]
        
        return GeneratedContent(
            preview: oneLineInsight,
            fullInsight: oneLineInsight,
            headline: "Honest Conversations",
            bodyLines: [oneLineInsight],
            contextInfo: nil,
            astrologicalContext: astroContext,
            numerologyContext: numContext,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: reflectionQuestions,
                contextSection: nil,
                deeperInsight: nil,
                practicalReflection: reflectionQuestions
            ),
            timeframeLabel: "Monthly Focus",
            summarySentence: oneLineInsight
        )
    }
    
    private func generateDefaultPersonalContent(
        userData: UserData,
        astroContext: String,
        numContext: String
    ) -> GeneratedContent {
        let _ = userData.sunSign
        let oneLineInsight = "Notice patterns in how you process experiences."
        let insightBullets = [
            "Theme: personal growth",
            "Best use: noticing patterns",
            "Watch for: ignoring what surfaces"
        ]
        let guidance = [
            "Do: notice patterns",
            "Try: reflecting on growth",
            "Avoid: ignoring what surfaces"
        ]
        let reflectionQuestions = [
            "What patterns do you notice?",
            "What growth is happening?",
            "What needs attention?"
        ]
        
        return GeneratedContent(
            preview: oneLineInsight,
            fullInsight: oneLineInsight,
            headline: "Personal Insight",
            bodyLines: [oneLineInsight],
            contextInfo: nil,
            astrologicalContext: astroContext,
            numerologyContext: numContext,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: reflectionQuestions,
                contextSection: nil,
                deeperInsight: nil,
                practicalReflection: reflectionQuestions
            ),
            timeframeLabel: "Personal Cycle",
            summarySentence: oneLineInsight
        )
    }
}
