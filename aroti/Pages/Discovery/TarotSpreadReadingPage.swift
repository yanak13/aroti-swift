//
//  TarotSpreadReadingPage.swift
//  Aroti
//
//  Interactive tarot spread reading page
//

import SwiftUI
import UIKit

struct ReadingCard: Identifiable {
    let id: Int  // Position ID
    let position: SpreadPosition
    let card: TarotCard
    var isFlipped: Bool  // Mutable state for flip animation
}

struct TarotSpreadReadingPage: View {
    @Environment(\.dismiss) private var dismiss
    let spreadId: String
    let intention: String?  // Optional user intention/question
    
    @State private var readingCards: [ReadingCard] = []
    @State private var showingCardDetail: TarotCard? = nil
    @State private var isSelectingCards: Bool = true
    @State private var selectedCards: [TarotCard] = []
    
    init(spreadId: String, intention: String? = nil) {
        self.spreadId = spreadId
        self.intention = intention
    }
    
    private var spread: TarotSpreadDetail? {
        // Reuse the same spread data structure from TarotSpreadDetailPage
        let spreads: [String: TarotSpreadDetail] = [
            "celtic-cross": TarotSpreadDetail(
                id: "celtic-cross",
                name: "Celtic Cross",
                cardCount: 10,
                description: "Comprehensive 10-card spread",
                instructions: [],
                difficulty: "Intermediate",
                bestFor: "General guidance and deep insights",
                positions: [
                    SpreadPosition(id: 1, title: "Current Situation", description: "The core issue or question at hand"),
                    SpreadPosition(id: 2, title: "Challenge/Opportunity", description: "What's crossing or blocking your path"),
                    SpreadPosition(id: 3, title: "Distant Past", description: "Events or influences that have shaped your current situation"),
                    SpreadPosition(id: 4, title: "Recent Past", description: "What you've just moved through"),
                    SpreadPosition(id: 5, title: "Possible Future", description: "Potential outcomes"),
                    SpreadPosition(id: 6, title: "Near Future", description: "What's likely to happen soon"),
                    SpreadPosition(id: 7, title: "Your Approach", description: "How you're handling the situation"),
                    SpreadPosition(id: 8, title: "External Influences", description: "People, events, or circumstances affecting you"),
                    SpreadPosition(id: 9, title: "Hopes and Fears", description: "What you're hoping for or worried about"),
                    SpreadPosition(id: 10, title: "Outcome", description: "The potential resolution or direction")
                ]
            ),
            "three-card": TarotSpreadDetail(
                id: "three-card",
                name: "Three Card Spread",
                cardCount: 3,
                description: "Past, present, future",
                instructions: [],
                difficulty: "Beginner",
                bestFor: "Quick insights and daily guidance",
                positions: [
                    SpreadPosition(id: 1, title: "Past", description: "Influences from your past affecting the present"),
                    SpreadPosition(id: 2, title: "Present", description: "Your current situation and energies"),
                    SpreadPosition(id: 3, title: "Future", description: "Potential outcomes based on current trajectory")
                ]
            ),
            "past-present-future": TarotSpreadDetail(
                id: "past-present-future",
                name: "Past Present Future",
                cardCount: 3,
                description: "Timeline insights",
                instructions: [],
                difficulty: "Beginner",
                bestFor: "Understanding your journey through time",
                positions: [
                    SpreadPosition(id: 1, title: "Past", description: "Influences from your past affecting the present"),
                    SpreadPosition(id: 2, title: "Present", description: "Your current situation and energies"),
                    SpreadPosition(id: 3, title: "Future", description: "Potential outcomes based on current trajectory")
                ]
            ),
            "moon-guidance": TarotSpreadDetail(
                id: "moon-guidance",
                name: "Moon Guidance",
                cardCount: 5,
                description: "Lunar cycle wisdom",
                instructions: [],
                difficulty: "Beginner",
                bestFor: "Aligning with lunar energy and cycles",
                positions: [
                    SpreadPosition(id: 1, title: "Waning Moon", description: "What to release during the waning moon"),
                    SpreadPosition(id: 2, title: "New Moon", description: "What to set during the new moon"),
                    SpreadPosition(id: 3, title: "Waxing Moon", description: "What to nurture during the waxing moon"),
                    SpreadPosition(id: 4, title: "Full Moon", description: "What to celebrate during the full moon"),
                    SpreadPosition(id: 5, title: "Overall Guidance", description: "Overall lunar guidance for this cycle")
                ]
            )
        ]
        return spreads[spreadId]
    }
    
