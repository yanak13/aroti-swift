//
//  DiscoveryView.swift
//  Aroti
//
//  Discovery page matching Home page style
//

import SwiftUI

enum DiscoveryLayout {
    static let horizontalPadding: CGFloat = DesignSpacing.sm
    static let tarotWidth: CGFloat = TarotSpreadCardLayout.defaultWidth
    static let interCardSpacing: CGFloat = 16
    static let wideCardWidth: CGFloat = 320 // legacy card width (less than two tarot cards)
}

struct DiscoveryView: View {
    @Binding var selectedTab: TabItem
    @State private var selectedCategory: String? = nil
    @State private var points: Int = 120
    @State private var scrollOffset: CGFloat = 0
    @State private var hasUnreadNotifications: Bool = false
    
    private func updatePoints() {
        let balance = PointsService.shared.getBalance()
        points = balance.totalPoints
    }
    
    private func updateNotificationState() {
        hasUnreadNotifications = NotificationService.shared.hasUnread()
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let _ = geometry.safeAreaInsets.top
                
                ZStack(alignment: .bottom) {
                    CelestialBackground()
                        .ignoresSafeArea()
                    
                    ZStack(alignment: .top) {
                        ScrollView {
                            VStack(spacing: 0) {
                                // Scroll offset tracker
                                GeometryReader { scrollGeometry in
                                    Color.clear
                                        .preference(
                                            key: ScrollOffsetPreferenceKey.self,
                                            value: scrollGeometry.frame(in: .named("scroll")).minY
                                        )
                                }
                                .frame(height: 0)
                                
                                // 1. Premium Forecasts Section
                                PremiumForecastsSection(selectedTab: $selectedTab)
                                    .padding(.bottom, 20) // Increased title spacing between sections
                                
                                // 2. Tarot Readings Section
                                TarotReadingsSection()
                                    .padding(.bottom, 20) // Increased title spacing between sections
                                
                                // 3. Daily Rituals Section
                                DailyRitualsSection()
                                    .padding(.bottom, 20) // Increased title spacing between sections
                                
                                // 4. Learning by Categories
                                LearningByCategoriesSection(
                                    selectedCategory: $selectedCategory
                                )
                                    .padding(.bottom, 20) // Increased title spacing between sections
                                
                                // 5. Category Grid
                                CategoryGridSection(selectedCategory: selectedCategory)
                                    .padding(.bottom, 20) // Increased title spacing between sections
                                
                                // 6. Courses Section
                                CoursesSection()
                            }
                            .padding(.horizontal, DiscoveryLayout.horizontalPadding)
                            .padding(.top, DesignSpacing.lg + 8)
                            
                            // Footer spacing
                            Spacer()
                                .frame(height: 60)
                        }
                        .coordinateSpace(name: "scroll")
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            scrollOffset = max(0, -value)
                        }
                        .padding(.top, StickyHeaderBar.contentHeight())
                        .padding(.bottom, 60) // Space for bottom nav
                        
                        StickyHeaderBar(
                            title: "Discovery",
                            subtitle: "Explore tarot, practices, and more",
                            scrollOffset: $scrollOffset
                        ) {
                            HStack(spacing: 8) {
                                // Points Chip - premium styling
                                NavigationLink(destination: JourneyPage()) {
                                    HeaderBadge(
                                        iconName: "star.fill",
                                        text: points.formatted()
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
                    
                    // Bottom Navigation Bar
                    VStack {
                        Spacer()
                        BottomNavigationBar(selectedTab: $selectedTab) { tab in
                            selectedTab = tab
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
                .navigationBarHidden(true)
            }
        }
        .onAppear {
            updatePoints()
            updateNotificationState()
        }
        .onReceive(NotificationCenter.default.publisher(for: NotificationService.notificationsUpdated)) { _ in
            updateNotificationState()
        }
    }
}

// MARK: - Premium Forecasts Section
struct PremiumForecastsSection: View {
    @Binding var selectedTab: TabItem
    @State private var showPaywall = false
    @State private var selectedCard: CoreGuidanceCard?
    @State private var showDetailSheet = false
    @State private var userData: UserData = UserData.default
    
    private let userSubscription = UserSubscriptionService.shared
    private let stateManager = DailyStateManager.shared
    
    private var isPremium: Bool {
        userSubscription.isPremium
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Core Guidance carousel - increased vertical spacing and elevated
            CoreGuidanceCarousel(onCardSelected: { card in
                selectedCard = card
                showDetailSheet = true
            })
                .padding(.top, 12) // Increased vertical spacing
                .padding(.bottom, 12)
        }
        .sheet(isPresented: $showDetailSheet) {
            if let card = selectedCard {
                CoreGuidanceDetailSheet(card: card, selectedTab: $selectedTab)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            loadUserData()
        }
    }
    
    private func loadUserData() {
        if let loadedUserData = stateManager.loadUserData() {
            userData = loadedUserData
        }
    }
}

enum ForecastType {
    case horoscope
    case tarot
    case numerology
    case personalAI
}

struct ForecastItem: Identifiable {
    let id: String
    let title: String
    let timeframe: String
    let description: String
    let forecastType: ForecastType
}

// MARK: - Premium Forecast Hero Card
struct PremiumForecastHeroCard: View {
    let isPremium: Bool
    let monthName: String
    @State private var pulseScale: CGFloat = 1.0
    @State private var hasAnimated = false
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Month label chip (top right) - matching detail page exactly
                HStack {
                    Spacer()
                    Text("\(monthName) Forecast")
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
                
                Spacer()
                
                // Title and Description - matching detail page layout exactly
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly Horoscope Forecast")
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(2)
                    
                    // For premium users, show exact same text as detail page
                    // For free users, show value proposition text
                    Text(descriptionText)
                        .font(.system(size: 14))
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineLimit(3)
                        .lineSpacing(4)
                        .padding(.top, 4)
                }
                
                // CTA at bottom
                VStack(alignment: .leading, spacing: 4) {
                    Text(ctaText)
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(isPremium ? DesignColors.foreground : DesignColors.accent)
                        .scaleEffect(!isPremium ? pulseScale : 1.0)
                    
                    if !isPremium {
                        Text("Deep monthly insight created just for you")
                            .font(DesignTypography.caption1Font())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: 200)
        }
        .onAppear {
            if !isPremium && !hasAnimated {
                animatePulse()
                hasAnimated = true
            }
        }
    }
    
    private var descriptionText: String {
        if isPremium {
            return "Your personalized horoscope forecast for \(monthName) will appear here."
        } else {
            return "Deep, personalized insights for the month ahead."
        }
    }
    
    private var ctaText: String {
        if isPremium {
            return "Read your forecast"
        } else {
            return "Unlock Premium Forecast"
        }
    }
    
    private func animatePulse() {
        withAnimation(.easeInOut(duration: 0.3)) {
            pulseScale = 1.05
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                pulseScale = 1.0
            }
        }
    }
}

// Legacy card component (kept for backward compatibility if needed elsewhere)
struct PremiumForecastCard: View {
    let forecast: ForecastItem
    let isPremium: Bool
    let numerologyNumber: Int?
    
    init(forecast: ForecastItem, isPremium: Bool, numerologyNumber: Int? = nil) {
        self.forecast = forecast
        self.isPremium = isPremium
        self.numerologyNumber = numerologyNumber
    }
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Top row: Timeframe chip or number badge (top right) and lock icon
                HStack {
                    Spacer()
                    
                    // Show number badge for numerology, timeframe chip for others
                    if forecast.forecastType == .numerology, let number = numerologyNumber {
                        // Number badge with orange glow
                        Text("\(number)")
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
                    } else {
                        // Timeframe chip in top right
                        Text(forecast.timeframe)
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
                    
                    // Lock icon for free users (soft, low contrast) - only if not premium
                    if !isPremium {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14))
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.5))
                            .padding(.leading, 8)
                    }
                }
                
