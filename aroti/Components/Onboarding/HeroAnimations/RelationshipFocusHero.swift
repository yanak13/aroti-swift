//
//  RelationshipFocusHero.swift
//
//  Constellation forming two linked stars
//

import SwiftUI

struct RelationshipFocusHero: View {
    @State private var starsProgress: Double = 0
    @State private var connectionProgress: Double = 0
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
                
                // Two linked stars
                LinkedStarsShape(
                    starsProgress: starsProgress,
                    connectionProgress: connectionProgress
                )
                .stroke(
                    LinearGradient(
                        colors: [
                            ArotiColor.accent.opacity(0.95),
                            ArotiColor.accent.opacity(0.85),
                            ArotiColor.accent.opacity(0.75),
                            ArotiColor.accent.opacity(0.65)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                )
                .scaleEffect(breathingScale)
                .shadow(color: ArotiColor.accent.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                .blur(radius: 0.5)
            }
        }
        .onAppear {
            // Draw stars first
            withAnimation(.easeInOut(duration: 1.5)) {
                starsProgress = 1.0
            }
            
            // Then connect them
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    connectionProgress = 1.0
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

struct LinkedStarsShape: Shape {
    var starsProgress: Double
    var connectionProgress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerY = rect.midY
        let spacing = rect.width * 0.3
        let star1Center = CGPoint(x: rect.midX - spacing, y: centerY)
        let star2Center = CGPoint(x: rect.midX + spacing, y: centerY)
        let starRadius = min(rect.width, rect.height) * 0.12
        
        // First star
        if starsProgress > 0 {
            path.addEllipse(in: CGRect(
                x: star1Center.x - starRadius * starsProgress,
                y: star1Center.y - starRadius * starsProgress,
                width: starRadius * 2 * starsProgress,
                height: starRadius * 2 * starsProgress
            ))
        }
        
        // Second star
        if starsProgress > 0 {
            path.addEllipse(in: CGRect(
                x: star2Center.x - starRadius * starsProgress,
                y: star2Center.y - starRadius * starsProgress,
                width: starRadius * 2 * starsProgress,
                height: starRadius * 2 * starsProgress
            ))
        }
        
        // Connection line
        if connectionProgress > 0 {
            path.move(to: CGPoint(x: star1Center.x + starRadius * starsProgress, y: star1Center.y))
            path.addLine(to: CGPoint(
                x: star1Center.x + starRadius * starsProgress + (spacing * 2 - starRadius * 2) * connectionProgress,
                y: star1Center.y
            ))
        }
        
        return path
    }
}
