//
//  HomeView.swift
//  Aroti
//
//  Home page reusing components from the design system
//

import SwiftUI

// Preference key for carousel scroll tracking
struct CarouselScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HomeView: View {
    @Binding var selectedTab: TabItem
    @State private var userData: UserData = UserData.default
    @State private var dailyInsight: DailyInsight?
    @State private var tarotCardFlipped: Bool = false
    @State private var currentAffirmation: String = ""
    @State private var canShuffleAffirmation: Bool = true
    @State private var userPoints: Int = 0
    @State private var carouselPageIndex: Int = 0
    
    // Sheet presentation states
    @State private var showTarotSheet: Bool = false
    @State private var showHoroscopeSheet: Bool = false
    @State private var showNumerologySheet: Bool = false
    @State private var showRitualDetail: Bool = false
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
                            // Greeting Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Hi \(userData.name),")
                                    .font(DesignTypography.title3Font())
                                    .foregroundColor(DesignColors.foreground)
                                
                                let energyText = generateEnergyDescription()
                                Text(energyText)
                                    .font(DesignTypography.subheadFont())
                                    .foregroundColor(DesignColors.accent)
                                    .opacity(0.9)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, DesignSpacing.sm)
                            .padding(.top, DesignSpacing.lg + 8)
                            
                            // Main Content
                            VStack(spacing: 24) {
                        // Tarot Card Section
                        if let insight = dailyInsight, let tarotCard = insight.tarotCard {
                            Group {
                                if tarotCardFlipped {
                                    Button(action: {
                                        showTarotSheet = true
                                    }) {
                                        TarotCardView(
                                            card: tarotCard,
                                            isFlipped: tarotCardFlipped,
                                            onFlip: {
                                                tarotCardFlipped = true
                                                stateManager.markCardFlipped()
                                                // Show sheet after flip animation
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    showTarotSheet = true
                                                }
                                            },
                                            canFlip: !stateManager.hasFlippedCardToday()
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                } else {
                                    TarotCardView(
                                        card: tarotCard,
                                        isFlipped: tarotCardFlipped,
                                        onFlip: {
                                            tarotCardFlipped = true
                                            stateManager.markCardFlipped()
                                            // Show sheet after flip animation
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                showTarotSheet = true
                                            }
                                        },
                                        canFlip: !stateManager.hasFlippedCardToday()
                                    )
                                }
                            }
                        }
                        
                        // Daily Insights Carousel
                        VStack(spacing: 12) {
                            GeometryReader { geometry in
                                let cardWidth = geometry.size.width - (2 * DesignSpacing.sm) // Match tarot card width
                                let cardSpacing: CGFloat = 16
                                
                                ScrollViewReader { proxy in
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: cardSpacing) {
                                            // Horoscope Card
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
                                                                Text("Daily Horoscope")
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
                                                        .frame(width: cardWidth, height: 200, alignment: .topLeading)
                                                    }
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                .contentShape(Rectangle())
                                                .id(0)
                                            }
                                            
                                            // Numerology Card
                                            if let insight = dailyInsight {
                                                Button(action: {
                                                    showNumerologySheet = true
                                                }) {
                                                    BaseCard {
                                                        VStack(alignment: .leading, spacing: 12) {
                                                            // Top row: Number badge in top right
                                                            HStack {
                                                                Spacer()
                                                                
                                                                // Number badge with orange glow
                                                                Text("\(insight.numerology.number)")
                                                                    .font(.system(size: 32, weight: .bold))
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
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            // Title and Description
                                                            VStack(alignment: .leading, spacing: 8) {
                                                                Text("Numerology")
                                                                    .font(DesignTypography.headlineFont(weight: .medium))
                                                                    .foregroundColor(DesignColors.foreground)
                                                                    .lineLimit(2)
                                                                
                                                                Text(insight.numerology.preview)
                                                                    .font(.system(size: 14))
                                                                    .foregroundColor(DesignColors.mutedForeground)
                                                                    .lineLimit(2)
                                                                    .padding(.top, 4)
                                                            }
                                                        }
                                                        .frame(width: cardWidth, height: 200, alignment: .topLeading)
                                                    }
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                .contentShape(Rectangle())
                                                .id(1)
                                            }
                                            
                                            // Today's Ritual Card
                                            if let insight = dailyInsight {
                                                Button(action: {
                                                    showRitualDetail = true
                                                }) {
                                                    BaseCard {
                                                        VStack(alignment: .leading, spacing: 12) {
                                                            // Top row: Chips in top right
                                                            HStack {
                                                                Spacer()
                                                                
                                                                HStack(spacing: 8) {
                                                                    CategoryChip(label: insight.ritual.duration, isActive: true, action: {})
                                                                    CategoryChip(label: insight.ritual.type, isActive: true, action: {})
                                                                }
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            // Title, Description, and CTA
                                                            VStack(alignment: .leading, spacing: 8) {
                                                                Text("Today's Ritual")
                                                                    .font(DesignTypography.headlineFont(weight: .medium))
                                                                    .foregroundColor(DesignColors.foreground)
                                                                    .lineLimit(2)
                                                                
                                                                Text(insight.ritual.description)
                                                                    .font(.system(size: 14))
                                                                    .foregroundColor(DesignColors.mutedForeground)
                                                                    .lineLimit(2)
                                                                    .padding(.top, 4)
                                                                
                                                                ArotiButton(
                                                                    kind: .custom(.accentCard(height: 48)),
                                                                    title: "Begin Practice",
                                                                    action: {
                                                                        showRitualDetail = true
                                                                    }
                                                                )
                                                                .padding(.top, 8)
                                                            }
                                                        }
                                                        .frame(width: cardWidth, height: 200, alignment: .topLeading)
                                                    }
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                .contentShape(Rectangle())
                                                .id(2)
                                            }
                                            
                                            // Reflection Card
                                            Button(action: {
                                                showReflectionSheet = true
                                            }) {
                                                BaseCard {
                                                    VStack(alignment: .leading, spacing: 12) {
                                                        // Top row: Empty (no icon needed)
                                                        HStack {
                                                            Spacer()
                                                        }
                                                        
                                                        Spacer()
                                                        
                                                        // Title, Description, and CTA
                                                        VStack(alignment: .leading, spacing: 8) {
                                                            Text("Your Reflection")
                                                                .font(DesignTypography.headlineFont(weight: .medium))
                                                                .foregroundColor(DesignColors.foreground)
                                                                .lineLimit(2)
                                                            
                                                            if reflectionText.isEmpty {
                                                                Text("Write something small about your day or energy.")
                                                                    .font(.system(size: 14))
                                                                    .foregroundColor(DesignColors.mutedForeground)
                                                                    .lineLimit(2)
                                                                    .padding(.top, 4)
                                                            } else {
                                                                Text(reflectionText)
                                                                    .font(.system(size: 14))
                                                                    .foregroundColor(DesignColors.mutedForeground)
                                                                    .lineLimit(2)
                                                                    .padding(.top, 4)
                                                            }
                                                            
                                                            ArotiButton(
                                                                kind: .custom(.accentCard(height: 48)),
                                                                action: {
                                                                    showReflectionSheet = true
                                                                },
                                                                label: {
                                                                    HStack(spacing: 8) {
                                                                        Image(systemName: reflectionText.isEmpty ? "plus" : "pencil")
                                                                            .font(.system(size: 16))
                                                                        Text(reflectionText.isEmpty ? "Add Reflection" : "Edit Reflection")
                                                                            .font(DesignTypography.subheadFont(weight: .medium))
                                                                    }
                                                                }
                                                            )
                                                            .padding(.top, 8)
                                                        }
                                                    }
                                                    .frame(width: cardWidth, height: 200, alignment: .topLeading)
                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .contentShape(Rectangle())
                                            .id(3)
                                        }
                                        .padding(.horizontal, DesignSpacing.sm)
                                        .background(
                                            GeometryReader { scrollGeometry in
                                                Color.clear
                                                    .preference(key: CarouselScrollOffsetPreferenceKey.self, value: scrollGeometry.frame(in: .named("carouselScroll")).minX)
                                            }
                                        )
                                    }
                                    .coordinateSpace(name: "carouselScroll")
                                    .scrollTargetBehavior(.paging)
                                    .onPreferenceChange(CarouselScrollOffsetPreferenceKey.self) { value in
                                        updateCarouselPageIndex(from: value, cardWidth: cardWidth, cardSpacing: cardSpacing, containerWidth: geometry.size.width)
                                    }
                                }
                            }
                            .frame(height: 200) // Fixed height to prevent overlap
                            
                            // Page indicator dots
                            HStack(spacing: 8) {
                                ForEach(0..<4, id: \.self) { index in
                                    Circle()
                                        .fill(index == carouselPageIndex ? DesignColors.accent : DesignColors.accent.opacity(0.3))
                                        .frame(width: index == carouselPageIndex ? 8 : 6, height: index == carouselPageIndex ? 8 : 6)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: carouselPageIndex)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(.horizontal, -DesignSpacing.sm)
                        
                        // Daily Affirmation
                        if let insight = dailyInsight {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Daily Affirmation")
                                            .font(DesignTypography.headlineFont(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Spacer()
                                        
                                        // Bookmark icon should be white
                                        Image(systemName: "bookmark.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(DesignColors.foreground)
                                    }
                                    
                                    // Quote should be centered
                                    Text("\"\(currentAffirmation.isEmpty ? insight.affirmation : currentAffirmation)\"")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                    
                                    ArotiButton(
                                        kind: .custom(ArotiButtonStyle(
                                            foregroundColor: ArotiColor.accent,
                                            backgroundColor: .clear,
                                            borderColor: ArotiColor.accent,
                                            borderWidth: 1,
                                            cornerRadius: DesignRadius.secondary,
                                            height: 48
                                        )),
                                        action: {
                                            if canShuffleAffirmation {
                                                let newAffirmation = contentService.generateAffirmation(dayOfYear: contentService.getDayOfYear() + 1)
                                                currentAffirmation = newAffirmation
                                                stateManager.markAffirmationShuffled()
                                                canShuffleAffirmation = stateManager.canShuffleAffirmation()
                                            }
                                        },
                                        label: {
                                            HStack(spacing: 8) {
                                                Image(systemName: "shuffle")
                                                    .font(.system(size: 16))
                                                Text("New one")
                                                    .font(DesignTypography.subheadFont(weight: .medium))
                                            }
                                        }
                                    )
                                    .disabled(!canShuffleAffirmation)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    
                    // Footer Message
                    Text("Aroti is guiding you today.")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .opacity(0.6)
                        .padding(.top, DesignSpacing.md)
                        .padding(.bottom, 60) // Reasonable padding to ensure visibility above nav bar
                        }
                        .padding(.bottom, 60) // Reasonable padding to prevent content from going behind nav bar
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
                    if let insight = dailyInsight, let card = insight.tarotCard {
                        TarotDetailSheet(card: card)
                            .presentationDetents([.large]) // full-height popup for Tarot
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showHoroscopeSheet) {
                    if let insight = dailyInsight {
                        HoroscopeDetailSheet(horoscope: insight.horoscope, sign: userData.sunSign)
                            .presentationDetents([.large]) // full-height for Astrology
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showNumerologySheet) {
                    if let insight = dailyInsight {
                        HomeNumerologyDetailSheet(numerology: insight.numerology)
                            .presentationDetents([.large]) // full-height for Numerology
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showReflectionSheet) {
                    ReflectionSheet(reflectionText: $reflectionText)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
                .navigationDestination(isPresented: $showRitualDetail) {
                    if let insight = dailyInsight {
                        RitualDetailPage(ritual: insight.ritual)
                    }
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
            tarotCardFlipped = false
        } else {
            tarotCardFlipped = stateManager.hasFlippedCardToday()
        }
        
        // Generate daily insight
        dailyInsight = contentService.generateDailyInsight(userData: userData)
        currentAffirmation = dailyInsight?.affirmation ?? ""
        canShuffleAffirmation = stateManager.canShuffleAffirmation()
        
        updatePoints()
    }
    
    private func updatePoints() {
        let balance = PointsService.shared.getBalance()
        userPoints = balance.totalPoints
    }
    
    private func generateEnergyDescription() -> String {
        let traits = userData.traits ?? ["intuitive", "spiritual"]
        let firstTrait = traits.first?.lowercased() ?? "intuitive"
        let secondTrait = traits.count > 1 ? traits[1].lowercased() : "grounded"
        return "Today your energy feels \(firstTrait) and \(secondTrait) under \(userData.sunSign) skies."
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
    
    private func updateCarouselPageIndex(from offset: CGFloat, cardWidth: CGFloat, cardSpacing: CGFloat, containerWidth: CGFloat) {
        let cardWithSpacing = cardWidth + cardSpacing
        let padding = DesignSpacing.sm
        let adjustedOffset = -offset + padding
        let newIndex = Int(round(adjustedOffset / cardWithSpacing))
        let clampedIndex = max(0, min(newIndex, 3))
        
        if clampedIndex != carouselPageIndex {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                carouselPageIndex = clampedIndex
            }
            HapticFeedback.impactOccurred(.light)
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(selectedTab: .constant(.home))
    }
}
