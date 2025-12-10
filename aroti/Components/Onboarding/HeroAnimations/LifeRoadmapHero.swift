//
//  LifeRoadmapHero.swift
//  Aroti
//
//  Animated life roadmap hero for carousel screen 3
//

import SwiftUI

struct LifeRoadmapHero: View {
    @State private var burstProgress: Double = 0
    @State private var linesProgress: Double = 0
    @State private var branchesProgress: Double = 0
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
                
                // Central glow
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(0.08 * burstProgress),
                        ArotiColor.accent.opacity(0.04 * burstProgress),
                        ArotiColor.accent.opacity(0.02 * burstProgress),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 8,
                    endRadius: min(geometry.size.width, geometry.size.height) * 0.45 * burstProgress
                )
                .blendMode(.plusLighter)
                
                // Flowing lines outward - 50% larger, more cinematic
                ForEach(0..<6, id: \.self) { index in
                    let angle = Double(index) * (2 * .pi / 6)
                    RoadmapLine(
                        angle: angle,
                        progress: linesProgress,
                        branchProgress: branchesProgress
                    )
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
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: ArotiColor.accent.opacity(0.5 * linesProgress), radius: 10, x: 0, y: 0)
                    .blur(radius: 0.5)
                }
                
                // Branching structure - larger
                ForEach(0..<12, id: \.self) { index in
                    let angle = Double(index) * (2 * .pi / 12)
                    BranchLine(
                        angle: angle,
                        progress: branchesProgress
                    )
                    .stroke(
                        LinearGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.7 * branchesProgress),
                                ArotiColor.accent.opacity(0.5 * branchesProgress),
                                ArotiColor.accent.opacity(0.3 * branchesProgress),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: ArotiColor.accent.opacity(0.4 * branchesProgress), radius: 6, x: 0, y: 0)
                }
                
                // Central glow pulse - softer, more atmospheric
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.12 * glowPulse),
                                ArotiColor.accent.opacity(0.06 * glowPulse),
                                ArotiColor.accent.opacity(0.02 * glowPulse),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 4,
                            endRadius: 35
                        )
                    )
                    .frame(width: 70, height: 70)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .blendMode(.plusLighter)
            }
        }
        .onAppear {
            // Light burst
            withAnimation(.easeOut(duration: 0.8)) {
                burstProgress = 1.0
            }
            
            // Lines flowing outward
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 1.5)) {
                    linesProgress = 1.0
                }
            }
            
            // Branching structure
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    branchesProgress = 1.0
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

struct RoadmapLine: Shape {
    let angle: Double
    var progress: Double
    var branchProgress: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(progress, branchProgress) }
        set {
            progress = newValue.first
            branchProgress = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maxRadius = min(rect.width, rect.height) * 0.4
        let currentRadius = maxRadius * progress
        
        let endX = center.x + cos(angle) * currentRadius
        let endY = center.y + sin(angle) * currentRadius
        
        path.move(to: center)
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        return path
    }
}

struct BranchLine: Shape {
    let angle: Double
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let branchStartRadius = min(rect.width, rect.height) * 0.25
        let branchLength = min(rect.width, rect.height) * 0.15 * progress
        
        let startX = center.x + cos(angle) * branchStartRadius
        let startY = center.y + sin(angle) * branchStartRadius
        let endX = startX + cos(angle) * branchLength
        let endY = startY + sin(angle) * branchLength
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        return path
    }
}

#Preview {
    LifeRoadmapHero()
        .frame(height: 400)
        .background(CelestialBackground())
}
