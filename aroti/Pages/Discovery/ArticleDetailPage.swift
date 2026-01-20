//
//  ArticleDetailPage.swift
//  Aroti
//
//  Article detail page matching React implementation
//

import SwiftUI
import Foundation

// Helper function to create justified text using AttributedString
func createJustifiedText(_ text: String) -> AttributedString {
    var attributedString = AttributedString(text)
    
    // Create Swift AttributedString paragraph style with justified alignment
    var paragraphStyle = ParagraphStyle()
    paragraphStyle.alignment = .justified
    paragraphStyle.lineSpacing = 4
    
    // Apply paragraph style to the entire string
    let range = attributedString.startIndex..<attributedString.endIndex
    attributedString[range].paragraphStyle = paragraphStyle
    
    return attributedString
}

enum ArticleDifficulty: String, Codable {
    case beginner
    case intermediate
    case advanced
    
    var displayName: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
}

struct Article: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let tag: String
    let category: String
    let content: String
    let author: String?
    let relatedArticles: [String]
    
    // Learning Hub fields
    let difficulty: ArticleDifficulty?
    
    // New fields for learning page structure
    let oneLineDescription: String?
    let positions: [SpreadPosition]?
    let whenToUse: [String]?
    let metaInfo: String?
    
    // Fields for Basics pages (educational entry points)
    let definition: String? // What is this? (1-2 lines max)
    let whatItIncludes: [String]? // Structured list of components
    let whatItIsNot: [String]? // What this is not (trust-building)
    let nextSteps: [String]? // Go deeper (implicit CTA)
    
    // Fields for expanded learning content (spreads like Celtic Cross)
    let whatIsThis: String? // What is this? (2-3 lines intro)
    let whyDifferent: [String]? // Why this spread is different (bullet points)
    let howToRead: String? // How to interpret the spread as a whole
    let positionGroups: [PositionGroup]? // Grouped positions for better UX
    
    init(id: String, title: String, subtitle: String, tag: String, category: String, content: String, author: String? = nil, relatedArticles: [String] = [], oneLineDescription: String? = nil, positions: [SpreadPosition]? = nil, whenToUse: [String]? = nil, metaInfo: String? = nil, difficulty: ArticleDifficulty? = nil, definition: String? = nil, whatItIncludes: [String]? = nil, whatItIsNot: [String]? = nil, nextSteps: [String]? = nil, whatIsThis: String? = nil, whyDifferent: [String]? = nil, howToRead: String? = nil, positionGroups: [PositionGroup]? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.tag = tag
        self.category = category
        self.content = content
        self.author = author
        self.relatedArticles = relatedArticles
        self.oneLineDescription = oneLineDescription
        self.difficulty = difficulty
        self.positions = positions
        self.whenToUse = whenToUse
        self.metaInfo = metaInfo
        self.definition = definition
        self.whatItIncludes = whatItIncludes
        self.whatItIsNot = whatItIsNot
        self.nextSteps = nextSteps
        self.whatIsThis = whatIsThis
        self.whyDifferent = whyDifferent
        self.howToRead = howToRead
        self.positionGroups = positionGroups
    }
    
    // Helper to detect if this is a Basics page
    var isBasicsPage: Bool {
        title.lowercased().contains("basics") || title.lowercased().contains("fundamentals")
    }
    
    // Helper to detect if this is a spread/learning page with expanded content
    var hasExpandedContent: Bool {
        whatIsThis != nil || whyDifferent != nil || howToRead != nil || positionGroups != nil
    }
}

struct PositionGroup: Identifiable {
    let id: String
    let title: String
    let positions: [SpreadPosition]
    
    init(id: String, title: String, positions: [SpreadPosition]) {
        self.id = id
        self.title = title
        self.positions = positions
    }
}

// Calculate reading time based on word count from all content sections
func calculateReadingTime(article: Article) -> String {
    let wordsPerMinute = 200
    
    // Collect all text content from the article
    var allText = article.content
    
    // Add content from structured fields
    if let oneLineDescription = article.oneLineDescription {
        allText += " " + oneLineDescription
    }
    if let definition = article.definition {
        allText += " " + definition
    }
    if let whatItIncludes = article.whatItIncludes {
        allText += " " + whatItIncludes.joined(separator: " ")
    }
    if let whatItIsNot = article.whatItIsNot {
        allText += " " + whatItIsNot.joined(separator: " ")
    }
    if let nextSteps = article.nextSteps {
        allText += " " + nextSteps.joined(separator: " ")
    }
    if let whatIsThis = article.whatIsThis {
        allText += " " + whatIsThis
    }
    if let whyDifferent = article.whyDifferent {
        allText += " " + whyDifferent.joined(separator: " ")
    }
    if let howToRead = article.howToRead {
        allText += " " + howToRead
    }
    if let whenToUse = article.whenToUse {
        allText += " " + whenToUse.joined(separator: " ")
    }
    if let positions = article.positions {
        for position in positions {
            allText += " " + position.title
            if let description = position.description {
                allText += " " + description
            }
        }
    }
    if let positionGroups = article.positionGroups {
        for group in positionGroups {
            allText += " " + group.title
            for position in group.positions {
                allText += " " + position.title
                if let description = position.description {
                    allText += " " + description
                }
            }
        }
    }
    
    // Normalize text
    var normalizedText = allText.trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: "\n", with: " ")
        .replacingOccurrences(of: "\t", with: " ")
        .replacingOccurrences(of: "\r", with: " ")
    
    // Collapse multiple spaces
    while normalizedText.contains("  ") {
        normalizedText = normalizedText.replacingOccurrences(of: "  ", with: " ")
    }
    
    // Split and filter words
    let words = normalizedText.components(separatedBy: CharacterSet.whitespaces)
        .filter { word in
            let trimmed = word.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty { return false }
            // Remove punctuation and check if there's actual content
            let alphanumeric = trimmed.trimmingCharacters(in: .punctuationCharacters)
            return !alphanumeric.isEmpty && alphanumeric.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil
        }
    
    let wordCount = words.count
    
    // Calculate minutes: word count / 200 words per minute
    let rawMinutes = Double(wordCount) / Double(wordsPerMinute)
    
    // Round to nearest minute and clamp between 5-25 min
    let minutes = max(5, min(25, Int(round(rawMinutes))))
    
    return "\(minutes) min read"
}

// Legacy function for backward compatibility
func calculateReadingTime(content: String) -> String {
    let wordsPerMinute = 200
    
    // Count words accurately: normalize text and split by whitespace
    var normalizedText = content.trimmingCharacters(in: .whitespacesAndNewlines)
        .replacingOccurrences(of: "\n", with: " ")
        .replacingOccurrences(of: "\t", with: " ")
        .replacingOccurrences(of: "\r", with: " ")
    
    // Collapse multiple spaces into single space
    while normalizedText.contains("  ") {
        normalizedText = normalizedText.replacingOccurrences(of: "  ", with: " ")
    }
    
    // Split by whitespace to get words
    let words = normalizedText.components(separatedBy: .whitespaces)
        .filter { word in
            // Filter out empty strings and words that are only punctuation/whitespace
            let trimmed = word.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                return false
            }
            // Keep words that have at least one letter or number
            let alphanumeric = trimmed.trimmingCharacters(in: .punctuationCharacters)
            return !alphanumeric.isEmpty
        }
    
    let wordCount = words.count
    let rawMinutes = Double(wordCount) / Double(wordsPerMinute)
    let minutes = max(5, min(25, Int(round(rawMinutes))))
    return "\(minutes) min read"
}

