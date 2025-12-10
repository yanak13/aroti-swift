//
//  GuidancePathHero.swift
//  Aroti
//
//  Animated guidance path hero for carousel screen 1
//

import SwiftUI

struct GuidancePathHero: View {
    @State private var pathProgress: Double = 0
    @State private var glowIntensity: Double = 0
    @State private var pathGlow: Double = 0.5
    @State private var breathingScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow - warm orange, blurred
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(0.12 * pathGlow),
                        ArotiColor.accent.opacity(0.06 * pathGlow),
                        ArotiColor.accent.opacity(0.02 * pathGlow),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.7
                )
                .blur(radius: 20)
                .blendMode(.plusLighter)
                
                // Animated path - cinematic with inner glow
                GuidancePathShape(progress: pathProgress)
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
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: ArotiColor.accent.opacity(0.5 * pathGlow), radius: 12, x: 0, y: 0)
                    .blur(radius: 0.5)
                
                // Glowing nodes along the path - larger and more prominent
                ForEach(0..<6, id: \.self) { index in
                    let nodeProgress = Double(index) / 5.0
                    if pathProgress >= nodeProgress {
                        ZStack {
                            // Soft outer glow
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            ArotiColor.accent.opacity(0.4 * glowIntensity),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 4,
                                        endRadius: 14
                                    )
                                )
                                .frame(width: 28, height: 28)
                                .blur(radius: 3)
                            
                            // Main node with inner glow
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
                                        startRadius: 3,
                                        endRadius: 12
                                    )
                                )
                                .frame(width: 12, height: 12)
                        }
                        .position(
                            x: geometry.size.width * (0.1 + nodeProgress * 0.8),
                            y: geometry.size.height * (0.3 + sin(nodeProgress * .pi * 2) * 0.2)
                        )
                        .opacity(glowIntensity)
                        .shadow(color: ArotiColor.accent.opacity(0.9), radius: 12, x: 0, y: 0)
                    }
                }
            }
        }
        .onAppear {
            // Draw path
            withAnimation(.easeInOut(duration: 3.0)) {
                pathProgress = 1.0
            }
            
            // Nodes glow
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    glowIntensity = 1.0
                }
            }
            
            // Path glow pulse
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                pathGlow = 1.0
            }
            
            // Very slow breathing animation
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                breathingScale = 1.02
            }
        }
    }
}

struct GuidancePathShape: Shape {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startY = rect.midY
        let endY = rect.midY
        let startX = rect.width * 0.1
        let endX = rect.width * 0.9
        
        // Create a flowing, organic path
        path.move(to: CGPoint(x: startX, y: startY))
        
        let controlPoints = [
            CGPoint(x: rect.width * 0.3, y: startY - rect.height * 0.15),
            CGPoint(x: rect.width * 0.5, y: startY + rect.height * 0.1),
            CGPoint(x: rect.width * 0.7, y: startY - rect.height * 0.1)
        ]
        
        for (index, point) in controlPoints.enumerated() {
            if index == 0 {
                path.addQuadCurve(to: point, control: CGPoint(x: (startX + point.x) / 2, y: startY))
            } else {
                let prevPoint = controlPoints[index - 1]
                path.addQuadCurve(to: point, control: CGPoint(x: (prevPoint.x + point.x) / 2, y: (prevPoint.y + point.y) / 2))
            }
        }
        
        path.addQuadCurve(to: CGPoint(x: endX, y: endY), control: CGPoint(x: (controlPoints.last!.x + endX) / 2, y: endY))
        
        return path.trimmedPath(from: 0, to: progress)
    }
}

#Preview {
    GuidancePathHero()
        .frame(height: 400)
        .background(CelestialBackground())
}
