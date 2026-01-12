//
//  AnimatedGuidanceSymbol.swift
//  Aroti
//
//  Animated circular/symbolic visual for Core Guidance cards
//

import SwiftUI

struct AnimatedGuidanceSymbol: View {
    let cardType: CoreGuidanceCardType
    @State private var breathingScale: CGFloat = 0.96
    @State private var glowPulse: Double = 0.0
    @State private var initialGlow: Double = 1.0
    
    var body: some View {
        ZStack {
            // Outer glow ring (pulses on open, then subtle continuous)
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            DesignColors.accent.opacity(0.4 * initialGlow * (0.5 + glowPulse * 0.5)),
                            DesignColors.accent.opacity(0.2 * initialGlow * (0.5 + glowPulse * 0.5)),
                            DesignColors.accent.opacity(0.1 * initialGlow * (0.5 + glowPulse * 0.5))
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
                .frame(width: 120, height: 120)
                .blur(radius: 8)
                .scaleEffect(breathingScale)
            
            // Inner circle background
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            DesignColors.accent.opacity(0.2),
                            DesignColors.accent.opacity(0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .scaleEffect(breathingScale)
                .shadow(
                    color: DesignColors.accent.opacity(0.3 * initialGlow * (0.5 + glowPulse * 0.5)),
                    radius: 16,
                    x: 0,
                    y: 0
                )
            
            // Symbol icon
            Image(systemName: getIconForType(cardType))
                .font(.system(size: 44, weight: .semibold))
                .foregroundColor(DesignColors.accent)
                .scaleEffect(breathingScale)
        }
        .onAppear {
            // Initial glow pulse on open
            withAnimation(.easeOut(duration: 0.8)) {
                initialGlow = 1.0
            }
            
            // Continuous subtle glow pulse
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
            
            // Breathing animation (6-8s loop)
            withAnimation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true)) {
                breathingScale = 1.0
            }
        }
    }
    
    private func getIconForType(_ type: CoreGuidanceCardType) -> String {
        switch type {
        case .rightNow:
            return "sparkles"
        case .thisPeriod:
            return "moon.stars"
        case .whereToFocus:
            return "target"
        case .whatsComingUp:
            return "calendar"
        case .personalInsight:
            return "person.circle"
        }
    }
}

#Preview {
    ZStack {
        CelestialBackground()
        AnimatedGuidanceSymbol(cardType: .rightNow)
    }
}

