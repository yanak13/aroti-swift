//
//  FloatingParticles.swift
//  Aroti
//
//  Atmospheric floating particles for premium onboarding
//

import SwiftUI

struct FloatingParticles: View {
    @State private var particles: [ParticleView] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                particle
            }
        }
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        particles = (0..<10).map { index in
            ParticleView(
                x: Double.random(in: 0...screenWidth),
                y: Double.random(in: 0...screenHeight),
                size: Double.random(in: 2...5),
                opacity: Double.random(in: 0.2...0.4),
                duration: Double.random(in: 8...15)
            )
        }
    }
}

struct ParticleView: View, Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
    let size: Double
    let opacity: Double
    let duration: Double
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(self.opacity * 0.4),
                        ArotiColor.accent.opacity(self.opacity * 0.1),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 1,
                    endRadius: self.size
                )
            )
            .frame(width: self.size * 2, height: self.size * 2)
            .position(x: x, y: y + offset)
            .blur(radius: 0.5)
            .opacity(self.opacity)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    offset = -UIScreen.main.bounds.height - 100
                }
            }
    }
}
