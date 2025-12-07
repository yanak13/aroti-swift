//
//  FannedDeckView.swift
//  Aroti
//
//  Subtle fanned deck view showing 6-7 card backs
//

import SwiftUI

struct FannedDeckView: View {
    let visibleCount: Int = 7
    let scaleEffect: CGFloat
    let opacity: Double
    let deckShift: Int // Number of cards already drawn (for shifting forward)
    
    init(scaleEffect: CGFloat = 1.0, opacity: Double = 1.0, deckShift: Int = 0) {
        self.scaleEffect = scaleEffect
        self.opacity = opacity
        self.deckShift = deckShift
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<visibleCount, id: \.self) { index in
                // Calculate position with deck shift (cards move forward)
                let adjustedIndex = index + deckShift
                
                // Subtle fan offsets
                let horizontalOffset = CGFloat(adjustedIndex) * 10 // Small horizontal: 8-12pt per card
                let verticalOffset = CGFloat(adjustedIndex) * 5   // Small vertical: 4-6pt per card
                
                // Very minimal rotation (1-2 degrees max)
                let rotation = Double(adjustedIndex) * 1.5 // Max ~10 degrees for last card
                
                // Card styling - match app's tarot card style
                ZStack {
                    // Card background with dark gradient
                    RoundedRectangle(cornerRadius: 12) // Match TarotCardBack
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
                                .stroke(Color.white.opacity(0.08), lineWidth: 1) // Match TarotCardBack
                        )
                        .shadow(
                            color: Color.black.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                    
                    // Decorative pattern (same as TarotCardBack)
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                            Spacer()
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                            Spacer()
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(12)
                }
                .frame(width: 200, height: 320) // Smaller, not covering screen
                .offset(
                    x: horizontalOffset,
                    y: verticalOffset
                )
                .rotationEffect(.degrees(rotation))
                .opacity((0.4 + 0.08 * Double(adjustedIndex)) * opacity) // Back cards more subtle
                .scaleEffect((0.98 + 0.003 * CGFloat(adjustedIndex)) * scaleEffect) // Front card slightly larger
                .shadow(
                    color: .black.opacity(0.4 + Double(adjustedIndex) * 0.02),
                    radius: 12 + CGFloat(adjustedIndex) * 0.5,
                    x: 0,
                    y: 8 + CGFloat(adjustedIndex) * 0.5
                )
            }
        }
        .frame(width: 220, height: 340) // Compact, not covering screen
    }
    
    // Helper to get the transform of the "top card" (front of fan)
    static func topCardInitialTransform(deckShift: Int = 0) -> (offset: CGSize, rotation: Double) {
        let index = 6 + deckShift // the front card in the fan
        let horizontalOffset = CGFloat(index) * 10
        let verticalOffset = CGFloat(index) * 5
        let rotation = Double(index) * 1.5
        
        return (CGSize(width: horizontalOffset, height: verticalOffset), rotation)
    }
}

#Preview {
    FannedDeckView()
        .padding()
        .background(CelestialBackground())
}
