//
//  InsightCard.swift
//  Aroti
//
//  Premium share-ready card component for Daily Pick detail pages
//  Designed as 9:16 object - Story-ready by default
//

import SwiftUI

struct InsightCard: View {
    let systemIcon: AnyView
    let identityChip: String
    let insightTitle: String
    let insightSentence: String
    let interpretation: String
    let chipColor: Color
    
    init(
        systemIcon: AnyView,
        identityChip: String,
        insightTitle: String = "Today's Insight",
        insightSentence: String,
        interpretation: String,
        chipColor: Color = DesignColors.accent
    ) {
        self.systemIcon = systemIcon
        self.identityChip = identityChip
        self.insightTitle = insightTitle
        self.insightSentence = insightSentence
        self.interpretation = interpretation
        self.chipColor = chipColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cardHeight = geometry.size.height * 0.70 // ~70% of available height (reduced to ensure CTA visibility)
            
            VStack(spacing: 0) {
                // System icon (symbolic, not functional - matching onboarding circular style)
                systemIcon
                    .frame(height: 100) // Increased to accommodate larger circular icon containers
                    .padding(.top, DesignSpacing.lg) // More generous top padding
                
                // Identity chip (tight spacing from icon - grouped with icon)
                Text(identityChip)
                    .font(ArotiTextStyle.caption1.weight(.semibold))
                    .foregroundColor(chipColor)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .frame(height: 28)
                    .background(
                        Capsule()
                            .fill(chipColor.opacity(0.2))
                    )
                    .overlay(
                        Capsule()
                            .stroke(chipColor.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.top, 8) // Tight spacing from icon (reduced from 12)
                
                // Today's Insight title (medium spacing from chip - clear separation)
                Text(insightTitle)
                    .font(DesignTypography.title3Font()) // Reduced from title2
                    .foregroundColor(DesignColors.foreground)
                    .padding(.top, 28) // Increased gap from chip (was 24)
                
                // Insight sentence (visual hero - largest visual weight, breathing space)
                Text(insightSentence)
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .lineSpacing(6) // Increased line-height for breathing space
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 16) // Breathing space
                    .padding(.horizontal, DesignSpacing.sm)
                
                // Interpretation (fully visible, no truncation, readable)
                Text(interpretation)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground.opacity(0.7)) // Reduced opacity more
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 28) // Generous spacing from insight sentence
                    .padding(.horizontal, DesignSpacing.md)
                
                Spacer(minLength: 0)
                
                // Brand mark (signature - intentional spacing, moved up)
                Text("Aroti")
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.foreground.opacity(0.45)) // Increased opacity slightly
                    .padding(.top, 16) // Small spacing from interpretation (reduced from 20)
                    .padding(.bottom, DesignSpacing.md) // Generous bottom padding
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: cardHeight) // Minimum height - content can expand if needed
            .padding(DesignSpacing.md)
            .background(
                ZStack {
                    // Gentle background gradient
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.85),
                                    Color(red: 20/255, green: 18/255, blue: 28/255, opacity: 0.85)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Liquid glass highlight at top
                    VStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.clear, Color.white.opacity(0.08), Color.clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 1)
                            .opacity(0.8)
                        Spacer()
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
            )
            .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 4)
        }
        .frame(minHeight: UIScreen.main.bounds.height * 0.70) // Minimum height - reduced to ensure CTA visibility
    }
}

#Preview {
    ZStack {
        CelestialBackground()
        
        InsightCard(
            systemIcon: AnyView(
                Text("♓")
                    .font(.system(size: 48))
                    .foregroundColor(.white.opacity(0.6))
            ),
            identityChip: "Pisces",
            insightSentence: "Intuition plays a stronger role today",
            interpretation: "With your Pisces sign influenced by Neptune-related themes today, emotional perception tends to come into clearer focus. In astrological frameworks, this influence is associated with greater sensitivity to intuitive signals, making inner impressions easier to notice as the day unfolds.",
            chipColor: Color(hue: 270/360, saturation: 0.7, brightness: 0.8)
        )
        .padding(DesignSpacing.sm)
    }
}
