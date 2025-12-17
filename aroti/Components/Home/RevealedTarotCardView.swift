//
//  RevealedTarotCardView.swift
//  Aroti
//
//  Revealed tarot card display after selection
//

import SwiftUI

struct RevealedTarotCardView: View {
    let card: TarotCard
    let onOpenFullInsight: () -> Void
    
    var body: some View {
        BaseCard {
            VStack(spacing: 20) {
                // Subtle label
                Text("Today's guidance")
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(DesignColors.mutedForeground)
                    .textCase(.uppercase)
                    .tracking(1)
                
                // Card message (headline)
                Text(generateHeadline())
                    .font(DesignTypography.title2Font(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                // Personal interpretation
                Text(generateInterpretation())
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                
                // Soft CTA
                Button(action: {
                    HapticFeedback.impactOccurred(.medium)
                    onOpenFullInsight()
                }) {
                    Text("Open full insight")
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(DesignColors.accent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                .fill(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                        .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.vertical, 8)
        }
    }
    
    private func generateHeadline() -> String {
        // Extract or generate headline from card interpretation
        if let interpretation = card.interpretation {
            // Try to extract first sentence or create a headline
            let sentences = interpretation.components(separatedBy: ". ")
            if let firstSentence = sentences.first {
                // If first sentence is short enough, use it
                if firstSentence.count < 60 {
                    return firstSentence
                } else {
                    // Otherwise, create a headline from card name
                    return "A moment of \(card.name.lowercased()) is unfolding."
                }
            }
        }
        
        // Fallback: generate from card name
        return "A moment of \(card.name.lowercased()) is unfolding."
    }
    
    private func generateInterpretation() -> String {
        // Use card interpretation if available
        if let interpretation = card.interpretation {
            return interpretation
        }
        
        // Fallback: generate from keywords
        let keywordText = card.keywords.joined(separator: ", ").lowercased()
        return "This card invites you to approach the day with \(keywordText). You may feel called to trust your instincts and allow something new to emerge naturally."
    }
}

#Preview {
    RevealedTarotCardView(
        card: TarotCard(
            id: "fool",
            name: "The Fool",
            keywords: ["New beginnings", "Innocence", "Adventure"],
            interpretation: "A new beginning, innocence, spontaneity, and a free spirit. Embrace new opportunities with an open heart.",
            guidance: ["Trust your instincts", "Take a leap of faith", "Embrace the unknown"],
            imageName: nil
        ),
        onOpenFullInsight: {
            print("Open full insight")
        }
    )
    .padding()
    .background(CelestialBackground())
}

