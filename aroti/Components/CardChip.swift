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
    case premium     // Premium access - accent gold/orange background, dark text
    case free        // Free access - neutral dark background, muted light text
    case new         // New content - accent highlight background, dark text
}

struct CardChip: View {
    let text: String
    let type: CardChipType
    
    // Standardized dimensions (locked)
    private static let height: CGFloat = 24 // Reduced from 28 to match spec (22-24px)
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
            // Soft accent/muted background
            return DesignColors.accent.opacity(0.2)
        case .premium:
            // Accent gold/orange background
            return DesignColors.accent
        case .free:
            // Neutral dark background
            return Color.white.opacity(0.05)
        case .new:
            // Accent highlight background
            return DesignColors.accent.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        switch type {
        case .base:
            // Muted white / light gray text
            return DesignColors.mutedForeground
        case .forYou:
            // Light text for soft accent background
            return DesignColors.accent
        case .premium:
            // Dark text for accent background
            return Color.black.opacity(0.8)
        case .free:
            // Muted light text
            return DesignColors.mutedForeground
        case .new:
            // Dark text for accent highlight
            return Color.black.opacity(0.8)
        }
    }
}

