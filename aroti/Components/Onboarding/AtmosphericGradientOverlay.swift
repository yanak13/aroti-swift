//
//  AtmosphericGradientOverlay.swift
//  Aroti
//
//  Premium atmospheric gradient that blends invisibly with background
//

import SwiftUI

struct AtmosphericGradientOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Large vertical gradient - 60% of screen height for smooth fade
                // Matches CelestialBackground colors exactly at edges
                VStack(spacing: 0) {
                    // Top gradient fade - transparent → gentle glow → transparent
                    LinearGradient(
                        colors: [
                            // Match exact background color at top
                            ArotiColor.bg,
                            // Very subtle warm glow
                            ArotiColor.accent.opacity(0.03),
                            ArotiColor.accent.opacity(0.06),
                            ArotiColor.accent.opacity(0.04),
                            ArotiColor.accent.opacity(0.02),
                            // Match background color again
                            ArotiColor.bg.opacity(0.5),
                            // Fully transparent
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: geometry.size.height * 0.6)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                    Spacer()
                }
                .blendMode(.plusLighter)
            }
        }
        .allowsHitTesting(false)
    }
}

// Radial glow component for behind hero illustrations
struct HeroRadialGlow: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Large subtle radial gradient behind hero
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(0.05),
                        ArotiColor.accent.opacity(0.02),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.5, y: 0.4),
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.8
                )
                .blendMode(.plusLighter)
            }
        }
        .allowsHitTesting(false)
    }
}
