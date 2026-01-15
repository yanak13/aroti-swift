//
//  CoreGuidanceCarousel.swift
//  Aroti
//
//  Horizontal carousel of Core Guidance cards
//

import SwiftUI

struct CoreGuidanceCarousel: View {
    @State private var cards: [CoreGuidanceCard] = []
    @State private var showPaywall = false
    @State private var selectedCard: CoreGuidanceCard?
    @State private var showDetailSheet = false
    
    private let guidanceService = CoreGuidanceService.shared
    private let userSubscription = UserSubscriptionService.shared
    
    private var isPremium: Bool {
        userSubscription.isPremium
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: DiscoveryLayout.interCardSpacing) {
                ForEach(cards) { card in
                    Button(action: {
                        if isPremium {
                            selectedCard = card
                            showDetailSheet = true
                            // Mark as opened to clear "New" chip
                            guidanceService.markCardOpened(cardId: card.id)
                            // Refresh cards to update "New" chip state
                            loadCards()
                        } else {
                            showPaywall = true
                        }
                    }) {
                        CoreGuidanceCardView(
                            card: card,
                            hasNewContent: guidanceService.hasNewContent(cardId: card.id),
                            isPremium: isPremium
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 400) // Increased from 320, maintaining 1.6:1 ratio
                }
            }
            .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            .padding(.vertical, 8) // Increased vertical padding for elevation
        }
        .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        .sheet(isPresented: $showPaywall) {
            PremiumPaywallSheet(context: "core_guidance")
        }
        .sheet(isPresented: $showDetailSheet) {
            if let card = selectedCard {
                CoreGuidanceDetailSheet(card: card)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
        .onAppear {
            loadCards()
        }
        .onChange(of: showDetailSheet) { oldValue, newValue in
            // Refresh when sheet is dismissed to update "New" chip
            if !newValue {
                loadCards()
            }
        }
    }
    
    private func loadCards() {
        cards = guidanceService.getCards()
    }
}

