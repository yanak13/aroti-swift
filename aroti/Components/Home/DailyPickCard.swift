//
//  DailyPickCard.swift
//  Aroti
//
//  Reusable card style for Daily Picks on Home, matching the existing
//  Horoscope / Today's Context card layout.
//

import SwiftUI

struct DailyPickCard<Badge: View>: View {
    let title: String
    let subtitle: String
    let badge: Badge
    let isLocked: Bool
    let showsChevron: Bool
    
    init(
        title: String,
        subtitle: String,
        isLocked: Bool = false,
        showsChevron: Bool = true,
        @ViewBuilder badge: () -> Badge
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isLocked = isLocked
        self.showsChevron = showsChevron
        self.badge = badge()
    }
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Top row: badge in top right and optional lock
                HStack(spacing: 8) {
                    Spacer()
                    
                    badge
                    
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 14))
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                    }
                }
                
                Spacer()
                
                // Title, Description, and subtle affordance
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(2)
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineLimit(2)
                        .padding(.top, 4)
                    
                    if showsChevron {
                        HStack {
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(DesignColors.mutedForeground.opacity(0.5))
                        }
                    }
                }
            }
            .frame(height: 200, alignment: .topLeading)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        DailyPickCard(
            title: "Horoscope",
            subtitle: "Intuitive nature heightened today. Spiritual practices recommended."
        ) {
            Text("♓")
                .font(.system(size: 32))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(DesignColors.accent.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                        )
                )
        }
        
        DailyPickCard(
            title: "Numerology",
            subtitle: "Cooperation and harmony",
            isLocked: false
        ) {
            Text("2")
                .font(.system(size: 28, weight: .bold))
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
        
        DailyPickCard(
            title: "Affirmation",
            subtitle: "I am grounded, centered, and at peace.",
            isLocked: false
        ) {
            Image(systemName: "quote.bubble")
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(DesignColors.accent.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                        )
                )
        }
    }
    .padding()
    .background(CelestialBackground())
}


