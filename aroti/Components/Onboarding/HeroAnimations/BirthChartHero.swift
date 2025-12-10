//
//  BirthChartHero.swift
//  Aroti
//
//  Animated birth chart hero for carousel screen 2
//

import SwiftUI

struct BirthChartHero: View {
    @State private var constellationProgress: Double = 0
    @State private var chartFormation: Double = 0
    @State private var rotation: Double = 0
    @State private var glowPulse: Double = 0.5
    @State private var breathingScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow - warm orange, blurred
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
                
                // Circular chart - cinematic with inner glow
                BirthChartCircle(
                    progress: chartFormation,
                    rotation: rotation
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
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )
                .scaleEffect(breathingScale)
                .shadow(color: ArotiColor.accent.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                .blur(radius: 0.5)
                
                // Constellation points forming into circle
                ForEach(0..<8, id: \.self) { index in
                    let angle = Double(index) * (2 * .pi / 8)
                    let radius = min(geometry.size.width, geometry.size.height) * 0.25
                    let centerX = geometry.size.width / 2
                    let centerY = geometry.size.height / 2
                    
                    let finalX = centerX + cos(angle) * radius
                    let finalY = centerY + sin(angle) * radius
                    
                    // Starting position (scattered)
                    let startX = centerX + cos(angle + .pi / 4) * radius * 1.5
                    let startY = centerY + sin(angle + .pi / 4) * radius * 1.5
                    
                    let currentX = startX + (finalX - startX) * chartFormation
                    let currentY = startY + (finalY - startY) * chartFormation
                    
                    ZStack {
                        // Soft outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        ArotiColor.accent.opacity(0.3 * glowPulse),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 3,
                                    endRadius: 12
                                )
                            )
                            .frame(width: 24, height: 24)
                            .blur(radius: 2)
                        
                        // Main point with inner glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        ArotiColor.accent.opacity(0.9),
                                        ArotiColor.accent.opacity(0.7),
                                        ArotiColor.accent.opacity(0.5),
                                        ArotiColor.accent.opacity(0.3)
                                    ],
                                    center: .center,
                                    startRadius: 2,
                                    endRadius: 10
                                )
                            )
                            .frame(width: 10, height: 10)
                    }
                    .position(x: currentX, y: currentY)
                    .opacity(constellationProgress)
                    .shadow(color: ArotiColor.accent.opacity(0.8 * glowPulse), radius: 10, x: 0, y: 0)
                    
                    // Connecting lines
                    if chartFormation > 0.5 && index > 0 {
                        Path { path in
                            let prevAngle = Double(index - 1) * (2 * .pi / 8)
                            let prevX = centerX + cos(prevAngle) * radius
                            let prevY = centerY + sin(prevAngle) * radius
                            
                            path.move(to: CGPoint(x: prevX, y: prevY))
                            path.addLine(to: CGPoint(x: currentX, y: currentY))
                        }
                        .stroke(
                            ArotiColor.accent.opacity(0.3 * chartFormation),
                            style: StrokeStyle(lineWidth: 1, lineCap: .round)
                        )
                    }
                }
            }
        }
        .onAppear {
            // First show constellation points
            withAnimation(.easeOut(duration: 1.0)) {
                constellationProgress = 1.0
            }
            
            // Then form into circle
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    chartFormation = 1.0
                }
            }
            
            // Subtle rotation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
            
            // Continuous glow pulse
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
            
            // Very slow breathing animation
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                breathingScale = 1.02
            }
        }
    }
}

struct BirthChartCircle: Shape {
    var progress: Double
    var rotation: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(progress, rotation) }
        set {
            progress = newValue.first
            rotation = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.25
        
        // Draw circle
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(rotation),
            endAngle: .degrees(rotation + 360 * progress),
            clockwise: false
        )
        
        return path
    }
}

#Preview {
    BirthChartHero()
        .frame(height: 400)
        .background(CelestialBackground())
}