    private var allCardsFlipped: Bool {
        readingCards.allSatisfy { $0.isFlipped }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    // Header
                    BaseHeader(
                        title: spread?.name ?? "Reading",
                        subtitle: spread != nil ? "\(spread!.cardCount)-card spread" : nil,
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, 0)
                    
                    if let spread = spread {
                        VStack(spacing: 20) {
                            if isSelectingCards {
                                // Card Selection Section
                                VStack(spacing: 16) {
                                    Text("Select Your Cards")
                                        .font(DesignTypography.title3Font(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text("Draw cards one by one from the deck")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    TarotCardDeck(cardCount: spread.cardCount) { cards in
                                        handleCardsSelected(cards)
                                    }
                                }
                            } else {
                                // Reading Section (shown after cards are selected)
                                // Reveal All Button
                                if !allCardsFlipped {
                                    Button(action: revealAllCards) {
                                        Text("Reveal All Cards")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                            .foregroundColor(DesignColors.accent)
                                            .padding(.horizontal, DesignSpacing.md)
                                            .padding(.vertical, DesignSpacing.sm)
                                            .background(
                                                Capsule()
                                                    .fill(DesignColors.accent.opacity(0.1))
                                                    .overlay(
                                                        Capsule()
                                                            .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                                    )
                                            )
                                    }
                                }
                                
                                // Divider
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                // Your Reading Label
                                Text("Your Reading")
                                    .font(DesignTypography.title3Font(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                // Card Grid
                                let columns = [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ]
                                
                                LazyVGrid(columns: columns, spacing: 20) {
                                    ForEach(readingCards) { readingCard in
                                        ReadingCardSlot(
                                            readingCard: readingCard,
                                            onFlip: {
                                                flipCard(at: readingCard.id)
                                            },
                                            onViewDetails: {
                                                showingCardDetail = readingCard.card
                                            }
                                        )
                                    }
                                }
                                
                                // Restart Reading Button
                                Button(action: restartReading) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "arrow.clockwise")
                                            .font(.system(size: 16))
                                        Text("Restart Reading")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                    }
                                    .foregroundColor(DesignColors.foreground)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.05))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                            )
                                    )
                                }
                                .padding(.top, 24)
                            }
                        }
                    } else {
                        // Spread not found
                        BaseCard {
                            VStack {
                                Text("Spread not found")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 16)
                .padding(.bottom, 60)
            }
            .navigationBarHidden(true)
            .sheet(item: $showingCardDetail) { card in
                TarotCardDetailSheet(card: card)
            }
        }
    }
    
    private func handleCardsSelected(_ cards: [TarotCard]) {
        guard let spread = spread else { return }
        
        selectedCards = cards
        
        // Create reading cards with positions
        readingCards = zip(spread.positions, cards).map { position, card in
            ReadingCard(id: position.id, position: position, card: card, isFlipped: false)
        }
        
        // Switch to reading view
        withAnimation {
            isSelectingCards = false
        }
    }
    
    private func drawCards() {
        guard let spread = spread else { return }
        
        // Get all available tarot cards
        let allCards = DailyContentService.shared.getAllTarotCards()
        
        // Randomly select unique cards
        let randomCards = Array(allCards.shuffled().prefix(spread.cardCount))
        
        // Create reading cards with positions
        readingCards = zip(spread.positions, randomCards).map { position, card in
            ReadingCard(id: position.id, position: position, card: card, isFlipped: false)
        }
    }
    
    private func flipCard(at positionId: Int) {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            if let index = readingCards.firstIndex(where: { $0.id == positionId }) {
                var updatedCards = readingCards
                updatedCards[index].isFlipped = true
                readingCards = updatedCards
            }
        }
    }
    
    private func revealAllCards() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            var updatedCards = readingCards
            for index in updatedCards.indices {
                updatedCards[index].isFlipped = true
            }
            readingCards = updatedCards
        }
    }
    
    private func restartReading() {
        withAnimation {
            readingCards = []
            selectedCards = []
            isSelectingCards = true
        }
    }
}

