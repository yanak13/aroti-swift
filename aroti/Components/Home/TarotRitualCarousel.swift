//
//  TarotRitualCarousel.swift
//  Aroti
//
//  Horizontal carousel of tarot cards with snap-to-center paging
//

import SwiftUI

struct TarotRitualCarousel: View {
    let cards: [TarotCard]
    @Binding var selectedIndex: Int
    @Binding var tarotState: TarotState
    let onCardTap: (TarotCard) -> Void
    
    private let cardWidth: CGFloat = 340
    private let cardHeight: CGFloat = 510
    private let cardSpacing: CGFloat = 16
    
    @State private var scrollPosition: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            let horizontalPadding = (containerWidth - cardWidth) / 2
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: cardSpacing) {
                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                        let isCentered = index == (scrollPosition ?? selectedIndex)
                        let isRevealed = tarotState.revealedCardId == card.id
                        
                        FlippableTarotCard(
                            card: card,
                            isRevealed: isRevealed,
                            isCentered: isCentered,
                            scale: scaleForCard(at: index),
                            opacity: opacityForCard(at: index)
                        )
                        .frame(width: cardWidth, height: cardHeight)
                        .id(index)
                        .onTapGesture {
                            if tarotState.isChoosing && isCentered {
                                onCardTap(card)
                            } else if tarotState.isChoosing && !isCentered {
                                // Scroll to tapped card
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    scrollPosition = index
                                    selectedIndex = index
                                }
                                HapticFeedback.impactOccurred(.light)
                            }
                        }
                        .allowsHitTesting(tarotState.isChoosing || (tarotState.isRevealed && isCentered))
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .scrollDisabled(!tarotState.isChoosing)
            .onChange(of: scrollPosition) { oldValue, newValue in
                if let newIndex = newValue, newIndex != selectedIndex {
                    selectedIndex = newIndex
                    HapticFeedback.impactOccurred(.light)
                }
            }
            .onAppear {
                // Set initial scroll position
                scrollPosition = selectedIndex
            }
        }
        .frame(height: cardHeight + 40) // Extra space for shadows and glow
    }
    
    // MARK: - Card Transforms
    
    private func scaleForCard(at index: Int) -> CGFloat {
        let distance = abs(index - selectedIndex)
        switch distance {
        case 0: return 1.0
        case 1: return 0.88
        default: return 0.78
        }
    }
    
    private func opacityForCard(at index: Int) -> Double {
        let distance = abs(index - selectedIndex)
        switch distance {
        case 0: return 1.0
        case 1: return 0.7
        default: return 0.5
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        CelestialBackground()
        
        TarotRitualCarousel(
            cards: [
                TarotCard(id: "fool", name: "The Fool", keywords: ["New beginnings"], interpretation: nil, guidance: nil, imageName: nil),
                TarotCard(id: "magician", name: "The Magician", keywords: ["Power"], interpretation: nil, guidance: nil, imageName: nil),
                TarotCard(id: "priestess", name: "The High Priestess", keywords: ["Intuition"], interpretation: nil, guidance: nil, imageName: nil),
                TarotCard(id: "empress", name: "The Empress", keywords: ["Abundance"], interpretation: nil, guidance: nil, imageName: nil),
                TarotCard(id: "emperor", name: "The Emperor", keywords: ["Authority"], interpretation: nil, guidance: nil, imageName: nil)
            ],
            selectedIndex: .constant(2),
            tarotState: .constant(.choosing),
            onCardTap: { _ in }
        )
    }
}

