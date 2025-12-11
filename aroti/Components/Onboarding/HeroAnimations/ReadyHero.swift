//
//  ReadyHero.swift
//
//  Subtle constellation final glow animation
//

import SwiftUI

struct ReadyHero: View {
    @State private var finalGlow: Double = 0
    @State private var glowPulse: Double = 0.5
    @State private var breathingScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow - final gentle pulse
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(0.12 * glowPulse * finalGlow),
                        ArotiColor.accent.opacity(0.06 * glowPulse * finalGlow),
                        ArotiColor.accent.opacity(0.02 * glowPulse * finalGlow),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.7
                )
                .blur(radius: 20)
                .blendMode(.plusLighter)
                
                // Final constellation
                FinalConstellationShape(progress: finalGlow)
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
                    .shadow(color: ArotiColor.accent.opacity(0.5 * glowPulse * finalGlow), radius: 12, x: 0, y: 0)
                    .blur(radius: 0.5)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5)) {
                finalGlow = 1.0
            }
            
            // Continuous gentle glow pulse
            withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
            
            // Breathing animation
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                breathingScale = 1.02
            }
        }
    }
}

struct FinalConstellationShape: Shape {
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.3 * progress
        
        // Simple elegant star
        let points = 6
        var starPoints: [CGPoint] = []
        
        for i in 0..<points {
            let angle = Double(i) * 2 * .pi / Double(points) - .pi / 2
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            starPoints.append(CGPoint(x: x, y: y))
        }
        
        // Draw star
        for (index, point) in starPoints.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        
        return path
    }
}
