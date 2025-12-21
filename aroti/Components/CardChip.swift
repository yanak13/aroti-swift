//
//  CardChip.swift
//  Aroti
//
//  Standardized chip component for cards (Daily Rituals, Tarot, Learning, etc.)
//  Follows strict design system: top-left placement, consistent sizing, semantic colors
//

import SwiftUI

enum CardChipType {
    case base        // Time, category, benefit - neutral styling
    case forYou      // Personalization - highlighted with accent color
}

struct CardChip: View {
    let text: String
    let type: CardChipType
    
    // Standardized dimensions (locked)
    private static let height: CGFloat = 28
    private static let horizontalPadding: CGFloat = 11
    private static let cornerRadius: CGFloat = height / 2 // Fully rounded (pill)
    
    var body: some View {
        Text(text)
            .font(DesignTypography.footnoteFont(weight: .medium)) // 1 size smaller than subtitle (15px), medium weight
            .foregroundColor(textColor)
            .padding(.horizontal, Self.horizontalPadding)
            .frame(height: Self.height)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
    
    private var backgroundColor: Color {
        switch type {
        case .base:
            // Subtle neutral dark gray background
            return Color.white.opacity(0.05)
        case .forYou:
            // Warm accent (gold) background
            return DesignColors.accent.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        switch type {
        case .base:
            // Muted white / light gray text
            return DesignColors.mutedForeground
        case .forYou:
            // Dark or near-black text for higher contrast
            return DesignColors.accent
        }
    }
}

