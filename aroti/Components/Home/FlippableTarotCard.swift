//
//  FlippableTarotCard.swift
//  Aroti
//
//  Tarot card with 3D flip animation for the ritual carousel
//

import SwiftUI

// MARK: - Tarot State
enum TarotState: Equatable {
    case choosing
    case revealing
    case revealed(cardId: String)
    
    var isChoosing: Bool { self == .choosing }
    var isRevealing: Bool { self == .revealing }
    var isRevealed: Bool {
        if case .revealed = self { return true }
        return false
    }
    
    var revealedCardId: String? {
        if case .revealed(let cardId) = self { return cardId }
        return nil
    }
}

// MARK: - Flippable Tarot Card
struct FlippableTarotCard: View {
    let card: TarotCard
    let isRevealed: Bool
    let isCentered: Bool
    let scale: CGFloat
    let opacity: Double
    
    @State private var flipProgress: CGFloat = 0
    @State private var liftOffset: CGFloat = 0
    @State private var liftScale: CGFloat = 1.0
    @State private var sweepProgress: CGFloat = 0
    
    private let cardWidth: CGFloat = 340
    private let cardHeight: CGFloat = 510
    
    var body: some View {
        ZStack {
            // Show back when flip < 0.5, front when >= 0.5
            if flipProgress < 0.5 {
                cardBackView
            } else {
                cardFrontView
                    .scaleEffect(x: -1, y: 1) // Mirror to correct orientation after flip
            }
            
            // Sweep overlay during flip
            if sweepProgress > 0 && sweepProgress < 1 {
                sweepOverlay
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .scaleEffect(liftScale * scale)
        .offset(y: liftOffset)
        .opacity(opacity)
        .rotation3DEffect(
            .degrees(Double(flipProgress) * 180),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .onChange(of: isRevealed) { _, newValue in
            if newValue {
                performRevealAnimation()
            }
        }
    }
    
    // MARK: - Sweep Overlay
    private var sweepOverlay: some View {
        GeometryReader { geometry in
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.white.opacity(0.3),
                    Color.white.opacity(0.5),
                    Color.white.opacity(0.3),
                    Color.clear
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 60)
            .offset(x: -30 + (geometry.size.width + 60) * sweepProgress)
            .blur(radius: 10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Card Back View
    private var cardBackView: some View {
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
            
            // Copper stroke border
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [
                            DesignColors.accent.opacity(0.6),
                            DesignColors.accent.opacity(0.3),
                            DesignColors.accent.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
            
            // Inner decorative border
            RoundedRectangle(cornerRadius: 10)
                .stroke(DesignColors.accent.opacity(0.15), lineWidth: 1)
                .padding(6)
            
            // Center decorative pattern
            VStack(spacing: 8) {
                // Top ornament
                Image(systemName: "sparkle")
                    .font(.system(size: 16))
                    .foregroundColor(DesignColors.accent.opacity(0.4))
                
                // Center symbol
                Image(systemName: "suit.spade.fill")
                    .font(.system(size: 32))
                    .foregroundColor(DesignColors.accent.opacity(0.5))
                
                // Bottom ornament
                Image(systemName: "sparkle")
                    .font(.system(size: 16))
                    .foregroundColor(DesignColors.accent.opacity(0.4))
            }
            
            // Corner decorations
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
            .padding(14)
            
            // Glow effect for centered card
            if isCentered {
                RoundedRectangle(cornerRadius: 12)
                    .fill(DesignColors.accent.opacity(0.05))
                    .blur(radius: 20)
                    .scaleEffect(1.1)
            }
        }
        .shadow(color: Color.black.opacity(isCentered ? 0.4 : 0.2), radius: isCentered ? 12 : 6, x: 0, y: 4)
    }
    
    private var cornerDot: some View {
        Circle()
            .fill(DesignColors.accent.opacity(0.3))
            .frame(width: 6, height: 6)
    }
    
    // MARK: - Card Front View
    private var cardFrontView: some View {
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
            
            // Copper stroke border
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [
                            DesignColors.accent.opacity(0.6),
                            DesignColors.accent.opacity(0.3),
                            DesignColors.accent.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
            
            // Inner decorative borders
            RoundedRectangle(cornerRadius: 10)
                .stroke(DesignColors.accent.opacity(0.2), lineWidth: 1)
                .padding(6)
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(DesignColors.accent.opacity(0.1), lineWidth: 1)
                .padding(10)
            
            // Card content
            VStack(spacing: 12) {
                Spacer()
                
                // Card icon/silhouette
                Image(systemName: getCardIcon())
                    .font(.system(size: 48))
                    .foregroundColor(DesignColors.accent)
                    .shadow(color: DesignColors.accent.opacity(0.5), radius: 8, x: 0, y: 0)
                
                Spacer()
                
                // Card name
                Text(card.name)
                    .font(DesignTypography.footnoteFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
            }
            .padding(.vertical, 16)
            
            // Glow effect
            RoundedRectangle(cornerRadius: 12)
                .fill(DesignColors.accent.opacity(0.08))
                .blur(radius: 20)
                .scaleEffect(1.1)
        }
        .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 4)
    }
    
    // MARK: - Animation
    private func performRevealAnimation() {
        // Step 1: Lift the card
        withAnimation(.easeOut(duration: 0.12)) {
            liftScale = 1.03
            liftOffset = -8
        }
        
        // Step 2: Flip the card with sweep
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            HapticFeedback.impactOccurred(.medium)
            
            // Start sweep animation
            withAnimation(.easeInOut(duration: 0.32)) {
                sweepProgress = 1.0
            }
            
            // Flip animation
            withAnimation(.easeInOut(duration: 0.32)) {
                flipProgress = 1.0
            }
        }
        
        // Step 3: Settle back and clear sweep
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.44) {
            withAnimation(.spring(response: 0.15, dampingFraction: 0.8)) {
                liftScale = 1.0
                liftOffset = 0
            }
            
            // Reset sweep
            sweepProgress = 0
            
            HapticFeedback.impactOccurred(.light)
        }
    }
    
    private func getCardIcon() -> String {
        // Map card names to appropriate SF Symbols
        switch card.id {
        case "fool": return "figure.walk"
        case "magician": return "wand.and.stars"
        case "priestess": return "moon.stars"
        case "empress": return "crown"
        case "emperor": return "building.columns"
        case "hierophant": return "book.closed"
        case "lovers": return "heart.fill"
        case "chariot": return "car.fill"
        case "strength": return "lion"
        case "hermit": return "flashlight.on.fill"
        case "wheel": return "circle.hexagongrid"
        case "justice": return "scalemass"
        case "hanged": return "figure.stand"
        case "death": return "leaf"
        case "temperance": return "drop.triangle"
        case "devil": return "flame"
        case "tower": return "bolt.fill"
        case "star": return "star.fill"
        case "moon": return "moon.fill"
        case "sun": return "sun.max.fill"
        case "judgement": return "horn.blast"
        case "world": return "globe"
        default: return "sparkles"
        }
    }
}

#Preview {
    ZStack {
        CelestialBackground()
        
        FlippableTarotCard(
            card: TarotCard(
                id: "world",
                name: "The World",
                keywords: ["Completion", "Achievement", "Fulfillment"],
                interpretation: "A cycle completes",
                guidance: nil,
                imageName: nil
            ),
            isRevealed: false,
            isCentered: true,
            scale: 1.0,
            opacity: 1.0
        )
    }
}

