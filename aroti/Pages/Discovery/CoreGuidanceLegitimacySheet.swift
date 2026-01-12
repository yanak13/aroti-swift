//
//  CoreGuidanceLegitimacySheet.swift
//  Aroti
//
//  Sheet showing how Core Guidance cards are calculated
//

import SwiftUI

struct CoreGuidanceLegitimacySheet: View {
    @Environment(\.dismiss) var dismiss
    let cardType: CoreGuidanceCardType
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How This Insight Is Calculated")
                                .font(DesignTypography.title2Font(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(cardType.title)
                                .font(DesignTypography.headlineFont(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                        }
                        .padding(.top, 8)
                        
                        // Calculation details
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(getCalculationDetails(), id: \.title) { detail in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(detail.title)
                                        .font(DesignTypography.subheadFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(detail.description)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineSpacing(4)
                                }
                            }
                        }
                        
                        // Trust line
                        VStack(alignment: .leading, spacing: 12) {
                            Divider()
                                .background(Color.white.opacity(0.1))
                            
                            Text("This insight is generated using your birth data, current planetary movements, and recurring personal themes. It's designed for reflection, not prediction.")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineSpacing(4)
                        }
                        .padding(.top, 8)
                    }
                    .padding(DesignSpacing.sm)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("About This Insight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.accent)
                }
            }
        }
    }
    
    private func getCalculationDetails() -> [(title: String, description: String)] {
        switch cardType {
        case .rightNow:
            return [
                (
                    title: "Current Moon Phase",
                    description: "The Moon's current phase influences emotional climate and immediate awareness."
                ),
                (
                    title: "Moon Sign Relative to Your Chart",
                    description: "How the Moon's current sign interacts with your natal Sun and Moon placements."
                ),
                (
                    title: "Dominant Daily Transits",
                    description: "Active planetary aspects affecting your chart in the present moment."
                )
            ]
        case .thisPeriod:
            return [
                (
                    title: "Major Planetary Transits",
                    description: "Significant planetary movements active over the next 7-14 days that influence longer-term themes."
                ),
                (
                    title: "Current Lunar Cycle Phase",
                    description: "Where you are in the current lunar cycle, which sets the emotional tone for the period."
                )
            ]
        case .whereToFocus:
            return [
                (
                    title: "Natal House Activation",
                    description: "Which areas of your birth chart are currently being activated by planetary transits."
                ),
                (
                    title: "Mercury & Venus Aspects",
                    description: "How communication (Mercury) and relationships/values (Venus) are being influenced right now."
                )
            ]
        case .whatsComingUp:
            return [
                (
                    title: "Upcoming Lunar Aspects",
                    description: "Lunar aspects forming in the next 3-7 days that will create emotional windows."
                ),
                (
                    title: "Near-Term Planetary Shifts",
                    description: "Planetary movements and aspect changes approaching in the coming days."
                )
            ]
        case .personalInsight:
            return [
                (
                    title: "Natal Chart Dominant Patterns",
                    description: "Recurring themes and patterns in your birth chart that consistently influence your experience."
                ),
                (
                    title: "Repeated Themes Across Forecasts",
                    description: "Patterns that have appeared in previous guidance, indicating ongoing personal themes."
                ),
                (
                    title: "User Interaction Patterns",
                    description: "How you engage with guidance over time, revealing personal tendencies and preferences."
                )
            ]
        }
    }
}

#Preview {
    CoreGuidanceLegitimacySheet(cardType: .rightNow)
}

