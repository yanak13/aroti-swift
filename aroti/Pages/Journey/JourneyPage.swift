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
                            // 1. Hero Section
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
                                                .font(DesignTypography.title3Font(weight: .semibold))
                                                .foregroundColor(DesignColors.mutedForeground)
                                            Text("Lifetime Points")
                                                .font(DesignTypography.caption2Font())
                                                .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                        }
                                    }
                                    
                                    // Progress to Next Level
                                    VStack(alignment: .leading, spacing: 8) {
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
                                    
                                    // Streak & Points Today
                                    HStack(spacing: 16) {
                                        HStack(spacing: 4) {
                                            Text("✨")
                                            Text("\(summary.today.streakDays) days")
                                                .font(DesignTypography.bodyFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("Points earned today: \(summary.today.points)")
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            
                            // 2. How Points Work - Two Micro-Cards
                            HStack(spacing: 12) {
                                // Earn Points Card
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Earn Points")
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Text("Complete activities to earn points.")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "leaf.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignColors.accent)
                                                Text("Daily Practice")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                Spacer()
                                                Text("+10 pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.accent)
                                            }
                                            
                                            HStack(spacing: 8) {
                                                Image(systemName: "target")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignColors.accent)
                                                Text("Tarot Spread")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                Spacer()
                                                Text("+10 pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.accent)
                                            }
                                            
                                            HStack(spacing: 8) {
                                                Image(systemName: "questionmark.circle.fill")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignColors.accent)
                                                Text("Quiz")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                Spacer()
                                                Text("+10 pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.accent)
                                            }
                                            
                                            HStack(spacing: 8) {
                                                Image(systemName: "sparkles")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignColors.accent)
                                                Text("Numerology")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                Spacer()
                                                Text("+5 pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.accent)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        NavigationLink(destination: DiscoveryView(selectedTab: .constant(.discovery))) {
                                            Text("View Activities")
                                                .font(DesignTypography.footnoteFont(weight: .medium))
                                                .foregroundColor(DesignColors.accent)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(DesignColors.accent.opacity(0.1))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                                        )
                                                )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Spend Points Card
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Spend Points")
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Text("Use points to unlock content and extend your access.")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text("Extra Chat Messages")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                Spacer()
                                                Text("20 pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            HStack {
                                                Text("Unlock Spreads")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                Spacer()
                                                Text("40–150 pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            HStack {
                                                Text("Unlock Articles")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                Spacer()
                                                Text("20 pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                            
                                            HStack {
                                                Text("Unlock Numerology Layers")
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                Spacer()
                                                Text("30 pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        NavigationLink(destination: DiscoveryView(selectedTab: .constant(.discovery))) {
                                            Text("View Unlocks")
                                                .font(DesignTypography.footnoteFont(weight: .medium))
                                                .foregroundColor(DesignColors.accent)
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(DesignColors.accent.opacity(0.1))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                                        )
                                                )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            
                            // 3. Recent Activity
                            BaseCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Recent Activity")
                                        .font(DesignTypography.headlineFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    VStack(alignment: .leading, spacing: 12) {
                                        let activities = getRecentActivities().prefix(5)
                                        ForEach(Array(activities), id: \.id) { activity in
                                            HStack {
                                                Text(activity.title)
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                                
                                                Spacer()
                                                
                                                Text("→ +\(activity.points) pts")
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.accent)
                                            }
                                        }
                                        
                                        if activities.isEmpty {
                                            Text("No activity yet today")
                                                .font(DesignTypography.bodyFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
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
    
    private func getRecentActivities() -> [ActivityItem] {
        let history = journeyService.getActivityHistory()
        let today = Date()
        let calendar = Calendar.current
        
        return history
            .filter { entry in
                if let date = entry["date"] as? Date {
                    return calendar.isDate(date, inSameDayAs: today)
                }
                return false
            }
            .compactMap { entry -> ActivityItem? in
                guard let type = entry["type"] as? String,
                      let points = entry["points"] as? Int else {
                    return nil
                }
                
                let title: String
                switch type {
                case "practice":
                    title = "Daily Practice completed"
                case "spread":
                    title = "Tarot Spread completed"
                case "quiz":
                    title = "Quiz completed"
                case "numerology":
                    title = "Numerology checked"
                default:
                    title = "Activity completed"
                }
                
                return ActivityItem(id: UUID().uuidString, title: title, points: points)
            }
            .reversed()
            .prefix(5)
            .map { $0 }
    }
    
}

struct ActivityItem: Identifiable {
    let id: String
    let title: String
    let points: Int
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

