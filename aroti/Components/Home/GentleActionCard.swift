//
//  GentleActionCard.swift
//  Aroti
//
//  Gentle action card with Reflection and Ritual
//

import SwiftUI

struct GentleActionCard: View {
    let ritual: Ritual
    let isRevealed: Bool
    let onReflectionTap: () -> Void
    let onRitualTap: () -> Void
    
    @State private var currentTab: Int = 0
    
    var body: some View {
        BaseCard {
            if isRevealed {
                // Revealed state with swipeable tabs
                VStack(spacing: 16) {
                    TabView(selection: $currentTab) {
                        // Reflection Tab
                        VStack(alignment: .leading, spacing: 16) {
                            Text("A few thoughts you may want to remember from today.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Button(action: {
                                HapticFeedback.impactOccurred(.medium)
                                onReflectionTap()
                            }) {
                                Text("Add reflection")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                            .fill(DesignColors.accent)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tag(0)
                        
                        // Ritual Tab
                        VStack(alignment: .leading, spacing: 16) {
                            Text("A short grounding practice to support today's energy.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Button(action: {
                                HapticFeedback.impactOccurred(.medium)
                                onRitualTap()
                            }) {
                                Text("Begin practice")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                            .fill(DesignColors.accent)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 160)
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
            } else {
                // Packed state
                VStack(spacing: 8) {
                    Text("A moment for yourself")
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Swipe to choose how to engage")
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
        GentleActionCard(
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
            isRevealed: false,
            onReflectionTap: {},
            onRitualTap: {}
        )
        
        GentleActionCard(
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
            isRevealed: true,
            onReflectionTap: {},
            onRitualTap: {}
        )
    }
    .padding()
    .background(CelestialBackground())
}

