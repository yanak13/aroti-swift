//
//  TarotRitualZone.swift
//  Aroti
//
//  Main container for the Tarot Ritual carousel experience
//

import SwiftUI

struct TarotRitualZone: View {
    let cards: [TarotCard]
    @Binding var tarotState: TarotState
    @Binding var selectedIndex: Int
    let onOpenInsight: (TarotCard) -> Void
    
    private let stateManager = DailyStateManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title and helper microcopy
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Tarot")
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Text(helperText)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .opacity(0.8)
            }
            .padding(.horizontal, DesignSpacing.sm)
            
            // Carousel
            TarotRitualCarousel(
                cards: cards,
                selectedIndex: $selectedIndex,
                tarotState: $tarotState,
                onCardTap: handleCardTap
            )
            
            // CTA Button (only shown when not revealed)
            if !tarotState.isRevealed {
                ctaButton
                    .padding(.horizontal, DesignSpacing.sm)
            }
            
            // Revealed card metadata (if revealed)
            if case .revealed(let cardId) = tarotState,
               let card = cards.first(where: { $0.id == cardId }) {
                revealedMetaView(card: card)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)).combined(with: .offset(y: 10)),
                        removal: .opacity
                    ))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: tarotState)
            }
        }
    }
    
    // MARK: - Helper Text
    
    private var helperText: String {
        switch tarotState {
        case .choosing:
            return "Choose one card"
        case .revealing:
            return "Revealing..."
        case .revealed:
            return "Your draw for today"
        }
    }
    
    // MARK: - CTA Button
    
    @ViewBuilder
    private var ctaButton: some View {
        switch tarotState {
        case .choosing:
            ArotiButton(
                kind: .secondary,
                title: "Reveal card",
                action: revealSelectedCard
            )
            
        case .revealing:
            ArotiButton(
                kind: .secondary,
                title: "Revealing...",
                action: {}
            )
            .disabled(true)
            .opacity(0.5)
            
        case .revealed:
            EmptyView()
        }
    }
    
    // MARK: - Revealed Meta View
    
    @ViewBuilder
    private func revealedMetaView(card: TarotCard) -> some View {
        VStack(alignment: .center, spacing: 16) {
            // Card name (larger, prominent)
            Text(card.name)
                .font(DesignTypography.title3Font(weight: .semibold))
                .foregroundColor(DesignColors.foreground)
            
            // Keywords as chips
            HStack(spacing: 8) {
                ForEach(card.keywords.prefix(3), id: \.self) { keyword in
                    Text(keyword)
                        .font(DesignTypography.caption1Font(weight: .medium))
                        .foregroundColor(DesignColors.accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(DesignColors.accent.opacity(0.15))
                                .overlay(
                                    Capsule()
                                        .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
            
            // CTA Button
            ArotiButton(
                kind: .primary,
                title: "Open full insight",
                action: {
                    onOpenInsight(card)
                }
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, DesignSpacing.sm)
        .padding(.top, 8)
    }
    
    // MARK: - Actions
    
    private func handleCardTap(_ card: TarotCard) {
        // Only allow reveal if this is the centered card and we're in choosing state
        guard tarotState.isChoosing else { return }
        revealCard(card)
    }
    
    private func revealSelectedCard() {
        guard tarotState.isChoosing,
              selectedIndex < cards.count else { return }
        
        let card = cards[selectedIndex]
        revealCard(card)
    }
    
    private func revealCard(_ card: TarotCard) {
        // Transition to revealing state
        withAnimation(.easeOut(duration: 0.1)) {
            tarotState = .revealing
        }
        
        HapticFeedback.impactOccurred(.medium)
        
        // After animation completes, transition to revealed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                tarotState = .revealed(cardId: card.id)
            }
            
            // Mark card as flipped in state manager
            stateManager.markCardFlipped()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        CelestialBackground()
        
        ScrollView {
            VStack(spacing: 24) {
                TarotRitualZone(
                    cards: [
                        TarotCard(id: "fool", name: "The Fool", keywords: ["New beginnings", "Innocence", "Adventure"], interpretation: "A new beginning awaits you.", guidance: nil, imageName: nil),
                        TarotCard(id: "magician", name: "The Magician", keywords: ["Manifestation", "Power", "Will"], interpretation: "You have all the tools you need.", guidance: nil, imageName: nil),
                        TarotCard(id: "priestess", name: "The High Priestess", keywords: ["Intuition", "Mystery", "Wisdom"], interpretation: "Trust your inner voice.", guidance: nil, imageName: nil),
                        TarotCard(id: "empress", name: "The Empress", keywords: ["Fertility", "Abundance", "Nature"], interpretation: "Embrace your creative power.", guidance: nil, imageName: nil),
                        TarotCard(id: "emperor", name: "The Emperor", keywords: ["Authority", "Structure", "Control"], interpretation: "Take control of your life.", guidance: nil, imageName: nil)
                    ],
                    tarotState: .constant(.choosing),
                    selectedIndex: .constant(2),
                    onOpenInsight: { _ in }
                )
            }
            .padding(.top, 60)
        }
    }
}

