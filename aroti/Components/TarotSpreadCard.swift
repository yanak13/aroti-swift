//
//  TarotSpreadCard.swift
//  Aroti
//
//  Reusable tarot spread card component with card back visual design
//

import SwiftUI

enum TarotSpreadCardLayout {
    static let defaultWidth: CGFloat = 180
    static let defaultHeight: CGFloat = 300
}

struct TarotSpreadCard: View {
    let name: String
    let cardCount: Int
    let width: CGFloat?
    let height: CGFloat?
    let microDescriptor: String?
    let time: String?
    let depth: String?
    let isForYou: Bool
    let ctaText: String?
    let isFirstCard: Bool
    let action: (() -> Void)?
    
    @State private var isPressed = false
    @State private var sigilScale: CGFloat = 1.0
    @State private var ctaOpacity: Double = 1.0
    
    init(
        name: String,
        cardCount: Int,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        microDescriptor: String? = nil,
        time: String? = nil,
        depth: String? = nil,
        isForYou: Bool = false,
        ctaText: String? = nil,
        isFirstCard: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.name = name
        self.cardCount = cardCount
        self.width = width
        self.height = height
        self.microDescriptor = microDescriptor
        self.time = time
        self.depth = depth
        self.isForYou = isForYou
        self.ctaText = ctaText
        self.isFirstCard = isFirstCard
        self.action = action
    }
    
    private var cardWidth: CGFloat {
        width ?? TarotSpreadCardLayout.defaultWidth
    }
    
    private var cardHeight: CGFloat {
        height ?? TarotSpreadCardLayout.defaultHeight
    }
    
    // Visual differentiation: first card lighter, deeper spreads darker
    private var backgroundOpacity: Double {
        isFirstCard ? 0.75 : 0.85
    }
    
    private var glowIntensity: Double {
        isFirstCard ? 0.15 : 0.25
    }
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: {
                    // Trigger animation on button press
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPressed = true
                        sigilScale = 1.03
                        ctaOpacity = 0.7
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPressed = false
                            sigilScale = 1.0
                            ctaOpacity = 1.0
                        }
                    }
                    action()
                }) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                cardContent
            }
        }
        .shadow(color: Color.black.opacity(0.45), radius: 8, x: 0, y: 2)
    }
    
    private var cardContent: some View {
        ZStack {
            // Card background with gradient (differentiated by isFirstCard)
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hue: 235/360, saturation: 0.30, brightness: isFirstCard ? 0.13 : 0.11),
                            Color(hue: 240/360, saturation: 0.28, brightness: isFirstCard ? 0.15 : 0.13)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(backgroundOpacity)
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
            
            // Content layout
            VStack(alignment: .leading, spacing: 0) {
                // Chips in top-left (max 2-3, single row)
                HStack(spacing: 6) {
                    if let time = time {
                        CardChip(text: time, type: .base)
                    }
                    if let depth = depth {
                        CardChip(text: depth, type: .base)
                    }
                    if isForYou {
                        CardChip(text: "For you", type: .forYou)
                    }
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.leading, 12)
                .padding(.bottom, 10) // 8-12px spacing to title
                
                Spacer()
                
                // Central circular tarot card design (sigil) - increased contrast and subtle glow
                ZStack {
                    // Outer ring - increased contrast
                    Circle()
                        .stroke(ArotiColor.accent.opacity(0.5), lineWidth: 1.5)
                        .frame(width: 80, height: 80)
                        .shadow(color: ArotiColor.accent.opacity(glowIntensity), radius: 8, x: 0, y: 0)
                    
                    // Inner ring
                    Circle()
                        .stroke(ArotiColor.accent.opacity(0.4), lineWidth: 1)
                        .frame(width: 64, height: 64)
                    
                    // Central pattern - increased contrast
                    ZStack {
                        Circle()
                            .stroke(ArotiColor.accent.opacity(0.6), lineWidth: 1.5)
                            .frame(width: 32, height: 32)
                        
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.4))
                            .frame(width: 16, height: 16)
                        
                        // Radiating lines
                        VStack {
                            Rectangle()
                                .fill(ArotiColor.accent.opacity(0.5))
                                .frame(width: 1.5, height: 4)
                            Spacer()
                            Rectangle()
                                .fill(ArotiColor.accent.opacity(0.5))
                                .frame(width: 1.5, height: 4)
                        }
                        .frame(width: 32, height: 32)
                        
                        HStack {
                            Rectangle()
                                .fill(ArotiColor.accent.opacity(0.5))
                                .frame(width: 4, height: 1.5)
                            Spacer()
                            Rectangle()
                                .fill(ArotiColor.accent.opacity(0.5))
                                .frame(width: 4, height: 1.5)
                        }
                        .frame(width: 32, height: 32)
                    }
                    
                    // Decorative dots around pattern
                    VStack {
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.6))
                            .frame(width: 4, height: 4)
                            .offset(y: -44)
                        Spacer()
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.6))
                            .frame(width: 4, height: 4)
                            .offset(y: 44)
                    }
                    
                    HStack {
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.6))
                            .frame(width: 4, height: 4)
                            .offset(x: -44)
                        Spacer()
                        Circle()
                            .fill(ArotiColor.accent.opacity(0.6))
                            .frame(width: 4, height: 4)
                            .offset(x: 44)
                    }
                }
                .scaleEffect(sigilScale)
                .shadow(color: ArotiColor.accent.opacity(glowIntensity * 1.5), radius: 12, x: 0, y: 0)
                
                Spacer()
                
                // Title and micro-descriptor
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(ArotiTextStyle.headline.weight(.medium))
                        .foregroundColor(ArotiColor.textPrimary)
                        .lineLimit(2)
                    
                    if let microDescriptor = microDescriptor {
                        Text(microDescriptor)
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textSecondary)
                            .lineLimit(2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                
                // Micro CTA in bottom-right
                if let ctaText = ctaText {
                    HStack {
                        Spacer()
                        Text(ctaText)
                            .font(ArotiTextStyle.caption1.weight(.medium))
                            .foregroundColor(ArotiColor.textSecondary.opacity(0.9))
                            .opacity(ctaOpacity)
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
            }
            .frame(width: cardWidth, height: cardHeight)
            
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
            
            // Mystical aura effect - differentiated by isFirstCard
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            ArotiColor.accent.opacity(glowIntensity),
                            Color.clear,
                            ArotiColor.accent.opacity(glowIntensity)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(0.3)
        }
        .frame(width: cardWidth, height: cardHeight)
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

