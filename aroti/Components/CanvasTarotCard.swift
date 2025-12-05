//
//  CanvasTarotCard.swift
//  Aroti
//
//  Tarot card component optimized for canvas display
//

import SwiftUI

struct CanvasTarotCard: View {
    let readingCard: ReadingCard
    let position: CardPosition
    let onFlip: () -> Void
    let onViewDetails: () -> Void
    let showPositionLabel: Bool
    
    @State private var isPressed = false
    
    init(
        readingCard: ReadingCard,
        position: CardPosition,
        showPositionLabel: Bool = false,
        onFlip: @escaping () -> Void,
        onViewDetails: @escaping () -> Void
    ) {
        self.readingCard = readingCard
        self.position = position
        self.showPositionLabel = showPositionLabel
        self.onFlip = onFlip
        self.onViewDetails = onViewDetails
    }
    
    var body: some View {
        Button(action: {
            if !readingCard.isFlipped {
                onFlip()
            } else {
                onViewDetails()
            }
        }) {
            ZStack {
                if readingCard.isFlipped {
                    // Card Front
                    cardFront
                } else {
                    // Card Back
                    TarotCardBack()
                        .frame(width: TarotSpreadCardLayout.width, height: TarotSpreadCardLayout.height)
                }
                
                // Position label overlay (shown when zoomed in)
                if showPositionLabel && readingCard.isFlipped {
                    VStack {
                        HStack {
                            Text("\(readingCard.position.id). \(readingCard.position.title)")
                                .font(DesignTypography.caption1Font(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.7))
                                        .overlay(
                                            Capsule()
                                                .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                        )
                                )
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(8)
                }
            }
            .frame(width: TarotSpreadCardLayout.width, height: TarotSpreadCardLayout.height)
            .rotationEffect(position.rotation)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
    
    private var cardFront: some View {
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
                        .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                )
            
            // Decorative border patterns
            RoundedRectangle(cornerRadius: 10)
                .stroke(DesignColors.accent.opacity(0.2), lineWidth: 1)
                .padding(8)
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(DesignColors.accent.opacity(0.1), lineWidth: 1)
                .padding(12)
            
            // Card image or placeholder
            if let imageName = readingCard.card.imageName,
               let image = UIImage(named: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(16)
            } else {
                // Fallback placeholder
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundColor(DesignColors.accent)
            }
        }
        .frame(width: TarotSpreadCardLayout.width, height: TarotSpreadCardLayout.height)
    }
}

