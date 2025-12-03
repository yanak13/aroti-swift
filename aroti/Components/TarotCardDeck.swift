//
//  TarotCardDeck.swift
//  Aroti
//
//  Interactive tarot card deck for selecting cards one-by-one
//

import SwiftUI
import UIKit

struct TarotCardDeck: View {
    let cardCount: Int
    let onCardsSelected: ([TarotCard]) -> Void
    
    @State private var availableCards: [TarotCard] = []
    @State private var selectedCards: [TarotCard] = []
    @State private var currentDrawnCard: TarotCard? = nil
    @State private var isDrawing: Bool = false
    @State private var showDrawnCard: Bool = false
    @State private var isShuffling: Bool = false
    @State private var deckRotation: Double = 0
    
    private var allCards: [TarotCard] {
        DailyContentService.shared.getAllTarotCards()
    }
    
    private var progressText: String {
        "Card \(selectedCards.count + 1) of \(cardCount)"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if selectedCards.count < cardCount {
                // Card selection in progress
                VStack(spacing: 16) {
                    // Progress indicator
                    Text(progressText)
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(DesignColors.mutedForeground)
                    
                    // Deck or drawn card
                    if showDrawnCard, let drawnCard = currentDrawnCard {
                        // Show drawn card with accept/reject
                        VStack(spacing: 20) {
                            // Drawn card
                            ZStack {
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
                                if let imageName = drawnCard.imageName,
                                   let image = UIImage(named: imageName) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(16)
                                } else {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 60))
                                        .foregroundColor(DesignColors.accent)
                                }
                            }
                            .frame(width: 220, height: 367)
                            .aspectRatio(3/5, contentMode: .fit)
                            
                            // Card name
                            Text(drawnCard.name)
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            // Action buttons
                            HStack(spacing: 16) {
                                // Reject button
                                Button(action: {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        showDrawnCard = false
                                        currentDrawnCard = nil
                                        isDrawing = false
                                    }
                                }) {
                                    Text("Draw Another")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                        .padding(.horizontal, DesignSpacing.md)
                                        .padding(.vertical, DesignSpacing.sm)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.white.opacity(0.05))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                                )
                                        )
                                }
                                
                                // Accept button
                                Button(action: {
                                    acceptCard()
                                }) {
                                    Text("Accept")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                        .foregroundColor(DesignColors.accent)
                                        .padding(.horizontal, DesignSpacing.md)
                                        .padding(.vertical, DesignSpacing.sm)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(DesignColors.accent.opacity(0.1))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                }
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        // Deck view
                        VStack(spacing: 20) {
                            Button(action: {
                                drawCard()
                            }) {
                                VStack(spacing: 16) {
                                    // Stacked deck effect - showing full deck
                                    ZStack {
                                        // Multiple card backs for stack effect (8-10 cards)
                                        ForEach(0..<10, id: \.self) { index in
                                            TarotCardBack()
                                                .frame(width: 220, height: 367)
                                                .aspectRatio(3/5, contentMode: .fit)
                                                .offset(
                                                    x: CGFloat(index) * 2.5,
                                                    y: CGFloat(index) * 2.5
                                                )
                                                .opacity(1.0 - Double(index) * 0.1)
                                                .rotationEffect(.degrees(isShuffling ? deckRotation : 0))
                                                .shadow(
                                                    color: Color.black.opacity(0.3 - Double(index) * 0.03),
                                                    radius: CGFloat(8 - index),
                                                    x: CGFloat(index) * 1.5,
                                                    y: CGFloat(index) * 1.5
                                                )
                                        }
                                    }
                                    .frame(width: 220, height: 367)
                                    .aspectRatio(3/5, contentMode: .fit)
                                    
                                    Text("Tap to Draw a Card")
                                        .font(DesignTypography.headlineFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(isDrawing || isShuffling)
                            .opacity((isDrawing || isShuffling) ? 0.6 : 1.0)
                            
                            // Action buttons
                            HStack(spacing: 16) {
                                // Shuffle button
                                Button(action: {
                                    shuffleDeck()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "arrow.2.squarepath")
                                            .font(.system(size: 16))
                                        Text("Shuffle")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                    }
                                    .foregroundColor(DesignColors.foreground)
                                    .padding(.horizontal, DesignSpacing.md)
                                    .padding(.vertical, DesignSpacing.sm)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.white.opacity(0.05))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                            )
                                    )
                                }
                                .disabled(isDrawing || isShuffling || showDrawnCard)
                                
                                // Draw All button
                                Button(action: {
                                    drawAllCards()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 16))
                                        Text("Draw All")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                    }
                                    .foregroundColor(DesignColors.accent)
                                    .padding(.horizontal, DesignSpacing.md)
                                    .padding(.vertical, DesignSpacing.sm)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(DesignColors.accent.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                }
                                .disabled(isDrawing || isShuffling || showDrawnCard)
                            }
                        }
                    }
                }
            } else {
                // All cards selected - show completion message briefly
                Text("All cards selected!")
                    .font(DesignTypography.headlineFont(weight: .medium))
                    .foregroundColor(DesignColors.accent)
            }
        }
        .onAppear {
            initializeDeck()
        }
    }
    
    private func initializeDeck() {
        availableCards = allCards.shuffled()
    }
    
    private func drawCard() {
        guard !availableCards.isEmpty, !isDrawing else { return }
        
        isDrawing = true
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            // Draw a random card from available deck
            let randomIndex = Int.random(in: 0..<availableCards.count)
            currentDrawnCard = availableCards[randomIndex]
            showDrawnCard = true
        }
    }
    
    private func acceptCard() {
        guard let card = currentDrawnCard else { return }
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            // Add to selected cards
            selectedCards.append(card)
            
            // Remove from available cards
            if let index = availableCards.firstIndex(where: { $0.id == card.id }) {
                availableCards.remove(at: index)
            }
            
            // Reset drawn card state
            currentDrawnCard = nil
            showDrawnCard = false
            isDrawing = false
            
            // Check if all cards are selected
            if selectedCards.count >= cardCount {
                // Call completion callback
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onCardsSelected(selectedCards)
                }
            }
        }
    }
    
    private func shuffleDeck() {
        guard !isShuffling else { return }
        
        isShuffling = true
        
        // Visual shuffle animation
        withAnimation(.easeInOut(duration: 0.4)) {
            deckRotation = 360
        }
        
        // Shuffle the available cards array
        availableCards.shuffle()
        
        // Reset rotation and finish animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.1)) {
                deckRotation = 0
            }
            isShuffling = false
        }
    }
    
    private func drawAllCards() {
        guard !availableCards.isEmpty, selectedCards.count < cardCount else { return }
        
        // Randomly select the remaining cards needed
        let remainingCount = cardCount - selectedCards.count
        let shuffledCards = availableCards.shuffled()
        let cardsToAdd = Array(shuffledCards.prefix(remainingCount))
        
        // Add all cards to selected
        selectedCards.append(contentsOf: cardsToAdd)
        
        // Remove selected cards from available
        for card in cardsToAdd {
            if let index = availableCards.firstIndex(where: { $0.id == card.id }) {
                availableCards.remove(at: index)
            }
        }
        
        // Immediately trigger completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            onCardsSelected(selectedCards)
        }
    }
}

#Preview {
    TarotCardDeck(cardCount: 3) { cards in
        print("Selected \(cards.count) cards")
    }
    .padding()
    .background(CelestialBackground())
}

