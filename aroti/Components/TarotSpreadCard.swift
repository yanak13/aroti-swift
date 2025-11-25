//
//  TarotSpreadCard.swift
//  Aroti
//
//  Reusable tarot spread card component with card back visual design
//

import SwiftUI

enum TarotSpreadCardLayout {
    static let width: CGFloat = 180
    static let height: CGFloat = 300
}

struct TarotSpreadCard: View {
    let name: String
    let cardCount: Int
    let action: (() -> Void)?
    
    init(
        name: String,
        cardCount: Int,
        action: (() -> Void)? = nil
    ) {
        self.name = name
        self.cardCount = cardCount
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            ZStack {
                // Card background with gradient
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
                
                // Decorative border with accent
                RoundedRectangle(cornerRadius: 10)
                    .stroke(ArotiColor.accent.opacity(0.2), lineWidth: 1)
                    .padding(8)
                    .opacity(0.6)
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ArotiColor.accent.opacity(0.1), lineWidth: 1)
                    .padding(12)
                    .opacity(0.4)
                
                // Corner decorative elements
                VStack {
                    HStack {
                        cornerDot
                        Spacer()
                        cornerDot
                    }
                    Spacer()
                    HStack {
                        cornerDot
                        Spacer()
                        cornerDot
                    }
                }
                .padding(8)
                
                // Central circular tarot card design
                ZStack {
                    // Outer ring
                    Circle()
                        .stroke(ArotiColor.accent.opacity(0.3), lineWidth: 1)
                        .frame(width: 80, height: 80)
                    
                    // Inner ring
                    Circle()
                        .stroke(ArotiColor.accent.opacity(0.2), lineWidth: 1)
                        .frame(width: 64, height: 64)
                    
                    // Central pattern
                    ZStack {
                        Circle()
                            .stroke(ArotiColor.accent.opacity(0.4), lineWidth: 1)
                            .frame(width: 32, height: 32)
                        
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.3))
                            .frame(width: 16, height: 16)
                        
                        // Radiating lines
                        VStack {
                            Rectangle()
                                .fill(ArotiColor.accent.opacity(0.4))
                                .frame(width: 1, height: 4)
                            Spacer()
                            Rectangle()
                                .fill(ArotiColor.accent.opacity(0.4))
                                .frame(width: 1, height: 4)
                        }
                        .frame(width: 32, height: 32)
                        
                        HStack {
                            Rectangle()
                                .fill(ArotiColor.accent.opacity(0.4))
                                .frame(width: 4, height: 1)
                            Spacer()
                            Rectangle()
                                .fill(ArotiColor.accent.opacity(0.4))
                                .frame(width: 4, height: 1)
                        }
                        .frame(width: 32, height: 32)
                    }
                    
                    // Decorative dots around pattern
                    VStack {
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.5))
                            .frame(width: 4, height: 4)
                            .offset(y: -44)
                        Spacer()
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.5))
                            .frame(width: 4, height: 4)
                            .offset(y: 44)
                    }
                    
                    HStack {
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.5))
                            .frame(width: 4, height: 4)
                            .offset(x: -44)
                        Spacer()
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.5))
                            .frame(width: 4, height: 4)
                            .offset(x: 44)
                    }
                }
                
                // Title overlay at bottom with gradient
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(name)
                            .font(ArotiTextStyle.headline.weight(.medium))
                            .foregroundColor(ArotiColor.textPrimary)
                            .lineLimit(1)
                        
                        Text("\(cardCount) cards")
                            .font(ArotiTextStyle.caption2)
                            .foregroundColor(ArotiColor.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.9),
                                Color.black.opacity(0.7),
                                Color.clear
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
                
                // Subtle texture overlay
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.01),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Mystical aura effect
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.05),
                                Color.clear,
                                ArotiColor.accent.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(0.3)
            }
            .frame(width: TarotSpreadCardLayout.width, height: TarotSpreadCardLayout.height)
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(color: Color.black.opacity(0.45), radius: 8, x: 0, y: 2)
    }
    
    private var cornerDot: some View {
        Circle()
            .stroke(ArotiColor.accent.opacity(0.3), lineWidth: 1)
            .frame(width: 8, height: 8)
            .overlay(
                Circle()
                    .fill(ArotiColor.accent.opacity(0.5))
                    .frame(width: 2, height: 2)
            )
    }
}

