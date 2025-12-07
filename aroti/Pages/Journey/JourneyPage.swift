//
//  JourneyPage.swift
//  Aroti
//
//  Full journey page with progress tracking
//

import SwiftUI

struct Activity: Identifiable {
    let id: String
    let type: String
    let title: String
    let timestamp: String
}

struct JourneyPage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var journeySummary: JourneySummary?
    private let journeyService = JourneyService.shared
    private let pointsService = PointsService.shared
    private let accessControl = AccessControlService.shared
    private let userSubscription = UserSubscriptionService.shared
    
    private var isPremium: Bool {
        userSubscription.isPremium
    }
    
    private var progress: CGFloat {
        guard let summary = journeySummary else { return 0 }
        guard summary.nextLevelThreshold > summary.currentLevel else { return 1.0 }
        let progressValue = Double(summary.lifetimePoints - getLevelThreshold(summary.currentLevel)) / Double(summary.nextLevelThreshold - getLevelThreshold(summary.currentLevel))
        return CGFloat(max(0, min(1, progressValue)))
    }
    
    private func getLevelThreshold(_ level: Int) -> Int {
        let thresholds: [Int] = [0, 100, 300, 600, 1000, 2000, 3000]
        return level > 0 && level <= thresholds.count ? thresholds[level - 1] : 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        BaseHeader(
                            title: "Your Journey",
                            subtitle: "Track your progress and achievements",
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            )
                        )
                        .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                        
                        // Content
                        let summary = journeyService.getJourneySummary()
                        VStack(spacing: 24) {
                            if summary.lifetimePoints > 0 || summary.totalPoints > 0 {
                                // Hero Card - Level & Points
                                BaseCard {
                                    VStack(spacing: 20) {
                                        // Level Display
                                        VStack(spacing: 8) {
                                            Text("Level \(summary.currentLevel)")
                                                .font(DesignTypography.title2Font(weight: .bold))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            Text(summary.currentLevelName)
                                                .font(DesignTypography.headlineFont(weight: .medium))
                                                .foregroundColor(DesignColors.accent)
                                        }
                                        
                                        // Points Display
                                        VStack(spacing: 4) {
                                            HStack(spacing: 16) {
                                                VStack(spacing: 4) {
                                                    Text("\(summary.totalPoints)")
                                                        .font(DesignTypography.title1Font(weight: .bold))
                                                        .foregroundColor(DesignColors.foreground)
                                                    Text("Points Balance")
                                                        .font(DesignTypography.caption2Font())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                }
                                                
                                                Rectangle()
                                                    .fill(Color.white.opacity(0.1))
                                                    .frame(width: 1, height: 40)
                                                
                                                VStack(spacing: 4) {
                                                    Text("\(summary.lifetimePoints)")
                                                        .font(DesignTypography.title1Font(weight: .bold))
                                                        .foregroundColor(DesignColors.accent)
                                                    Text("Lifetime Points")
                                                        .font(DesignTypography.caption2Font())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                }
                                            }
                                        }
                                        
                                        // Progress to Next Level
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text("Next Level: \(summary.currentLevelName)")
                                                    .font(DesignTypography.caption2Font(weight: .medium))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                    .textCase(.uppercase)
                                                Spacer()
                                                Text("\(summary.pointsToNextLevel) pts to go")
                                                    .font(DesignTypography.caption2Font())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            GeometryReader { proxy in
                                                ZStack(alignment: .leading) {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(Color.white.opacity(0.08))
                                                        .frame(height: 8)
                                                    
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(
                                                            LinearGradient(
                                                                colors: [DesignColors.accent, DesignColors.accent.opacity(0.6)],
                                                                startPoint: .leading,
                                                                endPoint: .trailing
                                                            )
                                                        )
                                                        .frame(width: max(proxy.size.width * progress, 0), height: 8)
                                                }
                                            }
                                            .frame(height: 8)
                                        }
                                    }
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Today's Progress Card
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Today's Progress")
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        VStack(spacing: 12) {
                                            HStack {
                                                Text("Points earned today:")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                Spacer()
                                                Text("\(summary.today.points)")
                                                    .font(DesignTypography.bodyFont(weight: .semibold))
                                                    .foregroundColor(DesignColors.accent)
                                            }
                                            
                                            HStack {
                                                Text("Streak:")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                Spacer()
                                                HStack(spacing: 4) {
                                                    Text("✨")
                                                    Text("\(summary.today.streakDays) days")
                                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                                        .foregroundColor(DesignColors.foreground)
                                                }
                                            }
                                            
                                            Divider()
                                                .background(Color.white.opacity(0.1))
                                            
                                            HStack(spacing: 16) {
                                                VStack(spacing: 4) {
                                                    Text("\(summary.today.completedPractices)")
                                                        .font(DesignTypography.title3Font(weight: .semibold))
                                                        .foregroundColor(DesignColors.foreground)
                                                    Text("Practices")
                                                        .font(DesignTypography.caption2Font())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                }
                                                
                                                VStack(spacing: 4) {
                                                    Text("\(summary.today.completedSpreads)")
                                                        .font(DesignTypography.title3Font(weight: .semibold))
                                                        .foregroundColor(DesignColors.foreground)
                                                    Text("Spreads")
                                                        .font(DesignTypography.caption2Font())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                }
                                                
                                                VStack(spacing: 4) {
                                                    Text("\(summary.today.completedQuizzes)")
                                                        .font(DesignTypography.title3Font(weight: .semibold))
                                                        .foregroundColor(DesignColors.foreground)
                                                    Text("Quizzes")
                                                        .font(DesignTypography.caption2Font())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Last 7 Days Card
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Last 7 Days")
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        HStack(spacing: 8) {
                                            ForEach(summary.last7Days.prefix(7), id: \.date) { day in
                                                VStack(spacing: 4) {
                                                    Text("\(day.points)")
                                                        .font(DesignTypography.caption1Font(weight: .semibold))
                                                        .foregroundColor(DesignColors.foreground)
                                                    
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .fill(day.points > 0 ? DesignColors.accent : Color.white.opacity(0.1))
                                                        .frame(width: 24, height: CGFloat(max(4, min(40, day.points))))
                                                }
                                                .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Milestones Card
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Milestones")
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        VStack(spacing: 12) {
                                            ForEach(summary.milestones.prefix(5)) { milestone in
                                                HStack {
                                                    Image(systemName: milestone.completed ? "checkmark.circle.fill" : "circle")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(milestone.completed ? DesignColors.accent : DesignColors.mutedForeground)
                                                    
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text(milestone.label)
                                                            .font(DesignTypography.bodyFont(weight: .medium))
                                                            .foregroundColor(DesignColors.foreground)
                                                        
                                                        if let reward = milestone.reward {
                                                            Text(reward)
                                                                .font(DesignTypography.caption2Font())
                                                                .foregroundColor(DesignColors.mutedForeground)
                                                        }
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Text("\(milestone.requiredPoints) pts")
                                                        .font(DesignTypography.caption2Font())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Recent Unlocks
                                if !summary.recentUnlocks.isEmpty {
                                    BaseCard {
                                        VStack(alignment: .leading, spacing: 16) {
                                            Text("Recent Unlocks")
                                                .font(DesignTypography.headlineFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            VStack(spacing: 8) {
                                                ForEach(summary.recentUnlocks.prefix(5)) { unlock in
                                                    HStack {
                                                        Image(systemName: "sparkles")
                                                            .font(.system(size: 16))
                                                            .foregroundColor(DesignColors.accent)
                                                        
                                                        Text("\(unlock.type.capitalized): \(unlock.contentId)")
                                                            .font(DesignTypography.bodyFont())
                                                            .foregroundColor(DesignColors.foreground)
                                                        
                                                        Spacer()
                                                        
                                                        Text(formatDate(unlock.timestamp))
                                                            .font(DesignTypography.caption2Font())
                                                            .foregroundColor(DesignColors.mutedForeground)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, DesignSpacing.sm)
                                }
                            }
                            
                            // Always show Quick Actions sections
                            // Quick Actions - Earn Points
                            BaseCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Earn Points")
                                        .font(DesignTypography.headlineFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text("Complete activities to earn points and level up")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    VStack(spacing: 12) {
                                        // Daily Practice
                                        QuickActionRow(
                                            icon: "leaf.fill",
                                            title: "Daily Practice",
                                            subtitle: isPremium ? "Unlimited access" : "1 free/day, then 10 pts",
                                            color: Color(red: 0.4, green: 0.8, blue: 0.6),
                                            destination: AnyView(DailyPracticesListingPage()),
                                            accessStatus: accessControl.checkAccess(contentId: "daily_practice", contentType: .dailyPractice),
                                            pointsEarned: 10,
                                            pointsCost: isPremium ? nil : (accessControl.checkAccess(contentId: "daily_practice", contentType: .dailyPractice) == .free ? nil : 10),
                                            isPremium: isPremium
                                        )
                                        
                                        // Tarot Spread
                                        QuickActionRow(
                                            icon: "target",
                                            title: "Tarot Spread",
                                            subtitle: isPremium ? "All spreads unlocked" : "Some free, unlock others with points",
                                            color: Color(red: 0.7, green: 0.5, blue: 0.9),
                                            destination: AnyView(TarotSpreadsListingPage()),
                                            accessStatus: accessControl.checkAccess(contentId: "three-card", contentType: .tarotSpread),
                                            pointsEarned: 10,
                                            pointsCost: getPointsCost(from: accessControl.checkAccess(contentId: "three-card", contentType: .tarotSpread)),
                                            isPremium: isPremium
                                        )
                                        
                                        // Quiz
                                        QuickActionRow(
                                            icon: "questionmark.circle.fill",
                                            title: "Take Quiz",
                                            subtitle: isPremium ? "Unlimited quizzes" : "1 free/day, then 10 pts",
                                            color: Color(red: 1.0, green: 0.7, blue: 0.3),
                                            destination: AnyView(QuizPage()),
                                            accessStatus: accessControl.checkAccess(contentId: "daily_quiz", contentType: .quiz),
                                            pointsEarned: 10,
                                            pointsCost: isPremium ? nil : (accessControl.checkAccess(contentId: "daily_quiz", contentType: .quiz) == .free ? nil : 10),
                                            isPremium: isPremium
                                        )
                                        
                                        // Numerology
                                        QuickActionRow(
                                            icon: "sparkles",
                                            title: "Check Numerology",
                                            subtitle: isPremium ? "Full numerology insights" : "Basic free, unlock layers with points",
                                            color: DesignColors.accent,
                                            destination: AnyView(HomeView(selectedTab: .constant(.home))),
                                            accessStatus: accessControl.checkAccess(contentId: "basic_daily_number", contentType: .numerologyLayer),
                                            pointsEarned: 5,
                                            pointsCost: getPointsCost(from: accessControl.checkAccess(contentId: "basic_daily_number", contentType: .numerologyLayer)),
                                            isPremium: isPremium
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            
                            // Quick Actions - Use Points
                            BaseCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Use Points")
                                        .font(DesignTypography.headlineFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text("Unlock content and extend your access")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    VStack(spacing: 12) {
                                        // AI Chat Messages
                                        QuickActionRow(
                                            icon: "message.fill",
                                            title: "AI Chat Messages",
                                            subtitle: isPremium ? "Unlimited messages" : "3 free/day, then 20 pts each",
                                            color: DesignColors.accent,
                                            destination: AnyView(GuidanceView(selectedTab: .constant(.guidance))),
                                            accessStatus: accessControl.checkAccess(contentId: "ai_chat", contentType: .aiChat),
                                            pointsEarned: 0,
                                            pointsCost: isPremium ? nil : (accessControl.checkAccess(contentId: "ai_chat", contentType: .aiChat) == .free ? nil : 20),
                                            isPremium: isPremium
                                        )
                                        
                                        // Articles
                                        QuickActionRow(
                                            icon: "book.fill",
                                            title: "Unlock Articles",
                                            subtitle: isPremium ? "All articles unlocked" : "Preview free, 20 pts to unlock full",
                                            color: Color(red: 0.4, green: 0.6, blue: 1.0),
                                            destination: AnyView(DiscoveryView(selectedTab: .constant(.discovery))),
                                            accessStatus: accessControl.checkAccess(contentId: "article_1", contentType: .article),
                                            pointsEarned: 0,
                                            pointsCost: getPointsCost(from: accessControl.checkAccess(contentId: "article_1", contentType: .article)),
                                            isPremium: isPremium
                                        )
                                        
                                        // Unlock Spreads
                                        QuickActionRow(
                                            icon: "sparkles.rectangle.stack.fill",
                                            title: "Unlock Spreads",
                                            subtitle: isPremium ? "All spreads unlocked" : "40-150 pts to unlock permanently",
                                            color: Color(red: 0.7, green: 0.5, blue: 0.9),
                                            destination: AnyView(TarotSpreadsListingPage()),
                                            accessStatus: accessControl.checkAccess(contentId: "celtic-cross", contentType: .tarotSpread),
                                            pointsEarned: 0,
                                            pointsCost: getPointsCost(from: accessControl.checkAccess(contentId: "celtic-cross", contentType: .tarotSpread)),
                                            isPremium: isPremium
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 60)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadJourneySummary()
        }
    }
    
    private func loadJourneySummary() {
        journeySummary = journeyService.getJourneySummary()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func getPointsCost(from accessStatus: AccessStatus) -> Int? {
        switch accessStatus {
        case .unlockableWithPoints(let cost):
            return cost
        case .free, .unlocked:
            return nil
        case .premiumOnly:
            return nil
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(DesignTypography.subheadFont(weight: .semibold))
                .foregroundColor(DesignColors.foreground)
            
            Text(label)
                .font(DesignTypography.caption2Font())
                .foregroundColor(DesignColors.mutedForeground)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

struct ActivityRow: View {
    let activity: Activity
    
    private var iconName: String {
        switch activity.type {
        case "tarot": return "target"
        case "ritual": return "sparkles"
        case "reflection": return "book"
        case "insight": return "eye"
        default: return "clock"
        }
    }
    
    private var iconColor: Color {
        switch activity.type {
        case "tarot": return Color(red: 0.4, green: 0.8, blue: 0.6)
        case "ritual": return Color(red: 1.0, green: 0.7, blue: 0.3)
        case "reflection": return Color(red: 0.7, green: 0.5, blue: 0.9)
        case "insight": return Color(red: 0.4, green: 0.6, blue: 1.0)
        default: return DesignColors.mutedForeground
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 32, height: 32)
                
                Image(systemName: iconName)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground)
                
                Text(activity.timestamp)
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
        )
    }
}

struct SavedItemRow: View {
    let label: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                Text("\(count) saved")
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(DesignColors.mutedForeground)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
        )
    }
}

struct QuickActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let destination: AnyView
    let accessStatus: AccessStatus?
    let pointsEarned: Int?
    let pointsCost: Int?
    let isPremium: Bool
    
    init(
        icon: String,
        title: String,
        subtitle: String,
        color: Color,
        destination: AnyView,
        accessStatus: AccessStatus? = nil,
        pointsEarned: Int? = nil,
        pointsCost: Int? = nil,
        isPremium: Bool = false
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.color = color
        self.destination = destination
        self.accessStatus = accessStatus
        self.pointsEarned = pointsEarned
        self.pointsCost = pointsCost
        self.isPremium = isPremium
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                        
                        if let accessStatus = accessStatus {
                            AccessBadge(accessStatus: accessStatus)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(subtitle)
                            .font(DesignTypography.caption2Font())
                            .foregroundColor(DesignColors.mutedForeground)
                        
                        // Points information
                        HStack(spacing: 12) {
                            if let pointsEarned = pointsEarned, pointsEarned > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(DesignColors.accent)
                                    Text("+\(pointsEarned) pts")
                                        .font(DesignTypography.caption2Font(weight: .medium))
                                        .foregroundColor(DesignColors.accent)
                                }
                            }
                            
                            if let pointsCost = pointsCost, pointsCost > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(DesignColors.mutedForeground)
                                    Text("\(pointsCost) pts to unlock")
                                        .font(DesignTypography.caption2Font())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                            
                            if isPremium {
                                HStack(spacing: 4) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                                    Text("Unlimited")
                                        .font(DesignTypography.caption2Font(weight: .medium))
                                        .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(DesignColors.mutedForeground)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        JourneyPage()
    }
}

