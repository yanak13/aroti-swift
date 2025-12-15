//
//  PaywallHeroIllustration.swift
//  Aroti
//
//  Hero illustration component for paywall carousel with bronze accent glow
//

import SwiftUI

struct PaywallHeroIllustration: View {
    let slide: PaywallSlide
    var parallaxOffset: CGFloat = 0
    @State private var glowPulse: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Radial glow background with bronze accent
            RadialGradient(
                colors: [
                    ArotiColor.accent.opacity(0.15 * glowPulse),
                    ArotiColor.accent.opacity(0.08 * glowPulse),
                    ArotiColor.accent.opacity(0.03 * glowPulse),
                    Color.clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 100
            )
            .blendMode(.plusLighter)
            
            // Custom illustration based on slide type
            Group {
                switch slide {
                case .personalProfile:
                    PersonalProfileIllustration()
                case .compatibility:
                    CompatibilityIllustration()
                case .tarot:
                    TarotIllustration()
                case .aiGuidance:
                    AIGuidanceIllustration()
                }
            }
            .offset(x: parallaxOffset)
        }
        .onAppear {
            // Subtle glow pulse animation
            withAnimation(
                Animation.easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true)
            ) {
                glowPulse = 1.15
            }
        }
    }
}

// MARK: - Personal Profile Illustration (Circular chart / constellation wheel)

private struct PersonalProfileIllustration: View {
    var body: some View {
        ZStack {
            // Outer circle
            Circle()
                .stroke(ArotiColor.accent.opacity(0.4), lineWidth: 2)
                .frame(width: 80, height: 80)
            
            // Inner circle
            Circle()
                .stroke(ArotiColor.accent.opacity(0.3), lineWidth: 1.5)
                .frame(width: 50, height: 50)
            
            // Center point with glow
            Circle()
                .fill(ArotiColor.accent)
                .frame(width: 8, height: 8)
                .shadow(color: ArotiColor.accent.opacity(0.6), radius: 4)
            
            // Constellation points (subtle glyphs)
            ForEach(0..<8, id: \.self) { index in
                let angle = Double(index) * .pi / 4
                let radius: CGFloat = 35
                Circle()
                    .fill(ArotiColor.textPrimary.opacity(0.6))
                    .frame(width: 3, height: 3)
                    .offset(x: cos(angle) * radius, y: sin(angle) * radius)
            }
        }
    }
}

// MARK: - Compatibility Illustration (Two orbiting rings intersecting)

private struct CompatibilityIllustration: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // First ring
            Circle()
                .stroke(ArotiColor.accent.opacity(0.5), lineWidth: 2.5)
                .frame(width: 70, height: 70)
                .rotationEffect(.degrees(rotation))
                .offset(x: -8, y: 0)
            
            // Second ring
            Circle()
                .stroke(ArotiColor.accent.opacity(0.5), lineWidth: 2.5)
                .frame(width: 70, height: 70)
                .rotationEffect(.degrees(-rotation))
                .offset(x: 8, y: 0)
            
            // Heart/spark at intersection
            Image(systemName: "heart.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ArotiColor.accent)
                .shadow(color: ArotiColor.accent.opacity(0.5), radius: 4)
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 8.0)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}

// MARK: - Tarot Illustration (3-card spread silhouette)

private struct TarotIllustration: View {
    var body: some View {
        HStack(spacing: -8) {
            // Left card (tilted left)
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [
                            ArotiColor.textPrimary.opacity(0.8),
                            ArotiColor.textPrimary.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 24, height: 36)
                .rotationEffect(.degrees(-12))
                .shadow(color: ArotiColor.accent.opacity(0.3), radius: 4, x: -2, y: 2)
            
            // Center card (straight)
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [
                            ArotiColor.textPrimary,
                            ArotiColor.textPrimary.opacity(0.85)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 28, height: 40)
                .shadow(color: ArotiColor.accent.opacity(0.4), radius: 6, x: 0, y: 3)
                .overlay(
                    // Shimmer effect
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.2),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
            
            // Right card (tilted right)
            RoundedRectangle(cornerRadius: 6)
                .fill(
                    LinearGradient(
                        colors: [
                            ArotiColor.textPrimary.opacity(0.8),
                            ArotiColor.textPrimary.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 24, height: 36)
                .rotationEffect(.degrees(12))
                .shadow(color: ArotiColor.accent.opacity(0.3), radius: 4, x: 2, y: 2)
        }
    }
}

// MARK: - AI Guidance Illustration (Chat bubble + star/compass motif)

private struct AIGuidanceIllustration: View {
    var body: some View {
        ZStack {
            // Chat bubble
            Image(systemName: "bubble.left.fill")
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            ArotiColor.textPrimary.opacity(0.9),
                            ArotiColor.textPrimary.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: ArotiColor.accent.opacity(0.3), radius: 6)
            
            // Star/compass motif overlay
            ZStack {
                // Star
                Image(systemName: "star.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(ArotiColor.accent)
                    .offset(x: -8, y: -8)
                
                // Compass
                Image(systemName: "location.north.circle.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(ArotiColor.accent.opacity(0.8))
                    .offset(x: 8, y: 8)
            }
        }
    }
}
