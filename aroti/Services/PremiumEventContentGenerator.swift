//
//  PremiumEventContentGenerator.swift
//  Aroti
//
//  Service for generating personalized content for premium event cards
//

import Foundation

class PremiumEventContentGenerator {
    static let shared = PremiumEventContentGenerator()
    
    private let astroService = AstrologicalCycleService.shared
    private let numerologyService = NumerologyCycleService.shared
    
    private init() {}
    
    // MARK: - Main Generation Method
    
    /// Generate CoreGuidanceCard from PremiumEvent
    func generateCard(from event: PremiumEvent, userData: UserData) -> CoreGuidanceCard {
        let content = generateContent(for: event, userData: userData)
        
        return CoreGuidanceCard(
            id: event.cardId,
            type: .thisPeriod, // Use existing type for now
            preview: event.preview,
            fullInsight: content.fullInsight,
            headline: content.headline,
            bodyLines: content.bodyLines,
            lastUpdated: Date(),
            contentVersion: UUID().uuidString,
            contextInfo: event.title,
            astrologicalContext: content.astrologicalContext,
            numerologyContext: content.numerologyContext,
            expandedContent: content.expandedContent,
            timeframeLabel: content.timeframeLabel,
            summarySentence: content.summarySentence
        )
    }
    
    // MARK: - Content Generation by Event Type
    
    private func generateContent(for event: PremiumEvent, userData: UserData) -> GeneratedEventContent {
        switch event.type {
        case .mercuryRetrograde:
            return generateMercuryRetrogradeContent(event: event, userData: userData)
        case .monthlyHoroscope:
            return generateMonthlyHoroscopeContent(event: event, userData: userData)
        case .personalMonthChange:
            return generatePersonalMonthContent(event: event, userData: userData)
        case .saturnReturn:
            return generateSaturnReturnContent(event: event, userData: userData)
        case .favorableDates:
            return generateFavorableDatesContent(event: event, userData: userData)
        case .focusArea:
            return generateFocusAreaContent(event: event, userData: userData)
        case .moonPhase:
            return generateMoonPhaseContent(event: event, userData: userData)
        }
    }
    
    // MARK: - Mercury Retrograde Content
    
