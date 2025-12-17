//
//  DiscoveryView.swift
//  Aroti
//
//  Discovery page matching Home page style
//

import SwiftUI

enum DiscoveryLayout {
    static let horizontalPadding: CGFloat = DesignSpacing.sm
    static let tarotWidth: CGFloat = TarotSpreadCardLayout.width
    static let interCardSpacing: CGFloat = 16
    static let wideCardWidth: CGFloat = 320 // legacy card width (less than two tarot cards)
}

struct DiscoveryView: View {
    @Binding var selectedTab: TabItem
    @State private var selectedCategory: String? = nil
    @State private var points: Int = 120
    
    private func updatePoints() {
        let balance = PointsService.shared.getBalance()
        points = balance.totalPoints
    }
    
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
                                // 1. Premium Forecasts Section
                                PremiumForecastsSection()
                                
                                // 2. Tarot Readings Section
                                TarotReadingsSection()
                                
                                // 3. Daily Rituals Section
                                DailyRitualsSection()
                                
                                // 4. Learning by Categories
                                LearningByCategoriesSection(
                                    selectedCategory: $selectedCategory
                                )
                                
                                // 5. Category Grid
                                CategoryGridSection(selectedCategory: selectedCategory)
                                
                                // 6. Courses Section
                                CoursesSection()
                            }
                            .padding(.horizontal, DiscoveryLayout.horizontalPadding)
                            .padding(.top, DesignSpacing.lg + 8)
                            
                            // Footer spacing
                            Spacer()
                                .frame(height: 60)
                        }
                        .padding(.top, 32) // Just header content height, safe area already handled
                        .padding(.bottom, 60) // Space for bottom nav
                        
                        StickyHeaderBar(
                            title: "Discovery",
                            subtitle: "Explore tarot, practices, and more",
                            safeAreaTop: safeAreaTop
                        ) {
                            HStack(spacing: 8) {
                                // Points Chip - dynamic width based on content
                                NavigationLink(destination: JourneyPage()) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 12))
                                        Text("\(points.formatted())")
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
        }
    }
}

// MARK: - Premium Forecasts Section
struct PremiumForecastsSection: View {
    @State private var showPaywall = false
    private let userSubscription = UserSubscriptionService.shared
    
    private var isPremium: Bool {
        userSubscription.isPremium
    }
    
    let forecasts = [
        ForecastItem(
            id: "horoscope",
            title: "Horoscope Forecast",
            timeframe: "This month",
            description: "Discover what the stars reveal about your path forward.",
            forecastType: .horoscope
        ),
        ForecastItem(
            id: "tarot",
            title: "Tarot Forecast",
            timeframe: "This month",
            description: "Insights and guidance from the cards for the month ahead.",
            forecastType: .tarot
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Premium Forecasts")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    Text("Personalized insights for the month ahead")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DiscoveryLayout.interCardSpacing) {
                    ForEach(forecasts) { forecast in
                        Group {
                            if isPremium {
                                NavigationLink(destination: forecastDestination(for: forecast)) {
                                    PremiumForecastCard(forecast: forecast, isPremium: isPremium)
                                }
                            } else {
                                Button(action: {
                                    showPaywall = true
                                }) {
                                    PremiumForecastCard(forecast: forecast, isPremium: isPremium)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            }
            .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        }
        .sheet(isPresented: $showPaywall) {
            PremiumPaywallSheet(context: "forecast")
        }
    }
    
    @ViewBuilder
    private func forecastDestination(for forecast: ForecastItem) -> some View {
        switch forecast.forecastType {
        case .horoscope:
            HoroscopeForecastPage()
        case .tarot:
            TarotForecastPage()
        case .numerology, .personalAI:
            // Placeholder for future forecast types
            HoroscopeForecastPage()
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

struct PremiumForecastCard: View {
    let forecast: ForecastItem
    let isPremium: Bool
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Top row: Timeframe chip (top right) and lock icon
                HStack {
                    Spacer()
                    
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
        SpreadItem(id: "quick-draw", title: "Quick Draw", cardCount: 1, isPremium: false),
        SpreadItem(id: "three-card", title: "Three Card Spread", cardCount: 3, isPremium: false),
        SpreadItem(id: "celtic-cross", title: "Celtic Cross", cardCount: 10, isPremium: true)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tarot Readings")
                        .font(DesignTypography.title3Font(weight: .medium))
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DiscoveryLayout.interCardSpacing) {
                    ForEach(spreads) { spread in
                        Group {
                            if spread.isPremium && !isPremium {
                                Button(action: {
                                    showPaywall = true
                                }) {
                                    TarotSpreadCard(
                                        name: spread.title,
                                        cardCount: spread.cardCount,
                                        action: nil
                                    )
                                }
                            } else {
                                NavigationLink(destination: TarotSpreadDetailPage(spreadId: spread.id)) {
                                    TarotSpreadCard(
                                        name: spread.title,
                                        cardCount: spread.cardCount,
                                        action: nil
                                    )
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
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
}

// MARK: - Learning by Categories Section
struct LearningByCategoriesSection: View {
    @Binding var selectedCategory: String?
    
    // Limited to 4 categories as per spec
    let categories = ["All", "Tarot", "Astrology", "Numerology", "Compatibility"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Learning by Categories")
                    .font(DesignTypography.title2Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                Text("Explore your interests")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
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
    
    let categoryItems = [
        CategoryGridItem(id: "1", title: "Three Card Spread", subtitle: "Past, present, future insights", category: "Tarot"),
        CategoryGridItem(id: "2", title: "Birth Chart", subtitle: "Discover your cosmic blueprint", category: "Astrology"),
        CategoryGridItem(id: "3", title: "Life Path Number", subtitle: "Calculate your numerology", category: "Numerology"),
        CategoryGridItem(id: "4", title: "Relationship Compatibility", subtitle: "Explore connections and dynamics", category: "Compatibility")
    ]
    
    var body: some View {
        if let category = selectedCategory {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DiscoveryLayout.interCardSpacing) {
                    ForEach(categoryItems.filter { $0.category == category }) { item in
                        NavigationLink(destination: ArticleDetailPage(articleId: item.id)) {
                            CategoryGridCard(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            }
            .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
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
}

struct CategoryGridCard: View {
    let item: CategoryGridItem
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Category Tag
                Text(item.category)
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
        PracticeItem(id: "1", title: "Morning Intention", duration: "5 min"),
        PracticeItem(id: "2", title: "Evening Reflection", duration: "8 min"),
        PracticeItem(id: "3", title: "Breath Reset", duration: "3 min"),
        PracticeItem(id: "4", title: "Gratitude Prompt", duration: "2 min"),
        PracticeItem(id: "5", title: "Grounding Practice", duration: "7 min")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Rituals")
                        .font(DesignTypography.title3Font(weight: .medium))
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
                            .foregroundColor(DesignColors.accent)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.accent)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DiscoveryLayout.interCardSpacing) {
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
}

struct DiscoveryPracticeCard: View {
    let practice: PracticeItem
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Tag
                Text("Practice")
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
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(practice.title)
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text(practice.duration)
                        .font(.system(size: 15))
                        .foregroundColor(DesignColors.mutedForeground)
                }
            }
            .frame(width: DiscoveryLayout.wideCardWidth, height: 200, alignment: .topLeading)
        }
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
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    Text("Mini courses to deepen your practice")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
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

