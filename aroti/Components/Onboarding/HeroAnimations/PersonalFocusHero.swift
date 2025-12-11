//
//  PersonalFocusHero.swift
//
//  Constellation in target/focus point shape
//

import SwiftUI

struct PersonalFocusHero: View {
    @State private var targetProgress: Double = 0
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
                
                // Target/focus shape
                TargetShape(progress: targetProgress)
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
                    .shadow(color: ArotiColor.accent.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                    .blur(radius: 0.5)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5)) {
                targetProgress = 1.0
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

struct TargetShape: Shape {
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maxRadius = min(rect.width, rect.height) * 0.4
        
        // Concentric circles
        for i in 1...3 {
            let radius = maxRadius * (Double(i) / 3.0) * progress
            path.addEllipse(in: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
        }
        
        // Crosshair lines
        let lineLength = maxRadius * progress
        path.move(to: CGPoint(x: center.x - lineLength, y: center.y))
        path.addLine(to: CGPoint(x: center.x + lineLength, y: center.y))
        path.move(to: CGPoint(x: center.x, y: center.y - lineLength))
        path.addLine(to: CGPoint(x: center.x, y: center.y + lineLength))
        
        return path
    }
}