    private func generateMercuryRetrogradeContent(event: PremiumEvent, userData: UserData) -> GeneratedEventContent {
        let mercurySign = event.personalizationData.userMercurySign ?? userData.sunSign
        let sunSign = event.personalizationData.userSunSign
        let moonSign = event.personalizationData.userMoonSign
        
        // Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let startDateStr = dateFormatter.string(from: event.startDate)
        let endDateStr = event.endDate != nil ? dateFormatter.string(from: event.endDate!) : ""
        let dateRange = endDateStr.isEmpty ? startDateStr : "\(startDateStr) - \(endDateStr)"
        
        // Calculate days remaining
        let calendar = Calendar.current
        let daysRemaining = event.endDate != nil ? calendar.dateComponents([.day], from: Date(), to: event.endDate!).day ?? 0 : 0
        
        // Personalized impact based on Mercury sign + Sun sign combination
        let signCombinations: [String: (impact: String, techTips: String, reviewAreas: String)] = [
            "Gemini": (
                impact: "Your Gemini Mercury makes you naturally attuned to communication patterns, so retrograde delays feel more noticeable. Combined with your \(sunSign) Sun, this period asks you to slow down your usual fast-paced communication style.",
                techTips: "Back up important files, double-check email recipients, and allow 15-20 minutes extra for any digital work. Your Gemini Mercury means you process information quickly, but during retrograde, take time to review before sending.",
                reviewAreas: "Revisit conversations from the past 2-3 months, review written communications, and reconsider travel plans. Your natural curiosity benefits from revisiting old ideas rather than starting new ones."
            ),
            "Virgo": (
                impact: "Your Virgo Mercury's attention to detail is disrupted during retrograde. Combined with your \(sunSign) Sun, this creates tension between your need for precision and the retrograde's tendency toward errors.",
                techTips: "Triple-check contracts, documents, and important information. Create backup copies of critical files. Your analytical nature will catch mistakes, but give yourself extra time to review everything thoroughly.",
                reviewAreas: "Revisit organizational systems, refine existing projects, and review health/wellness routines. Your perfectionist tendencies can be channeled into improving what already exists rather than starting fresh."
            ),
            "Sagittarius": (
                impact: "Your Sagittarius Mercury emphasizes travel and philosophical communication. Combined with your \(sunSign) Sun, retrograde delays in journeys and learning feel particularly frustrating.",
                techTips: "Allow extra time for travel (add 30-60 minutes buffer), double-check flight/travel bookings, and back up important documents before trips. Your adventurous spirit needs patience during this period.",
                reviewAreas: "Revisit educational plans, philosophical discussions, and long-distance communication. Your love of exploration benefits from revisiting past journeys and conversations rather than planning new ones."
            )
        ]
        
        let personalized = signCombinations[mercurySign] ?? (
            impact: "Your \(mercurySign) Mercury combined with your \(sunSign) Sun creates a unique communication style that's affected by this retrograde period. The retrograde asks you to slow down and review rather than push forward.",
            techTips: "Back up important files, double-check all communications, and allow extra time for technology-related tasks. Your \(mercurySign) Mercury means you process information in a specific way that benefits from review during retrograde.",
            reviewAreas: "Revisit past conversations, review written communications, and reconsider plans made in the past 2-3 months. Your natural communication style benefits from reflection rather than new initiatives."
        )
        
        // Moon sign influence
        let moonInfluence = moonSign != nil ? " Your \(moonSign!) Moon adds emotional depth to how you experience communication delays - you may feel more sensitive to misunderstandings during this period." : ""
        
        // Expanded body lines
        var bodyLines: [String] = []
        bodyLines.append("Mercury retrograde from \(dateRange) affects your \(mercurySign) communication style")
        bodyLines.append("Combined with your \(sunSign) Sun, this period emphasizes review over new initiatives")
        if moonSign != nil {
            bodyLines.append("Your \(moonSign!) Moon influences how you emotionally process communication delays")
        }
        if daysRemaining > 0 {
            bodyLines.append("\(daysRemaining) days remaining in this retrograde period")
        }
        
        // Expanded full insight (2-3 sentences)
        let fullInsight = "Mercury retrograde from \(dateRange) specifically affects your \(mercurySign) Mercury placement, which governs how you think, communicate, and process information. \(personalized.impact)\(moonInfluence) This retrograde period asks you to slow down communication, review important decisions, and reconnect with past conversations rather than starting new projects. Your \(sunSign) Sun's natural expression is modified by this retrograde energy, creating opportunities to refine rather than expand."
        
        // More compelling headline
        let compellingHeadline = "How Mercury Retrograde Affects You"
        
        // Expanded insight bullets (4-5 instead of 3)
        var insightBullets: [String] = []
        insightBullets.append("Theme: Review and revise communication patterns, especially in areas related to your \(mercurySign) Mercury")
        insightBullets.append("Best use: Reconnect with past contacts, finish incomplete projects, and refine existing plans")
        insightBullets.append("Watch for: Technology glitches, travel delays, and misunderstandings in communication")
        insightBullets.append("Your \(sunSign) Sun influence: Your natural expression is modified by retrograde energy - use this time for reflection")
        if moonSign != nil {
            insightBullets.append("Emotional impact: Your \(moonSign!) Moon makes you more sensitive to communication delays - practice patience")
        }
        
        // Expanded guidance (5-6 instead of 3)
        var guidance: [String] = []
        guidance.append("Do: Double-check all emails, messages, and important communications before sending - your \(mercurySign) Mercury benefits from extra review")
        guidance.append("Try: Revisiting old projects, conversations, or plans from the past 2-3 months - retrograde energy supports refinement")
        guidance.append("Avoid: Signing contracts, making major purchases, or starting new communication-heavy projects")
        guidance.append("Technology: \(personalized.techTips)")
        guidance.append("Review areas: \(personalized.reviewAreas)")
        if daysRemaining > 0 {
            guidance.append("Timeline: Use the remaining \(daysRemaining) days to complete reviews and refinements before Mercury goes direct")
        }
        
        // Expanded one-line insight (2-3 sentences)
        let oneLineInsight = "Mercury retrograde from \(dateRange) specifically affects your \(mercurySign) Mercury, which governs your communication style and thought processes. Combined with your \(sunSign) Sun, this period asks you to slow down, review important decisions, and reconnect with past conversations rather than pushing forward with new initiatives.\(moonInfluence)"
        
        return GeneratedEventContent(
            headline: compellingHeadline,
            bodyLines: bodyLines,
            fullInsight: fullInsight,
            astrologicalContext: "Mercury Retrograde • \(dateRange) • \(mercurySign) Mercury",
            numerologyContext: nil,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: [
                    "What communication patterns from the past 2-3 months need review?",
                    "What unfinished projects or conversations could benefit from attention during this retrograde?",
                    "How can I use this time for reflection and refinement rather than action?",
                    "What technology or communication systems need backup or review?"
                ],
                contextSection: "Mercury retrograde occurs 3-4 times per year, lasting about 3 weeks each time. This retrograde from \(dateRange) specifically affects your \(mercurySign) Mercury placement, which governs how you think, communicate, and process information. Your \(mercurySign) Mercury combined with your \(sunSign) Sun creates a unique communication style that's being tested during this retrograde period.\(moonSign != nil ? " Your \(moonSign!) Moon adds emotional depth to how you experience communication delays - you may feel more sensitive to misunderstandings during this period." : "") This is a time to slow down, review past communications, and refine existing plans rather than starting new initiatives. The retrograde energy supports reconnection with past contacts and completion of unfinished projects.",
                deeperInsight: nil,
                practicalReflection: nil
            ),
            timeframeLabel: "Active Now",
            summarySentence: "Mercury retrograde from \(dateRange) affects your \(mercurySign) communication style. Combined with your \(sunSign) Sun, this period emphasizes review over new initiatives."
        )
    }
    
    // MARK: - Monthly Horoscope Content
    
    private func generateMonthlyHoroscopeContent(event: PremiumEvent, userData: UserData) -> GeneratedEventContent {
        let sunSign = event.personalizationData.userSunSign
        let moonSign = event.personalizationData.userMoonSign
        let personalYear = event.personalizationData.userPersonalYear
        
        let calendar = Calendar.current
        let now = Date()
        let monthName = getMonthName(from: now)
        let month = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: now)
        
        // Calculate favorable dates within the month
        var favorableDates: [Date] = []
        if let birthDate = userData.birthDate {
            let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? now
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? now
            
            // Find favorable numerology dates (Personal Day numbers 1, 3, 6, 8)
            let favorableNumbers = [1, 3, 6, 8]
            var currentDate = startOfMonth
            while currentDate <= endOfMonth {
                let personalDay = numerologyService.getPersonalDayNumber(birthDate: birthDate, currentDate: currentDate)
                if favorableNumbers.contains(personalDay) {
                    favorableDates.append(currentDate)
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? endOfMonth
            }
        }
        
        // Generate monthly themes based on sign + personal year
        let monthlyThemes = getMonthlyThemes(sunSign: sunSign, month: month)
        let personalYearTheme = personalYear != nil ? getPersonalYearTheme(personalYear: personalYear!) : nil
        
        // Moon sign influence details
        let moonInfluence: String
        if let moonSign = moonSign {
            let moonInfluences: [String: String] = [
                "Aries": "Your Aries Moon brings passionate, impulsive emotional energy this month. Channel this fire into new beginnings and bold actions.",
                "Taurus": "Your Taurus Moon emphasizes stability and sensuality. Focus on creating comfort and enjoying life's pleasures this month.",
                "Gemini": "Your Gemini Moon brings curiosity and communication to your emotional world. Connect with others and explore new ideas.",
                "Cancer": "Your Cancer Moon heightens emotional sensitivity and nurturing instincts. Focus on home, family, and emotional security.",
                "Leo": "Your Leo Moon brings creative expression and confidence to your emotions. Shine your light and share your gifts this month.",
                "Virgo": "Your Virgo Moon emphasizes practical emotional processing and attention to detail. Focus on service and improvement.",
                "Libra": "Your Libra Moon brings harmony and partnership to your emotional world. Seek balance and connection with others.",
                "Scorpio": "Your Scorpio Moon intensifies emotional depth and transformation. Explore your inner world and embrace change.",
                "Sagittarius": "Your Sagittarius Moon brings adventure and expansion to your emotions. Explore new horizons and seek meaning.",
                "Capricorn": "Your Capricorn Moon emphasizes structure and responsibility in your emotional life. Build foundations and work toward goals.",
                "Aquarius": "Your Aquarius Moon brings innovation and independence to your emotions. Embrace your uniqueness and connect with community.",
                "Pisces": "Your Pisces Moon heightens intuition and compassion. Trust your inner wisdom and connect with the spiritual realm."
            ]
            moonInfluence = moonInfluences[moonSign] ?? "Your \(moonSign) Moon influences your emotional patterns this month."
        } else {
            moonInfluence = ""
        }
        
        // Life area focus based on sign
        let lifeAreas: [String: [String]] = [
            "Aries": ["Career and leadership opportunities", "Personal projects and initiatives", "Physical activity and health"],
            "Taurus": ["Financial stability and resources", "Material comfort and values", "Relationships and partnerships"],
            "Gemini": ["Communication and learning", "Social connections and networking", "Short-distance travel"],
            "Cancer": ["Home and family matters", "Emotional security and nurturing", "Personal foundation and roots"],
            "Leo": ["Creative expression and recognition", "Romance and self-expression", "Entertainment and joy"],
            "Virgo": ["Work and daily routines", "Health and wellness", "Service and improvement"],
            "Libra": ["Partnerships and relationships", "Beauty and aesthetics", "Balance and harmony"],
            "Scorpio": ["Transformation and deep change", "Intimate relationships", "Shared resources and investments"],
            "Sagittarius": ["Higher learning and philosophy", "Long-distance travel", "Expansion and adventure"],
            "Capricorn": ["Career and public image", "Long-term goals and structure", "Authority and responsibility"],
            "Aquarius": ["Friendships and community", "Innovation and technology", "Humanitarian causes"],
            "Pisces": ["Spirituality and intuition", "Creative and artistic pursuits", "Compassion and service"]
        ]
        let areas = lifeAreas[sunSign] ?? ["Personal growth", "Relationships", "Career"]
        
        // Format favorable dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let favorableDatesStr = favorableDates.prefix(5).map { dateFormatter.string(from: $0) }.joined(separator: ", ")
        
        // Expanded body lines
        var bodyLines: [String] = []
        bodyLines.append("Your \(sunSign) energy is influenced by \(monthName)'s themes: \(monthlyThemes)")
        if let moonSign = moonSign {
            bodyLines.append("Your \(moonSign) Moon adds emotional depth: \(moonInfluence.components(separatedBy: ". ").first ?? "")")
        }
        if let personalYear = personalYear, let personalYearTheme = personalYearTheme {
            bodyLines.append("Personal Year \(personalYear) emphasizes \(personalYearTheme) throughout this month")
        }
        if !favorableDates.isEmpty {
            bodyLines.append("Favorable dates this month: \(favorableDatesStr)")
        }
        bodyLines.append("Focus areas: \(areas.prefix(2).joined(separator: ", "))")
        
        // Expanded full insight (2-3 sentences)
        var fullInsight = "This month brings \(monthlyThemes) for your \(sunSign) sign, creating opportunities for growth and alignment with your natural tendencies. "
        if moonSign != nil {
            fullInsight += moonInfluence + " "
        }
        if let personalYear = personalYear, let personalYearTheme = personalYearTheme {
            fullInsight += "Your Personal Year \(personalYear) emphasizes \(personalYearTheme), which influences how you experience this month's themes. "
        }
        fullInsight += "Use this month to align with these energies, focus on areas that resonate with your \(sunSign) nature, and take advantage of favorable dates for important decisions."
        
        // More compelling headline
        let compellingHeadline = "Your \(monthName) Horoscope Forecast"
        
        // Expanded insight bullets (4-5 instead of 3)
        var insightBullets: [String] = []
        insightBullets.append("Theme: \(monthlyThemes) - your \(sunSign) sign naturally aligns with these energies")
        if let moonSign = moonSign {
            insightBullets.append("Emotional influence: Your \(moonSign) Moon shapes how you experience this month's themes emotionally")
        }
        if let personalYear = personalYear, let personalYearTheme = personalYearTheme {
            insightBullets.append("Numerology: Personal Year \(personalYear) emphasizes \(personalYearTheme), adding depth to this month")
        }
        insightBullets.append("Best use: Focus on areas that match your sign's natural tendencies: \(areas.prefix(2).joined(separator: " and "))")
        if !favorableDates.isEmpty {
            insightBullets.append("Favorable dates: Use \(favorableDatesStr) for important decisions and new beginnings")
        }
        
        // Expanded guidance (5-6 instead of 3)
        var guidance: [String] = []
        guidance.append("Do: Align your actions with this month's \(monthlyThemes) themes, especially in areas related to your \(sunSign) sign")
        if let moonSign = moonSign {
            guidance.append("Emotional focus: \(moonInfluence.components(separatedBy: ". ").first ?? "Work with your \(moonSign) Moon's emotional energy")")
        }
        guidance.append("Try: Exploring new approaches in \(areas.prefix(2).joined(separator: " and ")) that match your sign's energy")
        if let personalYear = personalYear {
            guidance.append("Numerology alignment: Work with your Personal Year \(personalYear) theme while navigating this month's energies")
        }
        if !favorableDates.isEmpty {
            guidance.append("Timing: Schedule important decisions and new initiatives for favorable dates: \(favorableDatesStr)")
        }
        guidance.append("Avoid: Fighting against the natural flow of this month - work with your \(sunSign) sign's tendencies rather than against them")
        
        // Expanded one-line insight (2-3 sentences)
        var oneLineInsight = "This month brings \(monthlyThemes) for your \(sunSign) sign, creating opportunities for growth and alignment. "
        if let moonSign = moonSign {
            oneLineInsight += moonInfluence.components(separatedBy: ". ").first ?? "Your \(moonSign) Moon influences your emotional experience. "
        }
        if let personalYear = personalYear, let personalYearTheme = personalYearTheme {
            oneLineInsight += "Your Personal Year \(personalYear) emphasizes \(personalYearTheme), adding depth to this month's themes. "
        }
        oneLineInsight += "Focus on areas that resonate with your \(sunSign) nature and use favorable dates for important decisions."
        
        return GeneratedEventContent(
            headline: compellingHeadline,
            bodyLines: bodyLines,
            fullInsight: fullInsight,
            astrologicalContext: "Monthly Horoscope • \(monthName) • \(sunSign) Sun\(moonSign != nil ? " • \(moonSign!) Moon" : "")",
            numerologyContext: personalYear != nil ? "Personal Year \(personalYear!)" : nil,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: [
                    "What themes from this month resonate most with my \(sunSign) nature?",
                    "How can I align my actions with this month's energy and my Personal Year theme?",
                    "What areas of life (\(areas.prefix(3).joined(separator: ", "))) need attention this month?",
                    "How can I use the favorable dates this month for important decisions?"
                ],
                contextSection: "Monthly horoscopes reflect the combination of your \(sunSign) sign, current astrological transits, and your personal numerological cycles. This \(monthName) forecast combines your \(sunSign) Sun's natural tendencies with \(moonSign != nil ? "your \(moonSign!) Moon's emotional influence, " : "")\(personalYear != nil ? "your Personal Year \(personalYear!) theme of \(personalYearTheme ?? "growth"), " : "")and the month's specific astrological energies. Your \(sunSign) sign naturally aligns with \(monthlyThemes), and this month provides opportunities to express these qualities in areas like \(areas.prefix(2).joined(separator: " and ")).\(!favorableDates.isEmpty ? " The favorable dates (\(favorableDatesStr)) are calculated based on your Personal Day numbers, which align with your birth date and current numerological cycles." : "") Use this month to work with your sign's natural flow rather than against it.",
                deeperInsight: nil,
                practicalReflection: nil
            ),
            timeframeLabel: "This Month",
            summarySentence: "Your personalized \(monthName) horoscope forecast combines your \(sunSign) sign's energy with \(moonSign != nil ? "your \(moonSign!) Moon's influence and " : "")your Personal Year \(personalYear ?? 0) theme."
        )
    }
    
    // MARK: - Personal Month Change Content
    
    private func generatePersonalMonthContent(event: PremiumEvent, userData: UserData) -> GeneratedEventContent {
        let personalMonth = event.personalizationData.userPersonalMonth ?? 1
        let personalYear = event.personalizationData.userPersonalYear
        
        let calendar = Calendar.current
        let now = Date()
        let month = calendar.component(.month, from: now)
        let year = calendar.component(.year, from: now)
        
        // Calculate dates within the month that align with Personal Month number
        var alignedDates: [Date] = []
        if let birthDate = userData.birthDate {
            let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? now
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? now
            
            var currentDate = startOfMonth
            while currentDate <= endOfMonth {
                let personalDay = numerologyService.getPersonalDayNumber(birthDate: birthDate, currentDate: currentDate)
                // Dates where Personal Day matches Personal Month are especially aligned
                if personalDay == personalMonth {
                    alignedDates.append(currentDate)
                }
                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? endOfMonth
            }
        }
        
        let monthThemes: [Int: (name: String, description: String, focus: String, lifeAreas: [String], dailyPractices: [String], examples: String)] = [
            1: (
                name: "New Beginnings",
                description: "A month for starting fresh and taking initiative",
                focus: "Begin new projects, make independent decisions, and step into leadership",
                lifeAreas: ["Career beginnings", "Personal projects", "Self-identity", "Leadership roles"],
                dailyPractices: ["Set one clear intention for the day", "Take one action toward a new goal", "Write down new ideas that come to you"],
                examples: "Start a new job or side project, launch something you've been thinking about, take on a leadership role, or make a decision you've been putting off"
            ),
            2: (
                name: "Partnership & Cooperation",
                description: "A month for working with others and finding balance",
                focus: "Strengthen relationships, collaborate with others, and find middle ground",
                lifeAreas: ["Romantic relationships", "Business partnerships", "Collaborations", "Diplomacy"],
                dailyPractices: ["Listen actively in conversations", "Look for ways to compromise", "Reach out to someone you care about"],
                examples: "Have a meaningful conversation with your partner, start a collaboration, work on finding balance in a relationship, or practice being more diplomatic"
            ),
            3: (
                name: "Creativity & Expression",
                description: "A month for creating, communicating, and connecting with others",
                focus: "Share your ideas, start creative projects, and express yourself authentically",
                lifeAreas: ["Creative projects", "Communication", "Self-expression", "Social connections"],
                dailyPractices: ["Do one creative activity (write, draw, make music, etc.)", "Share an idea or creation with someone", "Have a meaningful conversation"],
                examples: "Write a blog post or story, start learning an instrument, share your artwork online, improve your public speaking, join a creative group, or express your authentic self more openly"
            ),
            4: (
                name: "Structure & Planning",
                description: "A month for getting organized and building solid foundations",
                focus: "Create routines, organize your space, and plan for the future",
                lifeAreas: ["Home and family", "Work organization", "Health routines", "Financial planning"],
                dailyPractices: ["Do one organizing task", "Follow a routine you've created", "Plan tomorrow's priorities"],
                examples: "Organize a room in your home, create a better work system, establish a health routine, set up a budget, or plan a long-term goal"
            ),
            5: (
                name: "Change & Freedom",
                description: "A month for trying new things and breaking out of routines",
                focus: "Explore new experiences, learn something different, and embrace spontaneity",
                lifeAreas: ["Travel and adventure", "Learning new skills", "Breaking routines", "Embracing freedom"],
                dailyPractices: ["Try one new thing today", "Break your usual routine in a small way", "Say yes to something unexpected"],
                examples: "Take a trip, learn a new skill or hobby, change up your daily routine, explore a new opportunity, or do something spontaneous"
            ),
            6: (
                name: "Care & Responsibility",
                description: "A month for taking care of yourself and those you love",
                focus: "Nurture relationships, create a comfortable home, and practice self-care",
                lifeAreas: ["Family relationships", "Home environment", "Health and wellness", "Service to others"],
                dailyPractices: ["Do something kind for someone", "Tidy or improve your living space", "Take care of your own needs"],
                examples: "Spend quality time with family, make your home more comfortable, focus on your health, help someone in need, or practice better self-care"
            ),
            7: (
                name: "Reflection & Inner Work",
                description: "A month for slowing down, looking inward, and seeking deeper understanding",
                focus: "Take time alone, reflect on your life, and explore spiritual or philosophical questions",
                lifeAreas: ["Spiritual practice", "Inner work", "Research and study", "Solitude"],
                dailyPractices: ["Spend 10-15 minutes in quiet reflection", "Journal about your thoughts and feelings", "Read or study something meaningful"],
                examples: "Start a meditation practice, do some inner work or therapy, study something that interests you deeply, spend time alone in nature, or explore spiritual questions"
            ),
            8: (
                name: "Achievement & Success",
                description: "A month for focusing on career, money, and building material success",
                focus: "Advance in your career, work toward financial goals, and make strategic decisions",
                lifeAreas: ["Career advancement", "Financial goals", "Business success", "Authority and power"],
                dailyPractices: ["Take one action toward a career goal", "Review your finances", "Make a strategic decision"],
                examples: "Ask for a promotion or raise, start a side business, set up a savings plan, make a big career move, or take on more responsibility at work"
            ),
            9: (
                name: "Completion & Service",
                description: "A month for finishing what you started and helping others",
                focus: "Complete old projects, let go of what's finished, and serve others with compassion",
                lifeAreas: ["Ending cycles", "Service to others", "Compassion and giving", "Universal love"],
                dailyPractices: ["Finish one thing you've been putting off", "Do something kind for someone", "Let go of something that's no longer serving you"],
                examples: "Finish a project you started months ago, volunteer or help someone in need, practice more compassion, let go of something that's over, or express gratitude"
            )
        ]
        
        let theme = monthThemes[personalMonth] ?? (
            name: "Growth",
            description: "Personal growth",
            focus: "Focusing on development",
            lifeAreas: ["Personal development"],
            dailyPractices: ["Focus on growth"],
            examples: "Personal development activities"
        )
        
        // Format aligned dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let alignedDatesStr = alignedDates.prefix(5).map { dateFormatter.string(from: $0) }.joined(separator: ", ")
        
        // How Personal Month interacts with Personal Year
        let yearMonthInteraction: String
        if let personalYear = personalYear {
            let interactions: [String: String] = [
                "1-1": "Your Personal Year 1 and Personal Month 1 create powerful new beginning energy - double the initiative and independence",
                "1-2": "Personal Year 1's new beginnings combine with Personal Month 2's partnership focus - balance independence with cooperation",
                "1-3": "Year 1's fresh starts align with Month 3's creativity - express your new identity through creative projects",
                "2-1": "Year 2's cooperation combines with Month 1's new beginnings - start new partnerships or collaborations",
                "2-2": "Double partnership energy - focus heavily on relationships, balance, and cooperation",
                "3-3": "Double creativity - this is a highly creative and expressive period",
                "4-4": "Double structure - focus intensely on building foundations and organization",
                "5-5": "Double change - expect significant shifts and embrace freedom",
                "6-6": "Double care - focus on home, family, and nurturing",
                "7-7": "Double reflection - deep introspection and spiritual seeking",
                "8-8": "Double achievement - powerful material success and career advancement",
                "9-9": "Double completion - major endings and service to others"
            ]
            let key = "\(personalYear)-\(personalMonth)"
            yearMonthInteraction = interactions[key] ?? "Your Personal Year \(personalYear) and Personal Month \(personalMonth) work together to create a unique monthly experience that combines \(getPersonalYearTheme(personalYear: personalYear)) with \(theme.description.lowercased())."
        } else {
            yearMonthInteraction = ""
        }
        
        // Expanded body lines - clearer language
        var bodyLines: [String] = []
        bodyLines.append("This month's focus: \(theme.name)")
        bodyLines.append(theme.description)
        bodyLines.append("Put energy into: \(theme.lifeAreas.prefix(3).joined(separator: ", "))")
        if let personalYear = personalYear {
            bodyLines.append("Works together with your Personal Year \(personalYear) theme")
        }
        if !alignedDates.isEmpty {
            bodyLines.append("Best dates for this focus: \(alignedDatesStr)")
        }
        
        // Expanded full insight (2-3 sentences) - clearer language
        var fullInsight = "This month is about \(theme.description.lowercased()). Think of it as a time when the energy naturally supports \(theme.focus.lowercased()). You'll find it easier to focus on \(theme.lifeAreas.prefix(2).joined(separator: " and ")) during this period. "
        if personalYear != nil {
            fullInsight += yearMonthInteraction + " "
        }
        fullInsight += "Use this month to \(theme.focus.lowercased()). Try the daily practices suggested, and consider scheduling important activities on dates that align with this month's energy."
        
        // More compelling headline
        let compellingHeadline = "Your Personal Month \(personalMonth) Begins"
        
        // Expanded insight bullets (4-5 instead of 3) - clearer language
        var insightBullets: [String] = []
        insightBullets.append("What this means: \(theme.description)")
        insightBullets.append("Best use: \(theme.focus)")
        insightBullets.append("Focus areas: Put energy into \(theme.lifeAreas.prefix(2).joined(separator: " and "))")
        if let personalYear = personalYear {
            let interactionText = yearMonthInteraction.components(separatedBy: " - ").first ?? yearMonthInteraction
            insightBullets.append("With your Personal Year \(personalYear): \(interactionText)")
        }
        if !alignedDates.isEmpty {
            insightBullets.append("Best dates: Use \(alignedDatesStr) for activities related to \(theme.name.lowercased())")
        }
        
        // Expanded guidance (5-6 instead of 3) - clearer, more actionable
        var guidance: [String] = []
        guidance.append("Do: Focus on \(theme.lifeAreas.prefix(2).joined(separator: " and ")) this month - the energy naturally supports these areas")
        guidance.append("Daily: \(theme.dailyPractices.joined(separator: " • "))")
        guidance.append("Try this month: \(theme.examples)")
        if !alignedDates.isEmpty {
            guidance.append("Best dates: Schedule important activities for \(alignedDatesStr) - these dates align with this month's energy")
        }
        if let personalYear = personalYear {
            guidance.append("Remember: You're also in Personal Year \(personalYear), so combine both themes in your approach")
        }
        guidance.append("Avoid: Resisting this month's focus - work with the energy rather than against it")
        
        // Expanded one-line insight (2-3 sentences) - clearer, simpler language
        var oneLineInsight = "This month is about \(theme.description.lowercased()). It's a good time to \(theme.focus.lowercased()). "
        if let personalYear = personalYear {
            oneLineInsight += "Since you're also in Personal Year \(personalYear), these themes work together. "
        }
        oneLineInsight += "Put your energy into \(theme.lifeAreas.prefix(2).joined(separator: " and ")) this month."
        
        return GeneratedEventContent(
            headline: compellingHeadline,
            bodyLines: bodyLines,
            fullInsight: fullInsight,
            astrologicalContext: nil,
            numerologyContext: "Personal Month \(personalMonth) • Personal Year \(personalYear ?? 0)",
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: [
                    "What does Personal Month \(personalMonth) mean for me in my current life situation?",
                    "How can I work with this month's \(theme.description.lowercased()) energy?",
                    "What areas (\(theme.lifeAreas.prefix(3).joined(separator: ", "))) need attention this month?",
                    "How does this Personal Month interact with my Personal Year \(personalYear ?? 0) theme?"
                ],
                contextSection: "Your Personal Month changes each calendar month, based on your birth date and the current date. Think of it as a monthly theme that influences what areas of life feel easier or more natural to focus on. This month (Personal Month \(personalMonth)) is about \(theme.description.lowercased()). This means it's a good time to \(theme.focus.lowercased()), especially in areas like \(theme.lifeAreas.prefix(2).joined(separator: " and ")).\(personalYear != nil ? " You're also in Personal Year \(personalYear!), which has its own theme. These two themes work together - your year theme sets the overall direction, while this month's theme shows what to focus on right now." : "") The daily practices suggested below help you work with this month's energy naturally.",
                deeperInsight: nil,
                practicalReflection: nil
            ),
            timeframeLabel: "This Month",
            summarySentence: "Your Personal Month \(personalMonth) begins: \(theme.name). Focus on \(theme.lifeAreas.prefix(2).joined(separator: " and "))."
        )
    }
    
    // MARK: - Saturn Return Content
    
    private func generateSaturnReturnContent(event: PremiumEvent, userData: UserData) -> GeneratedEventContent {
        let age = event.personalizationData.userAge ?? 0
        let isFirstReturn = age >= 27 && age <= 32
        let sunSign = event.personalizationData.userSunSign
        
        // Calculate years remaining/into Saturn Return
        let saturnReturnStart = isFirstReturn ? 27 : 55
        let saturnReturnEnd = isFirstReturn ? 32 : 60
        let yearsIntoReturn = age - saturnReturnStart
        let yearsRemaining = saturnReturnEnd - age
        
        // Saturn Return phases
        let phase: String
        let phaseDescription: String
        if isFirstReturn {
            if yearsIntoReturn <= 1 {
                phase = "Early Phase"
                phaseDescription = "You're in the early phase of your first Saturn Return (ages 27-28). Saturn is beginning to test your foundations and ask you to take on adult responsibilities. This is a time of awakening to what needs to be built."
            } else if yearsIntoReturn <= 3 {
                phase = "Peak Phase"
                phaseDescription = "You're in the peak phase of your first Saturn Return (ages 29-30). Saturn's pressure is at its strongest, testing your commitments and asking you to build lasting structures. Major life decisions are likely during this period."
            } else {
                phase = "Integration Phase"
                phaseDescription = "You're in the integration phase of your first Saturn Return (ages 31-32). You're integrating the lessons and structures you've built. Saturn is preparing to move forward, and you're solidifying your adult identity."
            }
        } else {
            if yearsIntoReturn <= 1 {
                phase = "Early Phase"
                phaseDescription = "You're in the early phase of your second Saturn Return (ages 55-56). Saturn is beginning to ask you to reflect on your life's work and consider your legacy. This is a time of wisdom gathering."
            } else if yearsIntoReturn <= 3 {
                phase = "Peak Phase"
                phaseDescription = "You're in the peak phase of your second Saturn Return (ages 57-58). Saturn's influence is strongest, asking you to honor what you've built and share your wisdom. This is a time of legacy building."
            } else {
                phase = "Integration Phase"
                phaseDescription = "You're in the integration phase of your second Saturn Return (ages 59-60). You're integrating your life's wisdom and preparing to share it with others. Saturn is solidifying your legacy."
            }
        }
        
        // Life areas being tested (based on Saturn's traditional associations)
        let lifeAreas: [String]
        if isFirstReturn {
            lifeAreas = [
                "Career and life direction",
                "Long-term commitments and relationships",
                "Financial responsibility and stability",
                "Personal identity and adult role",
                "Family structures and responsibilities"
            ]
        } else {
            lifeAreas = [
                "Legacy and life's work",
                "Wisdom sharing and teaching",
                "Mentorship and guidance",
                "Reflection on life's journey",
                "Spiritual and philosophical understanding"
            ]
        }
        
        // Note: challenges and opportunities are defined for future use in expanded content
        
        // Expanded body lines
        var bodyLines: [String] = []
        bodyLines.append(isFirstReturn ? "You're in your first Saturn Return (ages 27-32)" : "You're in your second Saturn Return (ages 55-60)")
        bodyLines.append("Current phase: \(phase) - \(yearsIntoReturn) years into this return")
        if yearsRemaining > 0 {
            bodyLines.append("\(yearsRemaining) years remaining in this Saturn Return period")
        }
        bodyLines.append("Focus areas: \(lifeAreas.prefix(2).joined(separator: ", "))")
        
        // Expanded full insight (2-3 sentences)
        var fullInsight = phaseDescription + " "
        if isFirstReturn {
            fullInsight += "Your \(sunSign) Sun's natural expression is being tested and refined by Saturn's demands for structure and responsibility. This is a time to build lasting foundations in career, relationships, and personal identity that will support you for the next 29.5 years. Saturn asks you to commit to something real, take on adult responsibilities, and create structures that will last."
        } else {
            fullInsight += "Your \(sunSign) Sun's accumulated wisdom is being honored and shared by Saturn's call to legacy. This is a time to reflect on what you've built, share your knowledge with others, and consider your lasting impact. Saturn asks you to honor what you've created, teach what you've learned, and prepare your wisdom for the next generation."
        }
        
        // More compelling headline
        let compellingHeadline = isFirstReturn 
            ? "Your Saturn Return Journey"
            : "Your Second Saturn Return"
        
        // Expanded insight bullets (4-5 instead of 3)
        var insightBullets: [String] = []
        insightBullets.append("Phase: \(phase) - \(phaseDescription.components(separatedBy: ". ").first ?? "")")
        insightBullets.append(isFirstReturn ? "Theme: Building lasting structures and taking adult responsibility" : "Theme: Reflecting on legacy and sharing accumulated wisdom")
        insightBullets.append("Life areas: Focus on \(lifeAreas.prefix(2).joined(separator: " and "))")
        insightBullets.append("Timeline: \(yearsIntoReturn) years into return, \(yearsRemaining > 0 ? "\(yearsRemaining) years remaining" : "near completion")")
        insightBullets.append("Your \(sunSign) Sun: Your natural expression is \(isFirstReturn ? "being tested and refined" : "being honored and shared") during this period")
        
        // Expanded guidance (5-6 instead of 3)
        var guidance: [String] = []
        if isFirstReturn {
            guidance.append("Do: Take responsibility for your life direction and build structures that will last - your \(sunSign) Sun benefits from Saturn's discipline")
            guidance.append("Build: Create foundations in \(lifeAreas.prefix(2).joined(separator: " and ")) that will support you for decades")
            guidance.append("Commit: Make long-term commitments to goals, relationships, and structures that align with your authentic self")
            guidance.append("Face: Address areas where you've been provisional or avoided adult responsibilities")
        } else {
            guidance.append("Do: Reflect on your life's work and share your accumulated wisdom - your \(sunSign) Sun's experience is valuable")
            guidance.append("Share: Teach, mentor, or guide others, especially those in their first Saturn Return")
            guidance.append("Honor: Recognize and celebrate what you've built and the wisdom you've gained")
            guidance.append("Integrate: Combine your life's lessons into meaningful guidance for others")
        }
        guidance.append("Timeline: Use the remaining \(yearsRemaining > 0 ? "\(yearsRemaining) years" : "time") to \(isFirstReturn ? "complete your structures" : "solidify your legacy")")
        guidance.append("Avoid: \(isFirstReturn ? "Staying provisional, avoiding commitments, or resisting adult responsibilities" : "Dismissing your wisdom, avoiding reflection, or neglecting to share your knowledge")")
        
        // Expanded one-line insight (2-3 sentences)
        var oneLineInsight = phaseDescription + " "
        if isFirstReturn {
            oneLineInsight += "Your \(sunSign) Sun's natural expression is being tested by Saturn's demands for structure and responsibility. This is a time to build lasting foundations that will support you for the next 29.5 years."
        } else {
            oneLineInsight += "Your \(sunSign) Sun's accumulated wisdom is being honored by Saturn's call to legacy. This is a time to reflect on what you've built and share your knowledge with others."
        }
        
        return GeneratedEventContent(
            headline: compellingHeadline,
            bodyLines: bodyLines,
            fullInsight: fullInsight,
            astrologicalContext: "Saturn Return • \(phase) • Ages \(saturnReturnStart)-\(saturnReturnEnd)",
            numerologyContext: nil,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: [
                    isFirstReturn
                        ? "What structures do I need to build in my life that will last for decades?"
                        : "What wisdom have I gained that I can share with others?",
                    isFirstReturn
                        ? "What responsibilities am I ready to take on as an adult?"
                        : "What legacy do I want to leave, and how can I begin to build it?",
                    isFirstReturn
                        ? "How can I commit to something real and lasting rather than staying provisional?"
                        : "How can I honor what I've created while remaining open to continued growth?",
                    "What areas (\(lifeAreas.prefix(3).joined(separator: ", "))) need the most attention during this \(phase.lowercased())?"
                ],
                contextSection: "Saturn Return occurs approximately every 29.5 years, marking major life transitions. \(isFirstReturn ? "Your first return (ages 27-32) asks you to build lasting structures and take on adult responsibilities. This is a time when you're tested on your ability to commit to long-term goals, relationships, and career paths." : "Your second return (ages 55-60) asks you to reflect on your life's work and share your wisdom. This is a time when you're called to honor what you've built while remaining open to continued growth.") You're currently \(yearsIntoReturn) years into this return, in the \(phase.lowercased()). During this period, Saturn tests you in specific life areas: \(lifeAreas.prefix(3).joined(separator: ", ")). Your \(sunSign) Sun sign influences how you experience this Saturn Return - \(sunSign) signs naturally \(isFirstReturn ? "express energy in ways that are being tested for long-term sustainability" : "carry wisdom that's ready to be shared with others"). This is a profound period of growth, challenge, and opportunity that shapes the next 29.5 years of your life.",
                deeperInsight: nil,
                practicalReflection: nil
            ),
            timeframeLabel: "Active Period",
            summarySentence: isFirstReturn 
                ? "You're in your first Saturn Return (\(phase)), \(yearsIntoReturn) years into this major life transition. Focus on building lasting structures."
                : "You're in your second Saturn Return (\(phase)), \(yearsIntoReturn) years into this wisdom period. Focus on sharing your legacy."
        )
    }
    
    // MARK: - Favorable Dates Content
    
    private func generateFavorableDatesContent(event: PremiumEvent, userData: UserData) -> GeneratedEventContent {
        // Extract dates from additionalData
        let dateTimestamps = event.personalizationData.additionalData?["dates"] as? [TimeInterval] ?? []
        let dates = dateTimestamps.map { Date(timeIntervalSince1970: $0) }
        
        guard let birthDate = userData.birthDate, !dates.isEmpty else {
            // Fallback if no dates
            return GeneratedEventContent(
                headline: "Best Dates for Important Decisions",
                bodyLines: ["Calculating favorable dates based on your numerology"],
                fullInsight: "Favorable dates are being calculated based on your Personal Day numbers.",
                astrologicalContext: nil,
                numerologyContext: "Favorable Numerology Dates",
                expandedContent: ExpandedGuidanceContent(
                    oneLineInsight: "Favorable dates are calculated based on your Personal Day numbers and numerology patterns.",
                    insightBullets: ["Theme: Favorable timing", "Best use: Important decisions", "Watch for: Numerology alignment"],
                    guidance: ["Do: Use favorable dates", "Try: Aligning timing", "Avoid: Unfavorable dates"],
                    reflectionQuestions: ["What decisions need timing?", "How to use favorable dates?"],
                    contextSection: "Favorable dates are calculated based on your Personal Day numbers.",
                    deeperInsight: nil,
                    practicalReflection: nil
                ),
                timeframeLabel: "This Week",
                summarySentence: "Favorable dates for important decisions"
            )
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = "MMM d"
        
        // Calculate numerology for each date and categorize
        struct DateInfo {
            let date: Date
            let personalDay: Int
            let personalMonth: Int
            let personalYear: Int
            let whyFavorable: String
            let bestFor: String
        }
        
        var dateInfos: [DateInfo] = []
        for date in dates {
            let personalDay = numerologyService.getPersonalDayNumber(birthDate: birthDate, currentDate: date)
            let personalMonth = numerologyService.getPersonalMonthNumber(birthDate: birthDate, currentDate: date)
            let personalYear = numerologyService.getPersonalYearNumber(birthDate: birthDate, currentDate: date)
            
            // Determine why it's favorable
            var whyFavorable = ""
            var bestFor = ""
            
            switch personalDay {
            case 1:
                whyFavorable = "Personal Day 1 - New beginnings and leadership energy"
                bestFor = "Starting new projects, taking leadership roles, making independent decisions"
            case 3:
                whyFavorable = "Personal Day 3 - Creative expression and communication"
                bestFor = "Creative projects, communication, social connections, self-expression"
            case 6:
                whyFavorable = "Personal Day 6 - Harmony and responsibility"
                bestFor = "Relationships, home matters, care and nurturing, creating harmony"
            case 8:
                whyFavorable = "Personal Day 8 - Achievement and material success"
                bestFor = "Career decisions, financial matters, business deals, material goals"
            default:
                if personalDay == personalYear {
                    whyFavorable = "Personal Day \(personalDay) aligns with your Personal Year \(personalYear) - powerful alignment"
                    bestFor = "Major life decisions, long-term commitments, aligning with your year's theme"
                } else {
                    whyFavorable = "Personal Day \(personalDay) - Numerological alignment"
                    bestFor = "General decision-making and important activities"
                }
            }
            
            dateInfos.append(DateInfo(
                date: date,
                personalDay: personalDay,
                personalMonth: personalMonth,
                personalYear: personalYear,
                whyFavorable: whyFavorable,
                bestFor: bestFor
            ))
        }
        
        // Format all dates
        let allDatesStr = dateInfos.map { shortDateFormatter.string(from: $0.date) }.joined(separator: ", ")
        let firstThreeDatesStr = dateInfos.prefix(3).map { shortDateFormatter.string(from: $0.date) }.joined(separator: ", ")
        
        // Expanded body lines
        var bodyLines: [String] = []
        bodyLines.append("\(dates.count) favorable dates for important decisions")
        bodyLines.append("Dates: \(allDatesStr)")
        bodyLines.append("These dates align with favorable Personal Day numbers")
        if let firstDate = dateInfos.first {
            bodyLines.append("Example: \(shortDateFormatter.string(from: firstDate.date)) - Personal Day \(firstDate.personalDay)")
        }
        
        // Expanded full insight (2-3 sentences)
        var fullInsight = "You have \(dates.count) favorable dates coming up for making important decisions: \(allDatesStr). "
        fullInsight += "These dates are calculated based on your Personal Day numbers, which combine your birth date with each specific date to reveal numerological alignment. "
        fullInsight += "Each date has a specific Personal Day number (1, 3, 6, or 8, or alignment with your Personal Year) that supports different types of decisions - from new beginnings to creative expression, harmony to achievement. Use these dates strategically for signing contracts, making commitments, starting projects, or making major life decisions."
        
        // More compelling headline
        let compellingHeadline = "Best Dates for Important Decisions"
        
        // Expanded insight bullets (4-5 instead of 3)
        var insightBullets: [String] = []
        insightBullets.append("Theme: Favorable numerology timing for important decisions based on your Personal Day numbers")
        insightBullets.append("Best use: Schedule important decisions, contracts, commitments, and new beginnings for these dates")
        insightBullets.append("Calculation: Each date's Personal Day number (calculated from your birth date + the specific date) determines its favorability")
        insightBullets.append("Favorable numbers: Personal Day 1 (new beginnings), 3 (creativity), 6 (harmony), 8 (achievement), or alignment with Personal Year")
        insightBullets.append("Count: \(dates.count) favorable dates identified: \(allDatesStr)")
        
        // Expanded guidance (5-6 instead of 3) - include specific date guidance
        var guidance: [String] = []
        guidance.append("Do: Schedule important decisions, contracts, and commitments for these favorable dates")
        
        // Add specific guidance for each date (up to 5 dates)
        for dateInfo in dateInfos.prefix(5) {
            let dateStr = shortDateFormatter.string(from: dateInfo.date)
            guidance.append("\(dateStr): Use for \(dateInfo.bestFor) - \(dateInfo.whyFavorable)")
        }
        
        if dateInfos.count > 5 {
            guidance.append("Additional dates: \(dateInfos.dropFirst(5).map { shortDateFormatter.string(from: $0.date) }.joined(separator: ", ")) also favorable")
        }
        
        guidance.append("Prepare: Plan your important decisions in advance so you can schedule them for these favorable dates")
        guidance.append("Avoid: Making major decisions on dates not listed here - wait for the next favorable period")
        
        // Expanded one-line insight (2-3 sentences)
        var oneLineInsight = "You have \(dates.count) favorable dates coming up (\(firstThreeDatesStr)\(dates.count > 3 ? " and more" : "")) for making important decisions based on your Personal Day numerology. "
        oneLineInsight += "Each date has a specific Personal Day number that supports different types of decisions - from new beginnings (Day 1) to creative expression (Day 3), harmony (Day 6) to achievement (Day 8). "
        oneLineInsight += "Use these dates strategically for signing contracts, making commitments, starting projects, or making major life decisions."
        
        // Create detailed date explanations
        var dateExplanations: [String] = []
        for dateInfo in dateInfos {
            let dateStr = dateFormatter.string(from: dateInfo.date)
            let explanation = "\(dateStr): Personal Day \(dateInfo.personalDay) (Personal Month \(dateInfo.personalMonth), Personal Year \(dateInfo.personalYear)) - \(dateInfo.whyFavorable). Best for: \(dateInfo.bestFor)."
            dateExplanations.append(explanation)
        }
        
        return GeneratedEventContent(
            headline: compellingHeadline,
            bodyLines: bodyLines,
            fullInsight: fullInsight,
            astrologicalContext: nil,
            numerologyContext: "Favorable Numerology Dates • \(dates.count) dates identified",
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: [
                    "What important decisions do I need to make in the coming weeks?",
                    "How can I schedule these decisions to align with the favorable dates?",
                    "What types of decisions match each date's Personal Day number energy?",
                    "What projects or commitments could benefit from starting on these dates?"
                ],
                contextSection: "Favorable dates are calculated by combining your birth date with each specific date to determine the Personal Day number. Personal Day numbers 1 (new beginnings), 3 (creativity), 6 (harmony), and 8 (achievement) are considered favorable for important decisions. Dates where your Personal Day aligns with your Personal Year are also highly favorable. These calculations are unique to your birth date and current numerological cycles. The \(dates.count) dates identified (\(allDatesStr)) each have specific numerological energy that supports different types of decisions. Personal Day 1 dates are ideal for starting new projects, Personal Day 3 dates support creative endeavors, Personal Day 6 dates favor relationship and home matters, and Personal Day 8 dates are powerful for career and financial decisions. Use these dates strategically to align your important decisions with supportive numerological energy.",
                deeperInsight: nil,
                practicalReflection: nil
            ),
            timeframeLabel: "This Week",
            summarySentence: "\(dates.count) favorable dates for important decisions: \(allDatesStr). Each date has specific numerology supporting different types of decisions."
        )
    }
    
    // MARK: - Focus Area Content
    
    private func generateFocusAreaContent(event: PremiumEvent, userData: UserData) -> GeneratedEventContent {
        let personalMonth = event.personalizationData.userPersonalMonth ?? 1
        let personalYear = event.personalizationData.userPersonalYear
        let sunSign = event.personalizationData.userSunSign
        
        let focusAreas: [Int: (area: String, reason: String, actions: [String], examples: [String], dailyPractices: [String], weeklyPractices: [String], lifeAreas: [String], whyItMatters: String)] = [
            1: (
                area: "New Projects",
                reason: "Personal Month 1 emphasizes new beginnings and fresh starts",
                actions: ["Start new initiatives", "Take independent action", "Lead with confidence", "Make bold decisions", "Initiate change"],
                examples: ["Starting a new job or project", "Launching a personal initiative", "Taking on a leadership role", "Making a major life change", "Beginning a new creative endeavor"],
                dailyPractices: ["Set one new intention each morning", "Take one independent action daily", "Document new ideas and possibilities", "Practice self-leadership"],
                weeklyPractices: ["Start one new project or initiative", "Make progress on a personal goal", "Take a leadership role in something"],
                lifeAreas: ["Career beginnings", "Personal projects", "Self-identity", "Leadership roles", "Independent action"],
                whyItMatters: "Personal Month 1 is a powerful time for new beginnings. The number 1 represents leadership, independence, and initiation. This is your opportunity to start fresh, take charge, and create something new. Your \(sunSign) Sun's natural expression is amplified by this new beginning energy."
            ),
            2: (
                area: "Relationships",
                reason: "Personal Month 2 focuses on partnership, cooperation, and balance",
                actions: ["Build partnerships", "Seek cooperation", "Find balance", "Practice diplomacy", "Nurture connections"],
                examples: ["Strengthening a romantic relationship", "Forming a business partnership", "Improving family relationships", "Building collaborative projects", "Finding balance in your life"],
                dailyPractices: ["Practice active listening", "Seek compromise in conflicts", "Nurture one relationship daily", "Practice patience and understanding"],
                weeklyPractices: ["Have a meaningful conversation with a partner", "Work on a collaborative project", "Address relationship imbalances"],
                lifeAreas: ["Romantic relationships", "Business partnerships", "Family connections", "Friendships", "Collaborations"],
                whyItMatters: "Personal Month 2 emphasizes partnership and cooperation. The number 2 represents balance, diplomacy, and connection. This is a time to work with others, find harmony, and build relationships. Your \(sunSign) Sun benefits from this cooperative energy."
            ),
            3: (
                area: "Creative Expression",
                reason: "This month naturally supports creativity, communication, and expressing yourself",
                actions: ["Create something", "Share your ideas", "Improve how you communicate", "Start an artistic project", "Connect with others"],
                examples: ["Write a blog post or story", "Start learning an instrument", "Share your artwork online", "Improve your public speaking", "Join a creative group"],
                dailyPractices: ["Do one creative activity (write, draw, make music, etc.)", "Share an idea or creation with someone", "Have a meaningful conversation"],
                weeklyPractices: ["Work on a creative project", "Share your work with others", "Attend a social or creative event"],
                lifeAreas: ["Creative projects", "Communication", "Self-expression", "Social connections", "Artistic pursuits"],
                whyItMatters: "This month is about creating, sharing, and connecting. Think of it as a time when it's easier to express yourself, start creative projects, and communicate with others. The energy naturally supports these activities, so things like writing, art, music, or improving your communication skills will feel more natural and rewarding."
            ),
            4: (
                area: "Structure & Planning",
                reason: "Personal Month 4 focuses on building foundations, organization, and stability",
                actions: ["Create structure", "Plan carefully", "Build foundations", "Organize systems", "Establish routines"],
                examples: ["Organizing your home or workspace", "Creating work systems", "Establishing health routines", "Building financial foundations", "Planning long-term goals"],
                dailyPractices: ["Follow a structured routine", "Organize one area of your life", "Plan your day carefully", "Build one foundation"],
                weeklyPractices: ["Create or improve a system", "Organize a major area", "Make progress on foundational goals"],
                lifeAreas: ["Home and family", "Work organization", "Health routines", "Financial planning", "Long-term structure"],
                whyItMatters: "Personal Month 4 emphasizes structure and foundation-building. The number 4 represents stability, organization, and hard work. This is a time to create systems, establish routines, and build lasting foundations. Your \(sunSign) Sun benefits from this structured approach."
            ),
            5: (
                area: "Change & Freedom",
                reason: "Personal Month 5 emphasizes adaptation, freedom, and exploration",
                actions: ["Embrace change", "Explore new options", "Adapt flexibly", "Seek adventure", "Break routines"],
                examples: ["Traveling or exploring", "Learning new skills", "Changing routines", "Trying new experiences", "Seeking freedom and adventure"],
                dailyPractices: ["Try something new each day", "Break out of a routine", "Embrace spontaneity", "Explore new possibilities"],
                weeklyPractices: ["Take a trip or adventure", "Learn a new skill", "Make a significant change", "Explore new opportunities"],
                lifeAreas: ["Travel and adventure", "Learning and education", "Breaking routines", "Embracing freedom", "New experiences"],
                whyItMatters: "Personal Month 5 is a time for change and freedom. The number 5 represents adventure, flexibility, and exploration. This is your opportunity to break free from limitations, try new things, and embrace change. Your \(sunSign) Sun's natural expression benefits from this freedom."
            ),
            6: (
                area: "Home & Family",
                reason: "Personal Month 6 focuses on care, responsibility, and nurturing",
                actions: ["Nurture relationships", "Take responsibility", "Create harmony", "Care for others", "Build home"],
                examples: ["Strengthening family bonds", "Improving home environment", "Focusing on health", "Serving others", "Creating harmony"],
                dailyPractices: ["Nurture one relationship", "Create harmony at home", "Practice self-care", "Take responsibility"],
                weeklyPractices: ["Improve home environment", "Spend quality time with family", "Focus on health and wellness"],
                lifeAreas: ["Family relationships", "Home environment", "Health and wellness", "Service to others", "Creating harmony"],
                whyItMatters: "Personal Month 6 emphasizes care and responsibility. The number 6 represents nurturing, harmony, and service. This is a time to focus on home, family, and taking care of yourself and others. Your \(sunSign) Sun's caring nature is amplified."
            ),
            7: (
                area: "Inner Reflection",
                reason: "Personal Month 7 emphasizes introspection, spiritual growth, and seeking wisdom",
                actions: ["Seek inner wisdom", "Take time alone", "Reflect deeply", "Study and research", "Practice spirituality"],
                examples: ["Deepening spiritual practice", "Doing inner work", "Studying esoteric topics", "Seeking wisdom", "Practicing meditation"],
                dailyPractices: ["Spend time in solitude", "Practice meditation or reflection", "Engage in deep study", "Seek inner wisdom"],
                weeklyPractices: ["Dedicate time to spiritual practice", "Do deep inner work", "Study something meaningful", "Seek guidance or wisdom"],
                lifeAreas: ["Spiritual practice", "Inner work", "Research and study", "Solitude", "Wisdom seeking"],
                whyItMatters: "Personal Month 7 is a time for inner reflection and spiritual growth. The number 7 represents introspection, wisdom, and seeking. This is your opportunity to go within, seek deeper understanding, and connect with your spiritual nature. Your \(sunSign) Sun benefits from this reflective energy."
            ),
            8: (
                area: "Career & Achievement",
                reason: "Personal Month 8 focuses on material success, achievement, and authority",
                actions: ["Pursue goals", "Build material success", "Exercise authority", "Make strategic decisions", "Focus on career"],
                examples: ["Advancing in career", "Achieving financial goals", "Building business success", "Exercising leadership", "Making strategic moves"],
                dailyPractices: ["Focus on career goals", "Make strategic decisions", "Build material resources", "Exercise authority wisely"],
                weeklyPractices: ["Make progress on major goals", "Take strategic action", "Build business or career success"],
                lifeAreas: ["Career advancement", "Financial goals", "Business success", "Authority and power", "Material achievement"],
                whyItMatters: "Personal Month 8 emphasizes achievement and material success. The number 8 represents power, authority, and material accomplishment. This is a time to focus on career, build success, and exercise your authority. Your \(sunSign) Sun's ambitious nature is amplified."
            ),
            9: (
                area: "Completion & Service",
                reason: "Personal Month 9 emphasizes endings, service, and universal love",
                actions: ["Complete cycles", "Serve others", "Release what's done", "Practice compassion", "Share wisdom"],
                examples: ["Completing old projects", "Serving others", "Practicing compassion", "Ending cycles", "Sharing wisdom"],
                dailyPractices: ["Complete one unfinished project", "Serve someone else", "Practice compassion", "Release what's done"],
                weeklyPractices: ["Complete a major cycle", "Engage in service work", "Share wisdom with others"],
                lifeAreas: ["Ending cycles", "Service to others", "Compassion and giving", "Universal love", "Completing projects"],
                whyItMatters: "Personal Month 9 is a time for completion and service. The number 9 represents endings, compassion, and universal love. This is your opportunity to finish what you've started, serve others, and prepare for new cycles. Your \(sunSign) Sun's compassionate nature is amplified."
            )
        ]
        
        let focus = focusAreas[personalMonth] ?? (
            area: "Growth",
            reason: "Personal growth",
            actions: ["Focus on development"],
            examples: ["Personal development activities"],
            dailyPractices: ["Focus on growth"],
            weeklyPractices: ["Work on development"],
            lifeAreas: ["Personal development"],
            whyItMatters: "This month focuses on personal growth and development."
        )
        
        // How this connects to Personal Year
        let yearConnection: String
        if let personalYear = personalYear {
            yearConnection = "This focus area works in harmony with your Personal Year \(personalYear) theme of \(getPersonalYearTheme(personalYear: personalYear)). Together, they create a powerful combination that guides your monthly experience."
        } else {
            yearConnection = ""
        }
        
        // Expanded body lines
        var bodyLines: [String] = []
        bodyLines.append("This month, focus on \(focus.area)")
        bodyLines.append(focus.reason)
        bodyLines.append("Life areas: \(focus.lifeAreas.prefix(3).joined(separator: ", "))")
        if let personalYear = personalYear {
            bodyLines.append("Works with Personal Year \(personalYear) theme")
        }
        
        // Expanded full insight (2-3 sentences) - clearer language
        var fullInsight = "This month, focus on \(focus.area.lowercased()). \(focus.reason). "
        fullInsight += focus.whyItMatters + " "
        if !yearConnection.isEmpty {
            fullInsight += yearConnection + " "
        }
        fullInsight += "Try activities like \(focus.actions.prefix(3).joined(separator: ", ").lowercased()). The daily and weekly practices below help you work with this month's natural energy."
        
        // More compelling headline
        let compellingHeadline = "Where to Focus This Month"
        
        // Expanded insight bullets (4-5 instead of 3) - clearer language
        var insightBullets: [String] = []
        insightBullets.append("What this means: \(focus.reason)")
        insightBullets.append("Why it matters: \(focus.whyItMatters.components(separatedBy: ". ").first ?? focus.whyItMatters)")
        insightBullets.append("Focus areas: Put energy into \(focus.lifeAreas.prefix(2).joined(separator: " and "))")
        if let personalYear = personalYear {
            insightBullets.append("With your Personal Year \(personalYear): These themes work together")
        }
        insightBullets.append("Best use: \(focus.actions.prefix(2).joined(separator: " and "))")
        
        // Expanded guidance (5-6 instead of 3) - clearer, more actionable
        var guidance: [String] = []
        guidance.append("Do: \(focus.actions[0]) - the energy this month naturally supports this")
        guidance.append("Daily: \(focus.dailyPractices.prefix(2).joined(separator: " • "))")
        guidance.append("Weekly: \(focus.weeklyPractices.prefix(2).joined(separator: " • "))")
        guidance.append("Try this month: \(focus.examples.prefix(2).joined(separator: ", "))")
        if let personalYear = personalYear {
            guidance.append("Remember: You're also in Personal Year \(personalYear), so combine both themes")
        }
        guidance.append("Avoid: Resisting this month's focus - work with the energy rather than against it")
        
        // Expanded one-line insight (2-3 sentences)
        var oneLineInsight = "This month, focus on \(focus.area.lowercased()). "
        oneLineInsight += focus.reason + ". "
        oneLineInsight += focus.whyItMatters.components(separatedBy: ". ").first ?? focus.whyItMatters
        
        return GeneratedEventContent(
            headline: compellingHeadline,
            bodyLines: bodyLines,
            fullInsight: fullInsight,
            astrologicalContext: nil,
            numerologyContext: "Personal Month \(personalMonth)\(personalYear != nil ? " • Personal Year \(personalYear!)" : "")",
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: [
                    "How can I focus on \(focus.area.lowercased()) this month in my current life situation?",
                    "What specific actions (\(focus.actions.prefix(3).joined(separator: ", "))) align with this month's energy?",
                    "What opportunities are available in \(focus.lifeAreas.prefix(2).joined(separator: " and "))?",
                    "How can I incorporate the daily and weekly practices into my routine?"
                ],
                contextSection: "Your Personal Month changes each calendar month, based on your birth date and the current date. Think of it as a monthly theme that shows what areas of life feel easier or more natural to focus on. This month (Personal Month \(personalMonth)) is about \(focus.area.lowercased()). This means it's a good time to \(focus.actions[0].lowercased()), especially in areas like \(focus.lifeAreas.prefix(2).joined(separator: " and ")).\(personalYear != nil ? " You're also in Personal Year \(personalYear!), which has its own theme. These two themes work together - your year theme sets the overall direction, while this month's theme shows what to focus on right now." : "") The practices suggested below help you work with this month's energy naturally.",
                deeperInsight: nil,
                practicalReflection: nil
            ),
            timeframeLabel: "This Month",
            summarySentence: "Focus on \(focus.area) this month. \(focus.reason). Life areas: \(focus.lifeAreas.prefix(2).joined(separator: ", "))."
        )
    }
    
    // MARK: - Moon Phase Content
    
    private func generateMoonPhaseContent(event: PremiumEvent, userData: UserData) -> GeneratedEventContent {
        let moonPhase = astroService.getCurrentMoonPhase()
        let moonSign = event.personalizationData.userMoonSign ?? userData.moonSign ?? "emotional"
        let sunSign = event.personalizationData.userSunSign
        
        // Calculate exact moon phase date (approximate - in production use accurate ephemeris)
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let exactDateStr = dateFormatter.string(from: now)
        
        // Moon sign specific influences
        let moonSignInfluences: [String: (newMoon: String, fullMoon: String, rituals: [String], emotionalPatterns: String)] = [
            "Aries": (
                newMoon: "Your Aries Moon brings passionate, impulsive energy to new beginnings. Set intentions with boldness and take immediate action.",
                fullMoon: "Your Aries Moon intensifies emotional release. Let go of anger, impatience, and impulsive reactions with conscious awareness.",
                rituals: ["Light a red candle for passion", "Write intentions with bold declarations", "Take physical action toward goals"],
                emotionalPatterns: "You may feel more impulsive, passionate, and action-oriented. Channel this fire energy constructively."
            ),
            "Taurus": (
                newMoon: "Your Taurus Moon brings stability and sensuality to new beginnings. Set intentions around comfort, security, and material goals.",
                fullMoon: "Your Taurus Moon emphasizes release of material attachments and comfort zones. Let go of what no longer serves your stability.",
                rituals: ["Create a physical altar with meaningful objects", "Set intentions around material security", "Practice grounding exercises"],
                emotionalPatterns: "You may feel more stable, sensual, and attached to comfort. Balance security with growth."
            ),
            "Cancer": (
                newMoon: "Your Cancer Moon brings emotional depth and nurturing to new beginnings. Set intentions around home, family, and emotional security.",
                fullMoon: "Your Cancer Moon intensifies emotional release. Let go of old emotional patterns and family dynamics that no longer serve.",
                rituals: ["Create a home-based ritual space", "Set intentions around family and home", "Practice emotional self-care"],
                emotionalPatterns: "You may feel more sensitive, nurturing, and emotionally attuned. Protect your emotional boundaries."
            ),
            "Leo": (
                newMoon: "Your Leo Moon brings creative expression and confidence to new beginnings. Set intentions around creativity, recognition, and self-expression.",
                fullMoon: "Your Leo Moon emphasizes release of ego attachments and need for recognition. Let go of what blocks your authentic expression.",
                rituals: ["Create a creative ritual", "Set intentions with confidence and joy", "Express yourself authentically"],
                emotionalPatterns: "You may feel more confident, creative, and expressive. Share your light while staying authentic."
            ),
            "Scorpio": (
                newMoon: "Your Scorpio Moon brings transformation and depth to new beginnings. Set intentions around deep change and intimate connections.",
                fullMoon: "Your Scorpio Moon intensifies emotional release and transformation. Let go of deep-seated patterns and embrace change.",
                rituals: ["Create a transformative ritual", "Set intentions around deep change", "Practice shadow work"],
                emotionalPatterns: "You may feel more intense, transformative, and emotionally deep. Embrace change while maintaining boundaries."
            ),
            "Pisces": (
                newMoon: "Your Pisces Moon brings intuition and compassion to new beginnings. Set intentions around spirituality, creativity, and compassion.",
                fullMoon: "Your Pisces Moon emphasizes release of illusions and boundaries. Let go of what clouds your vision and embrace clarity.",
                rituals: ["Create a spiritual ritual", "Set intentions with intuition", "Practice meditation and compassion"],
                emotionalPatterns: "You may feel more intuitive, compassionate, and spiritually attuned. Ground your intuition in reality."
            )
        ]
        
        let moonInfluence = moonSignInfluences[moonSign] ?? (
            newMoon: "Your \(moonSign) Moon influences how you experience new beginnings. Set intentions that align with your emotional nature.",
            fullMoon: "Your \(moonSign) Moon influences how you experience release. Let go of what no longer serves your emotional well-being.",
            rituals: ["Create a personalized ritual", "Set intentions aligned with your moon sign", "Practice emotional awareness"],
            emotionalPatterns: "Your \(moonSign) Moon influences your emotional patterns during this moon phase."
        )
        
        // Sun-Moon combination influence
        let sunMoonCombination = "Your \(sunSign) Sun and \(moonSign) Moon combination creates a unique emotional experience during this \(moonPhase.rawValue). Your \(sunSign) Sun's natural expression is modified by your \(moonSign) Moon's emotional depth, creating opportunities for \(moonPhase == .new ? "setting intentions that honor both your identity and emotional needs" : "releasing patterns that conflict with your authentic self")."
        
        // Expanded body lines
        var bodyLines: [String] = []
        if moonPhase == .new {
            bodyLines.append("New Moon on \(exactDateStr) affects your \(moonSign) Moon")
            bodyLines.append("Set clear intentions for new beginnings")
            bodyLines.append("Your \(sunSign) Sun + \(moonSign) Moon combination influences this cycle")
        } else {
            bodyLines.append("Full Moon on \(exactDateStr) affects your \(moonSign) Moon")
            bodyLines.append("Release what no longer serves you")
            bodyLines.append("Your \(sunSign) Sun + \(moonSign) Moon combination influences this release")
        }
        bodyLines.append("Emotional patterns: \(moonInfluence.emotionalPatterns.components(separatedBy: ". ").first ?? moonInfluence.emotionalPatterns)")
        
        // Expanded full insight (2-3 sentences)
        var fullInsight = ""
        if moonPhase == .new {
            fullInsight = "The New Moon on \(exactDateStr) is a powerful time for setting intentions and planting seeds for what you want to manifest. "
            fullInsight += moonInfluence.newMoon + " "
            fullInsight += sunMoonCombination + " "
            fullInsight += "Use this time to clarify what you want to manifest in the coming 29.5-day lunar cycle, aligning your intentions with both your \(sunSign) Sun's identity and your \(moonSign) Moon's emotional needs."
        } else {
            fullInsight = "The Full Moon on \(exactDateStr) is a powerful time for release and completion. "
            fullInsight += moonInfluence.fullMoon + " "
            fullInsight += sunMoonCombination + " "
            fullInsight += "Use this time to release what no longer serves you, celebrate what you've achieved, and let go of patterns that conflict with your authentic \(sunSign) Sun expression and \(moonSign) Moon emotional needs."
        }
        
        // More compelling headline
        let compellingHeadline = moonPhase == .new 
            ? "New Moon Energy for You"
            : "Full Moon Release Guidance"
        
        // Expanded insight bullets (4-5 instead of 3)
        var insightBullets: [String] = []
        insightBullets.append("Exact date: \(exactDateStr) - \(moonPhase.rawValue) phase")
        if moonPhase == .new {
            insightBullets.append("Theme: New beginnings and intention setting - your \(moonSign) Moon influences how you set intentions")
            insightBullets.append("Best use: Setting clear intentions, planting seeds, starting new cycles aligned with your emotional nature")
        } else {
            insightBullets.append("Theme: Release and completion - your \(moonSign) Moon influences how you experience release")
            insightBullets.append("Best use: Releasing what no longer serves, celebrating achievements, letting go with grace")
        }
        insightBullets.append("Emotional patterns: \(moonInfluence.emotionalPatterns)")
        insightBullets.append("Sun-Moon combination: Your \(sunSign) Sun and \(moonSign) Moon work together during this phase")
        
        // Expanded guidance (5-6 instead of 3)
        var guidance: [String] = []
        if moonPhase == .new {
            guidance.append("Do: Set clear intentions for what you want to manifest - align with your \(sunSign) Sun's identity and \(moonSign) Moon's emotional needs")
            guidance.append("Rituals: \(moonInfluence.rituals.prefix(2).joined(separator: ", "))")
            guidance.append("Try: Writing down your intentions, creating a ritual space, planting seeds (literal or metaphorical)")
            guidance.append("Timing: Set intentions within 48 hours of the New Moon for maximum power")
        } else {
            guidance.append("Do: Release what no longer serves you - let go of patterns that conflict with your authentic self")
            guidance.append("Rituals: \(moonInfluence.rituals.prefix(2).joined(separator: ", "))")
            guidance.append("Try: Writing down what to release, creating a release ritual, letting go with gratitude")
            guidance.append("Timing: Release work is most powerful within 48 hours of the Full Moon")
        }
        guidance.append("Emotional awareness: Pay attention to your \(moonSign) Moon's emotional patterns during this phase")
        guidance.append("Avoid: \(moonPhase == .new ? "Starting without clear intentions or ignoring your emotional needs" : "Holding onto what's complete or resisting necessary release")")
        
        // Expanded one-line insight (2-3 sentences)
        var oneLineInsight = ""
        if moonPhase == .new {
            oneLineInsight = "The New Moon on \(exactDateStr) is a powerful time for setting intentions and planting seeds. "
            oneLineInsight += moonInfluence.newMoon + " "
            oneLineInsight += "Your \(sunSign) Sun and \(moonSign) Moon combination influences how you experience and set intentions during this phase."
        } else {
            oneLineInsight = "The Full Moon on \(exactDateStr) is a powerful time for release and completion. "
            oneLineInsight += moonInfluence.fullMoon + " "
            oneLineInsight += "Your \(sunSign) Sun and \(moonSign) Moon combination influences how you experience release during this phase."
        }
        
        return GeneratedEventContent(
            headline: compellingHeadline,
            bodyLines: bodyLines,
            fullInsight: fullInsight,
            astrologicalContext: "\(moonPhase.rawValue) • \(exactDateStr) • \(moonSign) Moon",
            numerologyContext: nil,
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: oneLineInsight,
                insightBullets: insightBullets,
                guidance: guidance,
                reflectionQuestions: [
                    moonPhase == .new
                        ? "What intentions do I want to set that honor both my \(sunSign) Sun identity and \(moonSign) Moon emotional needs?"
                        : "What needs to be released that conflicts with my authentic \(sunSign) Sun expression?",
                    moonPhase == .new
                        ? "What seeds do I want to plant for the coming lunar cycle?"
                        : "What have I completed that I can celebrate and release?",
                    moonPhase == .new
                        ? "How can I align with new beginnings while honoring my \(moonSign) Moon's emotional patterns?"
                        : "How can I let go with grace while respecting my \(moonSign) Moon's emotional depth?",
                    "What rituals can I create that honor both my \(sunSign) Sun and \(moonSign) Moon during this phase?"
                ],
                contextSection: "The moon cycles through phases every 29.5 days, influencing emotional patterns. The \(moonPhase.rawValue) on \(exactDateStr) specifically affects your \(moonSign) Moon, which governs your emotional nature, needs, and instinctual responses. Your \(sunSign) Sun's identity combines with your \(moonSign) Moon's emotional depth to create a unique experience during this lunar phase. \(moonPhase == .new ? "New Moons are times for setting intentions and planting seeds for the coming cycle. Your \(moonSign) Moon's emotional needs combine with your \(sunSign) Sun's natural expression to guide what you want to manifest." : moonPhase == .full ? "Full Moons are times for release, completion, and celebration. Your \(moonSign) Moon's emotional patterns combine with your \(sunSign) Sun's identity to show what needs to be released or completed." : moonPhase == .waxing ? "Waxing Moons support growth and building momentum. Your \(moonSign) Moon's emotional energy supports your \(sunSign) Sun's goals as you move toward the Full Moon." : "Waning Moons support release and letting go. Your \(moonSign) Moon's emotional depth helps you process what needs to be released as you move toward the New Moon.") The combination of your \(sunSign) Sun and \(moonSign) Moon creates a unique emotional signature that's particularly active during this phase.",
                deeperInsight: nil,
                practicalReflection: nil
            ),
            timeframeLabel: "Active Now",
            summarySentence: "The \(moonPhase.rawValue) on \(exactDateStr) affects your \(moonSign) Moon. Your \(sunSign) Sun + \(moonSign) Moon combination influences this phase."
        )
    }
    
    // MARK: - Helper Methods
    
    private func getMonthName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    private func getMonthlyThemes(sunSign: String, month: Int) -> String {
        // Simplified monthly themes by sign
        let themes: [String: [String]] = [
            "Aries": ["action and initiative", "bold new starts", "leadership opportunities"],
            "Taurus": ["stability and values", "practical progress", "sensory experiences"],
            "Gemini": ["communication and learning", "social connections", "mental stimulation"],
            "Cancer": ["home and family", "emotional depth", "nurturing energy"],
            "Leo": ["creativity and expression", "recognition and appreciation", "joyful experiences"],
            "Virgo": ["service and improvement", "attention to detail", "practical organization"],
            "Libra": ["partnership and balance", "beauty and harmony", "diplomatic connections"],
            "Scorpio": ["transformation and depth", "intimate connections", "emotional intensity"],
            "Sagittarius": ["exploration and adventure", "philosophical growth", "expanding horizons"],
            "Capricorn": ["structure and achievement", "long-term goals", "disciplined progress"],
            "Aquarius": ["innovation and freedom", "humanitarian connections", "unique perspectives"],
            "Pisces": ["intuition and compassion", "spiritual connection", "creative expression"]
        ]
        
        let signThemes = themes[sunSign] ?? ["personal growth", "new opportunities", "self-discovery"]
        // Cycle through themes based on month
        let themeIndex = (month - 1) % signThemes.count
        return signThemes[themeIndex]
    }
    
    private func getPersonalYearTheme(personalYear: Int) -> String {
        let themes: [Int: String] = [
            1: "new beginnings",
            2: "cooperation",
            3: "creativity",
            4: "structure",
            5: "change",
            6: "care",
            7: "introspection",
            8: "achievement",
            9: "completion"
        ]
        return themes[personalYear] ?? "growth"
    }
}

// MARK: - Generated Event Content Structure
struct GeneratedEventContent {
    let headline: String
    let bodyLines: [String]
    let fullInsight: String
    let astrologicalContext: String?
    let numerologyContext: String?
    let expandedContent: ExpandedGuidanceContent
    let timeframeLabel: String
    let summarySentence: String
}