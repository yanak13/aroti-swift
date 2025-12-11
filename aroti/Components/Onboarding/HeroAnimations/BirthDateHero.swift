//
//  BirthDateHero.swift
//
//  Constellation forming a circle around a star
//

import SwiftUI

struct BirthDateHero: View {
    @State private var starProgress: Double = 0
    @State private var circleProgress: Double = 0
    @State private var glowPulse: Double = 0.5
    @State private var breathingScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(0.12 * glowPulse),
                        ArotiColor.accent.opacity(0.06 * glowPulse),
                        ArotiColor.accent.opacity(0.02 * glowPulse),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.7
                )
                .blur(radius: 20)
                .blendMode(.plusLighter)
                
                // Circle around star
                BirthDateShape(
                    starProgress: starProgress,
                    circleProgress: circleProgress
                )
                .stroke(
                    LinearGradient(
                        colors: [
                            ArotiColor.accent.opacity(0.95),
                            ArotiColor.accent.opacity(0.85),
                            ArotiColor.accent.opacity(0.75),
                            ArotiColor.accent.opacity(0.65)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                )
                .scaleEffect(breathingScale)
                .shadow(color: ArotiColor.accent.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                .blur(radius: 0.5)
            }
        }
        .onAppear {
            // Draw star first
            withAnimation(.easeInOut(duration: 1.0)) {
                starProgress = 1.0
            }
            
            // Then draw circle
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    circleProgress = 1.0
                }
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

struct BirthDateShape: Shape {
    var starProgress: Double
    var circleProgress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.35
        
        // Central star
        if starProgress > 0 {
            let starSize = radius * 0.2 * starProgress
            path.addEllipse(in: CGRect(
                x: center.x - starSize,
                y: center.y - starSize,
                width: starSize * 2,
                height: starSize * 2
            ))
        }
        
        // Circle around star
        if circleProgress > 0 {
            let circleRadius = radius * circleProgress
            path.addEllipse(in: CGRect(
                x: center.x - circleRadius,
                y: center.y - circleRadius,
                width: circleRadius * 2,
                height: circleRadius * 2
            ))
        }
        
        return path
    }
}
