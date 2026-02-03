//
//  CoreGuidanceCarousel.swift
//  Aroti
//
//  Horizontal carousel of Core Guidance cards
//

import SwiftUI

struct CoreGuidanceCarousel: View {
    @State private var cards: [CoreGuidanceCard] = []
    @State private var premiumEventCards: [CoreGuidanceCard] = []
    @State private var showPaywall = false
    @State private var selectedCard: CoreGuidanceCard?
    @State private var userData: UserData = UserData.default
    
    let onCardSelected: ((CoreGuidanceCard) -> Void)?
    
    private let guidanceService = CoreGuidanceService.shared
    private let userSubscription = UserSubscriptionService.shared
    private let stateManager = DailyStateManager.shared
    
    private var isPremium: Bool {
        userSubscription.isPremium
    }
    
    init(onCardSelected: ((CoreGuidanceCard) -> Void)? = nil) {
        self.onCardSelected = onCardSelected
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: DiscoveryLayout.interCardSpacing) {
                // Premium Event Cards (dynamic, event-driven) - Show these first when they exist
                if !premiumEventCards.isEmpty {
                    ForEach(premiumEventCards) { card in
                        Button(action: {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            
                            if isPremium {
                                // Mark as opened to clear "New" chip
                                guidanceService.markCardOpened(cardId: card.id)
                                
                                // Get the latest card from service to ensure it has expandedContent
                                if let latestCard = guidanceService.getCard(id: card.id) {
                                    // Set selected card (use latest version)
                                    selectedCard = latestCard
                                    
                                    // Notify parent via callback
                                    onCardSelected?(latestCard)
                                } else {
                                    // Fallback to current card if service doesn't have it
                                    selectedCard = card
                                    onCardSelected?(card)
                                }
                                
                                // Refresh cards to update "New" chip state
                                loadCards()
                                loadPremiumEventCards()
                            } else {
                                showPaywall = true
                            }
                        }) {
                            ZStack {
                                CoreGuidanceCardView(
                                    card: card,
                                    hasNewContent: guidanceService.hasNewContent(cardId: card.id),
                                    isPremium: isPremium
                                )
                                
                                // Lock overlay for free users
                                if !isPremium {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundColor(.white)
                                                .padding(12)
                                                .background(
                                                    Circle()
                                                        .fill(Color.black.opacity(0.6))
                                                )
                                                .padding(.trailing, 16)
                                                .padding(.bottom, 16)
                                        }
                                    }
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                        .frame(width: 400) // Increased from 320, maintaining 1.6:1 ratio
                    }
                } else {
                    // Regular Core Guidance Cards - Only show when no premium event cards exist
                    ForEach(cards) { card in
                        Button(action: {
                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            
                            if isPremium {
                                // Mark as opened to clear "New" chip
                                guidanceService.markCardOpened(cardId: card.id)
                                
                                // Get the latest card from service to ensure it has expandedContent
                                if let latestCard = guidanceService.getCard(id: card.id) {
                                    // Set selected card (use latest version)
                                    selectedCard = latestCard
                                    
                                    // Notify parent via callback
                                    onCardSelected?(latestCard)
                                } else {
                                    // Fallback to current card if service doesn't have it
                                    selectedCard = card
                                    onCardSelected?(card)
                                }
                                
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
                        .contentShape(Rectangle())
                        .frame(width: 400) // Increased from 320, maintaining 1.6:1 ratio
                    }
                }
            }
            .padding(.horizontal, DiscoveryLayout.horizontalPadding)
            .padding(.vertical, 8) // Increased vertical padding for elevation
        }
        .padding(.horizontal, -DiscoveryLayout.horizontalPadding)
        .sheet(isPresented: $showPaywall) {
            PremiumPaywallSheet(
                context: "core_guidance",
                title: "Premium guidance",
                description: "Unlock deeper insights personalized for you."
            )
        }
        .onAppear {
            loadUserData()
            loadCards()
            loadPremiumEventCards()
            refreshCardsIfNeeded()
        }
    }
    
    private func loadUserData() {
        if let loadedUserData = stateManager.loadUserData() {
            userData = loadedUserData
        }
    }
    
    private func loadCards() {
        // Filter out "Right Now" card
        cards = guidanceService.getCards().filter { $0.type != .rightNow }
    }
    
    private func loadPremiumEventCards() {
        // Load dynamic premium event cards
        premiumEventCards = guidanceService.getPremiumEventCards(userData: userData)
    }
    
    private func refreshCardsIfNeeded() {
        // Check each card and refresh if needed (excluding "Right Now")
        for cardType in CoreGuidanceCardType.allCases where cardType != .rightNow {
            // Always refresh with dynamic content for premium users
            if isPremium {
                guidanceService.refreshCard(type: cardType, userData: userData)
            } else if guidanceService.shouldUpdateCard(type: cardType) {
                guidanceService.refreshCard(type: cardType, userData: userData)
            }
        }
        // Reload cards after refresh
        loadCards()
        loadPremiumEventCards()
        
        // Ensure all cards have expandedContent (refresh again if needed)
        // This is a safety check to ensure content is always available
        if isPremium {
            for cardType in CoreGuidanceCardType.allCases where cardType != .rightNow {
                if let card = guidanceService.getCard(type: cardType),
                   card.expandedContent == nil {
                    guidanceService.refreshCard(type: cardType, userData: userData)
                }
            }
            loadCards()
            loadPremiumEventCards()
        }
    }
}

