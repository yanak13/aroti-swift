//
//  ReadyHero.swift
//
//  Completed Blueprint Seal - closed, symmetrical geometric emblem
//  One-time resolve animation signaling completion and readiness
//

import SwiftUI

struct ReadyHero: View {
    @State private var sealOpacity: Double = 0
    @State private var sealScale: Double = 0.95
    @State private var glowIntensity: Double = 0
    @State private var innerGlow: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow - settles after initial pulse
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(0.08 * glowIntensity),
                        ArotiColor.accent.opacity(0.04 * glowIntensity),
                        ArotiColor.accent.opacity(0.02 * glowIntensity),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.7
                )
                .blur(radius: 20)
                .blendMode(.plusLighter)
                
                // Completed Blueprint Seal
                CompletedBlueprintSealShape()
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
                    .opacity(sealOpacity)
                    .scaleEffect(sealScale)
                    .shadow(color: ArotiColor.accent.opacity(0.4 * glowIntensity), radius: 12, x: 0, y: 0)
                    
                // Subtle inner glow - almost imperceptible
                CompletedBlueprintSealShape()
                    .fill(
                        RadialGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.15 * innerGlow),
                                ArotiColor.accent.opacity(0.05 * innerGlow),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: min(geometry.size.width, geometry.size.height) * 0.15
                        )
                    )
                    .opacity(sealOpacity)
                    .scaleEffect(sealScale)
            }
        }
        .onAppear {
            // One-time resolve animation: shape softly resolves into place
            withAnimation(.easeOut(duration: 1.8)) {
                sealOpacity = 1.0
                sealScale = 1.0
            }
            
            // Micro glow pulse that settles
            withAnimation(.easeInOut(duration: 1.2)) {
                glowIntensity = 1.0
            }
            
            // Inner glow appears gently
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut(duration: 1.0)) {
                    innerGlow = 1.0
                }
            }
            
            // Glow settles to final state
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeOut(duration: 1.3)) {
                    glowIntensity = 0.7
                }
            }
        }
    }
}

struct CompletedBlueprintSealShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.3
        
        // Closed hexagon - perfectly symmetrical seal
        let sides = 6
        var hexPoints: [CGPoint] = []
        
        for i in 0..<sides {
            let angle = Double(i) * 2 * .pi / Double(sides) - .pi / 2
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            hexPoints.append(CGPoint(x: x, y: y))
        }
        
        // Draw closed hexagon
        for (index, point) in hexPoints.enumerated() {
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        
        // Subtle inner detail: small center point
        let centerRadius = radius * 0.12
        path.addEllipse(in: CGRect(
            x: center.x - centerRadius,
            y: center.y - centerRadius,
            width: centerRadius * 2,
            height: centerRadius * 2
        ))
        
        return path
    }
}
