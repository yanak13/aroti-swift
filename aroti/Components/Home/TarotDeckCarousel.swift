//
//  TarotDeckCarousel.swift
//  Aroti
//
//  Swipeable tarot deck carousel showing fanned card backs
//

import SwiftUI

struct TarotDeckCarousel: View {
    let cards: [TarotCard]
    let onCardSelected: (TarotCard) -> Void
    
    @State private var currentIndex: Int = 0
    @State private var scrollOffset: CGFloat = 0
    
    private let cardWidth: CGFloat = 200
    private let cardHeight: CGFloat = 320
    private let cardSpacing: CGFloat = 16
    private let visibleCards: Int = 5 // Show 5 cards at a time
    
    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            
            VStack(spacing: 16) {
                // Title
                Text("Today's Tarot Card")
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Text("Tap to reveal your card")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                // Deck Carousel
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: cardSpacing) {
                            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                                ZStack {
                                    // Card back with fanned effect
                                    TarotCardBack()
                                        .frame(width: cardWidth, height: cardHeight)
                                        .scaleEffect(scaleForCard(at: index, containerWidth: containerWidth))
                                        .opacity(opacityForCard(at: index, containerWidth: containerWidth))
                                        .rotationEffect(.degrees(rotationForCard(at: index, containerWidth: containerWidth)))
                                        .offset(x: offsetXForCard(at: index, containerWidth: containerWidth))
                                        .shadow(
                                            color: .black.opacity(0.3),
                                            radius: 12,
                                            x: 0,
                                            y: 8
                                        )
                                }
                                .frame(width: cardWidth + cardSpacing)
                                .id(index)
                                .onTapGesture {
                                    selectCard(card, at: index)
                                }
                            }
                        }
                        .padding(.horizontal, (containerWidth - cardWidth) / 2)
                        .background(
                            GeometryReader { scrollGeometry in
                                Color.clear
                                    .preference(key: TarotScrollOffsetPreferenceKey.self, value: scrollGeometry.frame(in: .named("scroll")).minX)
                            }
                        )
                    }
                    .coordinateSpace(name: "scroll")
                    .scrollTargetBehavior(.paging)
                    .onPreferenceChange(TarotScrollOffsetPreferenceKey.self) { value in
                        scrollOffset = value
                        updateCurrentIndex(from: value, containerWidth: containerWidth)
                    }
                }
                .frame(height: cardHeight + 40)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 420)
    }
    
    private func scaleForCard(at index: Int, containerWidth: CGFloat) -> CGFloat {
        let centerIndex = currentIndex
        let distance = abs(index - centerIndex)
        
        if distance == 0 {
            return 1.0
        } else if distance == 1 {
            return 0.92
        } else if distance == 2 {
            return 0.85
        } else {
            return max(0.75, 1.0 - CGFloat(distance) * 0.08)
        }
    }
    
    private func opacityForCard(at index: Int, containerWidth: CGFloat) -> CGFloat {
        let centerIndex = currentIndex
        let distance = abs(index - centerIndex)
        
        if distance == 0 {
            return 1.0
        } else if distance == 1 {
            return 0.8
        } else if distance == 2 {
            return 0.6
        } else {
            return max(0.4, 1.0 - CGFloat(distance) * 0.15)
        }
    }
    
    private func rotationForCard(at index: Int, containerWidth: CGFloat) -> Double {
        let centerIndex = currentIndex
        let offset = Double(index - centerIndex) * 2.0 // Max 2 degrees per card
        return offset
    }
    
    private func offsetXForCard(at index: Int, containerWidth: CGFloat) -> CGFloat {
        let centerIndex = currentIndex
        let offset = CGFloat(index - centerIndex) * 8.0 // Small horizontal offset for fan effect
        return offset
    }
    
    private func updateCurrentIndex(from offset: CGFloat, containerWidth: CGFloat) {
        let cardWithSpacing = cardWidth + cardSpacing
        let newIndex = Int(round(-offset / cardWithSpacing))
        let clampedIndex = max(0, min(newIndex, cards.count - 1))
        
        if clampedIndex != currentIndex {
            currentIndex = clampedIndex
            HapticFeedback.impactOccurred(.light)
        }
    }
    
    private func selectCard(_ card: TarotCard, at index: Int) {
        HapticFeedback.impactOccurred(.medium)
        onCardSelected(card)
    }
}

// Preference key for scroll offset tracking
struct TarotScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    TarotDeckCarousel(
        cards: DailyContentService.shared.getAllTarotCards().prefix(10).map { $0 },
        onCardSelected: { card in
            print("Selected: \(card.name)")
        }
    )
    .padding()
    .background(CelestialBackground())
}

