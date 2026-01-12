//
//  CoreGuidanceCard.swift
//  Aroti
//
//  Core Guidance card component matching Monthly Horoscope style
//

import SwiftUI

struct CoreGuidanceCardView: View {
    let card: CoreGuidanceCard
    let hasNewContent: Bool
    let isPremium: Bool
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Top row: "New" chip (if applicable) and title
                HStack {
                    Spacer()
                    
                    if hasNewContent {
                        CardChip(text: "New", type: .forYou)
                    }
                }
                
                Spacer()
                
                // Title and Preview - matching Monthly Horoscope layout
                VStack(alignment: .leading, spacing: 8) {
                    Text(card.type.title)
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(2)
                    
                    Text(card.preview)
                        .font(.system(size: 14))
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineLimit(3)
                        .lineSpacing(4)
                        .padding(.top, 4)
                }
                
                // CTA at bottom - aligned with other sections
                VStack(alignment: .leading, spacing: 4) {
                    Text("Open your guidance")
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(isPremium ? DesignColors.foreground : DesignColors.accent)
                    
                    if !isPremium {
                        Text("A personal snapshot of what matters right now")
                            .font(DesignTypography.caption1Font())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: 250) // Increased from 200, maintaining 1.6:1 ratio
        }
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 4) // Slightly elevated
    }
}

