//
//  DeckStackView.swift
//  Aroti
//
//  Natural fanned/stacked deck view showing multiple card backs
//

import SwiftUI

struct DeckStackView: View {
    let scaleEffect: CGFloat
    let opacity: Double
    
    init(scaleEffect: CGFloat = 1.0, opacity: Double = 1.0) {
        self.scaleEffect = scaleEffect
        self.opacity = opacity
    }
    
    // Show 10 cards in a natural fanned/stacked arrangement
    private let cardCount = 10
    
    var body: some View {
        ZStack {
            ForEach(0..<cardCount, id: \.self) { index in
                TarotCardBack()
                    .frame(width: 220, height: 367)
                    .aspectRatio(3/5, contentMode: .fit)
                    .offset(
                        x: calculateOffsetX(for: index),
                        y: calculateOffsetY(for: index)
                    )
                    .rotationEffect(.degrees(calculateRotation(for: index)))
                    .opacity(calculateOpacity(for: index) * opacity)
                    .scaleEffect(calculateScale(for: index) * scaleEffect)
                    .shadow(
                        color: Color.black.opacity(0.2 + Double(index) * 0.03),
                        radius: 4 + CGFloat(index) * 0.5,
                        x: CGFloat(index) * 1.5,
                        y: CGFloat(index) * 1.5
                    )
            }
        }
        .frame(width: 220, height: 367)
        .aspectRatio(3/5, contentMode: .fit)
    }
    
    private func calculateOffsetX(for index: Int) -> CGFloat {
        // Natural fanned stack: cards offset to the left with slight variations
        let baseOffset = CGFloat(index) * -3.5
        // Add slight deterministic variation for organic feel
        let variation = sin(Double(index) * 0.7) * 1.2
        return baseOffset + CGFloat(variation)
    }
    
    private func calculateOffsetY(for index: Int) -> CGFloat {
        // Cards stack downward with slight variations
        let baseOffset = CGFloat(index) * 3.5
        let variation = cos(Double(index) * 0.5) * 0.8
        return baseOffset + CGFloat(variation)
    }
    
    private func calculateRotation(for index: Int) -> Double {
        // Slight rotation variations for organic feel
        let baseRotation = Double(index) * 0.5
        let variation = sin(Double(index) * 0.9) * 1.2
        return baseRotation + variation
    }
    
    private func calculateOpacity(for index: Int) -> Double {
        // Top cards: full opacity, bottom cards: more reduced
        if index < 3 {
            return 1.0 - Double(index) * 0.05
        } else if index < 6 {
            return 0.85 - Double(index - 3) * 0.05
        } else {
            return 0.7 - Double(index - 6) * 0.05
        }
    }
    
    private func calculateScale(for index: Int) -> CGFloat {
        // Top cards: full scale, bottom cards: slightly reduced
        if index < 3 {
            return 1.0 - CGFloat(index) * 0.005
        } else if index < 6 {
            return 0.985 - CGFloat(index - 3) * 0.005
        } else {
            return 0.97 - CGFloat(index - 6) * 0.005
        }
    }
}

#Preview {
    DeckStackView()
        .padding()
        .background(CelestialBackground())
}

