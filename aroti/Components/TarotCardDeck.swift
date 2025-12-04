//
//  TarotCardDeck.swift
//  Aroti
//
//  Interactive tarot card deck with fanned deck and draw animations
//

import SwiftUI
import UIKit

struct TarotCardDeck: View {
    let cardCount: Int
    let onCardsSelected: ([TarotCard]) -> Void
    
    // State model
    @State private var currentCardIndex: Int = 1
    @State private var isDrawing: Bool = false
    @State private var showActiveCard: Bool = false
    
    // Active card animation properties
    @State private var activeCardOffset: CGSize = .zero
    @State private var activeCardRotation: Double = 0
    @State private var activeCardScale: CGFloat = 1.0
    @State private var activeCardOpacity: Double = 1.0
    
    // Deck subtle animation
    @State private var deckScale: CGFloat = 1.0
    @State private var deckOpacity: Double = 1.0
    @State private var deckShift: Int = 0 // Track how many cards drawn (for deck shift)
    
    // Navigation control
    @State private var shouldNavigateToReading: Bool = false
    
    // Progress text animation
    @State private var progressOpacity: Double = 1.0
    @State private var progressOffset: CGFloat = 0
    
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
    
    // Get starting transform for card from front of fan
    private var topCardInitialTransform: (offset: CGSize, rotation: Double) {
        return FannedDeckView.topCardInitialTransform(deckShift: deckShift)
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
            AnimatedDeckCard(
                showActiveCard: showActiveCard,
                activeCardOffset: activeCardOffset,
                activeCardRotation: activeCardRotation,
                activeCardScale: activeCardScale,
                activeCardOpacity: activeCardOpacity,
                deckScale: deckScale,
                deckOpacity: deckOpacity,
                deckShift: deckShift
            ) {
                handleDeckTap()
            }
            .padding(.vertical, 32)
            
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
                    .offset(y: progressOffset)
                    .animation(.easeOut(duration: 0.25), value: progressOpacity)
                    .animation(.easeOut(duration: 0.25), value: progressOffset)
                
                // Helper text
                Text(helperText)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 24)
            .padding(.bottom, 24)
            
            // Single primary button (Draw All) - ~85% width via padding
            if currentCardIndex <= cardCount {
                ArotiButton(
                    kind: .custom(.accentCard()),
                    title: "Draw All",
                    icon: Image(systemName: "play.fill"),
                    isDisabled: isDrawing,
                    action: handleDrawAll
                )
                .padding(.horizontal, 32) // Creates ~85% width effect
                .padding(.bottom, 32)
            }
        }
        .padding(.horizontal, 24)
        .onAppear {
            initializeDeck()
        }
        .onChange(of: shouldNavigateToReading) { shouldNavigate in
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
        
        // 2) Prepare active card at same transform as top card in fan
        let start = topCardInitialTransform
        activeCardOffset = start.offset
        activeCardRotation = start.rotation
        activeCardScale = 1.0
        activeCardOpacity = 1.0
        showActiveCard = true
        
        // 1) Small press-down feedback on deck
        withAnimation(.easeOut(duration: 0.08)) {
            deckScale = 0.98
        }
        
        // Return deck scale and start lift animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.easeOut(duration: 0.08)) {
                deckScale = 1.0
            }
            
            // 3) Animate card lifting slightly (8-12pt upward) and fading out
            withAnimation(.easeOut(duration: 0.3)) {
                activeCardOffset = CGSize(
                    width: start.offset.width,
                    height: start.offset.height - 10 // Lift 10pt upward
                )
                activeCardRotation = start.rotation
                activeCardScale = 1.0 // No scaling
                activeCardOpacity = 0.0 // Fade out
                deckOpacity = 0.9 // Deck slightly dims
            }
            
            // 4) After fade completes, hide card and shift deck forward
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showActiveCard = false
                deckOpacity = 1.0
                
                // Shift deck forward by one layer
                withAnimation(.easeOut(duration: 0.25)) {
                    deckShift += 1
                }
                
                // Update progress with cross-fade
                progressOpacity = 0.0
                progressOffset = 8
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    currentCardIndex += 1
                    
                    // Animate progress update (cross-fade)
                    progressOpacity = 1.0
                    progressOffset = 0
                    
                    // Reset active card state
                    activeCardOffset = .zero
                    activeCardRotation = 0
                    activeCardScale = 1.0
                    activeCardOpacity = 1.0
                    
                    isDrawing = false
                    
                    if currentCardIndex > cardCount {
                        handleFinishedDrawing()
                    }
                }
            }
        }
    }
    
    private func handleFinishedDrawing() {
        // 1) Fade & slightly scale down deck
        withAnimation(.easeOut(duration: 0.25)) {
            deckScale = 0.93
            deckOpacity = 0.0
        }
        
        // 2) Helper text should now say "Your cards are ready" (handled by computed property)
        
        // 3) After a short pause, navigate to Reading screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
        
        // Quick "whoosh" animation
        withAnimation(.easeOut(duration: 0.18)) {
            deckScale = 1.05
            deckOpacity = 0.0
        }
        
        currentCardIndex = cardCount + 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
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
