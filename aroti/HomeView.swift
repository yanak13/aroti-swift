//
//  HomeView.swift
//  Aroti
//
//  Home page reusing components from the design system
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: TabItem
    @State private var userData: UserData = UserData.default
    @State private var dailyInsight: DailyInsight?
    @State private var userPoints: Int = 0
    
    // Tarot Carousel state
    @State private var selectedCardIndex: Int = 2
    @State private var carouselItems: [TarotCardCarousel.Item] = []
    @State private var revealedCard: TarotCardCarousel.Item?
    @State private var hasRevealedToday: Bool = false
    
    // Sheet presentation states
    @State private var showTarotSheet: Bool = false
    @State private var showHoroscopeSheet: Bool = false
    @State private var showNumerologySheet: Bool = false
    @State private var showAffirmationSheet: Bool = false
    @State private var showReflectionSheet: Bool = false
    @State private var reflectionText: String = ""
    
    // Animation states
    @State private var tarotSectionVisible: Bool = false
    @State private var dailyPicksSectionVisible: Bool = false
    @State private var reflectionSectionVisible: Bool = false
    @State private var teaseLineVisible: Bool = false
    @State private var isCTAPressed: Bool = false
    @State private var carouselShakeOffset: CGFloat = 0
    @State private var breathingGlowOpacity: Double = 0.3
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private let stateManager = DailyStateManager.shared
    private let contentService = DailyContentService.shared
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let safeAreaTop = geometry.safeAreaInsets.top
            
            ZStack(alignment: .bottom) {
                CelestialBackground()
                    .ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Tarot Card Carousel Section
                            VStack(alignment: .leading, spacing: 8) {                                
                                // 3D Carousel with shake support
                                TarotCardCarousel(
                                    items: carouselItems,
                                    selectedIndex: $selectedCardIndex,
                                    onReveal: { item in
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            // Mark card as revealed
                                            stateManager.markCardFlipped()
                                            revealedCard = item
                                            hasRevealedToday = true
                                        }
                                        HapticFeedback.impactOccurred(.medium)
                                        // Show detail sheet after reveal (only once)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            showTarotSheet = true
                                        }
                                    },
                                    onSelect: { _ in
                                        HapticFeedback.impactOccurred(.light)
                                    },
                                    canRevealCenterCard: !hasRevealedToday,
                                    revealedCardIDs: hasRevealedToday && revealedCard != nil ? [revealedCard!.id] : []
                                )
                                .offset(x: carouselShakeOffset)
                                .opacity(tarotSectionVisible ? 1 : 0)
                                .offset(y: reduceMotion ? 0 : (tarotSectionVisible ? 0 : 8))
                                
                                // Subtle interaction hint - moved below carousel, before CTA
                                Text("Swipe to choose")
                                    .font(DesignTypography.caption1Font())
                                    .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, -24)
                                    .padding(.bottom, 4)
                                    .opacity(tarotSectionVisible ? 1 : 0)
                                    .offset(y: reduceMotion ? 0 : (tarotSectionVisible ? 0 : 8))
                                
                                // CTA for tarot (state-based) + divider separating from Daily Picks
                                VStack(spacing: 0) {
                                    Button(action: {
                                        HapticFeedback.impactOccurred(.light)
                                        
                                        if hasRevealedToday {
                                            // Already revealed – reopen insight
                                            showTarotSheet = true
                                        } else {
                                            // Check if card is ready
                                            guard selectedCardIndex < carouselItems.count else {
                                                // Trigger gentle shake animation
                                                withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                                                    carouselShakeOffset = -4
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    withAnimation(.easeOut(duration: 0.1)) {
                                                        carouselShakeOffset = 0
                                                    }
                                                }
                                                return
                                            }
                                            
                                            let item = carouselItems[selectedCardIndex]
                                            
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                stateManager.markCardFlipped()
                                                revealedCard = item
                                                hasRevealedToday = true
                                            }
                                            
                                            HapticFeedback.impactOccurred(.medium)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                showTarotSheet = true
                                            }
                                        }
                                    }) {
                                        Text(hasRevealedToday ? "Reveal today's insight" : (selectedCardIndex < carouselItems.count ? "Reveal your card" : "Choose a card to reveal"))
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                            .foregroundColor(DesignColors.accent)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 48)
                                            .background(
                                                RoundedRectangle(cornerRadius: ArotiRadius.md)
                                                    .fill(Color.clear)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                                                            .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                                    )
                                            )
                                            .scaleEffect(isCTAPressed ? 0.98 : 1.0)
                                            .opacity(isCTAPressed ? 0.95 : 1.0)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                                        withAnimation(.easeOut(duration: 0.15)) {
                                            isCTAPressed = pressing
                                        }
                                    }, perform: {})
                                    .padding(.bottom, 20)
                                    
                                    // Subtle hairline divider under CTA
                                    Rectangle()
                                        .fill(Color.white.opacity(0.12))
                                        .frame(height: 0.5)
                                        .frame(maxWidth: .infinity)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                .padding(.top, 0)
                            }
                            .padding(.top, DesignSpacing.lg + 16)
                            
                            // Daily Picks section
                            VStack(alignment: .leading, spacing: 12) {
                                // Section header
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Daily Picks")
                                        .font(DesignTypography.title3Font(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text("Quick guidance for today")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                .opacity(dailyPicksSectionVisible ? 1 : 0)
                                .offset(y: reduceMotion ? 0 : (dailyPicksSectionVisible ? 0 : 8))
                                
                                // Horizontal carousel
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHStack(spacing: 14) {
                                        // Helper flags & data
                                        let hasInsight = dailyInsight != nil
                                        let horoscopeSubtitle = dailyInsight?.horoscope ?? "Loading today's horoscope..."
                                        let numerologyNumber = dailyInsight?.numerology.number
                                        let numerologyPreview = dailyInsight?.numerology.preview ?? "Loading today's number..."
                                        let affirmationText = dailyInsight?.affirmation ?? "Loading today's affirmation..."
                                        
                                        // Horoscope card
                                        Button(action: {
                                            if hasInsight {
                                                HapticFeedback.impactOccurred(.light)
                                                showHoroscopeSheet = true
                                            }
                                        }) {
                                            DailyPickCard(
                                                title: "Horoscope",
                                                subtitle: horoscopeSubtitle
                                            ) {
                                                // Zodiac symbol in square with glow
                                                Text(getZodiacSymbol(userData.sunSign))
                                                    .font(.system(size: 32))
                                                    .foregroundColor(.white)
                                                    .frame(width: 48, height: 48)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(getZodiacColor(userData.sunSign).opacity(0.3))
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .stroke(getZodiacColor(userData.sunSign).opacity(0.5), lineWidth: 1)
                                                            )
                                                    )
                                            }
                                            .frame(width: geometry.size.width * 0.82)
                                        }
                                        .buttonStyle(CardTapButtonStyle(cornerRadius: ArotiRadius.md))
                                        .disabled(!hasInsight)
                                        
                                        // Numerology card
                                        Button(action: {
                                            if hasInsight {
                                                HapticFeedback.impactOccurred(.light)
                                                showNumerologySheet = true
                                            }
                                        }) {
                                            DailyPickCard(
                                                title: "Numerology",
                                                subtitle: numerologyPreview
                                            ) {
                                                if let number = numerologyNumber {
                                                    Text("\(number)")
                                                        .font(.system(size: 28, weight: .bold))
                                                        .foregroundColor(.white)
                                                        .frame(width: 48, height: 48)
                                                        .background(
                                                            Circle()
                                                                .fill(DesignColors.accent.opacity(0.3))
                                                                .overlay(
                                                                    Circle()
                                                                        .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                                                )
                                                        )
                                                } else {
                                                    // Placeholder badge
                                                    Text("--")
                                                        .font(.system(size: 20, weight: .medium))
                                                        .foregroundColor(.white.opacity(0.7))
                                                        .frame(width: 48, height: 48)
                                                        .background(
                                                            Circle()
                                                                .fill(Color.white.opacity(0.08))
                                                        )
                                                }
                                            }
                                            .frame(width: geometry.size.width * 0.82)
                                        }
                                        .buttonStyle(CardTapButtonStyle(cornerRadius: ArotiRadius.md))
                                        .disabled(!hasInsight)
                                        
                                        // Affirmation card
                                        Button(action: {
                                            if hasInsight {
                                                HapticFeedback.impactOccurred(.light)
                                                showAffirmationSheet = true
                                            }
                                        }) {
                                            DailyPickCard(
                                                title: "Affirmation",
                                                subtitle: affirmationText
                                            ) {
                                                Image(systemName: "quote.bubble")
                                                    .font(.system(size: 22))
                                                    .foregroundColor(.white)
                                                    .frame(width: 44, height: 44)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(DesignColors.accent.opacity(0.3))
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                                            )
                                                    )
                                            }
                                            .frame(width: geometry.size.width * 0.82)
                                        }
                                        .buttonStyle(CardTapButtonStyle(cornerRadius: ArotiRadius.md))
                                        .disabled(!hasInsight)
                                    }
                                    .padding(.horizontal, DesignSpacing.sm)
                                }
                            }
                            .opacity(dailyPicksSectionVisible ? 1 : 0)
                            .offset(y: reduceMotion ? 0 : (dailyPicksSectionVisible ? 0 : 8))
                            
                            // Hairline divider above Reflection (guidance → introspection)
                            Rectangle()
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 0.5)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, DesignSpacing.sm)
                            
                            // Your Reflection section (typography only, no card)
                            Button(action: {
                                showReflectionSheet = true
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    // Title
                                    Text("Your Reflection")
                                        .font(DesignTypography.title3Font(weight: .medium))
                                        .foregroundColor(DesignColors.foreground.opacity(0.9))
                                    
                                    // Subtitle - soft, emotional
                                    Text("One thought. One feeling. Just for you.")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.9))
                                    
                                    // Text CTA row
                                    HStack(spacing: 6) {
                                        Text(reflectionText.isEmpty ? "Write a reflection" : "Open journal")
                                            .font(DesignTypography.footnoteFont(weight: .medium))
                                            .foregroundColor(DesignColors.accent.opacity(0.8))
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(DesignColors.accent.opacity(0.6))
                                    }
                                    .padding(.top, 4)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, DesignSpacing.sm)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(reflectionSectionVisible ? 1 : 0)
                            .offset(y: reduceMotion ? 0 : (reflectionSectionVisible ? 0 : 8))
                        }
                        .padding(.bottom, 100) // Padding to prevent content from going behind nav bar
                    }
                    .padding(.top, 32) // Just header content height, safe area already handled
                    
                    StickyHeaderBar(
                        title: "Today's Insights",
                        subtitle: "Your daily cosmic guidance",
                        safeAreaTop: safeAreaTop
                    ) {
                        HStack(spacing: 8) {
                            // Points Chip - dynamic width based on content
                            NavigationLink(destination: JourneyPage()) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                    Text("\(userPoints.formatted())")
                                        .font(DesignTypography.caption1Font(weight: .semibold))
                                }
                                .foregroundColor(DesignColors.accent)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .frame(height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.06))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Notification Bell - matching points style
                            Button(action: {
                                // Handle notification tap
                            }) {
                                Image(systemName: "bell")
                                    .font(.system(size: 16))
                                    .foregroundColor(DesignColors.accent)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                    }
                }
                
                // Bottom Navigation Bar - fixed at bottom
                VStack {
                    Spacer()
                    BottomNavigationBar(selectedTab: $selectedTab) { tab in
                        // Handle tab selection
                        selectedTab = tab
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                }
                .navigationBarHidden(true)
                .onAppear {
                    loadData()
                    
                    // Trigger section appear animations with staggered delays
                    withAnimation(.easeOut(duration: 0.5)) {
                        tarotSectionVisible = true
                    }
                    withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
                        teaseLineVisible = true
                    }
                    withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                        dailyPicksSectionVisible = true
                    }
                    withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                        reflectionSectionVisible = true
                    }
                }
                .sheet(isPresented: $showTarotSheet) {
                    if let item = revealedCard,
                       let card = findTarotCard(for: item) {
                        TarotDetailSheet(card: card)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    } else if let insight = dailyInsight, let card = insight.tarotCard {
                        TarotDetailSheet(card: card)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showHoroscopeSheet) {
                    if let insight = dailyInsight {
                        HoroscopeDetailSheet(horoscope: insight.horoscope, sign: userData.sunSign)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showNumerologySheet) {
                    if let insight = dailyInsight {
                        HomeNumerologyDetailSheet(numerology: insight.numerology)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showAffirmationSheet) {
                    if let insight = dailyInsight {
                        AffirmationDetailSheet(affirmation: insight.affirmation)
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showReflectionSheet) {
                    ReflectionSheet(reflectionText: $reflectionText)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
    
    private func loadData() {
        // Load user data
        if let loadedUserData = stateManager.loadUserData() {
            userData = loadedUserData
        }
        
        // Check if we need to reset daily state
        if stateManager.shouldResetDailyState() {
            _ = stateManager.resetDailyState()
            hasRevealedToday = false
            revealedCard = nil
        } else {
            // Check if user has already revealed today
            hasRevealedToday = stateManager.hasFlippedCardToday()
        }
        
        // Generate daily insight
        dailyInsight = contentService.generateDailyInsight(userData: userData)
        
        // Load tarot cards for carousel
        loadTarotCards()
        
        // If already revealed today, set the revealed card
        if hasRevealedToday, let insight = dailyInsight, let todayCard = insight.tarotCard {
            revealedCard = carouselItems.first(where: { $0.title == todayCard.name })
        }
        
        updatePoints()
    }
    
    private func loadTarotCards() {
        // Generate full 78-card tarot deck
        var items: [TarotCardCarousel.Item] = []
        
        // Major Arcana (22 cards)
        let majorArcana = contentService.getAllTarotCards()
        for card in majorArcana {
            items.append(TarotCardCarousel.Item(
                title: card.name,
                cardFrontImageName: card.imageName ?? "tarot_back"
            ))
        }
        
        // Minor Arcana (56 cards: 14 cards x 4 suits)
        let suits = ["Wands", "Cups", "Swords", "Pentacles"]
        let ranks = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Page", "Knight", "Queen", "King"]
        
        for suit in suits {
            for rank in ranks {
                let name = "\(rank) of \(suit)"
                let imageName = "tarot_\(rank.lowercased())_of_\(suit.lowercased())"
                items.append(TarotCardCarousel.Item(
                    title: name,
                    cardFrontImageName: imageName
                ))
            }
        }
        
        // Find today's card index in the full deck
        var todayCardIndex = 0
        if let insight = dailyInsight, let todayCard = insight.tarotCard {
            if let index = items.firstIndex(where: { $0.title == todayCard.name }) {
                todayCardIndex = index
            }
        }
        
        carouselItems = items
        selectedCardIndex = todayCardIndex // Start at today's card
    }
    
    private func findTarotCard(for item: TarotCardCarousel.Item) -> TarotCard? {
        // Check Major Arcana first
        let majorArcana = contentService.getAllTarotCards()
        if let card = majorArcana.first(where: { $0.name == item.title }) {
            return card
        }
        
        // For Minor Arcana, create a temporary card object
        return TarotCard(
            id: item.title.lowercased().replacingOccurrences(of: " ", with: "_"),
            name: item.title,
            keywords: getMinorArcanaKeywords(for: item.title),
            interpretation: getMinorArcanaInterpretation(for: item.title),
            guidance: nil,
            imageName: item.cardFrontImageName
        )
    }
    
    private func getMinorArcanaKeywords(for cardName: String) -> [String] {
        // Extract suit from card name
        if cardName.contains("Wands") {
            return ["Passion", "Action", "Energy"]
        } else if cardName.contains("Cups") {
            return ["Emotion", "Love", "Intuition"]
        } else if cardName.contains("Swords") {
            return ["Mind", "Conflict", "Clarity"]
        } else if cardName.contains("Pentacles") {
            return ["Material", "Wealth", "Stability"]
        }
        return ["Energy", "Focus", "Growth"]
    }
    
    private func getMinorArcanaInterpretation(for cardName: String) -> String {
        if cardName.contains("Wands") {
            return "This card speaks to your passions and creative energy. Take inspired action toward your goals."
        } else if cardName.contains("Cups") {
            return "This card reflects your emotional landscape. Listen to your heart and nurture your relationships."
        } else if cardName.contains("Swords") {
            return "This card challenges you to think clearly. Face truth with courage and communicate honestly."
        } else if cardName.contains("Pentacles") {
            return "This card relates to your material world. Focus on practical matters and build steady foundations."
        }
        return "This card offers insight for your journey today."
    }
    
    private func updatePoints() {
        let balance = PointsService.shared.getBalance()
        userPoints = balance.totalPoints
    }
    
    private func getZodiacSymbol(_ sign: String) -> String {
        let symbols: [String: String] = [
            "Aries": "♈",
            "Taurus": "♉",
            "Gemini": "♊",
            "Cancer": "♋",
            "Leo": "♌",
            "Virgo": "♍",
            "Libra": "♎",
            "Scorpio": "♏",
            "Sagittarius": "♐",
            "Capricorn": "♑",
            "Aquarius": "♒",
            "Pisces": "♓"
        ]
        return symbols[sign] ?? "♓"
    }
    
    private func getZodiacColor(_ sign: String) -> Color {
        // Return purple for Pisces with proper glow, accent for others
        if sign == "Pisces" {
            return Color(hue: 270/360, saturation: 0.7, brightness: 0.8)
        }
        return DesignColors.accent
    }
}

#Preview {
    NavigationStack {
        HomeView(selectedTab: .constant(.home))
    }
}
