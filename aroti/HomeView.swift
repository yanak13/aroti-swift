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
    @State private var showReflectionSheet: Bool = false
    @State private var reflectionText: String = ""
    
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
                        VStack(spacing: 24) {
                            // Tarot Card Carousel Section
                            VStack(alignment: .leading, spacing: 8) {
                                // Section Header - horizontal layout
                                HStack(alignment: .center) {
                                    Text("Today's Tarot")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Spacer()
                                    
                                    Text("Swipe to choose")
                                        .font(DesignTypography.caption1Font())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // 3D Carousel
                                TarotCardCarousel(
                                    items: carouselItems,
                                    selectedIndex: $selectedCardIndex,
                                    onReveal: { item in
                                        // Mark card as revealed
                                        stateManager.markCardFlipped()
                                        revealedCard = item
                                        hasRevealedToday = true
                                        HapticFeedback.impactOccurred(.medium)
                                        // Show detail sheet after reveal (only once)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            showTarotSheet = true
                                        }
                                    },
                                    onSelect: { item in
                                        HapticFeedback.impactOccurred(.light)
                                    },
                                    canRevealCenterCard: !hasRevealedToday,
                                    revealedCardIDs: hasRevealedToday && revealedCard != nil ? [revealedCard!.id] : []
                                )
                                
                                // CTA to reopen insights (only in revealed stage)
                                if hasRevealedToday, revealedCard != nil {
                                    VStack(spacing: 0) {
                                        ArotiButton(
                                            kind: .secondary,
                                            title: "View today's insight",
                                            action: {
                                                showTarotSheet = true
                                            }
                                        )
                                        .padding(.bottom, 12)
                                        
                                        // Subtle hairline divider under CTA
                                        Rectangle()
                                            .fill(Color.white.opacity(0.12))
                                            .frame(height: 0.5)
                                            .frame(maxWidth: .infinity)
                                    }
                                    .padding(.horizontal, DesignSpacing.sm)
                                    .padding(.top, 0)
                                }
                                
                                // Current card info (only in pre-revealed stage)
                                if !hasRevealedToday && selectedCardIndex < carouselItems.count {
                                    let currentItem = carouselItems[selectedCardIndex]
                                    VStack(spacing: 6) {
                                        Text(currentItem.title)
                                            .font(DesignTypography.title3Font(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Text("Card \(selectedCardIndex + 1) of \(carouselItems.count)")
                                            .font(DesignTypography.caption1Font())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 8)
                                }
                            }
                            .padding(.top, DesignSpacing.lg + 16)
                            
                            // Daily Insights - Context and Reflection
                            VStack(spacing: 16) {
                                // Context Card (Horoscope)
                                if let insight = dailyInsight {
                                    Button(action: {
                                        showHoroscopeSheet = true
                                    }) {
                                        BaseCard {
                                            VStack(alignment: .leading, spacing: 12) {
                                                // Top row: Icon in top right
                                                HStack {
                                                    Spacer()
                                                    
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
                                                
                                                Spacer()
                                                
                                                // Title and Description
                                                VStack(alignment: .leading, spacing: 8) {
                                                    Text("Today's Context")
                                                        .font(DesignTypography.headlineFont(weight: .medium))
                                                        .foregroundColor(DesignColors.foreground)
                                                        .lineLimit(2)
                                                    
                                                    Text(insight.horoscope)
                                                        .font(.system(size: 14))
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                        .lineLimit(2)
                                                        .padding(.top, 4)
                                                }
                                            }
                                            .frame(height: 200, alignment: .topLeading)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .contentShape(Rectangle())
                                }
                                
                                // Reflection Card
                                Button(action: {
                                    showReflectionSheet = true
                                }) {
                                    BaseCard {
                                        VStack(alignment: .leading, spacing: 8) {
                                            // Title
                                            Text("Your Reflection")
                                                .font(DesignTypography.headlineFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                                .lineLimit(1)
                                            
                                            // Description
                                            if reflectionText.isEmpty {
                                                Text("Write something small about your day or energy.")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                    .lineLimit(1)
                                            } else {
                                                Text(reflectionText)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                    .lineLimit(1)
                                            }
                                            
                                            Spacer()
                                            
                                            // CTA Button - soft, secondary style
                                            ArotiButton(
                                                kind: .custom(.glassCardButton(height: 40)),
                                                action: {
                                                    showReflectionSheet = true
                                                },
                                                label: {
                                                    Text(reflectionText.isEmpty ? "Add a reflection" : "Edit reflection")
                                                        .font(DesignTypography.footnoteFont(weight: .medium))
                                                }
                                            )
                                        }
                                        .frame(height: 130, alignment: .topLeading)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
                            }
                            .padding(.horizontal, DesignSpacing.sm)
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