// Learning Hub V1 - 50 educational articles
struct ArticleData {
    static let articles: [String: Article] = [
        // SAMPLE ARTICLE - Reference Implementation
        "lh-001": Article(
            id: "lh-001",
            title: "Reading Birth Charts Through Patterns",
            subtitle: "Interpret charts through relationships, not memorization",
            tag: "Featured",
            category: "Astrology",
            content: """
            Most people learn astrology by memorizing what each planet and sign means. Sun in Leo means this. Moon in Cancer means that. But charts don't work that way in practice.
            
            A birth chart is a system, not a collection of separate meanings. The same planet in the same sign expresses differently depending on its house, its aspects, and the chart's overall structure. Understanding this changes everything about how you read charts.
            
            This article shows you how to read charts by recognizing patterns and relationships rather than memorizing definitions. You'll learn to see the whole picture, not just individual pieces.
            
            Why Context Changes Everything
            
            Your Sun sign doesn't exist in isolation. It's modified by its house placement, its aspects to other planets, and the chart's dominant patterns. A Sun in Leo in the 12th house expresses very differently than a Sun in Leo in the 1st house. The sign gives you the energy; the house shows you where it plays out.
            
            The same principle applies to every planet. A Moon in Cancer conjunct Saturn feels different than a Moon in Cancer trine Jupiter. The sign tells you the emotional nature; the aspects tell you how that nature interacts with other parts of your personality.
            
            Charts function as systems where each element influences and is influenced by others. Understanding this interconnectedness is what separates surface-level astrology from meaningful interpretation.
            
            Reading Structure First
            
            Before looking up what each planet means, identify the chart's overall shape. Are planets clustered or scattered? Which elements dominate? Which houses are most active?
            
            A chart with five planets in fire signs, all in angular houses, tells a different story than a chart with planets evenly distributed across elements and houses. The first suggests someone who expresses energy directly and visibly. The second suggests someone who experiences life through multiple lenses.
            
            Notice hemisphere emphasis. Planets in the upper hemisphere (houses 7-12) suggest someone who experiences life primarily through relationships and external contexts. Planets in the lower hemisphere (houses 1-6) suggest someone more focused on personal identity and daily life.
            
            Reading Relationships, Not Positions
            
            Aspects show how planets interact. A square isn't just "challenge" — it's a specific type of energy interaction that creates tension requiring integration. A trine isn't just "easy" — it's energy that flows so smoothly it might be taken for granted.
            
            A Sun-Moon square means your core identity and emotional needs are in tension. This isn't a problem to solve; it's a dynamic that creates growth. Understanding the relationship tells you more than knowing each planet's sign placement.
            
            Look for aspect patterns. A grand trine suggests energy that flows easily but might lack challenge. A T-square suggests focused tension that drives action. These patterns reveal personality dynamics that individual planet meanings can't capture.
            
            Using the Chart Ruler as Your Anchor
            
            The chart ruler is the planet that rules your Rising sign. It shows how you navigate the world. If your chart ruler is in a challenging aspect, that's where you'll experience life's primary lessons. If it's well-aspected, that's your natural strength area.
            
            A chart ruler in the 10th house suggests someone who navigates life through career and public expression. A chart ruler in the 4th house suggests someone who navigates through home and family. This single placement often reveals more about personality than multiple other placements combined.
            
            When Pattern Reading Matters Most
            
            This approach matters most when traditional interpretations don't resonate. If you've read that your Sun sign means one thing but it doesn't feel true, pattern-based reading explains why — your Sun might be modified by its house, aspects, or the chart's overall structure.
            
            It's especially useful during life transitions when you need to understand not just what's happening, but why certain patterns keep repeating. If you consistently struggle with the same type of relationship issue, pattern reading shows you the underlying chart dynamics creating that pattern.
            
            This method also matters when reading charts for others. Instead of listing disconnected meanings, you can tell a coherent story about how someone's personality functions as an integrated system.
            
            How This Fits Inside the App
            
            Pattern-based reading connects directly to how the app shows your chart. Explore your Sun, Moon, and Rising combination to see how these three elements interact. Check your aspect patterns to understand relationship dynamics. Review your house emphasis to see where life's energy is most concentrated.
            """,
            author: nil,
            relatedArticles: ["lh-002", "lh-005", "lh-006", "lh-007"],
            oneLineDescription: "Learn to interpret charts through patterns and relationships, not rote memorization.",
            whenToUse: [
                "When traditional interpretations don't resonate",
                "Understanding why your chart feels complex",
                "Reading charts for others effectively",
                "Making sense of conflicting astrological information"
            ],
            difficulty: .intermediate
        ),
        
        // ASTROLOGY ARTICLES (13 remaining, 14 total)
        "lh-002": Article(
            id: "lh-002",
            title: "Sun, Moon, Rising: How They Work Together",
            subtitle: "How your three core elements interact",
            tag: "Featured",
            category: "Astrology",
            content: """
            You've probably heard that your Sun sign is who you are, your Moon sign is how you feel, and your Rising sign is how others see you. But that's too simple.
            
            These three don't operate independently. They work together, sometimes harmoniously and sometimes in tension, creating the complexity of your personality. Understanding their relationship reveals why you might feel like your Sun sign doesn't fully describe you, or why people see you differently than you see yourself.
            
            Your Sun represents your core identity and conscious self-expression — who you are at your essence. Your Moon shows your emotional nature, needs, and instinctual responses — how you process feelings and what makes you feel secure. Your Rising sign represents your outward expression and how others first perceive you — the energy you project.
            
            But here's what matters: these three form a system. They modify each other. They create dynamics. They reveal tensions and harmonies that shape how you experience yourself and how others experience you.
            
            When These Three Work Together
            
            When your Sun, Moon, and Rising share an element or complementary elements, you experience less internal conflict. A Sun in Leo, Moon in Sagittarius, and Rising in Aries all share fire energy. This person expresses energy consistently — directly, passionately, action-oriented. There's harmony in the element.
            
            But harmony isn't always better. Sometimes it means energy flows so smoothly it's taken for granted. A person with all three in water signs experiences life primarily through emotions and intuition, but might struggle to balance emotional depth with practical action.
            
            When They Create Tension
            
            When your Sun, Moon, and Rising are in different elements or conflicting qualities, you have more complexity. A Sun in Leo wants to shine and be recognized, but a Moon in Cancer needs emotional security and privacy. A Rising in Gemini makes you appear curious and communicative, which helps you navigate the tension between wanting attention and needing emotional safety.
            
            This isn't a problem to solve. It's a dynamic that creates growth. The tension between your Sun's need for recognition and your Moon's need for security isn't something to eliminate — it's something to understand and work with.
            
            A Sun in Scorpio seeks depth and transformation, while a Moon in Sagittarius needs freedom and expansion. A Rising in Capricorn projects seriousness and ambition. This creates someone who appears controlled and ambitious but has intense emotional depth and a need for adventure. The tension between depth and freedom creates a complex personality — and that complexity is valuable.
            
            Understanding Element Dominance
            
            If two or three of your Sun/Moon/Rising share an element, that element's qualities will be especially strong in your personality. Fire dominance suggests someone who expresses energy directly. Earth dominance suggests someone grounded in material reality. Air dominance suggests someone who processes life intellectually. Water dominance suggests someone who experiences life through emotions.
            
            If they're all different elements, you have more complexity and may need to consciously integrate different parts of yourself. This integration isn't automatic — it requires awareness and intention.
            
            Using Your Rising Sign Consciously
            
            Your Rising sign shows how you present yourself, which may or may not match your Sun sign. If your Sun is introverted but your Rising is extroverted, you might appear more social than you feel. Understanding this helps you navigate social situations authentically.
            
            Your Rising sign is like a lens through which your Sun and Moon express themselves. A Sun in Pisces with a Rising in Capricorn might have deep emotional sensitivity (Pisces) but present as practical and ambitious (Capricorn). This isn't inauthentic — it's how different layers of your personality work together.
            
            When This Matters Most
            
            This matters most when you're trying to understand why you don't feel like your Sun sign, or why people perceive you differently than you perceive yourself. It's especially useful during identity exploration, relationship navigation, and when making career choices that need to align with your authentic self.
            
            If you consistently feel misunderstood, your Rising sign might explain why. If you feel like you have conflicting needs, your Sun-Moon relationship might explain why. Understanding these three as a system helps you work with your complexity rather than against it.
            
            How This Fits Inside the App
            
            Your Sun, Moon, and Rising combination appears throughout the app. Understanding how they work together helps you make sense of daily guidance, timing cycles, and personal patterns. Explore your chart to see how these three elements interact in your specific configuration.
            """,
            author: nil,
            relatedArticles: ["lh-001", "lh-003", "lh-005"],
            oneLineDescription: "Understanding the relationship between your three core astrological elements.",
            whenToUse: [
                "Feeling like your Sun sign doesn't describe you",
                "Understanding why people see you differently",
                "Navigating internal conflicts between different parts of yourself"
            ],
            difficulty: .beginner
        ),
        
        "lh-003": Article(
            id: "lh-003",
            title: "Houses Explained Through Real-Life Situations",
            subtitle: "Learn how astrological houses shape different areas of your life experience",
            tag: "Featured",
            category: "Astrology",
            content: """
            Houses are often explained as abstract categories: the 1st house is identity, the 7th house is relationships, the 10th house is career. But that misses what houses actually do.
            
            Houses represent areas of life experience — the contexts and life domains where planetary energy plays out. They're the "where" of astrology. The same planet in different houses expresses differently because the house provides the context and stage for that planet's energy.
            
            A Venus in the 2nd house expresses through material comfort, valuing beautiful possessions, and finding self-worth through resources. The same Venus in the 7th house expresses through relationships, partnership harmony, and finding value through connection with others. Same planet, completely different life context.
            
            Understanding houses means understanding where your energy naturally flows and where life's lessons appear.
            
            How Houses Work
            
            Houses are numbered 1-12, each representing a different life area. But houses aren't just categories — they're active areas where you experience life's lessons and opportunities.
            
            Angular houses (1st, 4th, 7th, 10th) are active and visible. Planets here express directly and publicly. The 1st house shows identity and self-presentation. The 4th house shows home, family, and roots. The 7th house shows partnerships and relationships. The 10th house shows career and public image.
            
            Succedent houses (2nd, 5th, 8th, 11th) are about building and maintaining. The 2nd house shows resources, money, and values. The 5th house shows creativity, romance, and self-expression. The 8th house shows shared resources, transformation, and intimacy. The 11th house shows friends, groups, and community.
            
            Cadent houses (3rd, 6th, 9th, 12th) are about learning and processing. The 3rd house shows communication, learning, and daily routines. The 6th house shows work, health, and service. The 9th house shows higher learning, philosophy, and beliefs. The 12th house shows subconscious, spirituality, and hidden matters.
            
            How Planets Modify Houses
            
            A planet in a house brings its energy to that life area. Mars in the 10th house channels drive and assertiveness into career and public achievement. This person is ambitious, competitive in professional settings, and their identity is tied to career success. Mars energy is channeled into building reputation and achieving public goals.
            
            Saturn in the 7th house brings structure and responsibility to relationships. This doesn't mean relationships are difficult — it means relationships are where you learn about commitment, boundaries, and building lasting structures.
            
            Jupiter in the 9th house brings expansion and optimism to learning and beliefs. This person finds meaning through education, travel, philosophy, and exploring different worldviews.
            
            Understanding House Rulers
            
            The planet ruling a house's sign shows how that life area functions. If your 7th house is in Libra, Venus (Libra's ruler) shows how you approach partnerships. If Venus is in the 5th house, your partnerships are colored by creativity, romance, and self-expression.
            
            House rulers create connections between different life areas. A 10th house ruler in the 4th house suggests that career success is connected to home and family foundations. A 2nd house ruler in the 8th house suggests that resources come through shared resources, transformation, or partnership.
            
            Which Houses Are Most Active
            
            Houses with multiple planets are areas of life where you'll have more activity, lessons, and focus. Multiple planets in the 4th house suggest someone whose life is deeply focused on home, family, and private life. Even if they have planets that might suggest career focus (like Saturn or Mars), if they're in the 4th house, that energy expresses through family dynamics, home environment, and emotional roots.
            
            Empty houses aren't inactive — they're areas where you might have less complexity or where you're learning through other means. An empty 7th house doesn't mean no relationships. It might mean relationships are simpler, or that relationship lessons come through other houses or through the house ruler.
            
            When This Matters Most
            
            This matters most when you're trying to understand why certain life areas feel more significant or challenging than others. It's especially useful when making decisions about career, relationships, home, or other major life areas. Understanding houses helps you see where your energy naturally flows and where you might need to put conscious effort.
            
            How This Fits Inside the App
            
            Houses appear throughout your chart reading in the app. Understanding how houses work helps you make sense of where planetary energy expresses itself in your life. Explore your chart to see which houses are most active and how planets modify house meanings.
            """,
            author: nil,
            relatedArticles: ["lh-001", "lh-002", "lh-007"],
            oneLineDescription: "Learn how astrological houses shape different areas of your life experience.",
            whenToUse: [
                "Understanding why certain life areas feel more significant",
                "Making decisions about career, relationships, or home",
                "Seeing where your energy naturally flows"
            ]
        ),
        
        "lh-004": Article(
            id: "lh-004",
            title: "Planetary Aspects and Why Tension Is Useful",
            subtitle: "Understanding how planets interact and why challenging aspects create growth",
            tag: "Featured",
            category: "Astrology",
            content: """
            Aspects are often described as "good" or "bad" — trines are easy, squares are hard. But that's not how they actually work.
            
            Aspects are angles between planets that show how different parts of your personality interact. They're not judgments — they're descriptions of energy dynamics. A square aspect creates tension that requires conscious integration. A trine creates natural flow that might need conscious activation. Both serve important purposes in your chart.
            
            Understanding aspects means understanding why certain parts of yourself feel in conflict and how to work with that conflict productively.
            
            How Aspects Create Dynamics
            
            Conjunctions blend planetary energies, creating intensity and focus in that area. When planets are conjunct, their energies merge. A Sun-Moon conjunction creates someone whose identity and emotions are deeply intertwined. A Venus-Mars conjunction creates someone whose love and desire are closely connected.
            
            Sextiles create harmonious opportunities that require effort. They don't flow automatically — they need conscious action to activate. A Mercury sextile Jupiter suggests natural ability to communicate big ideas, but it needs to be developed consciously.
            
            Squares create tension requiring integration. They don't block energy — they create motivation and growth through challenge. A Sun square Moon means your core identity conflicts with your emotional needs. This isn't a flaw — it's a dynamic that creates growth. You learn to integrate your identity with your emotional needs, becoming more whole.
            
            Trines create natural flow and ease. Talents come easily, but they can also lead to complacency. A Venus trine Jupiter means love and expansion flow easily together. You naturally attract abundance in relationships and find joy easily. The challenge is not taking this for granted and consciously developing these gifts rather than coasting on natural harmony.
            
            Oppositions create polarities requiring balance. They show two sides of the same coin. A Mars opposite Saturn means action conflicts with structure. You want to move forward but feel blocked by responsibility or fear. This opposition creates a push-pull dynamic that, when integrated, gives you the ability to act with discipline and structure with energy.
            
            Why Tension Aspects Are Valuable
            
            Squares and oppositions aren't problems to solve. They're areas where you're learning to balance different parts of yourself. The tension creates motivation and growth.
            
            A Sun square Moon creates internal tension where what you want to be conflicts with what you need emotionally. This tension drives you to integrate these parts of yourself. Without the tension, integration might not happen. The challenge creates the growth.
            
            A Mars square Saturn creates frustration between wanting to act and feeling blocked. But this frustration teaches you to act with discipline and to structure your energy productively. The tension creates the learning.
            
            Working with tension aspects consciously means seeing them as teachers rather than obstacles. They show you where integration is needed and provide the motivation to do that work.
            
            Why Harmonious Aspects Need Activation
            
            Trines and sextiles provide natural flow, but they can also lead to complacency. A Venus trine Jupiter might make relationships easy, but easy doesn't always mean deep. Consciously developing these areas rather than taking them for granted creates more meaningful expression.
            
            A grand trine (three planets forming trines) creates natural talents that flow easily. But without challenge, these talents might not develop fully. The ease is a foundation, not a destination.
            
            Activating harmonious aspects means using the ease as a starting point for deeper development. Natural flow is valuable, but conscious development makes it more meaningful.
            
            Understanding Aspect Patterns
            
            Multiple squares create a T-square or grand square, indicating areas of significant challenge and growth. These patterns focus energy intensely and create major life themes. They're not curses — they're areas where you're meant to grow.
            
            Multiple trines create a grand trine, indicating natural talents that need conscious development to avoid stagnation. The ease is real, but it needs direction.
            
            Aspect patterns reveal major themes in your chart. Understanding these patterns helps you see where your energy is focused and what lessons you're here to learn.
            
            When This Matters Most
            
            This matters most when you're experiencing internal conflicts or when certain areas of life feel stuck. Understanding aspects helps you see why conflicts exist and how to work with them productively. It's especially useful during periods of personal growth when you're learning to integrate different parts of yourself.
            
            How This Fits Inside the App
            
            Aspects appear throughout your chart reading. Understanding how aspects work helps you make sense of internal dynamics and relationship patterns. Explore your chart to see which aspects are most active and how they create themes in your life.
            """,
            author: nil,
            relatedArticles: ["lh-001", "lh-002", "lh-005"],
            oneLineDescription: "Understanding how planets interact and why challenging aspects create growth.",
            whenToUse: [
                "Experiencing internal conflicts",
                "Understanding why certain areas feel stuck",
                "Learning to integrate different parts of yourself"
            ]
        ),
        
        "lh-005": Article(
            id: "lh-005",
            title: "What Dominant Planets Reveal About Your Life Themes",
            subtitle: "Understanding how planetary emphasis shapes your personality and life focus",
            tag: "Featured",
            category: "Astrology",
            content: """
            Some planets appear more often in your chart than others. Some planets rule multiple signs or houses. Some planets have many aspects. When a planet appears multiple times or has strong influence, it becomes dominant and creates themes in your life.
            
            A dominant planet's energy colors how you experience life and what lessons you're here to learn. Understanding dominance helps you see why certain themes repeat and how to work with them consciously.
            
            How Planets Become Dominant
            
            Dominance can come from several sources. Multiple planets in signs ruled by the same planet creates sign emphasis. Three planets in Venus-ruled signs (Libra, Taurus) makes Venus dominant. The planet's energy becomes especially strong in your personality.
            
            The planet ruling your Rising sign becomes your chart ruler and has special significance. It shows how you navigate the world. A chart ruler in an angular house or with many aspects becomes even more dominant.
            
            A planet with many aspects (especially major aspects) is highly active. It's constantly interacting with other parts of your chart, creating themes and dynamics.
            
            Planets in angular houses (1st, 4th, 7th, 10th) have more visibility and impact. They express directly and publicly, making their energy more dominant in your life experience.
            
            Stelliums — three or more planets in one sign or house — create intense focus on that planet's energy. A stellium in Capricorn makes Saturn dominant. A stellium in the 7th house makes relationships central to your life.
            
            What Dominant Planets Teach
            
            Each dominant planet brings specific lessons. Saturn teaches about structure, responsibility, limits, and time. A dominant Saturn means your life is deeply colored by themes of responsibility, structure, discipline, and authority. You learn lessons about boundaries, limits, and building lasting structures. Challenges around authority, time, and responsibility will be prominent.
            
            Jupiter teaches about expansion, meaning, and optimism. A dominant Jupiter means your life focuses on growth, learning, and finding meaning. You're learning about abundance, philosophy, and how to expand without losing boundaries.
            
            Mars teaches about action, assertion, and boundaries. A dominant Mars means your life is marked by action, drive, and conflict. You're learning about healthy aggression, boundaries, and how to channel energy productively. Themes of competition, courage, and action will be prominent.
            
            Venus teaches about love, values, and beauty. A dominant Venus means your life focuses on relationships, beauty, values, and harmony. You're learning about love, partnership, aesthetics, and what you value. Relationship themes and questions of worth will be central.
            
            The Shadow Side of Dominance
            
            Dominant planets can become overemphasized. Too much Saturn creates restriction and fear. Too much Jupiter creates excess and lack of boundaries. Too much Mars creates aggression and conflict. Too much Venus creates dependency and lack of boundaries in relationships.
            
            Balance comes from integrating the planet's energy rather than being overwhelmed by it. A dominant Saturn needs to learn structure without becoming rigid. A dominant Jupiter needs to learn expansion without becoming scattered. A dominant Mars needs to learn action without becoming aggressive.
            
            Understanding the shadow side helps you work with dominant planets consciously rather than being controlled by them.
            
            When Dominance Matters Most
            
            This matters most when you're noticing repeating themes in your life or when certain planetary energies feel overwhelming. Understanding dominance helps you see why certain lessons keep appearing and how to work with them consciously. It's especially useful during major life transitions when dominant planet themes become more active.
            
            If you consistently struggle with the same type of challenge, a dominant planet might explain why. If certain energies feel overwhelming, understanding dominance helps you work with them rather than against them.
            
            How This Fits Inside the App
            
            Dominant planets appear throughout your chart reading. Understanding which planets are dominant helps you make sense of major life themes and repeating patterns. Explore your chart to see which planets are most active and how they create themes in your life.
            """,
            author: nil,
            relatedArticles: ["lh-001", "lh-004", "lh-003"],
            oneLineDescription: "Understanding how planetary emphasis shapes your personality and life focus.",
            whenToUse: [
                "Noticing repeating themes in your life",
                "Understanding why certain energies feel overwhelming",
                "Working with major life lessons consciously"
            ]
        ),
        
        // Continue with remaining Astrology articles (9 more needed)
        "lh-006": Article(id: "lh-006", title: "Saturn Cycles", subtitle: "How Saturn returns shape your life", tag: "Featured", category: "Astrology", content: """
            Saturn gets a bad reputation. It's associated with restriction, limitation, and difficulty. But that misses what Saturn actually does.
            
            Saturn represents structure, responsibility, limits, and time. Its cycles, especially the Saturn return around ages 29 and 58, mark major life transitions where you're called to build lasting structures and take on adult responsibilities. These periods feel challenging because they require you to face reality and build something real.
            
            Understanding Saturn cycles means understanding why certain periods feel like tests — and why those tests create foundations.
            
            Why Saturn Returns Matter
            
            Saturn returns occur approximately every 29.5 years. The first return (around 28-30) marks the transition to true adulthood. The second (around 58-60) marks wisdom and legacy. Between returns, Saturn transits create smaller but significant lessons about responsibility and structure.
            
            During your first Saturn return, you might feel pressure to establish career, commit to relationships, or take on adult responsibilities. This isn't arbitrary — it's Saturn asking you to build something real rather than living provisionally.
            
            The pressure isn't punishment. It's structure asking to be built. Saturn doesn't block you — it asks you to commit to something real.
            
            What Saturn Teaches
            
            Saturn teaches about structure, responsibility, limits, and time. It shows you where you need to build foundations, where you need to take responsibility, and where you need to accept necessary limits.
            
            A Saturn transit to your Sun asks you to take responsibility for your identity. A Saturn transit to your Moon asks you to structure your emotional life. A Saturn transit to your Venus asks you to commit to what you value.
            
            These lessons feel challenging because they require you to face reality. But facing reality creates foundations. Without Saturn's lessons, everything stays provisional. With Saturn's lessons, you build something that lasts.
            
            Working With Saturn's Energy
            
            Work with Saturn's energy by taking responsibility consciously, building structures that last, and accepting necessary limits. Don't resist Saturn's lessons — they create the foundation for everything else.
            
            During Saturn periods, focus on building rather than avoiding. Take on responsibility rather than resisting it. Accept limits rather than fighting them. The structure you build now becomes the foundation for future growth.
            
            Saturn rewards commitment. It rewards building something real. It rewards taking responsibility for your choices. The challenge is real, but so is the foundation it creates.
            
            Between Saturn Returns
            
            Between returns, Saturn transits create smaller but significant lessons. A Saturn square to your natal Sun might create a period of taking responsibility for your identity. A Saturn trine might create a period of building structures easily.
            
            These transits prepare you for the returns. They teach you about responsibility, structure, and limits gradually. By the time a return arrives, you've learned enough to build something real.
            
            When Saturn Matters Most
            
            This matters most during Saturn returns, major life transitions, or when you're feeling pressure to grow up or take responsibility. Understanding Saturn helps you work with these periods rather than against them.
            
            If you're feeling stuck or blocked, Saturn might be asking you to build structure rather than forcing movement. If you're feeling pressure, Saturn might be asking you to commit rather than staying provisional.
            
            How This Fits Inside the App
            
            Saturn cycles appear in your timing features. Understanding Saturn helps you make sense of major life transitions and periods of building structure. Check your Saturn return timing and Saturn transits to see when these lessons become most active.
            """, author: nil, relatedArticles: ["lh-001", "lh-004", "lh-005"], oneLineDescription: "Understanding Saturn's return and how it shapes your life structure.", whenToUse: ["During Saturn returns", "Feeling pressure to grow up", "Building lasting structures"], difficulty: .intermediate),
        
        "lh-007": Article(id: "lh-007", title: "Venus and Relationships", subtitle: "How Venus reveals your approach to love", tag: "Featured", category: "Astrology", content: """
            Venus shows what you value, how you love, and what you find beautiful. But it's more than just "the love planet."
            
            Your Venus placement reveals your relationship patterns, values in love, and how you express affection. Its sign placement reveals your love language and attraction style. Its house placement shows where relationships play out in your life. Its aspects show how love interacts with other parts of your personality.
            
            Understanding Venus means understanding why you're attracted to certain types of people, how you show love, and what you need in relationships.
            
            How Venus Expresses Through Signs
            
            Venus in fire signs (Aries, Leo, Sagittarius) loves through passion and excitement. Love is active, direct, and enthusiastic. These placements need relationships that feel alive and dynamic. They express love through action and excitement.
            
            Venus in earth signs (Taurus, Virgo, Capricorn) loves through practicality and stability. Love is grounded, reliable, and built over time. These placements need relationships that feel secure and tangible. They express love through consistency and material care.
            
            Venus in air signs (Gemini, Libra, Aquarius) loves through intellectual connection. Love needs communication, mental stimulation, and space. These placements need relationships that feel mentally engaging. They express love through conversation and shared ideas.
            
            Venus in water signs (Cancer, Scorpio, Pisces) loves through deep emotional connection. Love is intuitive, intense, and emotionally rich. These placements need relationships that feel emotionally deep. They express love through emotional intimacy and care.
            
            How Venus Expresses Through Houses
            
            Venus in the 7th house makes partnerships central to your life experience. Relationships are where you learn about yourself through others. Partnership is a primary life theme.
            
            Venus in the 5th house expresses love through creativity, romance, and self-expression. Love is playful, creative, and fun. Relationships are about joy and expression.
            
            Venus in the 2nd house expresses love through material comfort and values. Love is about feeling secure and valued. Relationships are about building resources together.
            
            Venus in the 8th house expresses love through transformation and deep intimacy. Love is intense, transformative, and emotionally deep. Relationships are about merging and transformation.
            
            How Aspects Modify Venus
            
            Venus square Mars creates tension between love and desire. This isn't a problem — it's a dynamic that requires integration. You might struggle to balance love with passion, or you might attract relationships that feel intense but challenging. The tension creates growth in how you integrate love and desire.
            
            Venus trine Jupiter creates natural flow between love and expansion. Relationships feel abundant and joyful. You naturally attract positive relationships and find joy easily. The challenge is not taking this for granted.
            
            Venus conjunct Saturn creates structure and responsibility in love. Relationships require commitment and building over time. Love isn't always easy, but it's lasting. The structure creates foundations.
            
            Understanding Your Relationship Patterns
            
            Your Venus placement helps you understand why certain relationship dynamics repeat. If you consistently attract intense but challenging relationships, Venus in Scorpio or Venus square Mars might explain why. If you consistently need more space in relationships, Venus in Aquarius or Venus in air signs might explain why.
            
            Understanding your Venus placement helps you recognize your relationship patterns and needs. Use this awareness to communicate your needs clearly and understand your partner's Venus placement for compatibility.
            
            When This Matters Most
            
            This matters most when navigating relationships, understanding attraction patterns, or working on relationship issues. Venus placement helps you understand why certain relationship dynamics repeat and how to work with them consciously.
            
            If you're struggling in relationships, understanding your Venus placement helps you see what you need and how to communicate it. If you're wondering why you're attracted to certain types of people, Venus explains why.
            
            How This Fits Inside the App
            
            Your Venus placement appears throughout your chart reading. Understanding Venus helps you make sense of relationship patterns and attraction styles. Explore your Venus sign, house, and aspects to see how love expresses itself in your life.
            """, author: nil, relatedArticles: ["lh-002", "lh-003", "lh-004"], oneLineDescription: "How Venus placement reveals your approach to love and connection.", whenToUse: ["Navigating relationships", "Understanding attraction patterns", "Working on relationship issues"], difficulty: .beginner),
        
        "lh-008": Article(id: "lh-008", title: "Mars and Taking Action", subtitle: "Your relationship with action and drive", tag: "Featured", category: "Astrology", content: """
            Mars represents action, assertion, desire, and how you fight for what you want. But it's more than just aggression or drive.
            
            Your Mars placement reveals your relationship with action, assertion, conflict, and drive. Its sign placement shows your action style — how you move forward and handle conflict. Its house placement shows where you're most active and where you assert yourself. Its aspects show how action interacts with other parts of your personality.
            
            Understanding Mars means understanding why you approach challenges the way you do and how to channel Mars energy productively.
            
            How Mars Expresses Through Signs
            
            Mars in fire signs (Aries, Leo, Sagittarius) acts impulsively and directly. Action is immediate, enthusiastic, and visible. These placements move forward quickly and handle conflict head-on. They express drive through action and passion.
            
            Mars in earth signs (Taurus, Virgo, Capricorn) acts steadily and practically. Action is deliberate, persistent, and built over time. These placements move forward methodically and handle conflict through consistency. They express drive through building and maintaining.
            
            Mars in air signs (Gemini, Libra, Aquarius) acts mentally and communicatively. Action is about ideas, communication, and mental engagement. These placements move forward through thinking and talking. They express drive through communication and ideas.
            
            Mars in water signs (Cancer, Scorpio, Pisces) acts emotionally and intuitively. Action is about feelings, depth, and emotional engagement. These placements move forward through feeling and intuition. They express drive through emotional intensity.
            
            How Mars Expresses Through Houses
            
            Mars in the 10th house channels drive into career and public achievement. Action expresses through professional goals and public recognition. This person is ambitious, competitive in professional settings, and their identity is tied to career success.
            
            Mars in the 1st house channels drive into identity and self-expression. Action expresses through personal goals and self-assertion. This person is direct, assertive, and their identity is tied to action.
            
            Mars in the 7th house channels drive into relationships and partnerships. Action expresses through relationship dynamics and partnership goals. This person is active in relationships and assertive about partnership needs.
            
            Mars in the 4th house channels drive into home and family. Action expresses through family dynamics and home environment. This person is active in creating home and family structures.
            
            How Aspects Modify Mars
            
            Mars square Saturn creates tension between action and restriction. You want to move forward but feel blocked by responsibility or fear. This tension requires discipline and structure. The challenge is learning to act with discipline rather than being blocked by it.
            
            Mars trine Jupiter creates natural flow between action and expansion. Action feels abundant and optimistic. You naturally take action and find opportunities easily. The challenge is not taking this for granted and using the flow consciously.
            
            Mars opposite Venus creates tension between action and love. You might struggle to balance assertiveness with harmony, or you might attract relationships that feel passionate but challenging. The tension creates growth in how you integrate action and love.
            
            Understanding Your Action Style
            
            Your Mars placement helps you understand why you approach challenges the way you do. If you consistently act impulsively, Mars in Aries or Mars in fire signs might explain why. If you consistently feel blocked, Mars square Saturn might explain why.
            
            Understanding your Mars placement helps you recognize your action style and conflict patterns. Use this awareness to channel energy productively and handle conflicts effectively.
            
            When This Matters Most
            
            This matters most when you're feeling stuck, dealing with conflict, or trying to take action. Mars placement helps you understand your relationship with assertiveness and drive.
            
            If you're feeling stuck, understanding your Mars placement helps you see how to channel energy productively. If you're dealing with conflict, Mars explains your conflict style and how to handle it effectively.
            
            How This Fits Inside the App
            
            Your Mars placement appears throughout your chart reading. Understanding Mars helps you make sense of action patterns and drive. Explore your Mars sign, house, and aspects to see how action expresses itself in your life.
            """, author: nil, relatedArticles: ["lh-004", "lh-005", "lh-003"], oneLineDescription: "Understanding Mars placement and your relationship with action, conflict, and drive.", whenToUse: ["Feeling stuck", "Dealing with conflict", "Trying to take action"], difficulty: .beginner),
        
        "lh-009": Article(id: "lh-009", title: "The Moon and Daily Emotions", subtitle: "How lunar transits affect your emotions", tag: "Featured", category: "Astrology", content: """
            The Moon moves quickly through signs — about 2.5 days per sign — creating daily emotional shifts. But most people don't notice this.
            
            Your natal Moon sign shows your baseline emotional nature, but the transiting Moon activates different emotional qualities as it moves. Understanding this helps you navigate daily emotional fluctuations rather than being confused by them.
            
            Why You Feel Different From Day to Day
            
            When the transiting Moon is in a fire sign, emotions are passionate and action-oriented. You might feel more impulsive, enthusiastic, or ready to act. When it's in an earth sign, emotions are stable and practical. You might feel more grounded, focused, or material. When it's in an air sign, emotions are mental and communicative. You might feel more analytical, social, or idea-focused. When it's in a water sign, emotions are deep and intuitive. You might feel more sensitive, emotional, or intuitive.
            
            If your natal Moon is in Cancer but the transiting Moon is in Aries, you might feel more impulsive and action-oriented than usual. Your baseline emotional nature (Cancer) is still there, but it's being activated by fire energy (Aries). The combination creates a different emotional experience.
            
            How Lunar Aspects Create Activation
            
            The Moon's aspects to your natal planets create specific emotional activations. A transiting Moon conjunct your natal Sun activates your identity and emotional expression. A transiting Moon square your natal Venus activates tension between emotions and love. A transiting Moon trine your natal Jupiter activates emotional expansion and optimism.
            
            These aspects don't create events — they create emotional experiences. Understanding them helps you understand why you feel certain ways at certain times.
            
            Working With Lunar Energy
            
            Track the Moon's movement to understand your daily emotional shifts. Use this awareness to plan activities that match the Moon's energy and to understand why you feel certain ways.
            
            When the Moon is in fire signs, it's a good time for action and enthusiasm. When it's in earth signs, it's a good time for practical work and building. When it's in air signs, it's a good time for communication and ideas. When it's in water signs, it's a good time for emotional processing and intuition.
            
            This doesn't mean you can't do other things — it means you can work with the energy rather than against it.
            
            Understanding Your Natal Moon
            
            Your natal Moon sign shows your baseline emotional nature. A Moon in Cancer needs emotional security and nurturance. A Moon in Aries needs independence and action. A Moon in Libra needs harmony and partnership. A Moon in Capricorn needs structure and responsibility.
            
            The transiting Moon activates different qualities, but your natal Moon remains your emotional foundation. Understanding both helps you navigate emotional experiences consciously.
            
            When This Matters Most
            
            This matters most when you're experiencing unexplained emotional shifts or want to work with daily rhythms. Understanding lunar transits helps you navigate emotional fluctuations consciously.
            
            If you're feeling confused by mood changes, understanding lunar transits helps you see why. If you want to work with daily rhythms, understanding the Moon helps you plan activities that match emotional energy.
            
            How This Fits Inside the App
            
            Lunar transits appear in your daily guidance. Understanding the Moon helps you make sense of daily emotional shifts and plan activities accordingly. Check your daily guidance to see how the Moon's current position affects your emotional experience.
            """, author: nil, relatedArticles: ["lh-002", "lh-010", "lh-011"], oneLineDescription: "Understanding how lunar transits affect your daily emotional experience.", whenToUse: ["Experiencing emotional shifts", "Working with daily rhythms", "Understanding mood changes"], difficulty: .beginner),
        
        "lh-010": Article(id: "lh-010", title: "Retrogrades: What Changes", subtitle: "Understanding planetary retrogrades and their effects", tag: "Featured", category: "Astrology", content: """
            Astrology often gets simplified into warnings, memes, and dramatic forecasts. Few concepts suffer more from this than retrogrades. For many people, the word alone suggests disruption — broken plans, misunderstandings, delays, things going wrong at the worst possible time.
            
            But retrogrades are not chaotic events. They don't exist to punish or derail you. They describe a change in emphasis, not a breakdown of order.
            
            Understanding retrogrades properly means understanding what continues to move forward — and what temporarily turns inward.
            
            This article explains retrogrades without fear, exaggeration, or shortcuts. Not as something to avoid, but as something to work with.
            
            Why Retrogrades Exist at All
            
            From Earth's perspective, a planet occasionally appears to move backward through the zodiac. This apparent reversal isn't physical — the planet doesn't actually change direction — but the effect is meaningful in astrology because astrology is based on perception, timing, and relationship, not raw astronomy.
            
            When a planet enters retrograde, its usual mode of expression becomes less external and less linear. Progress doesn't stop, but it becomes indirect. Instead of pushing forward, attention turns to revision, reflection, correction, or integration.
            
            Retrogrades exist because life itself isn't a straight line.
            
            Some phases are for expansion. Others are for recalibration.
            
            What Changes During a Retrograde
            
            The most important shift during any retrograde is where effort produces results.
            
            During direct motion, planets tend to express outwardly. Actions have visible consequences. Decisions move things forward. Momentum is rewarded.
            
            During retrograde motion, effort still matters — but results show up internally first. Awareness deepens before outcomes change. What feels slow externally is often active beneath the surface.
            
            This is why retrogrades feel uncomfortable when approached with the wrong expectations. If you try to force progress in the usual way, friction increases. If you adjust how you engage, the same period can become clarifying rather than frustrating.
            
            Retrogrades don't block movement. They change the direction of growth.
            
            Mercury Retrograde: Information, Not Chaos
            
            Mercury retrograde has developed the worst reputation of all, largely because it affects areas people rely on daily: communication, technology, scheduling, and coordination.
            
            When Mercury is retrograde, information flows differently. Messages are more easily misunderstood. Details that were assumed become relevant again. Systems reveal weak points.
            
            This doesn't mean "don't communicate." It means communicate with awareness.
            
            Conversations benefit from clarification. Plans benefit from flexibility. Assumptions benefit from being questioned.
            
            Mercury retrograde often surfaces unfinished conversations, overlooked details, or outdated agreements — not to create trouble, but to bring coherence back to systems that were moving too quickly to notice their own gaps.
            
            Venus Retrograde: Values Under Review
            
            Venus retrograde doesn't remove love, pleasure, or connection. It asks deeper questions about them.
            
            During this period, people often reassess what they value, how they relate, and what they expect from connection — whether romantic, social, or financial. Old patterns become visible not because something is "wrong," but because awareness has shifted.
            
            Venus retrograde favors reflection over action. It's less about starting new commitments and more about understanding existing ones. What feels uncomfortable now often points to values that no longer align as cleanly as they once did.
            
            This is a time for honesty, not urgency.
            
            Mars Retrograde: Energy Recalibration
            
            Mars governs action, drive, and assertion. When Mars is retrograde, energy doesn't disappear — it becomes less direct.
            
            This is often experienced as frustration, hesitation, or a sense that effort doesn't land the way it used to. The instinct to push harder rarely helps. What works better is reworking how effort is applied.
            
            Mars retrograde is especially useful for identifying wasted energy, reactive behavior, or goals driven by pressure rather than intention. When forward momentum slows, precision matters more than force.
            
            Outer Planet Retrogrades: Subtle but Significant
            
            Jupiter, Saturn, Uranus, Neptune, and Pluto spend a large portion of every year in retrograde. Because of their distance, their retrogrades feel less personal on a daily level — but they shape long-term growth.
            
            Outer planet retrogrades work gradually. They influence belief systems, responsibilities, power dynamics, ideals, and transformation over time. Their effects are cumulative rather than immediate.
            
            This is why they often go unnoticed at first. The changes they initiate become clear in hindsight, not in headlines.
            
            What Retrogrades Do Not Do
            
            Retrogrades do not cause bad luck.
            They do not cancel progress.
            They do not invalidate decisions.
            They do not make life stop working.
            
            What they do is slow down external validation.
            
            If something truly aligns, it survives review.
            If something doesn't, retrogrades reveal that — gently or not.
            
            Working With Retrogrades Instead of Against Them
            
            The most effective way to work with retrogrades is not avoidance, but alignment.
            
            This means revisiting instead of initiating, clarifying instead of assuming, adjusting instead of forcing, listening instead of pushing.
            
            Retrogrades reward awareness. They punish autopilot.
            
            When used consciously, they become periods of refinement — the difference between moving fast and moving well.
            
            When Retrogrades Matter Most
            
            Retrogrades matter most when life feels stalled, confusing, or repetitive. These moments are rarely random. They signal that something requires attention before forward motion resumes cleanly.
            
            Understanding retrogrades doesn't make life predictable. It makes it intelligible.
            
            And intelligibility is power.
            
            How This Fits Inside the App
            
            Retrogrades connect directly to timing cycles, planetary transits, monthly and daily guidance, and long-term personal patterns. This article gives context. The app gives timing. Together, they help you move with awareness instead of reacting to noise.
            """, author: nil, relatedArticles: ["lh-009", "lh-011", "lh-001"], oneLineDescription: "Understanding planetary retrogrades and their actual effects on your life.", whenToUse: ["During retrograde periods", "Things feeling stuck", "Understanding timing"], difficulty: .beginner),
        
        "lh-011": Article(id: "lh-011", title: "Transits vs Natal Chart", subtitle: "How birth charts and transits work together", tag: "Featured", category: "Astrology", content: """
            Your natal chart shows your fundamental nature and potential. Transits show current activations and opportunities. Both matter, but in different ways.
            
            Your natal chart is the foundation — it describes who you are at your core. Transits activate different parts of it at different times. Understanding how they work together helps you make sense of why certain periods feel significant and others don't.
            
            How Natal Charts and Transits Work Together
            
            Your natal chart shows your fundamental nature — your personality, tendencies, and potential. It's like a blueprint. But blueprints don't tell you when things will be built.
            
            Transits show when planetary energy activates different parts of your chart. A Saturn transit to your natal Sun creates a period of taking responsibility for your identity. A Jupiter transit to your natal Venus expands your relationships and values. The transit activates what's already in your chart.
            
            Major transits (Saturn return, Jupiter return, etc.) create significant life changes. These are periods when foundational planets return to their natal positions or make major aspects. They mark major life transitions.
            
            Minor transits create daily fluctuations. The Moon moving through signs creates daily emotional shifts. Mercury aspects create daily communication patterns. These are smaller activations, but they still matter.
            
            The most important transits are those that aspect your natal planets, especially personal planets (Sun, Moon, Mercury, Venus, Mars). These create the most noticeable effects because they activate your core identity and needs.
            
            When to Focus on Natal vs Transits
            
            Use your natal chart to understand your fundamental nature. It shows your personality, tendencies, and potential. It explains why you're drawn to certain things and why certain patterns repeat.
            
            Use transits to understand timing and current opportunities. They show when energy is building, when it's releasing, and when conditions are favorable for certain actions.
            
            During major life transitions, transits explain why things are shifting. During stable periods, your natal chart explains your ongoing patterns. Both are always active, but their emphasis shifts.
            
            Working With Transits Consciously
            
            Transits don't control you — they activate energy. Working with them consciously means understanding what's being activated and how to work with that energy.
            
            A Saturn transit to your natal Sun asks you to take responsibility for your identity. This isn't punishment — it's structure asking to be built. Working with it consciously means building that structure rather than resisting it.
            
            A Jupiter transit to your natal Venus expands your relationships and values. Working with it consciously means opening to that expansion rather than staying closed.
            
            Transits reward awareness. They punish autopilot. Understanding what's being activated helps you work with it rather than against it.
            
            When This Matters Most
            
            This matters most during major life transitions, when trying to understand timing, or when current events don't make sense through your natal chart alone.
            
            If you're going through a major life change, transits explain why. If you're wondering when to act, transits show timing. If your natal chart doesn't explain what's happening, transits fill in the gaps.
            
            How This Fits Inside the App
            
            Your natal chart appears throughout the app. Transits appear in your timing features. Understanding how they work together helps you make sense of both your fundamental nature and current opportunities. Check your transits to see what's being activated in your chart.
            """, author: nil, relatedArticles: ["lh-006", "lh-010", "lh-001"], oneLineDescription: "Understanding the relationship between your birth chart and current planetary movements.", whenToUse: ["Major life transitions", "Understanding timing", "Making sense of current events"], difficulty: .intermediate),
        
        "lh-012": Article(id: "lh-012", title: "Astrology as Pattern Language", subtitle: "Recognizing patterns, not predicting future", tag: "Featured", category: "Astrology", content: """
            Astrology is often treated as prediction — what will happen, when it will happen, how it will happen. But that's not how it actually works.
            
            Astrology is a language for understanding patterns, not a tool for prediction. Your chart shows tendencies, potentials, and patterns that are likely to repeat. Understanding these patterns helps you work with them consciously rather than being controlled by them.
            
            Why Patterns Repeat
            
            Patterns repeat because they're part of your nature. A Saturn square to your Sun creates a pattern of responsibility challenges. This pattern will likely repeat throughout your life because it's built into your chart. Recognizing the pattern helps you work with it rather than being surprised by it repeatedly.
            
            If you have a pattern of relationship challenges (Venus square Saturn), astrology helps you understand why this pattern exists and how to work with it. It doesn't predict failure — it reveals the pattern so you can address it consciously.
            
            Patterns aren't fate. They're tendencies. Understanding them gives you choice. You can work with them consciously rather than repeating them unconsciously.
            
            How Patterns Show Up
            
            Patterns appear in different ways. A challenging aspect creates a pattern that plays out in different situations. A dominant planet creates themes that repeat. A house emphasis creates life areas where patterns are most active.
            
            A Saturn square to your Sun might show up as challenges with authority, responsibility, or structure. The pattern is the same, but it manifests differently in different situations. Understanding the pattern helps you see the connection between seemingly different experiences.
            
            Patterns also show up in timing. Saturn returns create patterns of building structure. Jupiter transits create patterns of expansion. Understanding timing patterns helps you work with cycles rather than fighting them.
            
            Working With Patterns Consciously
            
            Use astrology to recognize patterns in your life. Once you see the pattern, you can work with it consciously rather than repeating it unconsciously.
            
            If you notice a pattern of relationship challenges, look at your Venus aspects. If you notice a pattern of authority issues, look at your Saturn aspects. The chart shows why the pattern exists and what you're learning from it.
            
            Working with patterns consciously means understanding what they're teaching you. A Saturn square teaches about responsibility and structure. A Venus square teaches about love and values. Understanding the lesson helps you integrate it rather than repeating it.
            
            When This Matters Most
            
            This matters most when you're noticing repeating patterns or when astrology predictions don't resonate. Understanding astrology as pattern language makes it more useful.
            
            If predictions don't resonate, it's because astrology isn't about fixed outcomes — it's about patterns and possibilities. If patterns keep repeating, understanding them helps you work with them consciously.
            
            How This Fits Inside the App
            
            Patterns appear throughout your chart reading. Understanding astrology as pattern language helps you make sense of repeating themes and tendencies. Explore your chart to see which patterns are most active and how to work with them.
            """, author: nil, relatedArticles: ["lh-001", "lh-004", "lh-005"], oneLineDescription: "Understanding astrology as a framework for recognizing patterns rather than predicting the future.", whenToUse: ["Noticing repeating patterns", "Predictions not resonating", "Understanding astrology's purpose"], difficulty: .intermediate),
        
        "lh-013": Article(id: "lh-013", title: "Why Situations Repeat", subtitle: "Understanding repeating patterns and how to work with them", tag: "Featured", category: "Astrology", content: """
            You keep having the same type of relationship problem. The same work issue repeats. The same conflict pattern appears again and again. Why?
            
            Repeating situations happen because they're connected to patterns in your birth chart. A challenging aspect creates a pattern that plays out in different ways throughout your life. Understanding the pattern helps you address it at its source.
            
            How Chart Patterns Create Repeating Situations
            
            Challenging aspects (squares, oppositions) create tension. These tensions manifest as repeating situations until you integrate them. The situation changes when you learn the lesson the aspect is teaching.
            
            If you keep having authority issues, look for Saturn aspects in your chart. Saturn square Sun creates tension between identity and responsibility. This tension plays out as authority challenges until you learn to integrate responsibility with identity.
            
            If relationship patterns repeat, examine Venus aspects. Venus square Mars creates tension between love and desire. This tension plays out as relationship challenges until you learn to integrate love and desire.
            
            The pattern isn't random. It's teaching you something. Understanding what it's teaching helps you work with it rather than repeating it.
            
            Finding the Pattern in Your Chart
            
            Identify repeating situations in your life. What keeps happening? What themes repeat? What challenges come up again and again?
            
            Then find the corresponding chart pattern. Look for challenging aspects that relate to the repeating situation. A relationship pattern might connect to Venus aspects. A work pattern might connect to Saturn or Mars aspects. An identity pattern might connect to Sun aspects.
            
            The chart shows why the pattern exists and what you're learning from it. Understanding this helps you address it at its source rather than just managing symptoms.
            
            Working With Patterns Consciously
            
            Once you see the pattern, understand what it's teaching you. A Saturn square teaches about responsibility and structure. A Venus square teaches about love and values. A Mars square teaches about action and boundaries.
            
            Work with the pattern consciously rather than repeating it unconsciously. If you have a Saturn square, work on integrating responsibility rather than resisting it. If you have a Venus square, work on integrating love and desire rather than keeping them separate.
            
            The pattern continues until you learn the lesson. Understanding what you're learning helps you integrate it faster.
            
            When This Matters Most
            
            This matters most when you're frustrated by repeating patterns or when you want to understand why certain situations keep happening.
            
            If you're tired of the same problem repeating, understanding the chart pattern helps you see why and how to work with it. If you want to break a cycle, understanding the pattern helps you address it at its source.
            
            How This Fits Inside the App
            
            Repeating patterns appear throughout your chart reading. Understanding why situations repeat helps you work with them consciously. Explore your challenging aspects to see which patterns are most active and what they're teaching you.
            """, author: nil, relatedArticles: ["lh-004", "lh-012", "lh-001"], oneLineDescription: "Understanding why certain situations keep happening and how to work with them.", whenToUse: ["Frustrated by repeating patterns", "Understanding recurring situations", "Wanting to break cycles"], difficulty: .intermediate),
        
        "lh-014": Article(id: "lh-014", title: "When Astrology Is Most Useful", subtitle: "Understanding astrology's strengths and limitations", tag: "Featured", category: "Astrology", content: """
            Astrology is often treated as if it can do everything — predict the future, make decisions, explain every event. But that's not how it works.
            
            Astrology is excellent for understanding patterns, tendencies, and potential. It's less useful for specific predictions, making decisions for you, or explaining everything that happens. Understanding its strengths and limitations makes it more useful.
            
            What Astrology Does Well
            
            Astrology is most useful for understanding personality patterns, recognizing life themes, understanding timing, seeing relationship dynamics, and gaining self-awareness.
            
            It helps you understand why you're drawn to certain types of relationships (Venus placement). It shows why certain patterns repeat (challenging aspects). It reveals when energy is building or releasing (transits). It provides context for understanding yourself and your life.
            
            Astrology is a language for understanding patterns. It's excellent at revealing tendencies, potentials, and themes. It helps you see connections between seemingly different experiences.
            
            What Astrology Doesn't Do
            
            Astrology is less useful for specific predictions, making decisions for you, explaining random events, or replacing professional help.
            
            It doesn't tell you whether to stay in a specific relationship — that requires your judgment. It doesn't predict exact events — it shows patterns and possibilities. It doesn't explain everything that happens — some things are just random. It doesn't replace therapy, medical care, or professional advice.
            
            Astrology provides context; you make decisions. It shows patterns; you choose how to work with them. It reveals possibilities; you determine what's right for you.
            
            Using Astrology Effectively
            
            Use astrology for self-understanding and pattern recognition. Use your judgment for decisions. Don't let astrology replace your agency or professional help when needed.
            
            If astrology helps you understand a pattern, use that understanding to make better decisions. If astrology shows timing, use that awareness to plan actions. But don't let astrology make decisions for you — that's your responsibility.
            
            If you're struggling with something serious, get professional help. Astrology can provide context, but it's not a substitute for therapy, medical care, or professional advice.
            
            When This Matters Most
            
            This matters most when you're relying too heavily on astrology or when astrology isn't helping. Understanding its proper role makes it more useful.
            
            If you're checking astrology for every decision, you might be relying too heavily on it. If astrology isn't helping you understand yourself better, you might be using it incorrectly. Understanding its strengths and limitations helps you use it effectively.
            
            How This Fits Inside the App
            
            The app provides astrology insights for self-understanding and pattern recognition. Use these insights to understand yourself better, but remember that you make your own decisions. Astrology provides context; you determine what's right for you.
            """, author: nil, relatedArticles: ["lh-012", "lh-050", "lh-001"], oneLineDescription: "Understanding astrology's strengths and limitations as a tool for self-understanding.", whenToUse: ["Setting realistic expectations", "Understanding astrology's role", "Using astrology effectively"], difficulty: .beginner),
        
        // TAROT ARTICLES (12 articles)
        "lh-015": Article(id: "lh-015", title: "How Tarot Works Beyond Meanings", subtitle: "Tarot as symbols and relationships, not memorization", tag: "Featured", category: "Tarot", content: """
            Most people learn tarot by memorizing what each card means. The Tower means sudden change. The Star means hope. But cards don't work that way in practice.
            
            Tarot cards are symbols that gain meaning through context, relationships, and intuition. Memorizing card meanings is less important than understanding how symbols work together. A card's meaning changes based on surrounding cards, the question asked, and your intuitive response.
            
            How Cards Gain Meaning
            
            Cards have multiple layers: literal meaning, symbolic meaning, intuitive meaning, and relational meaning (how it interacts with other cards). The most important meaning emerges from how these layers combine in a specific reading.
            
            The Tower card alone might mean sudden change. Next to the Star, it might mean necessary breakdown leading to hope. In a relationship reading, it might mean the relationship structure needs to change. Context creates meaning.
            
            The same card in different contexts means different things. Understanding this changes how you read. Instead of forcing memorized meanings, you let meaning emerge from the reading.
            
            How Cards Interact
            
            Cards modify each other. A positive card next to a challenging card creates nuance. A challenging card next to another challenging card creates intensity. Understanding how cards interact helps you read more accurately.
            
            The Tower next to the Star suggests breakdown leading to hope. The Tower next to the Ten of Swords suggests breakdown leading to pain. The same card, different context, different meaning.
            
            Pay attention to how cards interact. Notice which cards modify others. See how combinations create meaning that individual cards can't capture alone.
            
            Trusting Your Intuitive Response
            
            Your intuitive response to card combinations matters. If a card combination feels different than its memorized meaning, trust that feeling. Your intuition is reading the context, not just the individual cards.
            
            Learn card meanings as starting points, not fixed definitions. Use them to understand symbols, but let meaning emerge from how cards interact in specific readings.
            
            When card meanings don't seem to fit, it's often because context is modifying them. Trust your intuitive response to see what the cards are actually saying.
            
            When This Matters Most
            
            This matters most when card meanings don't seem to fit, when readings feel disconnected, or when you want to read more intuitively.
            
            If memorized meanings aren't working, it's because context is modifying them. Understanding how cards interact helps you read more accurately. If you want to read more intuitively, focus on relationships rather than definitions.
            
            How This Fits Inside the App
            
            Tarot readings in the app show card relationships and context. Understanding how cards work together helps you make sense of readings. Pay attention to how cards interact rather than just individual meanings.
            """, author: nil, relatedArticles: ["lh-016", "lh-017", "lh-018"], oneLineDescription: "Understanding tarot as a system of symbols and relationships rather than memorized definitions.", whenToUse: ["Card meanings not fitting", "Wanting intuitive reading", "Understanding tarot's system"], difficulty: .intermediate),
        
        "lh-016": Article(id: "lh-016", title: "Major vs Minor Arcana", subtitle: "How these two card types work together", tag: "Featured", category: "Tarot", content: """
            A tarot deck has two types of cards: Major Arcana and Minor Arcana. Understanding the difference changes how you read.
            
            Major Arcana (22 cards) represent major life themes, spiritual lessons, and archetypal experiences. Minor Arcana (56 cards) represent daily experiences, practical situations, and how major themes play out in everyday life. Both are necessary for complete readings.
            
            How They Work Together
            
            Major Arcana cards are like chapters in your life story — major themes and lessons. Minor Arcana cards are like scenes within those chapters — daily experiences and practical details. A reading needs both to tell a complete story.
            
            The Fool (Major Arcana) represents a major new beginning or leap of faith. The Ace of Wands (Minor Arcana) represents a new creative spark or inspiration. Together, they might mean a major new beginning specifically around creativity or passion.
            
            When Major Arcana cards appear, they indicate significant themes. These are moments that matter — major transitions, important lessons, or archetypal experiences. They show the big picture.
            
            Minor Arcana cards show how major themes manifest in daily life. They provide practical details, everyday situations, and specific expressions of larger themes. They show the details.
            
            Reading Them Together
            
            Notice when Major Arcana cards appear — they indicate significant themes. Use Minor Arcana to understand practical details. Read them together to see how major themes manifest in daily life.
            
            A reading with mostly Major Arcana suggests major life themes and transitions. A reading with mostly Minor Arcana suggests daily experiences and practical situations. A balanced reading shows both the big picture and the details.
            
            When This Matters Most
            
            This matters most when readings feel incomplete or when you're unsure how to interpret card combinations. Understanding the difference helps you read more accurately.
            
            If a reading feels incomplete, check the balance between Major and Minor Arcana. If you're unsure how to interpret combinations, understanding which type each card is helps you see how they work together.
            
            How This Fits Inside the App
            
            The app shows both Major and Minor Arcana cards in readings. Understanding how they work together helps you make sense of card combinations. Pay attention to the balance between major themes and daily details.
            """, author: nil, relatedArticles: ["lh-015", "lh-017", "lh-019"], oneLineDescription: "Understanding the difference between Major and Minor Arcana and how they work together.", whenToUse: ["Readings feeling incomplete", "Understanding card types", "Interpreting combinations"], difficulty: .beginner),
        
        "lh-017": Article(id: "lh-017", title: "Reading Tarot for Insight", subtitle: "Tarot as reflection and self-awareness", tag: "Featured", category: "Tarot", content: """
            Tarot is often treated as fortune-telling — what will happen, when it will happen, how it will happen. But that's not how it actually works.
            
            Tarot works best as a mirror for self-reflection, not a crystal ball for prediction. Cards reflect your current energy, patterns, and possibilities. The insight comes from how you respond to what the cards show, not from the cards telling you what will happen.
            
            Why Prediction Doesn't Work
            
            Instead of asking "Will I get the job?" ask "What do I need to know about this job opportunity?" The cards show patterns, possibilities, and what you need to consider, not a yes/no answer.
            
            Prediction assumes the future is fixed. But the future isn't fixed — it's shaped by your choices, awareness, and actions. Tarot shows possibilities, not certainties.
            
            When you ask predictive questions, you're looking for certainty that doesn't exist. When you ask reflective questions, you're looking for awareness that helps you make better choices.
            
            How Reflection Works
            
            Approach readings with curiosity rather than seeking answers. Ask "What do I need to see?" rather than "What will happen?" Use cards to explore possibilities and patterns rather than seeking certainty.
            
            Cards reflect your current energy, patterns, and possibilities. They show what's present now, what patterns are active, and what possibilities exist. The insight comes from how you respond to what you see.
            
            Frame questions for insight rather than prediction. Use cards to explore patterns and possibilities. Reflect on what the cards reveal about your current situation and energy.
            
            When This Matters Most
            
            This matters most when you're seeking answers you can't find, when readings feel unhelpful, or when you want to use tarot more effectively.
            
            If you're seeking answers you can't find, it's because you're asking predictive questions. If readings feel unhelpful, it's because you're looking for certainty instead of awareness. If you want to use tarot more effectively, focus on reflection rather than prediction.
            
            How This Fits Inside the App
            
            The app provides tarot readings for reflection and self-awareness. Use readings to explore patterns and possibilities rather than seeking predictions. Focus on what you need to see rather than what will happen.
            """, author: nil, relatedArticles: ["lh-015", "lh-020", "lh-021"], oneLineDescription: "Understanding tarot as a tool for reflection and self-awareness rather than prediction.", whenToUse: ["Seeking insight", "Readings feeling unhelpful", "Using tarot effectively"], difficulty: .beginner),
        
        "lh-018": Article(id: "lh-018", title: "Why Contradictory Cards Appear", subtitle: "How opposing cards reveal complexity", tag: "Featured", category: "Tarot", content: """
            You pull cards and they seem to contradict each other. The Sun (joy) next to the Ten of Swords (pain). The Fool (new beginnings) next to the Tower (breakdown). What does this mean?
            
            Contradictory cards appear together because life is complex and situations have multiple layers. Opposing cards don't cancel each other out — they show different aspects of the same situation or internal conflicts that need integration.
            
            Why Contradictions Happen
            
            When contradictory cards appear, look for different aspects of the situation, internal conflicts, timing differences, or the need to integrate opposing energies. The contradiction is the message.
            
            The Sun (joy) next to the Ten of Swords (pain) might mean joy comes after letting go of something painful, or that there's joy and pain coexisting in the situation. Both can be true at the same time.
            
            Life isn't simple. Situations have multiple layers. You can feel joy and pain simultaneously. You can experience new beginnings and breakdowns at the same time. Contradictions reflect this complexity.
            
            How to Read Contradictions
            
            Don't dismiss contradictory cards. Explore how they relate. Look for what needs to be integrated. Understand that complexity is normal.
            
            Contradictions show internal conflicts that need integration. They show different aspects of the same situation. They show timing differences — what's happening now versus what's coming.
            
            The contradiction is the message. Understanding how opposing cards relate helps you see the full picture rather than just one side.
            
            When This Matters Most
            
            This matters most when readings seem confusing or contradictory. Understanding contradictions helps you read more accurately.
            
            If readings seem confusing, it's often because contradictions aren't being addressed. If cards seem contradictory, explore how they relate rather than dismissing them. Understanding contradictions helps you read more accurately.
            
            How This Fits Inside the App
            
            The app shows card relationships in readings. Understanding contradictions helps you make sense of opposing cards. Pay attention to how contradictory cards relate rather than dismissing them.
            """, author: nil, relatedArticles: ["lh-015", "lh-017", "lh-019"], oneLineDescription: "Understanding how opposing cards create meaning and reveal complexity.", whenToUse: ["Readings seem confusing", "Contradictory cards appearing", "Understanding complexity"], difficulty: .intermediate),
        
        "lh-019": Article(id: "lh-019", title: "Reading the Celtic Cross as Story", subtitle: "How to read the spread as integrated narrative", tag: "Featured", category: "Tarot", content: """
            The Celtic Cross is often read position by position — card one means this, card two means that. But that misses how the spread actually works.
            
            The Celtic Cross tells a story when you read positions in relationship. Each position modifies others. The story emerges from how cards interact across positions, not from individual card meanings.
            
            How Positions Work Together
            
            Read positions in groups: foundation (past positions), present situation (center cross), future (future positions), and outcome. Then read how these groups relate to create the full story.
            
            If past cards show conflict and present cards show peace, the story is about moving from conflict to peace. If future cards show challenge and outcome shows success, the story is about overcoming obstacles.
            
            Each position modifies others. The past positions show what led to the present. The present positions show what's happening now. The future positions show what's coming. The outcome shows where it all leads.
            
            Building the Story
            
            Read positions in relationship. Look for themes that connect positions. Build the story from how positions interact.
            
            Don't read each card in isolation. See how cards across positions relate. Notice themes that connect different positions. Build the story from how positions interact.
            
            The story emerges from relationships, not individual meanings. Understanding how positions relate helps you see the full narrative rather than disconnected pieces.
            
            When This Matters Most
            
            This matters most when Celtic Cross readings feel disconnected or when you want to read more effectively.
            
            If readings feel disconnected, it's because positions aren't being read in relationship. If you want to read more effectively, focus on how positions interact rather than individual card meanings.
            
            How This Fits Inside the App
            
            The app shows Celtic Cross spreads with position relationships. Understanding how positions work together helps you read spreads as integrated narratives. Pay attention to how positions interact rather than just individual cards.
            """, author: nil, relatedArticles: ["lh-015", "lh-018", "lh-020"], oneLineDescription: "Learning to read the Celtic Cross spread as an integrated narrative.", whenToUse: ["Celtic Cross readings", "Readings feeling disconnected", "Reading effectively"], difficulty: .intermediate),
        
        "lh-020": Article(id: "lh-020", title: "Three-Card Spreads", subtitle: "Using simple spreads for clarity", tag: "Featured", category: "Tarot", content: """
            Complex spreads aren't always better. Sometimes simplicity creates clarity.
            
            Three-card spreads are powerful because they're simple enough to see relationships clearly. Common patterns: past/present/future, situation/action/outcome, option A/option B/advice, or mind/body/spirit.
            
            Why Three Cards Work
            
            Three cards create enough structure to see relationships without overwhelming complexity. You can see how cards interact, how they relate, and what story they tell together.
            
            Past/present/future shows progression. Situation/action/outcome shows what to do. Option A/option B/advice helps with decisions. Each pattern serves a different purpose.
            
            The simplicity makes relationships clear. With three cards, you can see how they connect. With more cards, relationships can get lost in complexity.
            
            Choosing the Right Pattern
            
            Choose a pattern that matches your question. Read cards in relationship. Look for the story they tell together. Use the simplicity to see clearly.
            
            If you want to understand progression, use past/present/future. If you want to know what to do, use situation/action/outcome. If you're deciding between options, use option A/option B/advice.
            
            Match the spread to your question. The pattern should help you see what you need to see.
            
            Reading Three Cards Together
            
            Read cards together, not separately. Look for the story they tell together. Trust the simplicity.
            
            Don't read each card in isolation. See how they relate. Notice the story they tell together. Use the simplicity to see clearly.
            
            When This Matters Most
            
            This matters most when you need quick guidance or when complex spreads feel overwhelming.
            
            If you need quick guidance, three-card spreads provide clarity without complexity. If complex spreads feel overwhelming, simplicity helps you see what matters.
            
            How This Fits Inside the App
            
            The app offers three-card spreads for quick guidance. Use them when you need clarity without complexity. Trust the simplicity to see what matters.
            """, author: nil, relatedArticles: ["lh-017", "lh-021", "lh-015"], oneLineDescription: "Using simple three-card spreads for clarity and guidance.", whenToUse: ["Quick guidance", "Decision-making", "Daily readings"], difficulty: .beginner),
        
        "lh-021": Article(id: "lh-021", title: "Court Cards as Archetypes", subtitle: "Understanding court cards as personality aspects", tag: "Featured", category: "Tarot", content: """
            Court cards are often read as specific people — this person is a Queen of Cups, that person is a Knight of Wands. But that's too limiting.
            
            Court cards represent ways of being and expressing energy, not necessarily specific people. They can represent you, others, or aspects of yourself that need expression. Understanding them as archetypes makes them more useful.
            
            How Court Cards Work
            
            Pages are learning and curiosity. Knights are action and movement. Queens are nurturing and receptivity. Kings are mastery and authority. Each suit adds its element's qualities.
            
            The Knight of Wands is passionate action. The Queen of Cups is emotional nurturing. They can represent you, someone else, or qualities you need to develop.
            
            Court cards show energy types and archetypes. They represent ways of being, not fixed identities. Understanding them as archetypes helps you see their flexibility.
            
            Reading Court Cards Flexibly
            
            See court cards as energy types and archetypes. Consider whether they represent you, others, or qualities to develop.
            
            A court card might represent you in a specific situation. It might represent someone else. It might represent qualities you need to develop or integrate. The flexibility makes readings more accurate.
            
            Don't limit court cards to specific people. See them as energy types and archetypes. Consider all possibilities.
            
            When This Matters Most
            
            This matters most when court cards are confusing or when you want to understand them better.
            
            If court cards are confusing, it's often because they're being read too literally. If you want to understand them better, see them as archetypes rather than specific people.
            
            How This Fits Inside the App
            
            The app shows court cards in readings. Understanding them as archetypes helps you read them flexibly. Consider whether they represent you, others, or qualities to develop.
            """, author: nil, relatedArticles: ["lh-015", "lh-016", "lh-022"], oneLineDescription: "Understanding court cards as different aspects of personality and energy.", whenToUse: ["Court cards confusing", "Understanding personality types", "Reading court cards"], difficulty: .intermediate),
        
        "lh-022": Article(id: "lh-022", title: "Repeating Cards", subtitle: "Why certain cards appear repeatedly", tag: "Featured", category: "Tarot", content: """
            The same card keeps appearing in your readings. The Tower. The Hermit. The Three of Cups. Why?
            
            Repeating cards signal themes that need attention. The repetition means the energy or lesson isn't complete. Pay attention to what the card represents and why it keeps appearing.
            
            Why Cards Repeat
            
            Notice which cards repeat. Consider what theme they represent. Ask what you need to learn or integrate. The repetition continues until you address the theme.
            
            If the Tower keeps appearing, you might be resisting necessary change. If the Hermit appears repeatedly, you might need more introspection. The repetition is the message.
            
            Cards repeat because the energy or lesson isn't complete. The card is trying to get your attention. The repetition continues until you address what it's showing you.
            
            Working With Repeating Cards
            
            Track repeating cards. Understand what they represent. Work with the theme consciously.
            
            Don't ignore repeating cards. They're trying to tell you something. Understand what theme they represent. Work with that theme consciously rather than ignoring it.
            
            The repetition continues until you address the theme. Understanding what the card represents helps you work with it rather than against it.
            
            When This Matters Most
            
            This matters most when you notice cards repeating or when readings feel stuck.
            
            If cards keep repeating, it's because the theme needs attention. If readings feel stuck, repeating cards might show you why. Understanding repetition helps you work with themes consciously.
            
            How This Fits Inside the App
            
            The app tracks your readings. Notice which cards repeat across readings. Understanding repetition helps you see themes that need attention. Work with repeating cards consciously rather than ignoring them.
            """, author: nil, relatedArticles: ["lh-015", "lh-022", "lh-023"], oneLineDescription: "Understanding why certain cards appear repeatedly and what it means.", whenToUse: ["Cards repeating", "Themes needing attention", "Understanding patterns"], difficulty: .beginner),
        
        "lh-023": Article(id: "lh-023", title: "Tarot and Emotional Timing", subtitle: "How tarot reflects emotional cycles", tag: "Featured", category: "Tarot", content: """
            Tarot readings sometimes don't match events. You pull cards expecting one thing, but something else happens. Why?
            
            Tarot reflects your current emotional state and where you are in emotional cycles. Cards show emotional timing, not just events. Understanding this helps you read more accurately.
            
            How Cards Reflect Emotional States
            
            Cards reflect where you are emotionally. Wands show passion and action phases. Cups show emotional phases. Swords show mental phases. Pentacles show practical phases.
            
            Multiple Cups cards might mean you're in an emotional phase. Multiple Swords might mean a mental or conflict phase. The cards reflect your emotional state.
            
            Cards show emotional timing, not just events. They reflect where you are in emotional cycles, not just what's happening externally. Understanding this helps you read more accurately.
            
            Understanding Emotional Phases
            
            Notice which suits dominate. Understand what emotional phase you're in. Read cards in relation to emotional timing.
            
            If Cups dominate, you're in an emotional phase. If Swords dominate, you're in a mental or conflict phase. If Wands dominate, you're in a passion and action phase. If Pentacles dominate, you're in a practical phase.
            
            Understanding which phase you're in helps you read cards more accurately. Cards reflect emotional timing, not just events.
            
            When This Matters Most
            
            This matters most when readings don't seem to match events or when you want to understand emotional cycles.
            
            If readings don't match events, it's often because cards are reflecting emotional timing rather than external events. If you want to understand emotional cycles, notice which suits dominate and what phase you're in.
            
            How This Fits Inside the App
            
            The app shows card suits in readings. Understanding how suits reflect emotional phases helps you read more accurately. Pay attention to which suits dominate and what emotional phase you're in.
            """, author: nil, relatedArticles: ["lh-016", "lh-022", "lh-024"], oneLineDescription: "Understanding how tarot reflects emotional cycles and timing.", whenToUse: ["Understanding emotional cycles", "Readings not matching events", "Emotional timing"], difficulty: .beginner),
        
        "lh-024": Article(id: "lh-024", title: "Asking Better Questions", subtitle: "How to frame questions for useful insights", tag: "Featured", category: "Tarot", content: """
            How you ask questions determines what insights you receive. The question shapes the reading.
            
            Open-ended questions lead to exploration. Specific questions lead to focused answers. Good questions explore patterns, seek understanding, and focus on what you can control. Less useful questions seek yes/no answers, ask about others' feelings, or seek prediction without reflection.
            
            Why Question Structure Matters
            
            Instead of "Will they call?" ask "What do I need to understand about this relationship?" Instead of "What will happen?" ask "What patterns am I seeing?"
            
            Yes/no questions limit insights. They seek certainty that doesn't exist. Open-ended questions create exploration and understanding.
            
            Questions about others' feelings seek information you can't know. Questions about what you can control create actionable insights.
            
            Framing Better Questions
            
            Frame questions for insight. Focus on what you can understand or control. Use open-ended questions for exploration.
            
            Good questions explore patterns, seek understanding, and focus on what you can control. They create space for insight rather than seeking certainty.
            
            Less useful questions seek yes/no answers, ask about others' feelings, or seek prediction without reflection. They limit insights and create frustration.
            
            When This Matters Most
            
            This matters most when readings aren't helpful or when you want more useful insights.
            
            If readings aren't helpful, check your questions. If you want more useful insights, frame questions for exploration rather than certainty.
            
            How This Fits Inside the App
            
            The app helps you frame questions for insight. Use open-ended questions that explore patterns and seek understanding. Focus on what you can control rather than seeking predictions.
            """, author: nil, relatedArticles: ["lh-017", "lh-020", "lh-025"], oneLineDescription: "Learning how to frame questions that lead to useful insights.", whenToUse: ["Readings not helpful", "Wanting better insights", "Framing questions"], difficulty: .beginner),
        
        "lh-025": Article(id: "lh-025", title: "Tarot as Reflection Tool", subtitle: "Using tarot for self-reflection", tag: "Featured", category: "Tarot", content: """
            Tarot works as a mirror, reflecting your current energy, patterns, and inner state. The cards show what you need to see about yourself, not external events. Using tarot for reflection creates self-awareness.
            
            How Reflection Works
            
            Use tarot to explore current patterns, inner conflicts, growth areas, and self-understanding. Approach readings with curiosity about yourself rather than seeking external answers.
            
            Cards showing conflict might reflect internal conflict. Cards showing stagnation might reflect where you're stuck. The reflection creates awareness.
            
            Tarot reflects your inner world, not external events. The cards show what you need to see about yourself. Understanding this changes how you use tarot.
            
            Using Tarot for Self-Reflection
            
            Use tarot for self-reflection. Ask questions about yourself. Let cards mirror your inner world.
            
            Instead of asking about external events, ask about yourself. Instead of seeking predictions, seek self-understanding. Let cards mirror your inner world.
            
            The reflection creates awareness. Understanding what cards reflect about yourself helps you grow and change.
            
            When This Matters Most
            
            This matters most when you want self-awareness or when readings feel disconnected from events.
            
            If you want self-awareness, use tarot for reflection. If readings feel disconnected from events, it's because cards are reflecting your inner world rather than external events.
            
            How This Fits Inside the App
            
            The app provides tarot readings for self-reflection. Use readings to explore your inner world rather than seeking external predictions. Let cards mirror what you need to see about yourself.
            """, author: nil, relatedArticles: ["lh-017", "lh-025", "lh-026"], oneLineDescription: "Using tarot for self-reflection and personal growth.", whenToUse: ["Self-reflection", "Personal growth", "Self-awareness"], difficulty: .beginner),
        
        "lh-026": Article(id: "lh-026", title: "When Readings Feel Unclear", subtitle: "Why readings feel unclear and how to work with it", tag: "Featured", category: "Tarot", content: """
            Sometimes tarot readings feel unclear. The cards don't make sense. The message is confusing. What does this mean?
            
            Unclear readings happen when the question isn't clear, you're not ready to see the answer, the situation is still developing, or you're resisting what the cards show. Understanding why helps you work with it.
            
            Why Readings Feel Unclear
            
            If readings feel unclear, try reframing the question, waiting and reading again later, looking for what you're resisting, or accepting that some things aren't clear yet.
            
            Unclear readings might mean the situation is still developing. They might mean you're not ready to see something. They might mean you need to look deeper.
            
            Clarity isn't always available immediately. Some things need time to develop. Some things need you to be ready to see them.
            
            Working With Unclear Readings
            
            Don't force clarity. Explore why it's unclear. Reframe questions. Wait if needed.
            
            If the question isn't clear, reframe it. If you're not ready to see something, wait. If the situation is still developing, accept that. If you're resisting what the cards show, look deeper.
            
            Unclear readings aren't failures. They're information. Understanding why they're unclear helps you work with them productively.
            
            When This Matters Most
            
            This matters most when readings feel confusing or when you're frustrated by unclear messages.
            
            If readings feel confusing, explore why rather than forcing clarity. If you're frustrated by unclear messages, understand that clarity isn't always immediate.
            
            How This Fits Inside the App
            
            The app provides readings that might sometimes feel unclear. Don't force clarity. Explore why readings are unclear and work with them productively rather than dismissing them.
            """, author: nil, relatedArticles: ["lh-024", "lh-025", "lh-017"], oneLineDescription: "Understanding why readings sometimes feel unclear and how to work with this.", whenToUse: ["Readings unclear", "Feeling confused", "Working with unclear messages"], difficulty: .beginner),
        
        // NUMEROLOGY ARTICLES (8 articles)
        "lh-027": Article(id: "lh-027", title: "Life Path Numbers", subtitle: "How your Life Path guides your journey", tag: "Featured", category: "Numerology", content: """
            Your Life Path number (calculated from your birth date) represents your life's primary direction and lessons. It shows what you're here to learn and how you naturally move through life. Understanding it helps you align with your path.
            
            What Life Path Numbers Mean
            
            Life Path numbers 1-9 each represent different paths: 1 is leadership and independence, 2 is cooperation and partnership, 3 is creativity and expression, 4 is structure and stability, 5 is freedom and change, 6 is service and responsibility, 7 is introspection and wisdom, 8 is power and achievement, 9 is completion and humanitarianism.
            
            A Life Path 1 learns to lead independently. A Life Path 7 learns through introspection and seeking truth. The number shows your natural path and lessons.
            
            Each number represents a different path and set of lessons. Understanding your number helps you see your natural direction and what you're here to learn.
            
            Working With Your Life Path
            
            Understand your Life Path number's lessons. Work with its energy consciously. Don't resist your path — align with it.
            
            Your Life Path shows your natural direction. Working with it consciously means aligning with that direction rather than fighting it. Understanding the lessons helps you learn them more easily.
            
            Don't resist your path. Align with it. Work with its energy consciously rather than unconsciously.
            
            When This Matters Most
            
            This matters most when you're feeling lost or when you want to understand your life direction.
            
            If you're feeling lost, your Life Path number shows your natural direction. If you want to understand your life direction, understanding your number helps you see it.
            
            How This Fits Inside the App
            
            Your Life Path number appears throughout the app. Understanding it helps you make sense of your natural direction and lessons. Explore your number to see how it guides your journey.
            """, author: nil, relatedArticles: ["lh-028", "lh-029", "lh-030"], oneLineDescription: "Understanding your Life Path number and how it guides your life journey.", whenToUse: ["Feeling lost", "Understanding direction", "Life path questions"], difficulty: .beginner),
        
        "lh-028": Article(id: "lh-028", title: "Personal Year Cycles", subtitle: "How Personal Year cycles affect annual themes", tag: "Featured", category: "Numerology", content: """
            Your Personal Year number (calculated from your birth date and current year) shows the theme and energy of each year. Years cycle 1-9, each with different qualities. Understanding your Personal Year helps you align with annual themes.
            
            How Personal Years Work
            
            Personal Year 1 is new beginnings, Year 2 is cooperation, Year 3 is creativity, Year 4 is building structure, Year 5 is change, Year 6 is service, Year 7 is introspection, Year 8 is achievement, Year 9 is completion.
            
            A Personal Year 1 is good for starting new projects. A Personal Year 7 is good for reflection and inner work. Each year has its purpose.
            
            Years cycle through these themes, creating annual patterns. Understanding which year you're in helps you align with its energy rather than fighting it.
            
            Working With Each Year
            
            Calculate your Personal Year. Understand its theme. Work with the year's energy rather than against it.
            
            If you're in a Year 1, focus on new beginnings. If you're in a Year 7, focus on reflection. If you're in a Year 8, focus on achievement. Working with the year's energy makes it more effective.
            
            Don't fight the year's energy. Align with it. Understanding the theme helps you work with it consciously.
            
            When This Matters Most
            
            This matters most at the start of a new year or when you want to understand annual themes.
            
            If you want to understand annual themes, your Personal Year shows them. If you want to plan for the year, understanding its theme helps you align your actions.
            
            How This Fits Inside the App
            
            Your Personal Year appears in the app's timing features. Understanding it helps you align with annual themes. Check your Personal Year to see what theme is active.
            """, author: nil, relatedArticles: ["lh-027", "lh-029", "lh-037"], oneLineDescription: "Understanding how Personal Year cycles affect your annual themes and opportunities.", whenToUse: ["New year planning", "Understanding annual themes", "Timing decisions"], difficulty: .beginner),
        
        "lh-029": Article(id: "lh-029", title: "Personal Month and Daily Energy", subtitle: "How numerology cycles affect monthly energy", tag: "Featured", category: "Numerology", content: """
            Beyond Personal Years, you have Personal Months and daily numbers that affect shorter-term energy. These cycles help you understand monthly themes and daily energy for better timing and alignment.
            
            How Personal Months Work
            
            Personal Months cycle within your Personal Year, adding monthly themes. Daily numbers add daily energy. Understanding these cycles helps with timing and planning.
            
            A Personal Month 1 in a Personal Year 5 might mean a month of new beginnings within a year of change. Daily numbers add specific energy to each day.
            
            Personal Months add monthly themes to your annual theme. Daily numbers add daily energy to your monthly theme. Understanding these layers helps with timing.
            
            Using Cycles for Timing
            
            Calculate Personal Months and daily numbers. Understand their themes. Use them for timing and planning.
            
            If you're planning activities, check your Personal Month and daily numbers. If you want to understand daily energy, daily numbers show it. Understanding these cycles helps with timing.
            
            Use cycles for timing rather than fighting them. Understanding monthly and daily themes helps you align your actions.
            
            When This Matters Most
            
            This matters most when planning activities or when you want to understand daily and monthly energy.
            
            If you're planning activities, understanding monthly and daily cycles helps with timing. If you want to understand daily energy, daily numbers show it.
            
            How This Fits Inside the App
            
            Your Personal Month and daily numbers appear in the app's timing features. Understanding them helps with timing and planning. Check your cycles to see what themes are active.
            """, author: nil, relatedArticles: ["lh-028", "lh-037", "lh-027"], oneLineDescription: "Understanding how numerology cycles affect monthly and daily energy.", whenToUse: ["Planning activities", "Understanding daily energy", "Timing decisions"], difficulty: .beginner),
        
        "lh-030": Article(id: "lh-030", title: "Master Numbers Without Hype", subtitle: "Understanding Master Numbers realistically", tag: "Featured", category: "Numerology", content: """
            Master Numbers (11, 22, 33) are often treated as magical or special. But that's not how they actually work.
            
            Master Numbers are intensified versions of their root numbers (2, 4, 6). They represent higher potential but also greater challenge. Understanding them realistically helps you work with their energy.
            
            What Master Numbers Actually Mean
            
            Master Number 11 is intensified intuition and inspiration (root 2). Master Number 22 is intensified building and mastery (root 4). Master Number 33 is intensified service and teaching (root 6). They're potentials, not guarantees.
            
            A Life Path 11 has potential for intuitive leadership but also challenges with anxiety and idealism. It's intensified 2 energy, not magical powers.
            
            Master Numbers show intensified energy, not special powers. They represent higher potential but also greater challenge. Understanding them realistically helps you work with them.
            
            Working With Master Numbers
            
            Understand Master Numbers as intensified root numbers. Work with their potential consciously. Don't expect them to be easy — they're challenging paths.
            
            Master Numbers aren't easier than regular numbers. They're more challenging. They require more integration and work. Understanding this helps you work with them realistically.
            
            Don't expect Master Numbers to be easy. They're challenging paths that require conscious work. Understanding this helps you work with them effectively.
            
            When This Matters Most
            
            This matters most when you have a Master Number or when you want to understand them realistically.
            
            If you have a Master Number, understanding it realistically helps you work with it. If you want to understand Master Numbers, see them as intensified energy rather than special powers.
            
            How This Fits Inside the App
            
            Your Master Number appears in the app if you have one. Understanding it realistically helps you work with its energy. See it as intensified potential rather than magical powers.
            """, author: nil, relatedArticles: ["lh-027", "lh-031", "lh-032"], oneLineDescription: "Understanding Master Numbers (11, 22, 33) realistically and practically.", whenToUse: ["Have Master Number", "Understanding potential", "Realistic numerology"], difficulty: .intermediate),
        
        "lh-031": Article(id: "lh-031", title: "Numerology and Decision Timing", subtitle: "Using cycles to understand timing for decisions", tag: "Featured", category: "Numerology", content: """
            Numerology cycles show timing energy. Some numbers favor action, others favor waiting. Understanding timing helps you make decisions at the right time.
            
            How Timing Energy Works
            
            Years/Months/Days with 1, 5, 8 energy favor action. Those with 2, 4, 7 energy favor planning and waiting. Those with 3, 6, 9 energy favor expression and completion.
            
            A Personal Year 1 is good for starting new things. A Personal Year 7 is good for reflection, not major action. Understanding timing helps with decisions.
            
            Different numbers create different timing energy. Understanding which energy is active helps you know when to act and when to wait.
            
            Using Timing for Decisions
            
            Check your Personal Year, Month, and daily numbers. Understand their timing energy. Plan actions accordingly.
            
            If you're in action-oriented energy (1, 5, 8), it's a good time to act. If you're in planning energy (2, 4, 7), it's a good time to plan and wait. If you're in expression energy (3, 6, 9), it's a good time to express and complete.
            
            Understanding timing helps you make decisions at the right time. Working with timing energy makes actions more effective.
            
            When This Matters Most
            
            This matters most when making important decisions or when you want to understand timing.
            
            If you're making important decisions, understanding timing helps you know when to act. If you want to understand timing, numerology cycles show it.
            
            How This Fits Inside the App
            
            Your numerology cycles appear in the app's timing features. Understanding timing energy helps with decisions. Check your cycles to see what timing energy is active.
            """, author: nil, relatedArticles: ["lh-028", "lh-029", "lh-037"], oneLineDescription: "Using numerology cycles to understand timing for decisions and actions.", whenToUse: ["Making decisions", "Understanding timing", "Planning actions"], difficulty: .beginner),
        
        "lh-032": Article(id: "lh-032", title: "Why Numbers Repeat", subtitle: "Why certain numbers appear repeatedly", tag: "Featured", category: "Numerology", content: """
            The same number keeps appearing. You see 7 everywhere. Or 4. Or 11. Why?
            
            Repeating numbers signal themes that need attention. The repetition means the energy or lesson isn't complete. Pay attention to what the number represents and why it keeps appearing.
            
            Why Numbers Repeat
            
            Notice which numbers repeat. Understand what they represent numerologically. Ask what you need to learn or integrate. The repetition continues until you address the theme.
            
            If you keep seeing 7, you might need more introspection or spiritual seeking. If you keep seeing 4, you might need more structure. The repetition is the message.
            
            Numbers repeat because the energy or lesson isn't complete. The number is trying to get your attention. The repetition continues until you address what it's showing you.
            
            Working With Repeating Numbers
            
            Track repeating numbers. Understand their meaning. Work with the theme consciously.
            
            Don't ignore repeating numbers. They're trying to tell you something. Understand what theme they represent. Work with that theme consciously rather than ignoring it.
            
            The repetition continues until you address the theme. Understanding what the number represents helps you work with it rather than against it.
            
            When This Matters Most
            
            This matters most when you notice numbers repeating or when you want to understand patterns.
            
            If numbers keep repeating, it's because the theme needs attention. If you want to understand patterns, repeating numbers show them. Understanding repetition helps you work with themes consciously.
            
            How This Fits Inside the App
            
            The app tracks numerology cycles. Notice which numbers repeat across cycles. Understanding repetition helps you see themes that need attention. Work with repeating numbers consciously rather than ignoring them.
            """, author: nil, relatedArticles: ["lh-027", "lh-030", "lh-033"], oneLineDescription: "Understanding why certain numbers appear repeatedly and what it means.", whenToUse: ["Numbers repeating", "Understanding patterns", "Themes needing attention"], difficulty: .beginner),
        
        "lh-033": Article(id: "lh-033", title: "Numerology for Reflection", subtitle: "Numerology as self-awareness, not prediction", tag: "Featured", category: "Numerology", content: """
            Numerology is often treated as fate — your number determines your future, your path is fixed. But that's not how it works.
            
            Numerology works best as a mirror for self-reflection, not a prediction tool. Numbers reveal patterns, tendencies, and themes. Understanding these helps you work with them consciously.
            
            How Reflection Works
            
            Use numerology to explore patterns, tendencies, timing energy, and self-understanding. Approach numbers with curiosity about yourself rather than seeking fixed outcomes.
            
            A Life Path 5 doesn't mean you're doomed to change — it means change is your natural path. Understanding this helps you work with it consciously.
            
            Numbers show patterns and tendencies, not fixed outcomes. Understanding them helps you work with them consciously rather than being controlled by them.
            
            Using Numerology for Self-Awareness
            
            Use numerology for self-reflection. Understand patterns. Work with them consciously rather than seeing them as fate.
            
            Instead of seeing numbers as fate, see them as patterns. Instead of seeking fixed outcomes, seek self-understanding. Work with patterns consciously rather than unconsciously.
            
            The reflection creates awareness. Understanding what numbers reveal about yourself helps you grow and change.
            
            When This Matters Most
            
            This matters most when numerology feels limiting or when you want to use it more effectively.
            
            If numerology feels limiting, it's because you're seeing it as fate. If you want to use it more effectively, see it as reflection rather than prediction.
            
            How This Fits Inside the App
            
            The app provides numerology insights for self-reflection. Use numbers to explore patterns and tendencies rather than seeking predictions. Focus on self-understanding rather than fixed outcomes.
            """, author: nil, relatedArticles: ["lh-027", "lh-032", "lh-034"], oneLineDescription: "Understanding numerology as a tool for self-awareness rather than prediction.", whenToUse: ["Self-reflection", "Pattern recognition", "Using numerology effectively"], difficulty: .beginner),
        
        "lh-034": Article(id: "lh-034", title: "Numerology Complements Astrology", subtitle: "How both systems work together", tag: "Featured", category: "Numerology", content: """
            Numerology and astrology offer different perspectives on the same patterns. Together they create a fuller picture.
            
            How They Work Together
            
            Numerology shows life themes and cycles. Astrology shows personality and timing. Use numerology for life themes, cycles, and timing. Use astrology for personality, relationships, and planetary timing. Combine them for comprehensive understanding.
            
            A Life Path 5 (change) with a fixed Sun sign (resistance to change) shows internal tension between your path and your nature. Understanding both helps you work with the tension.
            
            Each system reveals different aspects of the same patterns. Understanding both helps you see the full picture rather than just one perspective.
            
            Using Both Systems
            
            Use both systems together. Notice where they align and where they differ. Use the differences to understand complexity.
            
            When systems align, the pattern is strong. When they differ, there's complexity to understand. Both are valuable information.
            
            Don't choose one system over the other. Use both to see different aspects of the same patterns.
            
            When This Matters Most
            
            This matters most when you want deeper insight or when one system alone doesn't explain everything.
            
            If you want deeper insight, using both systems provides it. If one system alone doesn't explain everything, the other system fills in the gaps.
            
            How This Fits Inside the App
            
            The app provides both numerology and astrology insights. Use both systems together to see different aspects of your patterns. Notice where they align and where they differ.
            """, author: nil, relatedArticles: ["lh-001", "lh-027", "lh-033"], oneLineDescription: "Understanding how numerology and astrology work together for deeper insight.", whenToUse: ["Wanting deeper insight", "Using multiple systems", "Comprehensive understanding"]),
        
        // TIMING & CYCLES ARTICLES (6 articles)
        "lh-035": Article(id: "lh-035", title: "Why Timing Matters More", subtitle: "How timing affects outcomes", tag: "Featured", category: "Timing & Cycles", content: """
            The same action at different times produces different results. Timing is often the difference between success and struggle.
            
            Why Timing Changes Everything
            
            Understanding timing helps you act when conditions are favorable rather than forcing action when they're not. Notice cycles and patterns. Understand when energy is building vs. releasing. Act when conditions support your action. Wait when they don't.
            
            Starting a project during a Personal Year 1 (new beginnings) vs. Year 7 (introspection) creates different outcomes. The action is the same; timing makes the difference.
            
            Timing isn't everything, but it matters. Understanding when energy is building versus releasing helps you know when to act and when to wait.
            
            Working With Timing
            
            Understand your cycles. Notice timing energy. Act when timing supports you. Wait when it doesn't.
            
            If timing supports your action, act. If it doesn't, wait. Working with timing makes actions more effective.
            
            Don't force action when timing doesn't support it. Wait for conditions to be favorable. Understanding timing helps you know when to act.
            
            When This Matters Most
            
            This matters most when actions aren't working or when you want to understand why timing matters.
            
            If actions aren't working, check timing. If you want to understand why timing matters, notice how the same action produces different results at different times.
            
            How This Fits Inside the App
            
            The app shows timing cycles and energy. Understanding timing helps with planning actions. Check your cycles to see when timing supports action.
            """, author: nil, relatedArticles: ["lh-028", "lh-031", "lh-036"], oneLineDescription: "Understanding how timing affects outcomes and when to act vs wait.", whenToUse: ["Actions not working", "Understanding timing", "Planning actions"]),
        
        "lh-036": Article(id: "lh-036", title: "Monthly Themes and Progress", subtitle: "How monthly cycles contribute to growth", tag: "Featured", category: "Timing & Cycles", content: """
            Monthly cycles create themes that build toward long-term goals. Understanding monthly themes helps you align with natural cycles rather than fighting them. Each month contributes to the larger picture.
            
            How Monthly Themes Build Progress
            
            Notice monthly themes from numerology, astrology, or natural cycles. Understand how they contribute to annual goals. Work with monthly energy rather than against it.
            
            A month focused on planning (Personal Month 4) contributes to a year of building (Personal Year 4). Understanding the connection helps you work with cycles.
            
            Monthly themes aren't random. They build toward annual goals. Understanding how they contribute helps you work with them rather than against them.
            
            Working With Monthly Energy
            
            Track monthly themes. Understand how they contribute to long-term goals. Work with monthly energy.
            
            If you want sustained progress, work with monthly themes. If monthly cycles feel disconnected, understand how they contribute to the larger picture.
            
            Don't fight monthly energy. Align with it. Understanding how monthly themes contribute to long-term goals helps you work with them.
            
            When This Matters Most
            
            This matters most when you want sustained progress or when monthly cycles feel disconnected.
            
            If you want sustained progress, understanding monthly themes helps. If monthly cycles feel disconnected, see how they contribute to the larger picture.
            
            How This Fits Inside the App
            
            The app shows monthly themes and cycles. Understanding how they contribute to long-term goals helps with planning. Check your monthly themes to see how they build progress.
            """, author: nil, relatedArticles: ["lh-028", "lh-029", "lh-035"], oneLineDescription: "Understanding how monthly cycles contribute to long-term growth.", whenToUse: ["Sustained progress", "Monthly planning", "Understanding cycles"]),
        
        "lh-037": Article(id: "lh-037", title: "Daily vs Long-Term Focus", subtitle: "Balancing daily insights with long-term goals", tag: "Featured", category: "Timing & Cycles", content: """
            Daily guidance shows immediate energy and opportunities. Long-term focus shows direction and goals. Both are important, but they serve different purposes. Understanding the balance helps you use both effectively.
            
            How Daily and Long-Term Work Together
            
            Use daily guidance for immediate decisions, daily energy, and short-term opportunities. Use long-term focus for direction, major goals, and life themes. Don't let daily guidance derail long-term focus.
            
            Daily guidance might suggest rest, but long-term goals require consistent action. Balance both rather than choosing one over the other.
            
            Daily guidance shows what's happening now. Long-term focus shows where you're going. Both matter, but they serve different purposes.
            
            Balancing Both
            
            Use daily guidance for immediate decisions. Use long-term focus for direction. Balance both consciously.
            
            Don't let daily guidance derail long-term focus. Don't let long-term focus ignore daily opportunities. Balance both rather than choosing one over the other.
            
            Understanding the balance helps you use both effectively. Daily guidance informs immediate actions. Long-term focus guides direction.
            
            When This Matters Most
            
            This matters most when daily guidance conflicts with long-term goals or when you want to balance both.
            
            If daily guidance conflicts with long-term goals, balance both rather than choosing one. If you want to balance both, understand how they work together.
            
            How This Fits Inside the App
            
            The app provides both daily guidance and long-term focus. Use daily guidance for immediate decisions. Use long-term focus for direction. Balance both consciously.
            """, author: nil, relatedArticles: ["lh-029", "lh-035", "lh-050"], oneLineDescription: "Balancing daily insights with long-term direction and goals.", whenToUse: ["Balancing guidance", "Daily vs long-term", "Staying focused"], difficulty: .beginner),
        
        "lh-038": Article(id: "lh-038", title: "Recognizing Turning Points", subtitle: "How to recognize and work with major transitions", tag: "Featured", category: "Timing & Cycles", content: """
            Turning points are periods when major shifts occur. They're marked by Saturn returns, major transits, Personal Year transitions, or life events. Recognizing them helps you work with transitions consciously.
            
            How to Recognize Turning Points
            
            Notice signs of turning points: major life changes, internal shifts, external events, or astrological/numerological markers. Understand what's shifting. Work with the transition consciously.
            
            A Saturn return creates a turning point around age 29-30. A Personal Year 9 creates completion and turning points. Recognizing these helps you work with them.
            
            Turning points aren't always obvious. They might show up as internal shifts before external changes. Understanding the markers helps you recognize them.
            
            Working With Transitions
            
            Notice turning point markers. Understand what's shifting. Work with transitions consciously rather than resisting them.
            
            Don't resist turning points. They're periods of necessary change. Understanding what's shifting helps you work with it rather than against it.
            
            Transitions create growth. Working with them consciously makes them more effective. Resisting them creates struggle.
            
            When This Matters Most
            
            This matters most during major life transitions or when you want to understand turning points.
            
            If you're going through a major transition, understanding turning points helps. If you want to understand turning points, notice the markers and what's shifting.
            
            How This Fits Inside the App
            
            The app shows timing cycles and major transitions. Understanding turning points helps you work with transitions consciously. Check your cycles to see when turning points are active.
            """, author: nil, relatedArticles: ["lh-006", "lh-028", "lh-035"], oneLineDescription: "Understanding how to recognize and work with major life transitions.", whenToUse: ["Major transitions", "Recognizing turning points", "Life changes"], difficulty: .intermediate),
        
        "lh-039": Article(id: "lh-039", title: "Working With Slow Periods", subtitle: "Slow periods as necessary phases", tag: "Featured", category: "Timing & Cycles", content: """
            Slow periods feel frustrating. Nothing is happening. Progress has stopped. But that's not the whole story.
            
            Slow periods are part of natural cycles. They're times for rest, reflection, planning, and integration. Resisting them creates frustration. Working with them creates growth.
            
            Why Slow Periods Exist
            
            Slow periods serve purposes: integration, rest, planning, and preparation. Understand what the period is for. Work with it rather than fighting it.
            
            A Personal Year 7 (introspection) is naturally slower. A Saturn transit creates slower, more deliberate periods. These aren't problems — they're necessary phases.
            
            Slow periods aren't failures. They're necessary phases in cycles. Understanding their purpose helps you work with them rather than fighting them.
            
            Working With Slow Periods
            
            Recognize slow periods. Understand their purpose. Work with them rather than resisting them.
            
            If you're in a slow period, use it for rest, reflection, planning, or integration. Don't force action when energy isn't building. Work with the period rather than against it.
            
            Slow periods create foundations. Working with them consciously makes them more effective. Resisting them creates frustration.
            
            When This Matters Most
            
            This matters most during slow periods or when you're frustrated by lack of progress.
            
            If you're in a slow period, understand its purpose. If you're frustrated by lack of progress, slow periods are part of cycles. Understanding this helps you work with them.
            
            How This Fits Inside the App
            
            The app shows timing cycles and energy. Understanding slow periods helps you work with them rather than fighting them. Check your cycles to see when slow periods are active.
            """, author: nil, relatedArticles: ["lh-035", "lh-037", "lh-040"], oneLineDescription: "Understanding slow periods as necessary phases rather than problems.", whenToUse: ["Slow periods", "Feeling stuck", "Understanding cycles"]),
        
        "lh-040": Article(id: "lh-040", title: "Understanding Transitions", subtitle: "Working with natural transitions", tag: "Featured", category: "Timing & Cycles", content: """
            Transitions happen naturally when conditions are ready. Forcing change when conditions aren't ready creates struggle. Understanding natural timing helps you work with transitions rather than forcing them.
            
            How Natural Transitions Work
            
            Notice when transitions are building naturally. Understand what needs to shift. Work with the transition rather than forcing it. Wait for natural timing.
            
            A relationship ending naturally vs. forcing it to end. A career change happening naturally vs. forcing it. Natural transitions flow; forced ones struggle.
            
            Natural transitions happen when conditions are ready. Forced transitions happen when you push before conditions are ready. Understanding the difference helps you work with transitions.
            
            Working With Natural Timing
            
            Notice natural transitions. Understand timing. Work with transitions rather than forcing them.
            
            If a transition is building naturally, work with it. If it's not ready, wait. Don't force change when conditions aren't ready.
            
            Natural transitions flow. Forced transitions struggle. Understanding timing helps you know when to work with transitions and when to wait.
            
            When This Matters Most
            
            This matters most when you're forcing change or when transitions feel stuck.
            
            If you're forcing change, check if conditions are ready. If transitions feel stuck, they might not be ready yet. Understanding natural timing helps you work with transitions.
            
            How This Fits Inside the App
            
            The app shows timing cycles and transitions. Understanding natural timing helps you work with transitions rather than forcing them. Check your cycles to see when transitions are building naturally.
            """, author: nil, relatedArticles: ["lh-035", "lh-038", "lh-039"], oneLineDescription: "Learning to recognize and work with natural transitions rather than forcing change.", whenToUse: ["Forcing change", "Understanding transitions", "Natural timing"], difficulty: .intermediate),
        
        // SELF-AWARENESS & INTEGRATION ARTICLES (6 articles)
        "lh-041": Article(id: "lh-041", title: "Pattern Recognition", subtitle: "Recognizing patterns and using them for growth", tag: "Featured", category: "Self-awareness & Integration", content: """
            Patterns repeat because they're part of your nature or learned responses. Recognizing patterns helps you see what's happening and why. Once you see the pattern, you can work with it consciously rather than repeating it unconsciously.
            
            How to Recognize Patterns
            
            Notice repeating situations, feelings, or dynamics. Identify the pattern. Understand what it's teaching you. Work with it consciously rather than repeating it.
            
            If you keep attracting the same type of relationship problem, there's a pattern. Recognizing it helps you address it at its source rather than repeating it.
            
            Patterns aren't always obvious. They might show up in different situations but with the same underlying dynamic. Understanding what's repeating helps you see the pattern.
            
            Working With Patterns Consciously
            
            Develop pattern awareness. Notice what repeats. Understand why. Work with patterns consciously.
            
            Once you see a pattern, understand what it's teaching you. Work with it consciously rather than repeating it unconsciously. Patterns continue until you address them.
            
            Don't just notice patterns — work with them. Understanding what they're teaching you helps you grow rather than repeat.
            
            When This Matters Most
            
            This matters most when you notice repeating patterns or when you want to break cycles.
            
            If you notice repeating patterns, understanding them helps you work with them. If you want to break cycles, recognizing patterns is the first step.
            
            How This Fits Inside the App
            
            The app helps you recognize patterns through astrology, numerology, and tarot. Understanding patterns helps you work with them consciously. Notice what repeats and what it's teaching you.
            """, author: nil, relatedArticles: ["lh-012", "lh-013", "lh-042"], oneLineDescription: "Learning to recognize patterns in your life and use them for growth.", whenToUse: ["Noticing patterns", "Breaking cycles", "Personal growth"], difficulty: .intermediate),
        
        "lh-042": Article(id: "lh-042", title: "Reflection as a Skill", subtitle: "Developing reflection for self-awareness", tag: "Featured", category: "Self-awareness & Integration", content: """
            Reflection is a skill that can be developed. Effective reflection requires structure, honesty, curiosity, and action. Developing this skill creates deeper self-awareness and growth.
            
            How Effective Reflection Works
            
            Effective reflection includes noticing what happened, understanding why, recognizing patterns, and deciding what to do differently. Structure helps reflection be productive rather than just rumination.
            
            Instead of just thinking about a situation, structure your reflection: What happened? How did I feel? What patterns do I see? What do I want to do differently?
            
            Reflection without structure becomes rumination. Reflection with structure becomes awareness and growth. Understanding the difference helps you reflect effectively.
            
            Developing Reflection Practices
            
            Develop reflection practices. Use structure. Be honest and curious. Take action based on reflection.
            
            Structure your reflection. Be honest about what happened and how you felt. Be curious about patterns and why. Take action based on what you learn.
            
            Reflection isn't just thinking — it's structured awareness that leads to action. Developing this skill creates deeper self-awareness.
            
            When This Matters Most
            
            This matters most when you want deeper self-awareness or when reflection feels unproductive.
            
            If you want deeper self-awareness, develop reflection skills. If reflection feels unproductive, add structure. Understanding how to reflect effectively helps you grow.
            
            How This Fits Inside the App
            
            The app provides tools for reflection through tarot, astrology, and numerology. Use these tools to structure your reflection. Develop reflection practices that create awareness and growth.
            """, author: nil, relatedArticles: ["lh-025", "lh-041", "lh-050"], oneLineDescription: "Developing reflection skills for deeper self-awareness and growth.", whenToUse: ["Wanting self-awareness", "Developing reflection", "Personal growth"]),
        
        "lh-043": Article(id: "lh-043", title: "Awareness Before Change", subtitle: "How self-awareness creates foundation for change", tag: "Featured", category: "Self-awareness & Integration", content: """
            You can't change what you don't see. Awareness creates the foundation for change. Without awareness, change is superficial. With awareness, change is deep and lasting.
            
            Why Awareness Comes First
            
            The process: awareness first, then understanding, then acceptance, then change. Skipping awareness leads to superficial change that doesn't last.
            
            Trying to change a behavior without understanding why it exists creates temporary change. Understanding the pattern creates lasting change.
            
            Change without awareness is superficial. It addresses symptoms, not causes. Awareness shows you what needs to change and why.
            
            The Process of Change
            
            Develop awareness first. Understand patterns. Accept what is. Then change consciously.
            
            Awareness shows you what's happening. Understanding shows you why. Acceptance allows you to work with what is. Then change happens naturally.
            
            Don't skip awareness. It's the foundation. Without it, change doesn't last.
            
            When This Matters Most
            
            This matters most when change isn't working or when you want lasting transformation.
            
            If change isn't working, check awareness. If you want lasting transformation, start with awareness. Understanding this process helps you change effectively.
            
            How This Fits Inside the App
            
            The app provides tools for awareness through astrology, numerology, and tarot. Use these tools to develop awareness before attempting change. Awareness creates the foundation for lasting transformation.
            """, author: nil, relatedArticles: ["lh-041", "lh-042", "lh-044"], oneLineDescription: "Understanding how self-awareness creates the foundation for meaningful change.", whenToUse: ["Change not working", "Wanting lasting change", "Understanding transformation"], difficulty: .beginner),
        
        "lh-044": Article(id: "lh-044", title: "Emotional Cycles and Trust", subtitle: "Understanding cycles and trusting the process", tag: "Featured", category: "Self-awareness & Integration", content: """
            Emotions move in cycles. Understanding cycles helps you trust the process rather than fighting emotions. Emotions aren't problems — they're information and energy that moves through cycles.
            
            How Emotional Cycles Work
            
            Emotional cycles include activation, expression, integration, and release. Understanding cycles helps you work with emotions rather than against them.
            
            Fighting sadness prolongs it. Allowing sadness to move through its cycle allows it to complete. Trusting the cycle creates emotional health.
            
            Emotions aren't problems to solve. They're energy that moves through cycles. Understanding this helps you work with them rather than against them.
            
            Trusting the Process
            
            Understand emotional cycles. Allow emotions to move through. Trust the process.
            
            Don't fight emotions. Allow them to move through their cycles. Trust that they'll complete. Fighting them prolongs them.
            
            Trusting emotional cycles creates emotional health. Fighting them creates struggle. Understanding cycles helps you trust the process.
            
            When This Matters Most
            
            This matters most when emotions feel overwhelming or when you want to trust your emotional process.
            
            If emotions feel overwhelming, understanding cycles helps. If you want to trust your emotional process, allow emotions to move through their cycles.
            
            How This Fits Inside the App
            
            The app shows emotional timing through lunar cycles and tarot. Understanding emotional cycles helps you trust your emotional process. Allow emotions to move through rather than fighting them.
            """, author: nil, relatedArticles: ["lh-023", "lh-042", "lh-043"], oneLineDescription: "Understanding emotional cycles and learning to trust your emotional process.", whenToUse: ["Emotions overwhelming", "Trusting emotions", "Emotional health"], difficulty: .beginner),
        
        "lh-045": Article(id: "lh-045", title: "Conflicting Insights", subtitle: "How to integrate conflicting insights", tag: "Featured", category: "Self-awareness & Integration", content: """
            Different systems show different insights. Astrology says one thing, numerology says another, tarot shows something else. How do you make sense of it all?
            
            Conflicting insights often reveal complexity rather than contradiction. Different systems show different aspects. Understanding how to integrate them creates a fuller picture.
            
            How to See Conflicts Differently
            
            When insights conflict, look for different aspects of the same situation, different timeframes, or different perspectives. Integration comes from seeing how they relate.
            
            Astrology might show one pattern while numerology shows another. They're not contradicting — they're showing different aspects. Integration sees both.
            
            Conflicts aren't problems to solve. They're different perspectives on the same situation. Understanding how they relate helps you see the full picture.
            
            Integrating Different Perspectives
            
            Don't dismiss conflicting insights. Look for how they relate. Integrate different perspectives.
            
            If insights conflict, explore how they relate. See different aspects, different timeframes, or different perspectives. Integration comes from understanding how they connect.
            
            Don't choose one insight over another. See how they work together. Understanding conflicts helps you see complexity.
            
            When This Matters Most
            
            This matters most when insights conflict or when you want to integrate multiple perspectives.
            
            If insights conflict, explore how they relate. If you want to integrate multiple perspectives, see how different systems show different aspects.
            
            How This Fits Inside the App
            
            The app provides insights from multiple systems. When they conflict, explore how they relate. Understanding conflicts helps you see the full picture rather than just one perspective.
            """, author: nil, relatedArticles: ["lh-034", "lh-046", "lh-050"], oneLineDescription: "Understanding how to integrate conflicting insights from different sources.", whenToUse: ["Conflicting insights", "Integrating perspectives", "Multiple systems"], difficulty: .intermediate),
        
        "lh-046": Article(id: "lh-046", title: "Insight Into Action", subtitle: "Translating insights into practical action", tag: "Featured", category: "Self-awareness & Integration", content: """
            Insights without action don't create change. But action must be gentle and sustainable. Forcing action creates resistance. Gentle action creates lasting change.
            
            How to Translate Insights Into Action
            
            The process: insight, then small action, then reflection, then more action. Gentle steps create sustainable change. Big leaps often fail.
            
            Instead of changing everything at once, make small changes. Instead of forcing action, take gentle steps. Sustainability matters more than speed.
            
            Action doesn't have to be dramatic. Small, gentle steps create lasting change. Big leaps often fail because they're unsustainable.
            
            Taking Gentle Steps
            
            Translate insights into small actions. Take gentle steps. Reflect and adjust. Build gradually.
            
            Don't force action. Take gentle steps. Reflect on what works. Adjust and continue. Building gradually creates sustainable change.
            
            Sustainability matters more than speed. Gentle action creates lasting change. Forcing action creates resistance.
            
            When This Matters Most
            
            This matters most when you have insights but aren't acting, or when action feels forced.
            
            If you have insights but aren't acting, start with small actions. If action feels forced, make it gentler. Understanding how to translate insights into action helps you change effectively.
            
            How This Fits Inside the App
            
            The app provides insights through astrology, numerology, and tarot. Translate these insights into small, gentle actions. Build gradually rather than forcing change.
            """, author: nil, relatedArticles: ["lh-043", "lh-044", "lh-045"], oneLineDescription: "Learning how to translate insights into practical, sustainable action.", whenToUse: ["Insights without action", "Wanting sustainable change", "Practical application"], difficulty: .beginner),
        
        // USING THE APP INTELLIGENTLY ARTICLES (4 articles)
        "lh-047": Article(id: "lh-047", title: "Using Daily Guidance", subtitle: "Using daily guidance effectively", tag: "Featured", category: "Using the App Intelligently", content: """
            Daily guidance is a tool for awareness, not a decision-maker. Using it effectively means checking it, reflecting briefly, then making your own decisions. Overthinking it defeats its purpose.
            
            How to Use Daily Guidance
            
            Use daily guidance for awareness, reflection, and perspective. Don't use it for making decisions for you, seeking certainty, or avoiding your own judgment.
            
            Check daily guidance in the morning. Reflect on how it might apply. Then make your own decisions. Don't check it repeatedly or use it to avoid decisions.
            
            Daily guidance provides perspective, not answers. Understanding this helps you use it effectively rather than becoming dependent on it.
            
            Finding Balance
            
            Check guidance once daily. Reflect briefly. Make your own decisions. Trust your judgment.
            
            Don't overthink guidance. Don't check it repeatedly. Don't use it to avoid decisions. Use it for awareness, then trust your judgment.
            
            Balance means using guidance for perspective without becoming dependent on it. Understanding this helps you use it effectively.
            
            When This Matters Most
            
            This matters most when you're overthinking guidance or becoming dependent on it.
            
            If you're overthinking guidance, simplify your use. If you're becoming dependent, trust your judgment more. Understanding balance helps you use guidance effectively.
            
            How This Fits Inside the App
            
            The app provides daily guidance. Use it for awareness and perspective, then make your own decisions. Don't overthink it or become dependent on it.
            """, author: nil, relatedArticles: ["lh-037", "lh-048", "lh-050"], oneLineDescription: "Learning to use daily guidance effectively without analysis paralysis.", whenToUse: ["Overthinking guidance", "Using guidance effectively", "Healthy app use"], difficulty: .beginner),
        
        "lh-048": Article(id: "lh-048", title: "When to Check Insights", subtitle: "Timing for checking insights and trusting judgment", tag: "Featured", category: "Using the App Intelligently", content: """
            There are good times to check insights (morning reflection, decision points) and times when it's better to trust your judgment (in the moment, during stress). Understanding timing helps you use the app effectively.
            
            Good Times to Check
            
            Good times to check: morning reflection, weekly planning, decision preparation. Not good times: during stress, repeatedly throughout the day, or to avoid decisions.
            
            Check insights in the morning for daily awareness. Don't check them repeatedly when anxious — that's avoidance, not use.
            
            Timing matters. Checking at the right times creates awareness. Checking at the wrong times creates dependency.
            
            Trusting Your Judgment
            
            Establish healthy checking habits. Trust your judgment when needed. Use insights as tools, not crutches.
            
            Don't check insights during stress or repeatedly throughout the day. Trust your judgment when you need to make decisions. Use insights as tools, not crutches.
            
            Balance means checking insights at the right times and trusting your judgment when needed. Understanding this helps you use the app effectively.
            
            When This Matters Most
            
            This matters most when you're checking too often or when you want to use the app more effectively.
            
            If you're checking too often, establish healthier habits. If you want to use the app more effectively, understand timing. Knowing when to check and when to trust your judgment helps.
            
            How This Fits Inside the App
            
            The app provides insights throughout the day. Check them at the right times (morning reflection, weekly planning). Trust your judgment when needed. Use insights as tools, not crutches.
            """, author: nil, relatedArticles: ["lh-047", "lh-049", "lh-050"], oneLineDescription: "Understanding timing for checking insights and when to trust your own judgment.", whenToUse: ["Checking too often", "Using app effectively", "Healthy habits"]),
        
        "lh-049": Article(id: "lh-049", title: "Using Multiple Systems Together", subtitle: "Integrating astrology, tarot, and numerology", tag: "Featured", category: "Using the App Intelligently", content: """
            Multiple systems show different aspects of the same patterns. Using them together creates a fuller picture. The key is understanding how they relate rather than seeing them as separate.
            
            How Systems Work Together
            
            Use astrology for personality and timing. Use tarot for reflection and insight. Use numerology for themes and cycles. Integrate them by seeing how they relate.
            
            Astrology shows your nature, numerology shows your path, tarot shows current reflection. Together they create comprehensive understanding.
            
            Each system reveals different aspects. Understanding how they relate helps you see the full picture rather than just one perspective.
            
            Integrating Insights
            
            Use each system for its strengths. Notice how they relate. Integrate insights rather than keeping them separate.
            
            Don't keep systems separate. See how they relate. Notice where they align and where they differ. Integration comes from understanding relationships.
            
            Multiple systems aren't confusing when you see how they relate. Understanding relationships helps you integrate insights effectively.
            
            When This Matters Most
            
            This matters most when using multiple systems feels confusing or when you want deeper insight.
            
            If multiple systems feel confusing, see how they relate. If you want deeper insight, integration provides it. Understanding how systems work together helps you use them effectively.
            
            How This Fits Inside the App
            
            The app provides insights from multiple systems. Use each system for its strengths. Notice how they relate. Integrate insights rather than keeping them separate.
            """, author: nil, relatedArticles: ["lh-034", "lh-045", "lh-050"], oneLineDescription: "Learning to integrate astrology, tarot, and numerology insights effectively.", whenToUse: ["Multiple systems confusing", "Wanting integration", "Deeper insight"]),
        
        "lh-050": Article(id: "lh-050", title: "Building a Reflection Practice", subtitle: "Creating a sustainable reflection practice", tag: "Featured", category: "Using the App Intelligently", content: """
            A reflection practice is a regular habit of checking in with yourself using tools like daily guidance, tarot, and insights. Building this practice creates self-awareness and growth over time.
            
            What a Good Practice Includes
            
            A good practice includes daily check-ins, weekly reviews, monthly reflections, and using different features (guidance, tarot, articles) for different purposes. Consistency matters more than perfection.
            
            Morning: check daily guidance. Weekly: review patterns. Monthly: reflect on themes. Use articles for deeper learning. Build gradually.
            
            A reflection practice doesn't have to be perfect. Consistency matters more than perfection. Building gradually creates sustainable habits.
            
            Building Your Practice
            
            Start small with daily check-ins. Add weekly reviews. Use articles for learning. Build gradually and consistently.
            
            Don't try to do everything at once. Start with daily check-ins. Add weekly reviews when daily check-ins feel natural. Build gradually rather than forcing it.
            
            Sustainability comes from building gradually. Consistency matters more than perfection. Understanding this helps you build a practice that lasts.
            
            When This Matters Most
            
            This matters most when you want to build a reflection practice or when app use feels scattered.
            
            If you want to build a reflection practice, start small and build gradually. If app use feels scattered, structure helps. Understanding how to build a practice helps you use the app effectively.
            
            How This Fits Inside the App
            
            The app provides tools for reflection: daily guidance, tarot, articles, and insights. Use them to build a reflection practice. Start small, build gradually, and stay consistent.
            """, author: nil, relatedArticles: ["lh-042", "lh-047", "lh-048"], oneLineDescription: "Creating a sustainable personal reflection practice using the app's features.", whenToUse: ["Building reflection practice", "Using app consistently", "Personal growth"]),
        
    ]
}

