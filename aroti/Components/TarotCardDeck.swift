//
//  TarotCardDeck.swift
//  Aroti
//
//  Interactive tarot card deck with static deck and reveal card animations
//

import SwiftUI
import UIKit

struct TarotCardDeck: View {
    let cardCount: Int
    let onCardsSelected: ([TarotCard]) -> Void
    
    // State model
    @State private var currentCardIndex: Int = 1
    @State private var isDrawing: Bool = false
    
    // Reveal card state
    @State private var showRevealCard: Bool = false
    @State private var revealCard: TarotCard?
    @State private var revealOffset: CGSize = .zero
    @State private var revealRotation: Double = 0
    @State private var revealFlip: Double = 0
    @State private var revealOpacity: Double = 1.0
    
    // Deck state (only opacity, no movement)
    @State private var deckScale: CGFloat = 1.0
    @State private var deckOpacity: Double = 1.0
    
    // Navigation control
    @State private var shouldNavigateToReading: Bool = false
    
    // Progress text animation (opacity only, no offset)
    @State private var progressOpacity: Double = 1.0
    
    // Card data
    @State private var availableCards: [TarotCard] = []
    @State private var selectedCards: [TarotCard] = []
    
    private var allCards: [TarotCard] {
        DailyContentService.shared.getAllTarotCards()
    }
    
    private var progressText: String {
        return "Card \(min(currentCardIndex, cardCount)) of \(cardCount)"
    }
    
    private var helperText: String {
        if currentCardIndex > cardCount {
            return "Your cards are ready"
        } else if currentCardIndex == 1 {
            return "Tap the deck to draw Card 1 of \(cardCount)"
        } else {
            return "Tap again to draw Card \(currentCardIndex) of \(cardCount)"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main heading
            Text("Draw your cards")
                .font(DesignTypography.title2Font(weight: .semibold))
                .foregroundColor(DesignColors.foreground)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            Spacer()
            
            // Deck area (centered, slightly above middle)
            ZStack {
                // Static deck - never moves
                StaticDeckView(opacity: deckOpacity)
                    .scaleEffect(deckScale)
                
                // Reveal card overlay - slides, flips, fades
                if showRevealCard, let card = revealCard {
                    RevealCardView(
                        card: card,
                        offset: revealOffset,
                        rotation: revealRotation,
                        flipAngle: revealFlip,
                        opacity: revealOpacity
                    )
                }
            }
            .frame(width: 220, height: 340)
            .padding(.vertical, 32)
            .onTapGesture {
                handleDeckTap()
            }
            
            Spacer()
            
            // Progress pill + helper text (below deck)
            VStack(spacing: 12) {
                // Card counter chip
                Text(progressText)
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(DesignColors.accent.opacity(0.2))
                            .overlay(
                                Capsule()
                                    .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .opacity(progressOpacity)
                
                // Helper text
                Text(helperText)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 24)
            .padding(.bottom, 24)
            
        }
        .padding(.horizontal, DesignSpacing.sm)
        .safeAreaInset(edge: .bottom) {
            if currentCardIndex <= cardCount {
                Button(action: handleDrawAll) {
                    Text("Draw All")
                        .font(ArotiTextStyle.subhead)
                        .foregroundColor(ArotiColor.accentText)
                        .frame(maxWidth: .infinity)
                        .frame(height: ArotiButtonHeight.compact)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ArotiColor.accent)
                                .shadow(color: ArotiColor.accent.opacity(0.35), radius: 10, x: 0, y: 6)
                        )
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(PlainButtonStyle())
                .disabled(isDrawing)
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            initializeDeck()
        }
        .onChange(of: shouldNavigateToReading) { _, shouldNavigate in
            if shouldNavigate {
                onCardsSelected(selectedCards)
            }
        }
    }
    
    private func initializeDeck() {
        availableCards = allCards.shuffled()
    }
    
    private func handleDeckTap() {
        guard !isDrawing else { return }
        guard currentCardIndex <= cardCount else { return }
        
        isDrawing = true
        
        // Trigger haptic
        HapticFeedback.impactOccurred(.medium)
        
        // Draw a random card
        let randomIndex = Int.random(in: 0..<availableCards.count)
        let drawnCard = availableCards[randomIndex]
        availableCards.remove(at: randomIndex)
        selectedCards.append(drawnCard)
        
        // Get center card transform from static deck
        let centerTransform = StaticDeckView.centerCardTransform()
        
        // Optional: Small deck press-down (can remove if jittery)
        withAnimation(.easeOut(duration: 0.08)) {
            deckScale = 0.97
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.easeOut(duration: 0.08)) {
                deckScale = 1.0
            }
            
            // Initialize reveal card at center card position
            revealCard = drawnCard
            revealOffset = centerTransform.offset
            revealRotation = centerTransform.rotation
            revealFlip = 0
            revealOpacity = 1.0
            showRevealCard = true
            
            // 1) Slide card out from fan to center above deck (0.3s spring)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                revealOffset = CGSize(width: 0, height: -120) // Centered above deck
                revealRotation = 0 // Straighten
            }
            
            // 2) After slide, flip card (0.3s)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    revealFlip = 180 // Flip from back to front
                }
                
                // 3) Pause to show the revealed card, then fade out (0.5s pause + 0.15s fade)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 + 0.5) {
                    withAnimation(.easeOut(duration: 0.15)) {
                        revealOpacity = 0.0
                    }
                    
                    // Hide card and update state
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        showRevealCard = false
                        
                        // Update progress (opacity only, no offset)
                        withAnimation(.easeOut(duration: 0.2)) {
                            progressOpacity = 0.0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            currentCardIndex += 1
                            
                            // Reset reveal card state
                            revealCard = nil
                            revealOffset = .zero
                            revealRotation = 0
                            revealFlip = 0
                            revealOpacity = 1.0
                            
                            // Fade in progress
                            withAnimation(.easeIn(duration: 0.2)) {
                                progressOpacity = 1.0
                            }
                            
                            isDrawing = false
                            
                            if currentCardIndex > cardCount {
                                handleFinishedDrawing()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func handleFinishedDrawing() {
        // Fade out static deck
        withAnimation(.easeOut(duration: 0.25)) {
            deckOpacity = 0.0
        }
        
        // After delay, navigate to Reading screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            shouldNavigateToReading = true
        }
    }
    
    private func handleDrawAll() {
        guard !isDrawing else { return }
        
        isDrawing = true
        
        // Calculate remaining cards needed
        let remainingCount = cardCount - selectedCards.count
        
        // Take remaining cards from available deck
        let cardsToAdd = Array(availableCards.prefix(remainingCount))
        selectedCards.append(contentsOf: cardsToAdd)
        
        // Remove from available
        for card in cardsToAdd {
            if let index = availableCards.firstIndex(where: { $0.id == card.id }) {
                availableCards.remove(at: index)
            }
        }
        
        // Fade out deck
        withAnimation(.easeOut(duration: 0.25)) {
            deckOpacity = 0.0
        }
        
        currentCardIndex = cardCount + 1
        
        // Update progress text
        withAnimation(.easeOut(duration: 0.2)) {
            progressOpacity = 0.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeIn(duration: 0.2)) {
                progressOpacity = 1.0
            }
        }
        
        // Navigate immediately
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            shouldNavigateToReading = true
        }
    }
}

#Preview {
    TarotCardDeck(cardCount: 10) { cards in
        print("Selected \(cards.count) cards")
    }
    .padding()
    .background(CelestialBackground())
}