                Spacer()
                
                // Title and Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(forecast.title)
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(2)
                    
                    Text(forecast.description)
                        .font(.system(size: 14))
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineLimit(2)
                        .padding(.top, 4)
                }
            }
            .frame(width: DiscoveryLayout.wideCardWidth, height: 200, alignment: .topLeading)
        }
    }
}

// MARK: - For You Section (REMOVED)

// MARK: - Tarot Readings Section
struct TarotReadingsSection: View {
    @State private var showPaywall = false
    private let accessControl = AccessControlService.shared
    private let userSubscription = UserSubscriptionService.shared
    
    private var isPremium: Bool {
        userSubscription.isPremium
    }
    
    let spreads = [
        SpreadItem(
            id: "quick-draw",
            title: "Quick Draw",
            cardCount: 1,
            isPremium: false,
            microDescriptor: "A single message for right now",
            time: "1 min",
            depth: "Quick",
            isForYou: true,
            ctaText: "Draw cards →",
            isFirstCard: true
        ),
        SpreadItem(
            id: "three-card",
            title: "Three Card Spread",
            cardCount: 3,
            isPremium: false,
            microDescriptor: "Understand your past, present, and future",
            time: "3-5 min",
            depth: "Reflective",
            isForYou: false,
            ctaText: "Begin reading →",
            isFirstCard: false
        ),
        SpreadItem(
            id: "celtic-cross",
            title: "Celtic Cross",
            cardCount: 10,
            isPremium: true,
            microDescriptor: "A comprehensive view of your path",
            time: "10-15 min",
            depth: "Deep",
            isForYou: false,
            ctaText: "Reveal insight →",
            isFirstCard: false
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tarot Readings")
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    Text("Explore different reading layouts")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                Spacer()
                
                NavigationLink(destination: TarotSpreadsListingPage()) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.accent)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.accent)
                    }
                }
            }
            
            // Fixed card dimensions for horizontal scrolling (allows 3+ cards visible)
            let cardWidth: CGFloat = 280
            let cardHeight: CGFloat = cardWidth * 1.5 // 2:3 aspect ratio
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: DiscoveryLayout.interCardSpacing) {
                    ForEach(spreads) { spread in
                        Group {
                            if spread.isPremium && !isPremium {
                                Button(action: {
                                    showPaywall = true
                                }) {
                                    TarotSpreadCard(
                                        name: spread.title,
                                        cardCount: spread.cardCount,
                                        width: cardWidth,
                                        height: cardHeight,
                                        microDescriptor: spread.microDescriptor,
                                        time: spread.time,
                                        depth: spread.depth,
                                        isForYou: spread.isForYou,
                                        ctaText: spread.ctaText,
                                        isFirstCard: spread.isFirstCard,
                                        isPremium: spread.isPremium,
                                        hasNewContent: false, // TODO: Add logic to determine if content is new
                                        userIsPremium: isPremium,
                                        action: nil
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                NavigationLink(destination: TarotSpreadDetailPage(spreadId: spread.id)) {
                                    TarotSpreadCard(
                                        name: spread.title,
                                        cardCount: spread.cardCount,
                                        width: cardWidth,
                                        height: cardHeight,
                                        microDescriptor: spread.microDescriptor,
                                        time: spread.time,
                                        depth: spread.depth,
                                        isForYou: spread.isForYou,
                                        ctaText: spread.ctaText,
                                        isFirstCard: spread.isFirstCard,
                                        isPremium: spread.isPremium,
                                        hasNewContent: false, // TODO: Add logic to determine if content is new
                                        userIsPremium: isPremium,
                                        action: nil
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(width: cardWidth, height: cardHeight)
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
                .padding(.vertical, 4)
            }
            .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        }
        .sheet(isPresented: $showPaywall) {
            PremiumPaywallSheet(context: "tarot_spread")
        }
    }
}

struct SpreadItem: Identifiable {
    let id: String
    let title: String
    let cardCount: Int
    let isPremium: Bool
    let microDescriptor: String
    let time: String
    let depth: String
    let isForYou: Bool
    let ctaText: String
    let isFirstCard: Bool
}

// MARK: - Learning by Categories Section
struct LearningByCategoriesSection: View {
    @Binding var selectedCategory: String?
    
    // Learning Hub categories - 6 pillars
    let categories = ["All", "Astrology", "Tarot", "Numerology", "Timing & Cycles", "Self-awareness & Integration", "Using the App Intelligently"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Learning by Categories")
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    Text("Explore your interests")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                Spacer()
                
                NavigationLink(destination: LearningHubListingPage(selectedCategory: selectedCategory)) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        let isAll = category == "All"
                        CategoryChip(
                            label: category,
                            isActive: isAll ? selectedCategory == nil : selectedCategory == category,
                            action: {
                                if isAll {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            }
            .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        }
    }
}

// MARK: - Category Grid Section
struct CategoryGridSection: View {
    let selectedCategory: String?
    
    // Get articles from ArticleData, convert to CategoryGridItems
    var categoryItems: [CategoryGridItem] {
        let articles = ArticleData.articles.values
        
        // If a category is selected, filter by it; otherwise show featured articles from each pillar
        let filteredArticles: [Article]
        if let category = selectedCategory, category != "All" {
            filteredArticles = Array(articles.filter { $0.category == category })
        } else {
            // Show featured articles from each pillar when "All" is selected
            filteredArticles = Array(articles.prefix(8)) // Show first 8 articles as featured
        }
        
        return filteredArticles.map { article in
            // Calculate reading time - use helper function from ArticleDetailPage
            let readingTime = calculateReadingTime(article: article)
            return CategoryGridItem(
                id: article.id,
                title: article.title,
                subtitle: article.subtitle,
                category: article.category,
                benefit: article.difficulty?.displayName ?? "",
                difficulty: article.difficulty,
                readingTime: readingTime
            )
        }
    }
    
    var body: some View {
        if categoryItems.isEmpty {
            EmptyView()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DiscoveryLayout.interCardSpacing) {
                    ForEach(categoryItems) { item in
                        NavigationLink(destination: ArticleDetailPage(articleId: item.id)) {
                            CategoryGridCard(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            }
            .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        }
    }
}

struct CategoryGridItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let category: String
    let benefit: String
    let difficulty: ArticleDifficulty?
    let readingTime: String?
}

struct CategoryGridCard: View {
    let item: CategoryGridItem
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 0) {
                // Chips in top-left: difficulty and reading time
                HStack(spacing: 8) {
                    if let difficulty = item.difficulty {
                        Text(difficulty.displayName)
                            .font(DesignTypography.footnoteFont(weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                    
                    if let readingTime = item.readingTime {
                        Text(readingTime)
                            .font(DesignTypography.footnoteFont(weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                    
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.leading, 12)
                .padding(.bottom, 10) // 8-12px spacing between chips row and title
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title)
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(2)
                    
                    Text(item.subtitle)
                        .font(.system(size: 15))
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineLimit(2)
                }
            }
            .frame(width: DiscoveryLayout.wideCardWidth, height: 200, alignment: .topLeading)
        }
    }
}

// MARK: - Daily Rituals Section
struct DailyRitualsSection: View {
    let practices = [
        PracticeItem(id: "1", title: "Morning Intention", duration: "5 min", category: "Focus", helperText: "Set the tone for your day", isForYou: true),
        PracticeItem(id: "2", title: "Evening Reflection", duration: "8 min", category: "Reflection", helperText: "Process your day with intention", isForYou: false),
        PracticeItem(id: "3", title: "Breath Reset", duration: "3 min", category: "Calm", helperText: "Return to center quickly", isForYou: false),
        PracticeItem(id: "4", title: "Gratitude Prompt", duration: "2 min", category: "Gratitude", helperText: "Cultivate appreciation", isForYou: false),
        PracticeItem(id: "5", title: "Grounding Practice", duration: "7 min", category: "Grounding", helperText: "Connect with the present moment", isForYou: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Rituals")
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    Text("Morning routines & evening rituals")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                Spacer()
                
                NavigationLink(destination: DailyPracticesListingPage()) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.8)) // Lower contrast
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.8)) // Lower contrast
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DiscoveryLayout.interCardSpacing) {
                    // Practices
                    ForEach(practices) { practice in
                        NavigationLink(destination: PracticeDetailPage(practiceId: practice.id)) {
                            DiscoveryPracticeCard(practice: practice)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            }
            .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        }
    }
}

struct PracticeItem: Identifiable {
    let id: String
    let title: String
    let duration: String
    let category: String
    let helperText: String
    let isForYou: Bool
}

struct DiscoveryPracticeCard: View {
    let practice: PracticeItem
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 0) {
                // Chips in top-left (max 2 chips: Access chip first, then Status chip)
                HStack(spacing: 8) {
                    // Remove duration and category chips per spec
                    // Only show "For you" status chip if applicable
                    if practice.isForYou {
                        CardChip(text: "For you", type: .forYou)
                    }
                    
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.leading, 12)
                .padding(.bottom, 10) // 8-12px spacing between chips row and title
                
                Spacer()
                
                // Title and helper text - lower contrast, supportive tone
                VStack(alignment: .leading, spacing: 4) {
                    Text(practice.title)
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground.opacity(0.95)) // Slightly lower contrast
                        .lineLimit(2)
                    
                    // Helper text below title - supportive, not promotional
                    Text(practice.helperText)
                        .font(DesignTypography.caption1Font())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.9)) // Lower contrast
                        .lineLimit(2)
                }
            }
            .frame(width: DiscoveryLayout.wideCardWidth, height: 200, alignment: .topLeading)
        }
        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 2) // Softer shadow for lower contrast
    }
}

