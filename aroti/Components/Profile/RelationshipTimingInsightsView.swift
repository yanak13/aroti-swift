//
//  RelationshipTimingInsightsView.swift
//  Aroti
//
//  Premium-only relationship timing insights component
//

import SwiftUI

struct RelationshipTimingInsightsView: View {
    let partnerName: String
    
    // Mock timing insights data - in real app, this would come from API
    private let timingInsights: [(title: String, date: String, description: String, icon: String)] = [
        (
            title: "Best Time for Important Conversations",
            date: "March 15-20, 2024",
            description: "Venus trine Mercury creates ideal conditions for open, heartfelt communication.",
            icon: "heart.fill"
        ),
        (
            title: "Relationship Milestone Timing",
            date: "April 8-12, 2024",
            description: "Jupiter enters your composite 7th house, perfect for deepening commitment.",
            icon: "calendar"
        ),
        (
            title: "Harmonious Activity Period",
            date: "May 1-7, 2024",
            description: "Both charts align with creative and playful energy—great for shared adventures.",
            icon: "clock.fill"
        )
    ]
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                // Premium Badge
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.accent)
                        Text("Premium Exclusive")
                            .font(DesignTypography.caption2Font(weight: .medium))
                            .foregroundColor(DesignColors.accent)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [DesignColors.accent.opacity(0.2), DesignColors.accent.opacity(0.1)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay(
                                Capsule()
                                    .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Relationship Timing Insights")
                        .font(DesignTypography.title3Font())
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Astrological timing recommendations for \(partnerName) and you")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                VStack(spacing: 12) {
                    ForEach(Array(timingInsights.enumerated()), id: \.offset) { index, insight in
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: insight.icon)
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.accent)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(DesignColors.accent.opacity(0.1))
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(insight.title)
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(insight.date)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.accent)
                                
                                Text(insight.description)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.02))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                )
                        )
                    }
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                Text("Timing insights are calculated based on both your natal charts and current planetary transits. Check back regularly for updated recommendations.")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                    .italic()
            }
        }
    }
}

