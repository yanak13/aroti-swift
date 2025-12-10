//
//  BuildingAnimationView.swift
//  Aroti
//
//  Building profile animation component
//

import SwiftUI

struct BuildingAnimationView: View {
    @State private var phase: Int = 0
    @State private var constellationOpacity: Double = 0
    @State private var orbitScale: Double = 0.8
    @State private var cardOffset: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Constellation Lines
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let points: [CGPoint] = [
                    CGPoint(x: center.x - 50, y: center.y - 50),
                    CGPoint(x: center.x + 50, y: center.y - 50),
                    center,
                    CGPoint(x: center.x - 50, y: center.y + 50),
                    CGPoint(x: center.x + 50, y: center.y + 50)
                ]
                
                // Stars
                for point in points {
                    context.fill(
                        Path(ellipseIn: CGRect(x: point.x - 2, y: point.y - 2, width: 4, height: 4)),
                        with: .color(.white.opacity(0.3))
                    )
                }
                
                // Connecting lines (animated)
                if phase >= 0 {
                    context.stroke(
                        Path { path in
                            path.move(to: points[0])
                            path.addLine(to: points[2])
                            path.move(to: points[1])
                            path.addLine(to: points[2])
                            path.move(to: points[2])
                            path.addLine(to: points[3])
                            path.move(to: points[2])
                            path.addLine(to: points[4])
                        },
                        with: .color(.white.opacity(0.5)),
                        lineWidth: 1
                    )
                }
            }
            .opacity(constellationOpacity)
            
            // Glowing Orbits
            if phase >= 1 {
                ForEach(0..<3, id: \.self) { ring in
                    Circle()
                        .stroke(ArotiColor.accent.opacity(0.3), lineWidth: 1)
                        .frame(width: 60 + CGFloat(ring) * 40, height: 60 + CGFloat(ring) * 40)
                        .scaleEffect(orbitScale)
                        .opacity(0.6)
                }
            }
            
            // Tarot Card Silhouettes
            if phase >= 2 {
                HStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        ArotiColor.accent.opacity(0.2),
                                        ArotiColor.accent.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 96)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ArotiColor.accent.opacity(0.3), lineWidth: 1)
                            )
                            .offset(y: cardOffset)
                            .animation(
                                .easeOut(duration: 0.5)
                                    .delay(Double(index) * 0.15),
                                value: cardOffset
                            )
                    }
                }
            }
        }
        .onAppear {
            // Phase 0: Constellation
            withAnimation(.easeIn(duration: 0.5)) {
                constellationOpacity = 1
            }
            
            // Phase 1: Orbits
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                phase = 1
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    orbitScale = 1.1
                }
            }
            
            // Phase 2: Cards
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                phase = 2
                withAnimation(.easeOut(duration: 0.5)) {
                    cardOffset = 0
                }
            }
        }
    }
}
