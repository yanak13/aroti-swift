//
//  SpreadCardCarousel.swift
//  Aroti
//

import SwiftUI

struct SpreadCardCarousel: View {
    var body: some View {
        DesignCard(title: "Card / Spread Card") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    spreadCard(title: "Celtic Cross", description: "A comprehensive 10-card spread", cardCount: 10, difficulty: "Intermediate", timeEstimate: "20 min")
                    spreadCard(title: "Three Card", description: "Past, present, future", cardCount: 3, difficulty: "Beginner", timeEstimate: "10 min")
                }
            }
        }
    }
    
    private func spreadCard(title: String, description: String, cardCount: Int, difficulty: String, timeEstimate: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(DesignTypography.headlineFont(weight: .semibold))
                .foregroundColor(DesignColors.foreground)
            Text(description)
                .font(DesignTypography.footnoteFont())
                .foregroundColor(DesignColors.mutedForeground)
            HStack(spacing: 8) {
                CategoryChip(label: "\(cardCount) cards", isActive: false, action: {})
                CategoryChip(label: difficulty, isActive: false, action: {})
                CategoryChip(label: timeEstimate, isActive: false, action: {})
            }
        }
        .padding()
        .frame(width: 280)
        .background(
            RoundedRectangle(cornerRadius: DesignRadius.main)
                .fill(DesignColors.glassPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignRadius.main)
                        .stroke(DesignColors.glassBorder, lineWidth: 1)
                )
        )
    }
}

