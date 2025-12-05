//
//  DiscoveryView.swift
//  Aroti
//
//  Discovery page matching Home page style
//

import SwiftUI

private enum DiscoveryLayout {
    static let horizontalPadding: CGFloat = DesignSpacing.sm
    static let tarotWidth: CGFloat = TarotSpreadCardLayout.width
    static let interCardSpacing: CGFloat = 16
    static let wideCardWidth: CGFloat = 320 // legacy card width (less than two tarot cards)
}

struct DiscoveryView: View {
    @Binding var selectedTab: TabItem
    @State private var selectedCategory: String? = nil
    @State private var points: Int = 120
    
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
                                // 1. For You Section
                                ForYouSection()
                                
                                // 2. Tarot Spreads Section
                                TarotSpreadsSection()
                                
                                // 3. Browse by Category
                                BrowseByCategorySection(
                                    selectedCategory: $selectedCategory
                                )
                                
                                // 4. Category Grid
                                CategoryGridSection(selectedCategory: selectedCategory)
                                
                                // 5. Daily Practice
                                DailyPracticeSection()
                                
                                // 6. Your Journey Section
                                YourJourneySection()
                                
                                // 7. Recently Viewed Section
                                RecentlyViewedSection()
                                
                                // 8. Courses Section
                                CoursesSection()
                            }
                            .padding(.horizontal, DiscoveryLayout.horizontalPadding)
                            
                            // Footer spacing
                            Spacer()
                                .frame(height: 60)
                        }
                        .padding(.top, StickyHeaderBar.totalHeight(for: safeAreaTop))
                        .padding(.bottom, 60) // Space for bottom nav
                        
                        StickyHeaderBar(
                            title: "Discovery",
                            safeAreaTop: safeAreaTop
                        ) {
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 16))
                                    .foregroundColor(DesignColors.accent)
                                Text("\(points)")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.accent)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(DesignColors.accent.opacity(0.15))
                                    .overlay(
                                        Capsule()
                                            .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                    )
                            )
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
    }
}

// MARK: - For You Section
struct ForYouSection: View {
    let items = [
        ForYouItem(
            id: "1",
            title: "Celtic Cross Reading",
            subtitle: "A comprehensive 10-card spread for deep insights",
            tag: "Daily Pick",
            category: "Tarot"
        ),
        ForYouItem(
            id: "2",
            title: "Love & Relationships",
            subtitle: "Explore connections and understand dynamics",
            tag: "Recommended",
            category: "Astrology"
        ),
        ForYouItem(
            id: "3",
            title: "Moon Phase Meditation",
            subtitle: "Align with lunar cycles for inner peace",
            tag: "Trending",
            category: "Moon Phases"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("For You")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    Text("Personalized recommendations")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                Spacer()
                
                NavigationLink(destination: ForYouListingPage()) {
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
            
            // Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DiscoveryLayout.interCardSpacing) {
                    ForEach(items) { item in
                        NavigationLink(destination: ArticleDetailPage(articleId: item.id)) {
                            ForYouCard(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    NavigationLink(destination: QuizPage()) {
                        ForYouDailyQuizCard()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            }
            .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        }
    }
}

struct ForYouItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let tag: String
    let category: String
}

struct ForYouCard: View {
    let item: ForYouItem
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Tag
                Text(item.tag)
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
                
                // Title and Subtitle
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

struct ForYouDailyQuizCard: View {
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                quizChip
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Start Quiz")
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(2)
                    
                    Text("Test your tarot knowledge and earn points")
                        .font(.system(size: 15))
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineLimit(2)
                }
            }
            .frame(width: DiscoveryLayout.wideCardWidth, height: 200, alignment: .topLeading)
        }
    }
    
