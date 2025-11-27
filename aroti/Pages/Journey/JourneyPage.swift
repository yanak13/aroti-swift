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
    
    private let progress: CGFloat = 0.5 // 7 out of 14 days
    private let streakValue: Int = 7
    private let readings: Int = 24
    private let reflections: Int = 12
    private let rituals: Int = 8
    
    private let activities: [Activity] = [
        Activity(id: "1", type: "tarot", title: "Tarot card pulled", timestamp: "2 hours ago"),
        Activity(id: "2", type: "ritual", title: "Ritual completed", timestamp: "Yesterday"),
        Activity(id: "3", type: "reflection", title: "Reflection added", timestamp: "2 days ago"),
        Activity(id: "4", type: "insight", title: "AI insight viewed", timestamp: "3 days ago")
    ]
    
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
                        VStack(spacing: 24) {
                            BaseCard {
                                VStack(spacing: 24) {
                                    // Streak Section
                                    VStack(spacing: 8) {
                                        HStack(spacing: 8) {
                                            Text("✨")
                                                .font(.system(size: 32))
                                            Text("\(streakValue)-day streak")
                                                .font(DesignTypography.title3Font(weight: .semibold))
                                                .foregroundColor(DesignColors.foreground)
                                        }
                                        
                                        Text("You've shown up every day. Keep going.")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    
                                    // Milestone Tracker
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Next milestone: 14 days")
                                            .font(DesignTypography.caption2Font(weight: .medium))
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .textCase(.uppercase)
                                        
                                        GeometryReader { proxy in
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(Color.white.opacity(0.08))
                                                    .frame(height: 4)
                                                
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [DesignColors.accent, DesignColors.accent.opacity(0.6)],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                    .frame(width: max(proxy.size.width * progress, 0), height: 4)
                                            }
                                        }
                                        .frame(height: 4)
                                    }
                                    
                                    // Stats Cards
                                    HStack(spacing: 12) {
                                        StatCard(
                                            value: "\(readings)",
                                            label: "Readings",
                                            icon: "target",
                                            color: Color(red: 0.4, green: 0.8, blue: 0.6)
                                        )
                                        
                                        StatCard(
                                            value: "\(reflections)",
                                            label: "Reflections",
                                            icon: "sparkles",
                                            color: Color(red: 0.7, green: 0.5, blue: 0.9)
                                        )
                                        
                                        StatCard(
                                            value: "\(rituals)",
                                            label: "Rituals",
                                            icon: "book",
                                            color: Color(red: 1.0, green: 0.7, blue: 0.3)
                                        )
                                    }
                                    
                                    // Activity Timeline
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Recent Activity")
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        VStack(spacing: 8) {
                                            ForEach(activities) { activity in
                                                ActivityRow(activity: activity)
                                            }
                                        }
                                    }
                                    
                                    // Saved Items
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Saved Items")
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        VStack(spacing: 8) {
                                            SavedItemRow(
                                                label: "Saved Affirmations",
                                                count: 3,
                                                icon: "sparkles",
                                                color: Color(red: 0.7, green: 0.5, blue: 0.9)
                                            )
                                            
                                            SavedItemRow(
                                                label: "Saved Spread Cards",
                                                count: 5,
                                                icon: "book",
                                                color: Color(red: 1.0, green: 0.7, blue: 0.3)
                                            )
                                            
                                            SavedItemRow(
                                                label: "Saved Reflections",
                                                count: 8,
                                                icon: "heart.fill",
                                                color: Color(red: 1.0, green: 0.4, blue: 0.5)
                                            )
                                        }
                                    }
                                    
                                    // Footer Text
                                    Text("Your journey is unfolding beautifully.")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .frame(maxWidth: .infinity)
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

#Preview {
    NavigationStack {
        JourneyPage()
    }
}

