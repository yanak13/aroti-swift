//
//  ConstellationHero.swift
//  Aroti
//
//  Animated constellation hero for welcome screen
//

import SwiftUI

struct ConstellationHero: View {
    @State private var drawingProgress: Double = 0
    @State private var starsOpacity: Double = 0
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
                
                // Constellation path - cinematic scale with inner glow
                ConstellationPath(progress: drawingProgress)
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
                
                // Stars - with soft glow
                ForEach(0..<10, id: \.self) { index in
                    StarView(index: index, opacity: starsOpacity, glowIntensity: glowPulse)
                        .scaleEffect(breathingScale)
                }
            }
        }
        .onAppear {
            // Draw constellation path
            withAnimation(.easeInOut(duration: 3.0)) {
                drawingProgress = 1.0
            }
            
            // Stars appear sequentially
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeIn(duration: 1.5)) {
                    starsOpacity = 1.0
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

struct ConstellationPath: Shape {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let centerX = rect.midX
        let centerY = rect.midY
        let radius = min(rect.width, rect.height) * 0.3
        
        // Create a constellation pattern (simplified)
        let points: [(x: Double, y: Double)] = [
            (centerX - radius * 0.8, centerY - radius * 0.3),
            (centerX - radius * 0.3, centerY - radius * 0.6),
            (centerX, centerY - radius * 0.4),
            (centerX + radius * 0.3, centerY - radius * 0.2),
            (centerX + radius * 0.7, centerY),
            (centerX + radius * 0.4, centerY + radius * 0.5),
            (centerX, centerY + radius * 0.3),
            (centerX - radius * 0.5, centerY + radius * 0.2)
        ]
        
        // Draw lines connecting points
        if points.count > 1 {
            path.move(to: CGPoint(x: points[0].x, y: points[0].y))
            for i in 1..<points.count {
                path.addLine(to: CGPoint(x: points[i].x, y: points[i].y))
            }
            // Close the constellation
            path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
        }
        
        return path.trimmedPath(from: 0, to: progress)
    }
}

struct StarView: View {
    let index: Int
    let opacity: Double
    let glowIntensity: Double
    
    var body: some View {
        let positions: [(x: Double, y: Double)] = [
            (0.2, 0.3), (0.35, 0.15), (0.5, 0.25),
            (0.65, 0.2), (0.8, 0.35), (0.7, 0.55),
            (0.5, 0.65), (0.3, 0.5), (0.15, 0.4), (0.85, 0.5)
        ]
        
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.3 * glowIntensity),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 3,
                            endRadius: 10
                        )
                    )
                    .frame(width: 20, height: 20)
                    .blur(radius: 3)
                
                // Main star with inner glow
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
                            startRadius: 1.5,
                            endRadius: 8
                        )
                    )
                    .frame(width: 8, height: 8)
            }
            .position(
                x: geometry.size.width * positions[index % positions.count].x,
                y: geometry.size.height * positions[index % positions.count].y
            )
            .opacity(opacity)
            .shadow(color: ArotiColor.accent.opacity(0.6 * glowIntensity), radius: 6, x: 0, y: 0)
        }
    }
}

#Preview {
    ConstellationHero()
        .frame(height: 400)
        .background(CelestialBackground())
}
