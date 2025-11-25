//
//  TarotCardView.swift
//  Aroti
//
//  Tarot card component with flip animation
//

import SwiftUI

struct TarotCardView: View {
    let card: TarotCard?
    let isFlipped: Bool
    let onFlip: () -> Void
    let canFlip: Bool
    
    @State private var rotation: Double = 0
    
    var body: some View {
        BaseCard {
            if let card = card, isFlipped {
                // Revealed card front
                VStack(spacing: 16) {
                    // Card image area - vertical/portrait orientation (larger size, 3:5 aspect ratio)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hue: 235/360, saturation: 0.30, brightness: 0.11),
                                        Color(hue: 240/360, saturation: 0.28, brightness: 0.13)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                            )
                        
                        // Decorative border patterns
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(DesignColors.accent.opacity(0.2), lineWidth: 1)
                            .padding(8)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(DesignColors.accent.opacity(0.1), lineWidth: 1)
                            .padding(12)
                        
                        // Card silhouette/icon
                        Image(systemName: "person.walking")
                            .font(.system(size: 60))
                            .foregroundColor(DesignColors.accent)
                            .shadow(color: DesignColors.accent.opacity(0.5), radius: 12, x: 0, y: 0)
                    }
                    .frame(width: 220, height: 367) // Larger size, maintaining 3:5 aspect ratio
                    .aspectRatio(3/5, contentMode: .fit)
                    
                    // Card title BELOW the image
                    Text(card.name)
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    
                    // Keyword chips
                    HStack(spacing: 8) {
                        ForEach(card.keywords, id: \.self) { keyword in
                            CategoryChip(label: keyword, isActive: true, action: {})
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
            } else {
                // Card back (pre-reveal)
                VStack(spacing: 16) {
                    Text("Your Tarot Card")
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Tap to reveal your card for today")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                    
                    if canFlip {
                        ArotiButton(
                            kind: .custom(.accentCard()),
                            title: "Reveal Card",
                            action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    onFlip()
                                }
                            }
                        )
                    } else {
                        Text("Card already revealed today")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }
}

