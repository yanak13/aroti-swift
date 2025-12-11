//
//  BirthLocationHero.swift
//
//  Constellation forming a location pin/map marker
//

import SwiftUI

struct BirthLocationHero: View {
    @State private var locationProgress: Double = 0
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
                
                // Location pin shape
                LocationPinShape(progress: locationProgress)
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
            withAnimation(.easeInOut(duration: 2.5)) {
                locationProgress = 1.0
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

struct LocationPinShape: Shape {
    var progress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerX = rect.midX
        let centerY = rect.midY
        let pinWidth = rect.width * 0.15 * progress
        let pinHeight = rect.height * 0.4 * progress
        
        // Pin point (bottom)
        let pinBottom = CGPoint(x: centerX, y: centerY + pinHeight * 0.5)
        path.move(to: pinBottom)
        
        // Pin body (diamond shape)
        let topPoint = CGPoint(x: centerX, y: centerY - pinHeight * 0.5)
        let leftPoint = CGPoint(x: centerX - pinWidth, y: centerY)
        let rightPoint = CGPoint(x: centerX + pinWidth, y: centerY)
        
        path.addLine(to: leftPoint)
        path.addLine(to: topPoint)
        path.addLine(to: rightPoint)
        path.closeSubpath()
        
        return path
    }
}