    private var quizChip: some View {
        Text("Daily Quiz")
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

// MARK: - Tarot Spreads Section
struct TarotSpreadsSection: View {
    let spreads = [
        SpreadItem(id: "celtic-cross", title: "Celtic Cross", cardCount: 10),
        SpreadItem(id: "three-card", title: "Three Card Spread", cardCount: 3),
        SpreadItem(id: "past-present-future", title: "Past Present Future", cardCount: 3)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tarot Spreads")
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
                        NavigationLink(destination: TarotSpreadDetailPage(spreadId: spread.id)) {
                            TarotSpreadCard(
                                name: spread.title,
                                cardCount: spread.cardCount,
                                action: nil
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            }
            .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        }
    }
}

struct SpreadItem: Identifiable {
    let id: String
    let title: String
    let cardCount: Int
}

// MARK: - Browse by Category Section
struct BrowseByCategorySection: View {
    @Binding var selectedCategory: String?
    
    // First row: 8 items
    let firstRowCategories = ["All", "Tarot", "Numerology", "Meditation", "Crystals", "Astrology", "Moon Phases", "Rituals"]
    // Second row: 7 items
    let secondRowCategories = ["Candles", "Energy Work", "Divination", "Chakras", "Manifestation", "Spiritual Guides", "Angel Numbers"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Browse by Category")
                    .font(DesignTypography.title2Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                Text("Explore your interests")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    // First row
                    HStack(spacing: 8) {
                        ForEach(firstRowCategories, id: \.self) { category in
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
                    
                    // Second row
                    HStack(spacing: 8) {
                        ForEach(secondRowCategories, id: \.self) { category in
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
                }
                .frame(minWidth: UIScreen.main.bounds.width - (DiscoveryLayout.horizontalPadding * 2))
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
        CategoryGridItem(id: "3", title: "Life Path Number", subtitle: "Calculate your numerology", category: "Numerology")
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

// MARK: - Daily Practice Section
struct DailyPracticeSection: View {
    let practices = [
        PracticeItem(id: "1", title: "Morning Intention", duration: "5 min"),
        PracticeItem(id: "2", title: "Breathing Exercise", duration: "10 min"),
        PracticeItem(id: "3", title: "Evening Reflection", duration: "8 min")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Daily Practice")
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

// MARK: - Your Journey Section
struct YourJourneySection: View {
    
    private let progress: CGFloat = 0.65
    
    var body: some View {
        BaseCard {
            VStack(alignment: .center, spacing: 16) {
                Text("Your Journey")
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                    .frame(maxWidth: .infinity)
                
                VStack(spacing: 12) {
                    JourneyStatsRow(stats: [
                        JourneyStatDisplay(topText: "7-day", bottomText: "streak"),
                        JourneyStatDisplay(topText: "24", bottomText: "readings"),
                        JourneyStatDisplay(topText: "12", bottomText: "reflections"),
                        JourneyStatDisplay(topText: "8", bottomText: "rituals")
                    ])
                    
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 6)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        colors: [DesignColors.accent, DesignColors.accent.opacity(0.6)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(proxy.size.width * progress, 0), height: 6)
                        }
                    }
                    .frame(height: 6)
                    
                    // View Your Journey Button
                    NavigationLink(destination: JourneyPage()) {
                        ArotiButton(
                            kind: .primary,
                            action: {}
                        ) {
                            HStack(spacing: 8) {
                                Text("View Your Journey")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct JourneyStatDisplay: Identifiable {
    let id = UUID()
    let topText: String
    let bottomText: String
}

struct JourneyStatsRow: View {
    let stats: [JourneyStatDisplay]
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(stats.indices, id: \.self) { index in
                VStack(spacing: 4) {
                    Text(stats[index].topText)
                        .font(DesignTypography.subheadFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    Text(stats[index].bottomText)
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                .frame(maxWidth: .infinity)
                
                if index < stats.count - 1 {
                    Text("•")
                        .font(DesignTypography.headlineFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .padding(.horizontal, 8)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Recently Viewed Section
struct RecentlyViewedSection: View {
    let items = [
        RecentlyViewedItem(id: "1", title: "Moon Guidance", type: "Spread"),
        RecentlyViewedItem(id: "2", title: "The Fool", type: "Card"),
        RecentlyViewedItem(id: "3", title: "Celtic Cross", type: "Spread")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recently Viewed")
                .font(DesignTypography.headlineFont(weight: .semibold))
                .foregroundColor(DesignColors.foreground)
            
            // Separator line
            Divider()
                .overlay(Color.white.opacity(0.2))
                .padding(.bottom, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DiscoveryLayout.interCardSpacing) {
                    ForEach(items) { item in
                        Group {
                            if item.type == "Spread" {
                                NavigationLink(destination: TarotSpreadDetailPage(spreadId: item.id)) {
                                    RecentlyViewedCard(item: item)
                                }
                            } else if item.type == "Card" {
                                NavigationLink(destination: ArticleDetailPage(articleId: item.id)) {
                                    RecentlyViewedCard(item: item)
                                }
                            } else {
                                NavigationLink(destination: ArticleDetailPage(articleId: item.id)) {
                                    RecentlyViewedCard(item: item)
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
    }
}

struct RecentlyViewedItem: Identifiable {
    let id: String
    let title: String
    let type: String
}

struct RecentlyViewedCard: View {
    let item: RecentlyViewedItem
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Type Tag
                Text(item.type)
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
                
                Text(item.title)
                    .font(DesignTypography.headlineFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                    .lineLimit(2)
                
                Text("Tap to explore")
                    .font(.system(size: 15))
                    .foregroundColor(DesignColors.mutedForeground)
            }
            .frame(width: DiscoveryLayout.wideCardWidth, height: 200, alignment: .topLeading)
        }
    }
}

#Preview {
    NavigationStack {
        DiscoveryView(selectedTab: .constant(.discovery))
    }
}

