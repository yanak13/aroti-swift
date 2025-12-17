//
//  SecondaryInsightCard.swift
//  Aroti
//
//  Secondary insight card with Horoscope and Numerology
//

import SwiftUI

struct SecondaryInsightCard: View {
    let horoscope: String
    let numerology: NumerologyInsight
    let isRevealed: Bool
    let onHoroscopeTap: () -> Void
    let onNumerologyTap: () -> Void
    
    @State private var currentTab: Int = 0
    
    var body: some View {
        BaseCard {
            if isRevealed {
                // Revealed state with swipeable tabs
                VStack(spacing: 16) {
                    TabView(selection: $currentTab) {
                        // Horoscope Tab
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Horoscope")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(horoscope)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tag(0)
                        
                        // Numerology Tab
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Numerology")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(numerology.preview)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 120)
                    .onChange(of: currentTab) { _, _ in
                        HapticFeedback.impactOccurred(.light)
                    }
                    
                    // Page indicator dots
                    HStack(spacing: 8) {
                        ForEach(0..<2, id: \.self) { index in
                            Circle()
                                .fill(index == currentTab ? DesignColors.accent : DesignColors.accent.opacity(0.3))
                                .frame(width: index == currentTab ? 8 : 6, height: index == currentTab ? 8 : 6)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentTab)
                        }
                    }
                    .padding(.top, 4)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if currentTab == 0 {
                        onHoroscopeTap()
                    } else {
                        onNumerologyTap()
                    }
                }
            } else {
                // Packed state
                VStack(spacing: 8) {
                    Text("Daily Context")
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Tap to explore today's influence")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        SecondaryInsightCard(
            horoscope: "With the Moon emphasizing intuition, emotional awareness may feel stronger than usual today.",
            numerology: NumerologyInsight(number: 7, preview: "Spiritual focus and introspection"),
            isRevealed: false,
            onHoroscopeTap: {},
            onNumerologyTap: {}
        )
        
        SecondaryInsightCard(
            horoscope: "With the Moon emphasizing intuition, emotional awareness may feel stronger than usual today.",
            numerology: NumerologyInsight(number: 7, preview: "Spiritual focus and introspection"),
            isRevealed: true,
            onHoroscopeTap: {},
            onNumerologyTap: {}
        )
    }
    .padding()
    .background(CelestialBackground())
}

