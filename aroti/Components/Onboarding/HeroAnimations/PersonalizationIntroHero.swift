//
//  PersonalizationIntroHero.swift
//
//  Constellation forming into abstract human shape
//

import SwiftUI

struct PersonalizationIntroHero: View {
    @State private var constellationProgress: Double = 0
    @State private var humanFormProgress: Double = 0
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
                
                // Abstract human form - constellation lines
                HumanFormShape(progress: humanFormProgress)
                    .stroke(
                        LinearGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.95),
                                ArotiColor.accent.opacity(0.85),
                                ArotiColor.accent.opacity(0.75),
                                ArotiColor.accent.opacity(0.65)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: ArotiColor.accent.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                    .blur(radius: 0.5)
            }
        }
        .onAppear {
            // Draw constellation first
            withAnimation(.easeInOut(duration: 2.0)) {
                constellationProgress = 1.0
            }
            
            // Then form human shape
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 2.5)) {
                    humanFormProgress = 1.0
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

struct HumanFormShape: Shape {
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerX = rect.midX
        let centerY = rect.midY
        let width = rect.width * 0.6
        let height = rect.height * 0.8
        
        // Head (circle)
        let headRadius = width * 0.15
        let headCenter = CGPoint(x: centerX, y: centerY - height * 0.35)
        path.addEllipse(in: CGRect(
            x: headCenter.x - headRadius,
            y: headCenter.y - headRadius,
            width: headRadius * 2,
            height: headRadius * 2
        ))
        
        // Body (vertical line)
        let bodyStart = CGPoint(x: centerX, y: headCenter.y + headRadius)
        let bodyEnd = CGPoint(x: centerX, y: centerY + height * 0.25)
        path.move(to: bodyStart)
        path.addLine(to: CGPoint(
            x: bodyEnd.x,
            y: bodyStart.y + (bodyEnd.y - bodyStart.y) * progress
        ))
        
        // Arms (horizontal lines)
        let armY = bodyStart.y + (bodyEnd.y - bodyStart.y) * 0.3
        let armLength = width * 0.25
        path.move(to: CGPoint(x: centerX - armLength, y: armY))
        path.addLine(to: CGPoint(
            x: centerX - armLength + (armLength * 2) * progress,
            y: armY
        ))
        
        // Legs (two diagonal lines)
        let legStart = bodyEnd
        let legLength = height * 0.2
        path.move(to: legStart)
        path.addLine(to: CGPoint(
            x: legStart.x - legLength * 0.3,
            y: legStart.y + legLength * progress
        ))
        path.move(to: legStart)
        path.addLine(to: CGPoint(
            x: legStart.x + legLength * 0.3,
            y: legStart.y + legLength * progress
        ))
        
        return path
    }
}
