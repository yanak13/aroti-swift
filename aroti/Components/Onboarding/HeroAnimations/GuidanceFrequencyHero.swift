//
//  GuidanceFrequencyHero.swift
//
//  Gentle repeating pulse circles
//

import SwiftUI

struct GuidanceFrequencyHero: View {
    @State private var pulseProgress: Double = 0
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
                
                // Pulsing circles
                ForEach(0..<3, id: \.self) { index in
                    let delay = Double(index) * 0.4
                    PulseCircleShape(
                        progress: pulseProgress,
                        delay: delay
                    )
                    .stroke(
                        LinearGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.95 - Double(index) * 0.2),
                                ArotiColor.accent.opacity(0.75 - Double(index) * 0.2),
                                ArotiColor.accent.opacity(0.55 - Double(index) * 0.2),
                                ArotiColor.accent.opacity(0.35 - Double(index) * 0.2)
                            ],
                            startPoint: .center,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: ArotiColor.accent.opacity(0.5 * glowPulse * (1.0 - Double(index) * 0.3)), radius: 12, x: 0, y: 0)
                    .blur(radius: 0.5)
                }
            }
        }
        .onAppear {
            // Continuous pulse animation
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                pulseProgress = 1.0
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

struct PulseCircleShape: Shape {
    var progress: Double
    var delay: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let baseRadius = min(rect.width, rect.height) * 0.2
        let pulseRadius = baseRadius + (baseRadius * 0.6 * abs(sin((progress + delay) * .pi * 2)))
        
        path.addEllipse(in: CGRect(
            x: center.x - pulseRadius,
            y: center.y - pulseRadius,
            width: pulseRadius * 2,
            height: pulseRadius * 2
        ))
        
        return path
    }
}