// MARK: - Reading Card Slot Component
struct ReadingCardSlot: View {
    let readingCard: ReadingCard
    let onFlip: () -> Void
    let onViewDetails: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Position Label
            Text("\(readingCard.position.id). \(readingCard.position.title)")
                .font(DesignTypography.footnoteFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            // Card
            Button(action: {
                if !readingCard.isFlipped {
                    onFlip()
                } else {
                    onViewDetails()
                }
            }) {
                if readingCard.isFlipped {
                    // Card Front
                    VStack(spacing: 12) {
                        // Card Image (using decorative style from TarotCardView)
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
                            if let imageName = readingCard.card.imageName,
                               let image = UIImage(named: imageName) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(16)
                            } else {
                                // Fallback placeholder
                                Image(systemName: "sparkles")
                                    .font(.system(size: 40))
                                    .foregroundColor(DesignColors.accent)
                            }
                        }
                        .frame(width: TarotSpreadCardLayout.width, height: TarotSpreadCardLayout.height * 0.7)
                        .aspectRatio(3/5, contentMode: .fit)
                        
                        // Card Name
                        Text(readingCard.card.name)
                            .font(DesignTypography.subheadFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        
                        // Short Meaning
                        if let interpretation = readingCard.card.interpretation {
                            Text(interpretation)
                                .font(DesignTypography.caption1Font())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                        }
                        
                        // View Details Button
                        Button(action: onViewDetails) {
                            Text("View full meaning")
                                .font(DesignTypography.caption1Font(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                        }
                        .padding(.top, 4)
                    }
                } else {
                    // Card Back
                    TarotCardBack()
                        .frame(width: TarotSpreadCardLayout.width, height: TarotSpreadCardLayout.height * 0.7)
                        .aspectRatio(3/5, contentMode: .fit)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Position Description
            if let description = readingCard.position.description {
                Text(description)
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Card Detail Sheet
struct TarotCardDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let card: TarotCard
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Card Image
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
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
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                            )
                        
                        if let imageName = card.imageName,
                           let image = UIImage(named: imageName) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(24)
                        } else {
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundColor(DesignColors.accent)
                        }
                    }
                    .frame(height: 400)
                    .padding(.horizontal, DesignSpacing.sm)
                    
                    // Card Name
                    Text(card.name)
                        .font(DesignTypography.title1Font(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                        .padding(.horizontal, DesignSpacing.sm)
                    
                    // Keywords
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(card.keywords, id: \.self) { keyword in
                                Text(keyword)
                                    .font(DesignTypography.footnoteFont())
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
                            }
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                    }
                    
                    // Interpretation
                    if let interpretation = card.interpretation {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Interpretation")
                                .font(DesignTypography.headlineFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(interpretation)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                    }
                    
                    // Guidance
                    if let guidance = card.guidance, !guidance.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Guidance")
                                .font(DesignTypography.headlineFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            ForEach(guidance, id: \.self) { item in
                                HStack(alignment: .top, spacing: 12) {
                                    Circle()
                                        .fill(DesignColors.accent.opacity(0.3))
                                        .frame(width: 6, height: 6)
                                        .padding(.top, 6)
                                    
                                    Text(item)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                    }
                }
                .padding(.vertical, DesignSpacing.md)
            }
            .background(CelestialBackground().ignoresSafeArea())
            .navigationTitle("Card Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.accent)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TarotSpreadReadingPage(spreadId: "celtic-cross")
    }
}


