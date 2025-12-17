//
//  SwipeableCardsContainer.swift
//  Aroti
//
//  Container for Secondary Insight and Gentle Action cards
//

import SwiftUI

struct SwipeableCardsContainer: View {
    let horoscope: String
    let numerology: NumerologyInsight
    let ritual: Ritual
    let secondaryInsightRevealed: Bool
    let gentleActionRevealed: Bool
    let onHoroscopeTap: () -> Void
    let onNumerologyTap: () -> Void
    let onReflectionTap: () -> Void
    let onRitualTap: () -> Void
    let onSecondaryInsightReveal: () -> Void
    let onGentleActionReveal: () -> Void
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        TabView(selection: $currentIndex) {
            // Card 2: Secondary Insight
            SecondaryInsightCard(
                horoscope: horoscope,
                numerology: numerology,
                isRevealed: secondaryInsightRevealed,
                onHoroscopeTap: onHoroscopeTap,
                onNumerologyTap: onNumerologyTap
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if !secondaryInsightRevealed {
                    onSecondaryInsightReveal()
                }
            }
            .tag(0)
            
            // Card 3: Gentle Action
            GentleActionCard(
                ritual: ritual,
                isRevealed: gentleActionRevealed,
                onReflectionTap: onReflectionTap,
                onRitualTap: onRitualTap
            )
            .contentShape(Rectangle())
            .onTapGesture {
                if !gentleActionRevealed {
                    onGentleActionReveal()
                }
            }
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(minHeight: estimateHeight())
        .onChange(of: currentIndex) { _, _ in
            HapticFeedback.impactOccurred(.light)
        }
        
        // Page indicator dots
        HStack(spacing: 8) {
            ForEach(0..<2, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? DesignColors.accent : DesignColors.accent.opacity(0.3))
                    .frame(width: index == currentIndex ? 8 : 6, height: index == currentIndex ? 8 : 6)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentIndex)
            }
        }
        .padding(.top, 8)
    }
    
    private func estimateHeight() -> CGFloat {
        // Estimate height based on revealed state
        if secondaryInsightRevealed || gentleActionRevealed {
            return 220 // Revealed state is taller
        } else {
            return 120 // Packed state is shorter
        }
    }
}

#Preview {
    SwipeableCardsContainer(
        horoscope: "With the Moon emphasizing intuition, emotional awareness may feel stronger than usual today.",
        numerology: NumerologyInsight(number: 7, preview: "Spiritual focus and introspection"),
        ritual: Ritual(
            id: "1",
            title: "Grounding Breath",
            description: "A simple breathing practice",
            duration: "3 min",
            type: "Grounding",
            intention: nil,
            steps: nil,
            affirmation: nil,
            benefits: nil
        ),
        secondaryInsightRevealed: false,
        gentleActionRevealed: false,
        onHoroscopeTap: {},
        onNumerologyTap: {},
        onReflectionTap: {},
        onRitualTap: {},
        onSecondaryInsightReveal: {},
        onGentleActionReveal: {}
    )
    .padding()
    .background(CelestialBackground())
}

