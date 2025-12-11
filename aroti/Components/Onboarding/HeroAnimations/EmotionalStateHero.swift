//
//  EmotionalStateHero.swift
//
//  Constellation with soft oscillating wave animation
//

import SwiftUI

struct EmotionalStateHero: View {
    @State private var waveProgress: Double = 0
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
                
                // Oscillating wave lines
                WaveShape(progress: waveProgress)
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
            withAnimation(.easeInOut(duration: 2.0)) {
                waveProgress = 1.0
            }
            
            // Continuous wave oscillation
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                waveProgress = 1.0
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

struct WaveShape: Shape {
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerY = rect.midY
        let amplitude = rect.height * 0.15
        let frequency = 3.0
        
        path.move(to: CGPoint(x: 0, y: centerY))
        
        for x in stride(from: 0, through: rect.width, by: 2) {
            let normalizedX = x / rect.width
            let y = centerY + sin(normalizedX * frequency * .pi * 2 + progress * .pi * 2) * amplitude * progress
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}
