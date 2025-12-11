//
//  GeneratingBlueprintHero.swift
//
//  Complex constellation pattern with connecting lines
//

import SwiftUI

struct GeneratingBlueprintHero: View {
    @State private var nodesProgress: Double = 0
    @State private var connectionsProgress: Double = 0
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
                
                // Complex blueprint pattern
                BlueprintPatternShape(
                    nodesProgress: nodesProgress,
                    connectionsProgress: connectionsProgress
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
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                )
                .scaleEffect(breathingScale)
                .shadow(color: ArotiColor.accent.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                .blur(radius: 0.5)
            }
        }
        .onAppear {
            // Draw nodes first
            withAnimation(.easeInOut(duration: 1.5)) {
                nodesProgress = 1.0
            }
            
            // Then connect them
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 2.0)) {
                    connectionsProgress = 1.0
                }
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

struct BlueprintPatternShape: Shape {
    var nodesProgress: Double
    var connectionsProgress: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.35
        
        // Create nodes in a pattern
        let nodeCount = 6
        var nodes: [CGPoint] = []
        
        for i in 0..<nodeCount {
            let angle = Double(i) * 2 * .pi / Double(nodeCount) - .pi / 2
            let node = CGPoint(
                x: center.x + radius * cos(angle) * nodesProgress,
                y: center.y + radius * sin(angle) * nodesProgress
            )
            nodes.append(node)
            
            // Draw node circle
            if nodesProgress > 0 {
                let nodeRadius = radius * 0.08 * nodesProgress
                path.addEllipse(in: CGRect(
                    x: node.x - nodeRadius,
                    y: node.y - nodeRadius,
                    width: nodeRadius * 2,
                    height: nodeRadius * 2
                ))
            }
        }
        
        // Connect nodes
        if connectionsProgress > 0 {
            for i in 0..<nodeCount {
                let nextIndex = (i + 1) % nodeCount
                path.move(to: nodes[i])
                
                let midX = nodes[i].x + (nodes[nextIndex].x - nodes[i].x) * connectionsProgress
                let midY = nodes[i].y + (nodes[nextIndex].y - nodes[i].y) * connectionsProgress
                path.addLine(to: CGPoint(x: midX, y: midY))
            }
        }
        
        return path
    }
}
