//
//  MappingBlueprintHero.swift
//
//  Animated blueprint mapping hero - emergent blueprint field
//  Points and lines forming with intention and calm
//

import SwiftUI

struct MappingBlueprintHero: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    // Animation phase states
    @State private var phase: Int = 0  // 0: Awareness, 1: Gathering, 2: Formation, 3: Stability
    @State private var pointsOpacity: [Double] = Array(repeating: 0.0, count: 10)  // Fade in during Phase 1
    @State private var pointsRadius: [Double] = Array(repeating: 0.45, count: 10)  // Move inward during Phase 2
    @State private var lineProgress: [Double] = Array(repeating: 0.0, count: 10)  // Lines appear during Phase 2
    @State private var linesOpacity: [Double] = Array(repeating: 0.0, count: 10)  // Lines fade in
    @State private var pulseProgress: Double = 0.0  // Pulse passes through in Phase 3
    @State private var breathingGlow: Double = 1.0  // Breathing glow in Phase 4
    
    // Callbacks
    let onPhaseChange: ((Int, String) -> Void)?
    let onGatheringStart: (() -> Void)?
    let onFormationComplete: (() -> Void)?
    
    init(
        onPhaseChange: ((Int, String) -> Void)? = nil,
        onGatheringStart: (() -> Void)? = nil,
        onFormationComplete: (() -> Void)? = nil
    ) {
        self.onPhaseChange = onPhaseChange
        self.onGatheringStart = onGatheringStart
        self.onFormationComplete = onFormationComplete
    }
    
    // Point positions (10 points arranged around center)
    private let pointCount = 10
    private let initialRadius: CGFloat = 0.45  // Starting radius
    private let finalRadius: CGFloat = 0.38   // Final radius after moving inward
    
    // Connection order (intentional, not random)
    private let connectionOrder: [(Int, Int)] = [
        (0, 1), (1, 2), (2, 3), (3, 4),  // First cluster
        (4, 5), (5, 6),                   // Second cluster
        (6, 7), (7, 8), (8, 9),           // Third cluster
        (0, 9)                            // Final connection
    ]
    
    // Phase subtitles
    private let phaseSubtitles = [
        "Collecting your personal signals",
        "Aligning insights that shape you",
        "Forming your unique blueprint",
        "Your blueprint is ready"
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Lines - thin, glowing amber lines
                ForEach(0..<connectionOrder.count, id: \.self) { index in
                    let (startIdx, endIdx) = connectionOrder[index]
                    BlueprintLine(
                        startIndex: startIdx,
                        endIndex: endIdx,
                        progress: lineProgress[index],
                        opacity: linesOpacity[index] * breathingGlow,
                        pulseProgress: pulseProgress,
                        size: geometry.size,
                        pointRadius: getCurrentRadius(for: startIdx),
                        endRadius: getCurrentRadius(for: endIdx)
                    )
                }
                
                // Points - soft points with subtle halos
                ForEach(0..<pointCount, id: \.self) { index in
                    LuminousPoint(
                        index: index,
                        opacity: pointsOpacity[index] * breathingGlow,
                        size: geometry.size,
                        pointRadius: getCurrentRadius(for: index)
                    )
                }
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func getCurrentRadius(for index: Int) -> CGFloat {
        return CGFloat(pointsRadius[index])
    }
    
    private func startAnimation() {
        // If reduce motion is enabled, skip to final state immediately
        if reduceMotion {
            // Show static final blueprint state
            for i in 0..<pointCount {
                pointsOpacity[i] = 1.0
                pointsRadius[i] = Double(finalRadius)
            }
            for i in 0..<connectionOrder.count {
                lineProgress[i] = 1.0
                linesOpacity[i] = 1.0
            }
            phase = 3
            onPhaseChange?(3, phaseSubtitles[2])  // "Forming your unique blueprint"
            onFormationComplete?()
            return
        }
        
        // PHASE 1 - Awareness (0.0s - 0.8s)
        // Points fade in gently, no movement
        onPhaseChange?(0, phaseSubtitles[0])
        
        for i in 0..<pointCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.08) {
                withAnimation(.easeOut(duration: 0.4)) {
                    pointsOpacity[i] = 1.0
                }
            }
        }
        
        // PHASE 2 - Gathering (0.8s - 2.4s)
        // Points move inward slowly, lines appear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            phase = 1
            onPhaseChange?(1, phaseSubtitles[1])
            onGatheringStart?()
            
            // Points move inward
            let moveDuration: Double = 1.6  // 2.4s - 0.8s
            withAnimation(.easeInOut(duration: moveDuration)) {
                for i in 0..<pointCount {
                    pointsRadius[i] = Double(finalRadius)
                }
            }
            
            // Lines appear sequentially
            let lineCount = connectionOrder.count
            let lineAppearDuration: Double = moveDuration / Double(lineCount)
            
            for i in 0..<lineCount {
                let lineStartTime = Double(i) * lineAppearDuration
                
                DispatchQueue.main.asyncAfter(deadline: .now() + lineStartTime) {
                    withAnimation(.easeInOut(duration: lineAppearDuration * 0.6)) {
                        linesOpacity[i] = 1.0
                    }
                    
                    withAnimation(.easeInOut(duration: lineAppearDuration * 0.8)) {
                        lineProgress[i] = 1.0
                    }
                }
            }
        }
        
        // PHASE 3 - Formation (2.4s - 3.6s)
        // Lines settle, pulse passes through
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            phase = 2
            onPhaseChange?(2, phaseSubtitles[2])
            
            // Pulse passes through structure once
            withAnimation(.easeInOut(duration: 0.8)) {
                pulseProgress = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeOut(duration: 0.4)) {
                    pulseProgress = 0.0
                }
            }
        }
        
        // PHASE 4 - Stability (3.6s+)
        // Structure remains stable, breathing glow
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.6) {
            phase = 3
            onPhaseChange?(3, phaseSubtitles[3])
            onFormationComplete?()
            startBreathingGlow()
        }
    }
    
    private func startBreathingGlow() {
        // Extremely subtle breathing glow - opacity shift only, no movement
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            breathingGlow = 0.95  // Very subtle breathing (5% variation)
        }
    }
}

