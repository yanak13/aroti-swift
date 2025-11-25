//
//  HorizontalCardCarouselView.swift
//  Aroti
//

import SwiftUI

struct HorizontalCardCarouselView: View {
    private let cards: [(String, String, Int, String, String)] = [
        ("Celtic Cross", "A comprehensive 10-card spread", 10, "Intermediate", "20 min"),
        ("Three Card", "Past, present, future", 3, "Beginner", "10 min"),
        ("Daily Guidance", "Quick daily insight", 1, "Beginner", "5 min")
    ]
    
    var body: some View {
        DesignCard(title: "Horizontal Card Carousel") {
            VStack(alignment: .leading, spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(cards, id: \.0) { card in
                            carouselCard(title: card.0, description: card.1, cardCount: card.2, difficulty: card.3, timeEstimate: card.4)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                
                Text("Horizontally scrollable container used in Discovery")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
    
    private func carouselCard(title: String, description: String, cardCount: Int, difficulty: String, timeEstimate: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            let colors = difficultyColors(for: difficulty)
            HStack(spacing: 6) {
                Badge(
                    text: difficulty,
                    backgroundColor: colors.background,
                    textColor: colors.text,
                    borderColor: colors.border,
                    fontSize: DesignTypography.caption2Font()
                )
                Badge(
                    text: "\(cardCount) \(cardCount == 1 ? "Card" : "Cards")",
                    backgroundColor: ArotiColor.overlayScrim,
                    textColor: ArotiColor.accentText,
                    borderColor: ArotiColor.pureWhite.opacity(0.1),
                    fontSize: DesignTypography.caption2Font()
                )
            }
            
            Text(title)
                .font(DesignTypography.headlineFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
                .lineLimit(1)
            
            Text(description)
                .font(DesignTypography.footnoteFont())
                .foregroundColor(DesignColors.mutedForeground)
                .lineLimit(2)
            
            Text(timeEstimate)
                .font(DesignTypography.footnoteFont())
                .foregroundColor(DesignColors.mutedForeground)
                .padding(.top, 2)
        }
        .padding(12)
        .frame(width: 200, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignRadius.card)
                .fill(DesignColors.card)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignRadius.card)
                        .stroke(DesignColors.border.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func difficultyColors(for difficulty: String) -> (background: Color, text: Color, border: Color) {
        switch difficulty {
        case "Beginner":
            return (ArotiColor.success, ArotiColor.successText, ArotiColor.successBorder)
        case "Intermediate":
            return (ArotiColor.warning, ArotiColor.warningText, ArotiColor.warningBorder)
        default:
            return (ArotiColor.danger, ArotiColor.dangerText, ArotiColor.dangerBorder)
        }
    }
}

