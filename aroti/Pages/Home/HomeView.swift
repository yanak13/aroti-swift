//
//  HomeView.swift
//  Aroti
//
//  Home page reusing components from the design system
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: TabItem
    @StateObject private var controller = HomeController()
    @State private var userPoints: Int = 0
    @State private var isMockModeEnabled = MockModeService.shared.isEnabled
    
    private var userData: UserData {
        controller.userData
    }
    
    private var dailyInsight: DailyInsight? {
        controller.dailyInsight
    }
    
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
    @State private var dailyReflectionPrompt: String = ""
    
    // Animation states
    @State private var tarotSectionVisible: Bool = false
    @State private var dailyPicksSectionVisible: Bool = false
    @State private var reflectionSectionVisible: Bool = false
    @State private var teaseLineVisible: Bool = false
    @State private var isCTAPressed: Bool = false
    @State private var carouselShakeOffset: CGFloat = 0
    @State private var breathingGlowOpacity: Double = 0.3
    @State private var scrollOffset: CGFloat = 0
    @State private var hasUnreadNotifications: Bool = false
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    private let stateManager = DailyStateManager.shared
    private let contentService = DailyContentService.shared
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let _ = geometry.safeAreaInsets.top
            
            ZStack(alignment: .bottom) {
                CelestialBackground()
                    .ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Scroll offset tracker
                            GeometryReader { scrollGeometry in
                                Color.clear
                                    .preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: scrollGeometry.frame(in: .named("scroll")).minY
                                    )
                            }
                            .frame(height: 0)
                            
                            // Mock Mode Indicator Banner
                            if isMockModeEnabled {
                                HStack(spacing: 8) {
                                    Image(systemName: "testtube.2")
                                        .font(.system(size: 14, weight: .medium))
                                    Text("Mock Mode Active - Showing test data")
                                        .font(DesignTypography.caption1Font(weight: .medium))
                                }
                                .foregroundColor(ArotiColor.warningText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(DesignColors.warning)
                                        .overlay(
                                            Capsule()
                                                .stroke(DesignColors.warningBorder, lineWidth: 1)
                                        )
                                )
                                .padding(.horizontal, DesignSpacing.sm)
                                .padding(.top, 8)
                            }
                            
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
                                        .font(DesignTypography.headlineFont(weight: .medium))
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
                                        let dayOfYear = contentService.getDayOfYear()
                                        let affirmationSubtitle = contentService.generateAffirmationSubtitle(dayOfYear: dayOfYear)
                                        
                                        // Horoscope card
                                        Button(action: {
                                            HapticFeedback.impactOccurred(.light)
                                            showHoroscopeSheet = true
                                        }) {
                                            DailyPickCard(
                                                title: "Horoscope",
                                                subtitle: horoscopeSubtitle,
                                                showsChevron: false
                                            ) {
                                                // Hero-style icon matching detail pages
                                                HoroscopeHeroIcon(sign: userData.sunSign, color: ArotiColor.accent)
                                                    .frame(width: 60, height: 60)
                                            }
                                            .frame(width: geometry.size.width * 0.82)
                                            .contentShape(Rectangle())
                                        }
                                        .buttonStyle(CardTapButtonStyle(cornerRadius: ArotiRadius.md))
                                        .disabled(!hasInsight)
                                        
                                        // Numerology card
                                        Button(action: {
                                            HapticFeedback.impactOccurred(.light)
                                            showNumerologySheet = true
                                        }) {
                                            DailyPickCard(
                                                title: "Numerology",
                                                subtitle: numerologyPreview,
                                                showsChevron: false
                                            ) {
                                                if let number = numerologyNumber {
                                                    // Hero-style icon matching detail pages
                                                    NumerologyHeroIcon(number: number, color: ArotiColor.accent)
                                                        .frame(width: 60, height: 60)
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
                                            .contentShape(Rectangle())
                                        }
                                        .buttonStyle(CardTapButtonStyle(cornerRadius: ArotiRadius.md))
                                        .disabled(!hasInsight)
                                        
                                        // Affirmation card
                                        Button(action: {
                                            HapticFeedback.impactOccurred(.light)
                                            showAffirmationSheet = true
                                        }) {
                                            DailyPickCard(
                                                title: "Affirmation",
                                                subtitle: affirmationSubtitle,
                                                showsChevron: false
                                            ) {
                                                // Hero-style icon matching detail pages
                                                AffirmationHeroIcon(color: ArotiColor.accent)
                                                    .frame(width: 60, height: 60)
                                            }
                                            .frame(width: geometry.size.width * 0.82)
                                            .contentShape(Rectangle())
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
                            
                            // Your Reflection section (card-based, therapeutic)
                            VStack(alignment: .leading, spacing: 12) {
                                // Section header
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your Reflection")
                                        .font(DesignTypography.headlineFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text("A quiet moment to check in with yourself")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Reflection card
                                Button(action: {
                                    HapticFeedback.impactOccurred(.light)
                                    showReflectionSheet = true
                                }) {
                                    BaseCard {
                                        VStack(alignment: .leading, spacing: 16) {
                                            // Optional subtle icon
                                            HStack {
                                                Spacer()
                                                Text("✦")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(DesignColors.accent.opacity(0.4))
                                            }
                                            
                                            Spacer()
                                            
                                            // Daily prompt
                                            Text(dailyReflectionPrompt)
                                                .font(DesignTypography.bodyFont())
                                                .foregroundColor(DesignColors.foreground.opacity(0.95))
                                                .lineLimit(3)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            // Gentle CTA (no arrow)
                                            Text("Start reflection")
                                                .font(DesignTypography.footnoteFont(weight: .medium))
                                                .foregroundColor(DesignColors.accent.opacity(0.7))
                                                .padding(.top, 4)
                                        }
                                        .frame(height: 200, alignment: .topLeading)
                                    }
                                }
                                .buttonStyle(CardTapButtonStyle(cornerRadius: ArotiRadius.md))
                                .padding(.horizontal, DesignSpacing.sm)
                            }
                            .opacity(reflectionSectionVisible ? 1 : 0)
                            .offset(y: reduceMotion ? 0 : (reflectionSectionVisible ? 0 : 8))
                        }
                        .padding(.bottom, 100) // Padding to prevent content from going behind nav bar
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollOffset = max(0, -value)
                    }
                    .padding(.top, StickyHeaderBar.contentHeight())
                    
                    StickyHeaderBar(
                        title: "Today's Insights",
                        subtitle: "Your daily cosmic guidance",
                        scrollOffset: $scrollOffset
                    ) {
                        HStack(spacing: 8) {
                            // Points Chip - premium styling
                            NavigationLink(destination: JourneyPage()) {
                                HeaderBadge(
                                    iconName: "star.fill",
                                    text: userPoints.formatted()
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Notification Bell - premium styling
                            NavigationLink(destination: NotificationsPage()) {
                                HeaderBadge(
                                    iconName: "bell",
                                    showUnreadDot: hasUnreadNotifications
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
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
                .task {
                    // Fetch data on appear
                    if controller.dailyInsight == nil {
                        await controller.fetchDailyInsights()
                    }
                    if controller.userData.name == UserData.default.name {
                        await controller.fetchUserData()
                    }
                }
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
                .onReceive(NotificationCenter.default.publisher(for: .mockModeChanged)) { _ in
                    isMockModeEnabled = MockModeService.shared.isEnabled
                    // Reload data when mock mode changes
                    loadData()
                }
                .onReceive(NotificationCenter.default.publisher(for: NotificationService.notificationsUpdated)) { _ in
                    updateNotificationState()
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
                        let dayOfYear = contentService.getDayOfYear()
                        let affirmationSubtitle = contentService.generateAffirmationSubtitle(dayOfYear: dayOfYear)
                        AffirmationDetailSheet(affirmation: insight.affirmation, affirmationSubtitle: affirmationSubtitle)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showReflectionSheet) {
                    ReflectionSheet(prompt: dailyReflectionPrompt)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
    
    private func updateNotificationState() {
        hasUnreadNotifications = NotificationService.shared.hasUnread()
    }
    
    private func loadData() {
        updateNotificationState()
        
        // Check if mock mode is enabled
        if MockModeService.shared.isEnabled {
            // Use mock data
            controller.userData = MockModeService.mockUserData
            controller.dailyInsight = MockModeService.mockDailyInsight
        } else {
            // Load user data
            if let loadedUserData = stateManager.loadUserData() {
                controller.userData = loadedUserData
            }
            
            // Generate daily insight
            controller.dailyInsight = contentService.generateDailyInsight(userData: controller.userData)
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
        
        // Load tarot cards for carousel
        loadTarotCards()
        
        // If already revealed today, set the revealed card
        if hasRevealedToday, let insight = controller.dailyInsight, let todayCard = insight.tarotCard {
            revealedCard = carouselItems.first(where: { $0.title == todayCard.name })
        }
        
        // Load daily reflection prompt
        let dayOfYear = contentService.getDayOfYear()
        dailyReflectionPrompt = contentService.generateReflectionPrompt(dayOfYear: dayOfYear)
        
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
        let suits: [String] = ["Wands", "Cups", "Swords", "Pentacles"]
        let numberRanks: [String] = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
        let courtRanks: [String] = ["Page", "Knight", "Queen", "King"]
        let ranks: [String] = numberRanks + courtRanks
        
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
