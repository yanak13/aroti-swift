//
//  StaticDeckView.swift
//  Aroti
//
//  Static fanned deck view that never moves or animates
//

import SwiftUI

struct StaticDeckView: View {
    let visibleCount: Int = 6
    let opacity: Double
    
    init(opacity: Double = 1.0) {
        self.opacity = opacity
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<visibleCount, id: \.self) { index in
                // Subtle fan offsets
                let horizontalOffset = CGFloat(index) * 10
                let verticalOffset = CGFloat(index) * 5
                let rotation = Double(index) * 1.5
                
                // Card styling - match app's tarot card style
                ZStack {
                    // Card background with dark gradient
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hue: 235/360, saturation: 0.30, brightness: 0.11),
                                    Color(hue: 240/360, saturation: 0.28, brightness: 0.13)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(
                            color: Color.black.opacity(0.3),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                    
                    // Decorative pattern (same as TarotCardBack)
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                            Spacer()
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                            Spacer()
                            Circle()
                                .fill(ArotiColor.accent.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(12)
                }
                .frame(width: 200, height: 320)
                .offset(
                    x: horizontalOffset,
                    y: verticalOffset
                )
                .rotationEffect(.degrees(rotation))
                .opacity((0.4 + 0.08 * Double(index)) * opacity)
                .scaleEffect(0.98 + 0.003 * CGFloat(index))
                .shadow(
                    color: .black.opacity(0.4 + Double(index) * 0.02),
                    radius: 12 + CGFloat(index) * 0.5,
                    x: 0,
                    y: 8 + CGFloat(index) * 0.5
                )
            }
        }
        .frame(width: 220, height: 340)
    }
    
    // Helper to get the transform of the center card (index 3)
    static func centerCardTransform() -> (offset: CGSize, rotation: Double) {
        let index = 3 // center card in the fan
        let horizontalOffset = CGFloat(index) * 10
        let verticalOffset = CGFloat(index) * 5
        let rotation = Double(index) * 1.5
        
        return (CGSize(width: horizontalOffset, height: verticalOffset), rotation)
    }
}

#Preview {
    StaticDeckView()
        .padding()
        .background(CelestialBackground())
}

