//
//  AnimatedDeckCard.swift
//  Aroti
//
//  Animated deck card component with fanned deck and active card
//

import SwiftUI

struct AnimatedDeckCard: View {
    let showActiveCard: Bool
    let activeCardOffset: CGSize
    let activeCardRotation: Double
    let activeCardScale: CGFloat
    let activeCardOpacity: Double
    let deckScale: CGFloat
    let deckOpacity: Double
    let deckShift: Int
    let onTap: () -> Void
    
    @State private var initialAppear: Bool = false
    
    init(
        showActiveCard: Bool,
        activeCardOffset: CGSize,
        activeCardRotation: Double,
        activeCardScale: CGFloat,
        activeCardOpacity: Double,
        deckScale: CGFloat,
        deckOpacity: Double,
        deckShift: Int,
        onTap: @escaping () -> Void
    ) {
        self.showActiveCard = showActiveCard
        self.activeCardOffset = activeCardOffset
        self.activeCardRotation = activeCardRotation
        self.activeCardScale = activeCardScale
        self.activeCardOpacity = activeCardOpacity
        self.deckScale = deckScale
        self.deckOpacity = deckOpacity
        self.deckShift = deckShift
        self.onTap = onTap
    }
    
    var body: some View {
        ZStack {
            // Deck stack - always visible
            FannedDeckView(scaleEffect: deckScale, opacity: deckOpacity, deckShift: deckShift)
            
            // Active card overlay - only visible when drawing
            if showActiveCard {
                // Use TarotCardBack for consistency
                TarotCardBack()
                    .frame(width: 200, height: 320) // Match deck card size
                    .rotationEffect(.degrees(activeCardRotation))
                    .offset(activeCardOffset)
                    .scaleEffect(activeCardScale)
                    .opacity(activeCardOpacity)
                    .shadow(
                        color: .black.opacity(0.5),
                        radius: 16,
                        x: 0,
                        y: 8
                    )
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .frame(width: 220, height: 340) // Compact, matches deck
        .onTapGesture {
            onTap()
        }
        .scaleEffect(initialAppear ? 1.0 : 0.9)
        .opacity(initialAppear ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.45)) {
                initialAppear = true
            }
        }
    }
}

#Preview {
    AnimatedDeckCard(
        showActiveCard: false,
        activeCardOffset: .zero,
        activeCardRotation: 0,
        activeCardScale: 1.0,
        activeCardOpacity: 1.0,
        deckScale: 1.0,
        deckOpacity: 1.0,
        deckShift: 0
    ) {
        print("Tapped")
    }
    .padding()
    .background(CelestialBackground())
}
