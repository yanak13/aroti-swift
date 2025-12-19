//
//  TarotCarouselDemo.swift
//  Aroti
//
//  Demo view showcasing the TarotCardCarousel component
//

import SwiftUI

struct TarotCarouselDemo: View {
    
    // MARK: - State
    
    @State private var selectedIndex: Int = 10 // Start at middle card
    @State private var showPaywall: Bool = false
    @State private var lastRevealedCard: TarotCardCarousel.Item?
    
    // MARK: - Sample Data
    
    private let tarotItems: [TarotCardCarousel.Item] = generateTarotDeck()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header section
                        headerSection
                            .padding(.top, 20)
                        
                        // Carousel
                        TarotCardCarousel(
                            items: tarotItems,
                            selectedIndex: $selectedIndex,
                            onReveal: handleReveal,
                            onSelect: handleSelect
                        )
                        .padding(.vertical, 24)
                        
                        // Card info section
                        cardInfoSection
                            .padding(.horizontal, 20)
                        
                        // Instructions
                        instructionsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 32)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPaywall) {
                paywallSheet
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Pick a Card")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(ArotiColor.textPrimary)
            
            Text("Trust your intuition and choose wisely")
                .font(.system(size: 15))
                .foregroundColor(ArotiColor.textSecondary)
        }
    }
    
    // MARK: - Card Info Section
    
    private var cardInfoSection: some View {
        VStack(spacing: 16) {
            // Current card title
            if selectedIndex < tarotItems.count {
                let currentCard = tarotItems[selectedIndex]
                
                VStack(spacing: 8) {
                    Text("Selected Card")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ArotiColor.textMuted)
                        .textCase(.uppercase)
                        .tracking(1.2)
                    
                    Text(currentCard.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(ArotiColor.textPrimary)
                    
                    if currentCard.isLocked {
                        HStack(spacing: 4) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 11))
                            Text("Premium Card")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(ArotiColor.accent)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ArotiColor.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ArotiColor.border, lineWidth: 1)
                        )
                )
            }
            
            // Card counter
            HStack {
                Text("Card \(selectedIndex + 1) of \(tarotItems.count)")
                    .font(.system(size: 13))
                    .foregroundColor(ArotiColor.textMuted)
                
                Spacer()
                
                // Navigation buttons
                HStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.75)) {
                            if selectedIndex > 0 {
                                selectedIndex -= 1
                            }
                        }
                        HapticFeedback.impactOccurred(.light)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(selectedIndex > 0 ? ArotiColor.accent : ArotiColor.textMuted)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(ArotiColor.surface)
                                    .overlay(
                                        Circle()
                                            .stroke(ArotiColor.border, lineWidth: 1)
                                    )
                            )
                    }
                    .disabled(selectedIndex == 0)
                    
                    Button(action: {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.75)) {
                            if selectedIndex < tarotItems.count - 1 {
                                selectedIndex += 1
                            }
                        }
                        HapticFeedback.impactOccurred(.light)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(selectedIndex < tarotItems.count - 1 ? ArotiColor.accent : ArotiColor.textMuted)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(ArotiColor.surface)
                                    .overlay(
                                        Circle()
                                            .stroke(ArotiColor.border, lineWidth: 1)
                                    )
                            )
                    }
                    .disabled(selectedIndex == tarotItems.count - 1)
                }
            }
        }
    }
    
    // MARK: - Instructions Section
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How it works")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(ArotiColor.textPrimary)
            
            VStack(alignment: .leading, spacing: 8) {
                instructionRow(icon: "hand.draw", text: "Swipe left or right to browse cards")
                instructionRow(icon: "hand.tap", text: "Tap a card to center it")
                instructionRow(icon: "sparkles", text: "Tap the center card to reveal")
                instructionRow(icon: "lock.fill", text: "Premium cards require subscription")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ArotiColor.surface.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ArotiColor.border.opacity(0.5), lineWidth: 1)
                )
        )
    }
    
    private func instructionRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(ArotiColor.accent)
                .frame(width: 20)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(ArotiColor.textSecondary)
        }
    }
    
    // MARK: - Paywall Sheet
    
    private var paywallSheet: some View {
        VStack(spacing: 24) {
            Image(systemName: "crown.fill")
                .font(.system(size: 48))
                .foregroundColor(ArotiColor.accent)
            
            Text("Premium Card")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(ArotiColor.textPrimary)
            
            if let card = lastRevealedCard {
                Text("\"\(card.title)\" is a premium card.")
                    .font(.system(size: 16))
                    .foregroundColor(ArotiColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Text("Unlock all 78 tarot cards with Aroti Premium.")
                .font(.system(size: 15))
                .foregroundColor(ArotiColor.textMuted)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showPaywall = false
            }) {
                Text("Upgrade to Premium")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(ArotiColor.accent)
                    )
            }
            .padding(.top, 8)
            
            Button(action: {
                showPaywall = false
            }) {
                Text("Maybe Later")
                    .font(.system(size: 15))
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ArotiColor.bg.ignoresSafeArea())
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Actions
    
    private func handleReveal(_ item: TarotCardCarousel.Item) {
        print("✨ Revealed: \(item.title)")
        lastRevealedCard = item
        
        if item.isLocked {
            // Show paywall for locked cards
            showPaywall = true
        }
    }
    
    private func handleSelect(_ item: TarotCardCarousel.Item) {
        print("👆 Selected: \(item.title)")
    }
}

// MARK: - Generate Tarot Deck

private func generateTarotDeck() -> [TarotCardCarousel.Item] {
    // Major Arcana (0-21)
    let majorArcana = [
        "The Fool",
        "The Magician",
        "The High Priestess",
        "The Empress",
        "The Emperor",
        "The Hierophant",
        "The Lovers",
        "The Chariot",
        "Strength",
        "The Hermit",
        "Wheel of Fortune",
        "Justice",
        "The Hanged Man",
        "Death",
        "Temperance",
        "The Devil",
        "The Tower",
        "The Star",
        "The Moon",
        "The Sun",
        "Judgement",
        "The World"
    ]
    
    // Minor Arcana suits
    let suits = ["Wands", "Cups", "Swords", "Pentacles"]
    let ranks = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Page", "Knight", "Queen", "King"]
    
    var items: [TarotCardCarousel.Item] = []
    
    // Add Major Arcana
    for (index, name) in majorArcana.enumerated() {
        let imageName = "tarot_\(name.lowercased().replacingOccurrences(of: " ", with: "_"))"
        items.append(.init(
            title: name,
            cardFrontImageName: imageName,
            isLocked: index > 10 // Lock half of Major Arcana for demo
        ))
    }
    
    // Add Minor Arcana
    for suit in suits {
        for rank in ranks {
            let name = "\(rank) of \(suit)"
            let imageName = "tarot_\(rank.lowercased())_of_\(suit.lowercased())"
            items.append(.init(
                title: name,
                cardFrontImageName: imageName,
                isLocked: true // All Minor Arcana locked for demo
            ))
        }
    }
    
    return items
}

// MARK: - Preview

#Preview {
    TarotCarouselDemo()
}