// MARK: - Helper Components

struct LearningIntroCard: View {
    let article: Article
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Category and difficulty pills
                HStack(spacing: 8) {
                    Text(article.category)
                        .font(DesignTypography.footnoteFont(weight: .medium))
                        .foregroundColor(DesignColors.accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(DesignColors.accent.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                )
                        )
                    
                    if let difficulty = article.difficulty {
                        Text(difficulty.displayName)
                            .font(DesignTypography.footnoteFont(weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                }
                
                // Title
                Text(article.title)
                    .font(DesignTypography.title2Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                // Subtitle (fully visible, no truncation)
                if let description = article.oneLineDescription {
                    Text(description)
                        .font(DesignTypography.subheadFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text(article.subtitle)
                        .font(DesignTypography.subheadFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Meta info (e.g., "10-card spread · ~3-4 min read")
                Text(article.metaInfo ?? calculateReadingTime(article: article))
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

struct VisualAnchorCard: View {
    let category: String
    let label: String
    let helperText: String?
    
    var body: some View {
        BaseCard {
            VStack(spacing: 12) {
                // Label
                Text(label)
                    .font(DesignTypography.subheadFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                // Visual placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
                    .frame(height: 120)
                    .overlay(
                        Text(category)
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    )
                
                // Helper text
                if let helperText = helperText {
                    Text(helperText)
                        .font(DesignTypography.caption1Font())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct PositionBlock: View {
    let position: SpreadPosition
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            (Text("Position \(position.id):")
                .font(DesignTypography.bodyFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
             + Text(" " + (position.description ?? position.title))
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct WhenToUseSection: View {
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("When to use this")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.accent)
                        Text(item)
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Basics Page Components

struct DefinitionBlock: View {
    let definition: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What is this?")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            Text(createJustifiedText(definition))
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WhatItIncludesSection: View {
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What it includes")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.accent)
                        Text(item)
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WhatItIsNotSection: View {
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What this is not")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.accent)
                        Text(item)
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct NextStepsSection: View {
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Go deeper")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.accent)
                        Text(item)
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Expanded Learning Content Components

struct PositionGroupSection: View {
    let groups: [PositionGroup]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Celtic Cross Layout")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            Text("Card positions and meanings")
                .font(DesignTypography.caption1Font())
                .foregroundColor(DesignColors.mutedForeground)
                .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(groups) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group.title)
                            .font(DesignTypography.subheadFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(group.positions) { position in
                                PositionBlock(position: position)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ArticleDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    let articleId: String
    @State private var isSaved: Bool = false
    @State private var showUnlockModal = false
    @State private var isUnlocked = false
    
    private var article: Article? {
        ArticleData.articles[articleId]
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            if let article = article {
                ScrollView {
                    VStack(spacing: 16) {
                        // Header
                        BaseHeader(
                            title: article.title,
                            subtitle: article.category,
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            ),
                            rightView: AnyView(
                                HStack(spacing: 8) {
                                    Button(action: {
                                        isSaved.toggle()
                                    }) {
                                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                                            .font(.system(size: 20))
                                            .foregroundColor(isSaved ? DesignColors.accent : DesignColors.mutedForeground)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.white.opacity(0.05))
                                            )
                                    }
                                    
                                    Button(action: {
                                        // Handle share
                                    }) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 20))
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .frame(width: 44, height: 44)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color.white.opacity(0.05))
                                            )
                                    }
                                }
                            ),
                            alignment: .leading,
                            horizontalPadding: 0
                        )
                        .padding(.top, 0)
                        
                        // Intro Card (merged hero card - no visual anchor for spreads)
                        LearningIntroCard(article: article)
                            .padding(.bottom, DesignSpacing.md)
                        
                        // Main Content
                        if isUnlocked || AccessControlService.shared.isPremium {
                            if article.isBasicsPage {
                                // Basics Page Layout (Educational Entry Point)
                                basicsPageContent(article: article)
                            } else if article.hasExpandedContent {
                                // Expanded Learning Page Layout (e.g., Celtic Cross)
                                expandedLearningContent(article: article)
                            } else {
                                // Regular Learning Page Layout - Parse 7-section structure
                                learningHubContent(article: article)
                            }
                        } else {
                            // Preview only
                            BaseCard {
                                VStack(spacing: 16) {
                                    if let description = article.oneLineDescription {
                                        Text(description)
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .lineLimit(3)
                                    } else {
                                        Text(article.content.components(separatedBy: "\n\n").first ?? "")
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .lineLimit(3)
                                    }
                                    
                                    Button(action: {
                                        showUnlockModal = true
                                    }) {
                                        Text("Unlock Full Article - 20 points")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(DesignColors.accent)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                        }
                        
                        // Divider before Related Articles
                        if !article.relatedArticles.isEmpty {
                            Divider()
                                .background(Color.white.opacity(0.1))
                                .padding(.vertical, DesignSpacing.md)
                        }
                        
                        // Related Articles
                        if !article.relatedArticles.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Related Articles")
                                    .font(DesignTypography.title3Font(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(article.relatedArticles, id: \.self) { relatedId in
                                            if let related = ArticleData.articles[relatedId] {
                                                NavigationLink(destination: ArticleDetailPage(articleId: related.id)) {
                                                    RelatedArticleCard(article: related)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                    .padding(.horizontal, DesignSpacing.sm)
                                }
                                .padding(.horizontal, -DesignSpacing.sm)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .padding(.bottom, 48)
                }
            } else {
                VStack {
                    BaseHeader(
                        title: "Article Not Found",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back",
                            action: { dismiss() }
                        ),
                        alignment: .leading
                    )
                    .padding(.top, 12)
                    
                    BaseCard {
                        Text("This article could not be found.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            checkArticleAccess()
        }
        .sheet(isPresented: $showUnlockModal) {
            let balance = PointsService.shared.getBalance()
            PointsSpendModal(
                isPresented: $showUnlockModal,
                cost: 20,
                currentBalance: balance.totalPoints,
                title: "Unlock Full Article",
                message: "Unlock the full article content for 20 points?",
                onConfirm: {
                    handleUnlockArticle()
                },
                onUpgrade: {
                    // Navigate to premium upgrade
                }
            )
        }
    }
    
    // MARK: - Expanded Learning Content (e.g., Celtic Cross)
    
    @ViewBuilder
    private func expandedLearningContent(article: Article) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            // Section 1: What is this? (2-3 lines intro)
            if let whatIsThis = article.whatIsThis {
                VStack(alignment: .leading, spacing: 12) {
                    Text("What is the \(article.title)?")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text(justifiedText(whatIsThis))
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Section 2: Why this spread is different
            if let whyDifferent = article.whyDifferent, !whyDifferent.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Why this spread is different")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(whyDifferent, id: \.self) { item in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.accent)
                                Text(item)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Section 3: Layout and grouped positions
            if let positionGroups = article.positionGroups, !positionGroups.isEmpty {
                PositionGroupSection(groups: positionGroups)
            }
            
            // Section 4: How to read the spread as a whole
            if let howToRead = article.howToRead {
                VStack(alignment: .leading, spacing: 12) {
                    Text("How to read the spread as a whole")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text(justifiedText(howToRead))
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Section 5: When to use this spread
            if let whenToUse = article.whenToUse, !whenToUse.isEmpty {
                WhenToUseSection(items: whenToUse)
            }
        }
        .padding(.horizontal, DesignSpacing.sm)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Basics Page Content
    
    @ViewBuilder
    private func basicsPageContent(article: Article) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            // Definition Block (MANDATORY)
            if let definition = article.definition {
                DefinitionBlock(definition: definition)
            }
            
            // What it includes (MANDATORY)
            if let whatItIncludes = article.whatItIncludes, !whatItIncludes.isEmpty {
                WhatItIncludesSection(items: whatItIncludes)
            }
            
            // When to use this (moved up, refined)
            if let whenToUse = article.whenToUse, !whenToUse.isEmpty {
                WhenToUseSection(items: whenToUse)
            }
            
            // What it's not (NEW, optional but powerful)
            if let whatItIsNot = article.whatItIsNot, !whatItIsNot.isEmpty {
                WhatItIsNotSection(items: whatItIsNot)
            }
            
            // Next steps (implicit CTA)
            if let nextSteps = article.nextSteps, !nextSteps.isEmpty {
                NextStepsSection(items: nextSteps)
            }
        }
        .padding(.horizontal, DesignSpacing.sm)
        .frame(maxWidth: .infinity)
    }
    
    private func checkArticleAccess() {
        let (allowed, isPreviewOnly) = AccessControlService.shared.canAccessArticle(articleId: articleId)
        if !allowed {
            // Article not accessible
            return
        }
        isUnlocked = !isPreviewOnly
    }
    
    private func handleUnlockArticle() {
        let result = PointsService.shared.spendPoints(event: "unlock_article", cost: 20)
        if result.success {
            AccessControlService.shared.unlockContent(contentId: articleId, contentType: .article, permanent: true)
            isUnlocked = true
        }
    }
    
    // MARK: - Learning Hub Content (7-Section Structure)
    
    @ViewBuilder
    private func learningHubContent(article: Article) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            // Display article content as flowing prose - remove section labels and parse headings
            let cleanedContent = removeSectionLabels(from: article.content)
            let parsedContent = parseContentWithHeadings(cleanedContent)
            
            if !parsedContent.isEmpty {
                ForEach(Array(parsedContent.enumerated()), id: \.offset) { index, item in
                    if item.isHeading {
                        // Section heading - larger and semibold
                        Text(item.text)
                            .font(DesignTypography.title3Font(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                            .padding(.top, index > 0 ? 24 : 0)
                            .padding(.bottom, 8)
                    } else {
                        // Body paragraph - justified text
                        Text(justifiedText(item.text))
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(4)
                            .padding(.bottom, 12)
                    }
                }
            }
            
            // "When to Use This" Section if available
            if let whenToUse = article.whenToUse, !whenToUse.isEmpty {
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.vertical, 8)
                
                WhenToUseSection(items: whenToUse)
            }
        }
        .padding(.horizontal, DesignSpacing.sm)
        .frame(maxWidth: .infinity)
    }
    
    // Helper function to create justified text using AttributedString
    private func justifiedText(_ text: String) -> AttributedString {
        return createJustifiedText(text)
    }
    
    // Parse content to identify section headings vs body paragraphs
    private func parseContentWithHeadings(_ content: String) -> [(text: String, isHeading: Bool)] {
        var result: [(text: String, isHeading: Bool)] = []
        let paragraphs = content.components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        for paragraph in paragraphs {
            // Check if this paragraph looks like a heading
            // Headings are typically:
            // - Short (less than 100 characters)
            // - Don't end with punctuation (or end with question mark)
            // - Are title case or all caps
            // - Followed by body paragraphs
            
            let isHeading = isLikelyHeading(paragraph)
            result.append((text: paragraph, isHeading: isHeading))
        }
        
        return result
    }
    
    // Determine if a paragraph is likely a section heading
    private func isLikelyHeading(_ text: String) -> Bool {
        // Must be relatively short (headings are typically concise)
        if text.count > 80 {
            return false
        }
        
        // Check if it's a single line (no line breaks)
        if text.contains("\n") {
            return false
        }
        
        // Check if it ends with certain punctuation (headings usually don't end with periods, commas, etc.)
        if text.hasSuffix(".") || text.hasSuffix(",") || text.hasSuffix(":") {
            return false
        }
        
        // Check if it ends with question mark (could be a heading)
        if text.hasSuffix("?") {
            return true
        }
        
        let words = text.components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        
        if words.isEmpty {
            return false
        }
        
        // If it's all caps (like "WHY CONTEXT CHANGES EVERYTHING"), it's likely a heading
        if text == text.uppercased() && text.count > 5 && words.count >= 2 {
            return true
        }
        
        // If first word is capitalized and most significant words are capitalized, likely a heading
        if let firstWord = words.first, firstWord.first?.isUppercase == true {
            // Count significant words (longer than 2 characters)
            let significantWords = words.filter { $0.count > 2 }
            if significantWords.isEmpty {
                return false
            }
            
            let capitalizedSignificant = significantWords.filter { word in
                guard let first = word.first else { return false }
                return first.isUppercase
            }
            
            // If most significant words are capitalized and it's short, likely a heading
            if Double(capitalizedSignificant.count) / Double(significantWords.count) >= 0.6 && text.count < 80 {
                return true
            }
        }
        
        return false
    }
    
    // Remove section labels (ORIENTATION, CORE CONCEPT, etc.) from content
    // Structure exists for writer, not reader - content should flow naturally
    private func removeSectionLabels(from content: String) -> String {
        let sectionLabels = [
            "ORIENTATION",
            "CORE CONCEPT",
            "FRAMEWORK OR BREAKDOWN",
            "FRAMEWORK",
            "EXAMPLES OR PATTERNS",
            "EXAMPLES",
            "HOW TO APPLY THIS INSIGHT",
            "HOW TO APPLY",
            "WHEN THIS MATTERS MOST",
            "WHEN THIS MATTERS MOST:",
            "RELATED CONCEPTS INSIDE THE APP",
            "RELATED CONCEPTS"
        ]
        
        let lines = content.components(separatedBy: "\n")
        var result: [String] = []
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            let upperTrimmed = trimmed.uppercased()
            
            // Check if this entire line is a section label (exact match or contains label)
            var isLabel = false
            for label in sectionLabels {
                if upperTrimmed == label || upperTrimmed == label + ":" {
                    isLabel = true
                    break
                }
                // Also check if line starts with label followed by colon or nothing
                if upperTrimmed.hasPrefix(label) && (upperTrimmed.count <= label.count + 1) {
                    isLabel = true
                    break
                }
            }
            
            if !isLabel {
                result.append(line)
            } else {
                // Skip the label line, add paragraph break if previous line had content
                if !result.isEmpty {
                    let lastLine = result.last!.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !lastLine.isEmpty {
                        result.append("")
                    }
                }
            }
        }
        
        var cleaned = result.joined(separator: "\n")
        // Remove multiple consecutive empty lines
        while cleaned.contains("\n\n\n") {
            cleaned = cleaned.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }
        
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func parseLearningHubContent(_ content: String) -> [(title: String, content: String)] {
        let sectionHeaders = [
            "ORIENTATION",
            "CORE CONCEPT",
            "FRAMEWORK OR BREAKDOWN",
            "FRAMEWORK",
            "EXAMPLES OR PATTERNS",
            "EXAMPLES",
            "HOW TO APPLY THIS INSIGHT",
            "HOW TO APPLY",
            "WHEN THIS MATTERS MOST",
            "WHEN THIS MATTERS MOST:",
            "RELATED CONCEPTS INSIDE THE APP",
            "RELATED CONCEPTS"
        ]
        
        var sections: [(title: String, content: String)] = []
        let lines = content.components(separatedBy: "\n")
        var currentSection: (title: String, content: String)? = nil
        var currentContent: [String] = []
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Check if this line is a section header
            if let header = sectionHeaders.first(where: { trimmedLine.uppercased().contains($0) }) {
                // Save previous section if exists and has content
                if let section = currentSection {
                    let contentText = currentContent.joined(separator: "\n\n").trimmingCharacters(in: .whitespacesAndNewlines)
                    if !contentText.isEmpty && !section.title.isEmpty {
                        sections.append((title: section.title, content: contentText))
                    }
                }
                
                // Start new section
                let displayTitle = formatSectionTitle(header)
                currentSection = (title: displayTitle, content: "")
                currentContent = []
            } else if !trimmedLine.isEmpty {
                currentContent.append(trimmedLine)
            }
        }
        
        // Add last section if it has content
        if let section = currentSection {
            let contentText = currentContent.joined(separator: "\n\n").trimmingCharacters(in: .whitespacesAndNewlines)
            if !contentText.isEmpty && !section.title.isEmpty {
                sections.append((title: section.title, content: contentText))
            }
        }
        
        // If no sections found, return content as single section to ensure content is displayed
        if sections.isEmpty {
            let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedContent.isEmpty {
                return [(title: "", content: trimmedContent)]
            }
        }
        
        return sections
    }
    
    private func formatSectionTitle(_ header: String) -> String {
        switch header.uppercased() {
        case "ORIENTATION":
            return "Orientation"
        case "CORE CONCEPT":
            return "Core Concept"
        case "FRAMEWORK OR BREAKDOWN", "FRAMEWORK":
            return "Framework or Breakdown"
        case "EXAMPLES OR PATTERNS", "EXAMPLES":
            return "Examples or Patterns"
        case "HOW TO APPLY THIS INSIGHT", "HOW TO APPLY":
            return "How to Apply This Insight"
        case "WHEN THIS MATTERS MOST", "WHEN THIS MATTERS MOST:":
            return "When This Matters Most"
        case "RELATED CONCEPTS INSIDE THE APP", "RELATED CONCEPTS":
            return "Related Concepts Inside the App"
        default:
            return header.capitalized
        }
    }
}

struct RelatedArticleCard: View {
    let article: Article
    
    var body: some View {
        BaseCard(variant: .interactive, action: {}) {
            VStack(alignment: .leading, spacing: 12) {
                Text(article.category)
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                
                Spacer()
                
                Text(article.title)
                    .font(DesignTypography.headlineFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                    .lineLimit(2)
                
                // Use oneLineDescription if available, otherwise subtitle (max 1 line)
                Text(article.oneLineDescription ?? article.subtitle)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .lineLimit(1)
            }
            .frame(width: 320, height: 200, alignment: .topLeading)
        }
    }
}

#Preview {
    NavigationStack {
        ArticleDetailPage(articleId: "1")
    }
}

