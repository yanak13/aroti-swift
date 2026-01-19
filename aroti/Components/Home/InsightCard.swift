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
    let showIcon: Bool
    
    init(
        systemIcon: AnyView,
        identityChip: String,
        insightTitle: String = "Today's Insight",
        insightSentence: String,
        interpretation: String,
        chipColor: Color = DesignColors.accent,
        showIcon: Bool = true
    ) {
        self.systemIcon = systemIcon
        self.identityChip = identityChip
        self.insightTitle = insightTitle
        self.insightSentence = insightSentence
        self.interpretation = interpretation
        self.chipColor = chipColor
        self.showIcon = showIcon
    }
    
    var body: some View {
        GeometryReader { geometry in
            let cardHeight = geometry.size.height * 0.70 // ~70% of available height (reduced to ensure CTA visibility)
            
            VStack(spacing: 0) {
                // System icon (symbolic, not functional - matching onboarding circular style)
                if showIcon {
                    systemIcon
                        .frame(height: 180) // Increased to accommodate larger hero icon containers
                        .padding(.top, DesignSpacing.lg) // More generous top padding
                }
                
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
                
                // Today's Insight title (medium spacing from chip - clear separation) - only show if not empty
                if !insightTitle.isEmpty {
                    Text(insightTitle)
                        .font(DesignTypography.title3Font()) // Reduced from title2
                        .foregroundColor(DesignColors.foreground)
                        .padding(.top, 28) // Increased gap from chip (was 24)
                }
                
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
                
                // Interpretation (fully visible, no truncation, readable) - only show if not empty
                if !interpretation.isEmpty {
                    Text(interpretation)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground.opacity(0.7)) // Reduced opacity more
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 28) // Generous spacing from insight sentence
                        .padding(.horizontal, DesignSpacing.md)
                }
                
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
                    // Base gradient - 2026 style: deeper, more organic with 4 color stops
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 16/255, green: 14/255, blue: 24/255, opacity: 0.95),
                                    Color(red: 20/255, green: 17/255, blue: 28/255, opacity: 0.92),
                                    Color(red: 18/255, green: 16/255, blue: 26/255, opacity: 0.93),
                                    Color(red: 22/255, green: 19/255, blue: 30/255, opacity: 0.90)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Secondary radial gradient layer - top-left depth
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 28/255, green: 24/255, blue: 38/255, opacity: 0.4),
                                    Color(red: 25/255, green: 22/255, blue: 35/255, opacity: 0.25),
                                    Color.clear
                                ],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 250
                            )
                        )
                    
                    // Tertiary radial gradient layer - bottom-right depth
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 24/255, green: 21/255, blue: 32/255, opacity: 0.3),
                                    Color.clear
                                ],
                                center: .bottomTrailing,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                    
                    // Accent glow - top-right warm tone
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            RadialGradient(
                                colors: [
                                    ArotiColor.accent.opacity(0.12),
                                    ArotiColor.accent.opacity(0.06),
                                    ArotiColor.accent.opacity(0.02),
                                    Color.clear
                                ],
                                center: .topTrailing,
                                startRadius: 0,
                                endRadius: 180
                            )
                        )
                    
                    // Accent glow - bottom-left subtle tone
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            RadialGradient(
                                colors: [
                                    ArotiColor.accent.opacity(0.05),
                                    Color.clear
                                ],
                                center: .bottomLeading,
                                startRadius: 0,
                                endRadius: 120
                            )
                        )
                    
                    // Liquid glass highlight at top - enhanced with multiple layers
                    VStack {
                        // Primary highlight
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.10),
                                        Color.white.opacity(0.08),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 3)
                            .opacity(0.95)
                        
                        // Secondary subtle highlight
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.06),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 1)
                            .opacity(0.7)
                            .padding(.top, 2)
                        
                        Spacer()
                    }
                    
                    // Texture overlay layer 1 - noise/grain effect
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.03),
                                    Color.black.opacity(0.015),
                                    Color.white.opacity(0.02),
                                    Color.black.opacity(0.01)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.overlay)
                    
                    // Texture overlay layer 2 - additional depth
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.015),
                                    Color.clear,
                                    Color.black.opacity(0.01)
                                ],
                                center: .center,
                                startRadius: 50,
                                endRadius: 300
                            )
                        )
                        .blendMode(.softLight)
                    
                    // Subtle diagonal texture pattern
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            AngularGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.01),
                                    Color.clear,
                                    Color.black.opacity(0.005),
                                    Color.clear
                                ],
                                center: .center,
                                angle: .degrees(45)
                            )
                        )
                        .blendMode(.overlay)
                        .opacity(0.6)
                }
                .overlay(
                    // Enhanced border with gradient
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.08),
                                    Color.white.opacity(0.12)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            )
            .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 6)
            .shadow(color: ArotiColor.accent.opacity(0.1), radius: 8, x: 0, y: 2)
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
