//
//  RevealCardView.swift
//  Aroti
//
//  Card that slides out, flips, and fades during draw
//

import SwiftUI

struct RevealCardView: View {
    let card: TarotCard
    let offset: CGSize
    let rotation: Double
    let flipAngle: Double
    let opacity: Double
    
    var body: some View {
        ZStack {
            if flipAngle < 90 {
                // Show back (before 90 degrees)
                TarotCardBack()
            } else {
                // Show front (after 90 degrees)
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
                    
                    // Card content - counter-rotate to keep text readable when card is flipped
                    VStack(spacing: 12) {
                        // Card icon/silhouette
                        Image(systemName: "sparkles")
                            .font(.system(size: 50))
                            .foregroundColor(DesignColors.accent)
                            .shadow(color: DesignColors.accent.opacity(0.5), radius: 12, x: 0, y: 0)
                        
                        // Card name
                        Text(card.name)
                            .font(DesignTypography.headlineFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .rotation3DEffect(
                        .degrees(-flipAngle),
                        axis: (x: 0, y: 1, z: 0)
                    )
                }
            }
        }
        .frame(width: 200, height: 320)
        .rotation3DEffect(
            .degrees(flipAngle),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .rotationEffect(.degrees(rotation))
        .offset(offset)
        .opacity(opacity)
        .shadow(
            color: .black.opacity(0.6),
            radius: 20,
            x: 0,
            y: 10
        )
    }
}

#Preview {
    RevealCardView(
        card: TarotCard(
            id: "test",
            name: "The Fool",
            keywords: [],
            interpretation: nil,
            guidance: nil,
            imageName: nil
        ),
        offset: .zero,
        rotation: 0,
        flipAngle: 0,
        opacity: 1.0
    )
    .padding()
    .background(CelestialBackground())
}