// MARK: - Luminous Point View
struct LuminousPoint: View {
    let index: Int
    let opacity: Double
    let size: CGSize
    let pointRadius: CGFloat
    
    // Point positions (arranged in balanced pattern around center)
    private var positions: [(angle: Double, radius: CGFloat)] {
        let angles = [
            0.0,           // Right
            .pi * 0.3,     // Upper right
            .pi * 0.6,     // Top right
            .pi * 0.9,     // Top
            .pi * 1.2,     // Top left
            .pi * 1.5,     // Left
            .pi * 1.8,     // Bottom left
            .pi * 2.1,     // Bottom
            .pi * 2.4,     // Bottom right
            .pi * 2.7      // Lower right
        ]
        return angles.map { (angle: $0, radius: pointRadius) }
    }
    
    var body: some View {
        let pos = positions[index % positions.count]
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let baseRadius = min(size.width, size.height) * pos.radius
        
        let x = center.x + cos(pos.angle) * baseRadius
        let y = center.y + sin(pos.angle) * baseRadius
        
        ZStack {
            // Outer glow (subtle halo)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            ArotiColor.accent.opacity(0.25 * opacity),
                            ArotiColor.accent.opacity(0.12 * opacity),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 2,
                        endRadius: 10
                    )
                )
                .frame(width: 20, height: 20)
                .blur(radius: 1.5)
            
            // Main point
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            ArotiColor.accent.opacity(0.9 * opacity),
                            ArotiColor.accent.opacity(0.7 * opacity),
                            ArotiColor.accent.opacity(0.5 * opacity),
                            ArotiColor.accent.opacity(0.2 * opacity)
                        ],
                        center: .center,
                        startRadius: 1,
                        endRadius: 5
                    )
                )
                .frame(width: 5, height: 5)
        }
        .position(x: x, y: y)
    }
}

// MARK: - Blueprint Line Shape
struct BlueprintLineShape: Shape {
    let startIndex: Int
    let endIndex: Int
    var progress: Double
    var pulseProgress: Double
    
    let size: CGSize
    let pointRadius: CGFloat
    let endRadius: CGFloat
    
    // Point positions (same as LuminousPoint)
    private var positions: [(angle: Double, radius: CGFloat)] {
        let angles = [
            0.0, .pi * 0.3, .pi * 0.6, .pi * 0.9, .pi * 1.2,
            .pi * 1.5, .pi * 1.8, .pi * 2.1, .pi * 2.4, .pi * 2.7
        ]
        return angles.map { (angle: $0, radius: pointRadius) }
    }
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(progress, pulseProgress) }
        set {
            progress = newValue.first
            pulseProgress = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let startPos = positions[startIndex % positions.count]
        let endPos = positions[endIndex % positions.count]
        
        let startBaseRadius = min(size.width, size.height) * pointRadius
        let endBaseRadius = min(size.width, size.height) * endRadius
        
        let startX = center.x + cos(startPos.angle) * startBaseRadius
        let startY = center.y + sin(startPos.angle) * startBaseRadius
        let endX = center.x + cos(endPos.angle) * endBaseRadius
        let endY = center.y + sin(endPos.angle) * endBaseRadius
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        return path.trimmedPath(from: 0, to: progress)
    }
}

// MARK: - Blueprint Line View
struct BlueprintLine: View {
    let startIndex: Int
    let endIndex: Int
    var progress: Double
    var opacity: Double
    var pulseProgress: Double
    
    let size: CGSize
    let pointRadius: CGFloat
    let endRadius: CGFloat
    
    var body: some View {
        BlueprintLineShape(
            startIndex: startIndex,
            endIndex: endIndex,
            progress: progress,
            pulseProgress: pulseProgress,
            size: size,
            pointRadius: pointRadius,
            endRadius: endRadius
        )
        .stroke(
            LinearGradient(
                colors: [
                    ArotiColor.accent.opacity(0.85 * opacity * (1.0 + pulseProgress * 0.2)),
                    ArotiColor.accent.opacity(0.7 * opacity * (1.0 + pulseProgress * 0.2)),
                    ArotiColor.accent.opacity(0.55 * opacity * (1.0 + pulseProgress * 0.2))
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            style: StrokeStyle(
                lineWidth: 1.2 + (pulseProgress * 0.3),
                lineCap: .round,
                lineJoin: .round
            )
        )
        .shadow(
            color: ArotiColor.accent.opacity(0.25 * progress * opacity * (1.0 + pulseProgress * 0.3)),
            radius: 1.5 + (pulseProgress * 1.5),
            x: 0,
            y: 0
        )
    }
}

#Preview {
    MappingBlueprintHero()
        .frame(height: 400)
        .background(CelestialBackground())
}
