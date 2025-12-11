//
//  PremiumOfferHero.swift
//
//  Soft glowing constellation that expands and softens
//

import SwiftUI

struct PremiumOfferHero: View {
    @State private var expansionProgress: Double = 0
    @State private var glowPulse: Double = 0.5
    @State private var breathingScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow - more intense
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(0.15 * glowPulse),
                        ArotiColor.accent.opacity(0.08 * glowPulse),
                        ArotiColor.accent.opacity(0.04 * glowPulse),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.8
                )
                .blur(radius: 25)
                .blendMode(.plusLighter)
                
                // Expanding constellation
                ExpandingConstellationShape(progress: expansionProgress)
                    .stroke(
                        LinearGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.95),
                                ArotiColor.accent.opacity(0.85),
                                ArotiColor.accent.opacity(0.75),
                                ArotiColor.accent.opacity(0.65)
                            ],
                            startPoint: .center,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: ArotiColor.accent.opacity(0.6 * glowPulse), radius: 15, x: 0, y: 0)
                    .blur(radius: 0.5)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 3.0)) {
                expansionProgress = 1.0
            }
            
            // Continuous glow pulse
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
            
            // Breathing animation
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                breathingScale = 1.02
            }
        }
    }
}

struct ExpandingConstellationShape: Shape {
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let baseRadius = min(rect.width, rect.height) * 0.25
        let expandedRadius = baseRadius * (1.0 + progress * 0.5)
        
        // Multiple concentric circles
        for i in 1...3 {
            let radius = expandedRadius * (Double(i) / 3.0)
            path.addEllipse(in: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
        }
        
        // Stars around the circle
        let starCount = 8
        for i in 0..<starCount {
            let angle = Double(i) * 2 * .pi / Double(starCount)
            let starX = center.x + expandedRadius * cos(angle)
            let starY = center.y + expandedRadius * sin(angle)
            let starSize = baseRadius * 0.1 * progress
            
            path.addEllipse(in: CGRect(
                x: starX - starSize,
                y: starY - starSize,
                width: starSize * 2,
                height: starSize * 2
            ))
        }
        
        return path
    }
}