// MARK: - Courses Section
struct CoursesSection: View {
    let courses = [
        DiscoveryCourseItem(id: "1", title: "Tarot Fundamentals", description: "Master the basics of tarot reading and card in...", lessonCount: 8, duration: "2h 30m", price: 29.99),
        DiscoveryCourseItem(id: "2", title: "Advanced Astrology", description: "Deep dive into planetary aspects and chart in...", lessonCount: 12, duration: "4h 15m", price: 49.99),
        DiscoveryCourseItem(id: "3", title: "Numerology Mastery", description: "Learn to calculate and interpret life path num...", lessonCount: 10, duration: "3h 20m", price: 39.99)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Courses")
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    Text("Mini courses to deepen your practice")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                    // Subtle line above courses
                    Text("For those ready to go deeper")
                        .font(DesignTypography.caption1Font())
                        .foregroundColor(DesignColors.mutedForeground)
                        .padding(.top, 2)
                }
                
                Spacer()
                
                NavigationLink(destination: CoursesListingPage()) {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.accent)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.accent)
                    }
                }
            }
            
            VStack(spacing: 12) {
                ForEach(courses) { course in
                    NavigationLink(destination: CourseDetailPage(courseId: course.id)) {
                        CourseCard(course: course)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct DiscoveryCourseItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let lessonCount: Int
    let duration: String
    let price: Double
}

struct CourseCard: View {
    let course: DiscoveryCourseItem
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center, spacing: 8) {
                    Text(course.title)
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(1)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(DesignColors.mutedForeground)
                    
                    Spacer()
                    
                    Text("$\(course.price, specifier: "%.2f")")
                        .font(DesignTypography.caption1Font(weight: .medium))
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
                }
                
                Text(course.description)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .lineLimit(2)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.mutedForeground)
                        Text("\(course.lessonCount) Lessons")
                            .font(DesignTypography.caption2Font())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.mutedForeground)
                        Text(course.duration)
                            .font(DesignTypography.caption2Font())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(DesignColors.mutedForeground)
                }
            }
        }
    }
}

// MARK: - Your Journey Section (REMOVED)
// MARK: - Recently Viewed Section (REMOVED)

#Preview {
    NavigationStack {
        DiscoveryView(selectedTab: .constant(.discovery))
    }
}

