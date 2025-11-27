//
//  TarotCardBack.swift
//  Aroti
//
//  Tarot card back visual component
//

import SwiftUI

struct TarotCardBack: View {
    var body: some View {
        ZStack {
            // Card background
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
            
            // Decorative pattern
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
    }
}

#Preview {
    TarotCardBack()
        .frame(width: 80, height: 128)
}

