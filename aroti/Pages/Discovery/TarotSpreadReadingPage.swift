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
    @State private var canvasScale: CGFloat = 1.0
    @State private var showUnlockModal = false
    @State private var hasCheckedAccess = false
    
    // Canvas configuration
    private let canvasSize = CGSize(width: 1200, height: 1600)
    
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
            ),
            "relationship": TarotSpreadDetail(
                id: "relationship",
                name: "Relationship Spread",
                cardCount: 7,
                description: "Connection dynamics",
                instructions: [],
                difficulty: "Intermediate",
                bestFor: "Understanding partnerships and connections",
                positions: [
                    SpreadPosition(id: 1, title: "You", description: "Your perspective and energy in this relationship"),
                    SpreadPosition(id: 2, title: "Them", description: "Their perspective and energy in this relationship"),
                    SpreadPosition(id: 3, title: "Connection", description: "The bond and dynamic between you both"),
                    SpreadPosition(id: 4, title: "Past", description: "What brought you together or past influences"),
                    SpreadPosition(id: 5, title: "Present", description: "The current state of the relationship"),
                    SpreadPosition(id: 6, title: "Challenges", description: "Obstacles or areas needing attention"),
                    SpreadPosition(id: 7, title: "Future", description: "Potential outcomes and direction")
                ]
            ),
            "career-path": TarotSpreadDetail(
                id: "career-path",
                name: "Career Path Spread",
                cardCount: 6,
                description: "Professional guidance and direction",
                instructions: [],
                difficulty: "Intermediate",
                bestFor: "Career decisions and professional growth",
                positions: [
                    SpreadPosition(id: 1, title: "Current Role", description: "Your present professional situation"),
                    SpreadPosition(id: 2, title: "Skills & Strengths", description: "Your abilities and talents"),
                    SpreadPosition(id: 3, title: "Opportunities", description: "Potential career paths and options"),
                    SpreadPosition(id: 4, title: "Challenges", description: "Obstacles or areas needing development"),
                    SpreadPosition(id: 5, title: "Advice", description: "Guidance for your career journey"),
                    SpreadPosition(id: 6, title: "Outcome", description: "Potential career direction and future")
                ]
            ),
            "wheel-of-fortune": TarotSpreadDetail(
                id: "wheel-of-fortune",
                name: "Wheel of Fortune",
                cardCount: 8,
                description: "Life cycles and turning points",
                instructions: [],
                difficulty: "Advanced",
                bestFor: "Understanding life patterns and cycles",
                positions: [
                    SpreadPosition(id: 1, title: "Center", description: "The current cycle you're in"),
                    SpreadPosition(id: 2, title: "Ascending", description: "What's rising and growing in your life"),
                    SpreadPosition(id: 3, title: "Peak", description: "The highest point or greatest opportunity"),
                    SpreadPosition(id: 4, title: "Descending", description: "What's declining or ending"),
                    SpreadPosition(id: 5, title: "Bottom", description: "The lowest point or greatest challenge"),
                    SpreadPosition(id: 6, title: "Rising", description: "What's emerging or beginning to grow"),
                    SpreadPosition(id: 7, title: "Past Cycle", description: "Previous patterns and cycles"),
                    SpreadPosition(id: 8, title: "Future Cycle", description: "Upcoming patterns and cycles")
                ]
            ),
            "horseshoe": TarotSpreadDetail(
                id: "horseshoe",
                name: "Horseshoe Spread",
                cardCount: 7,
                description: "Seven-card arc for comprehensive reading",
                instructions: [],
                difficulty: "Intermediate",
                bestFor: "Detailed situation analysis",
                positions: [
                    SpreadPosition(id: 1, title: "Past", description: "Past influences affecting the situation"),
                    SpreadPosition(id: 2, title: "Present", description: "Your current situation"),
                    SpreadPosition(id: 3, title: "Near Future", description: "What's likely to happen soon"),
                    SpreadPosition(id: 4, title: "Distant Future", description: "Long-term potential outcomes"),
                    SpreadPosition(id: 5, title: "Your Approach", description: "Your attitude and approach to the situation"),
                    SpreadPosition(id: 6, title: "External Influences", description: "Outside factors affecting you"),
                    SpreadPosition(id: 7, title: "Outcome", description: "The final outcome or resolution")
                ]
            ),
            "one-card": TarotSpreadDetail(
                id: "one-card",
                name: "Daily Card",
                cardCount: 1,
                description: "Single card for daily guidance",
                instructions: [],
                difficulty: "Beginner",
                bestFor: "Quick daily insights and reflection",
                positions: [
                    SpreadPosition(id: 1, title: "Daily Guidance", description: "The card's message for your day")
                ]
            ),
            "pentagram": TarotSpreadDetail(
                id: "pentagram",
                name: "Pentagram Spread",
                cardCount: 5,
                description: "Five elements alignment",
                instructions: [],
                difficulty: "Intermediate",
                bestFor: "Balancing different aspects of life",
                positions: [
                    SpreadPosition(id: 1, title: "Spirit", description: "Your spiritual self and higher purpose"),
                    SpreadPosition(id: 2, title: "Air", description: "Thoughts, communication, and mental clarity"),
                    SpreadPosition(id: 3, title: "Fire", description: "Passion, action, and creative energy"),
                    SpreadPosition(id: 4, title: "Water", description: "Emotions, intuition, and relationships"),
                    SpreadPosition(id: 5, title: "Earth", description: "Material world, physical health, and stability")
                ]
            ),
            "tree-of-life": TarotSpreadDetail(
                id: "tree-of-life",
                name: "Tree of Life",
                cardCount: 10,
                description: "Kabbalistic wisdom spread",
                instructions: [],
                difficulty: "Advanced",
                bestFor: "Spiritual growth and enlightenment",
                positions: [
                    SpreadPosition(id: 1, title: "Kether - Crown", description: "Divine will and highest purpose"),
                    SpreadPosition(id: 2, title: "Chokmah - Wisdom", description: "Wisdom and pure thought"),
                    SpreadPosition(id: 3, title: "Binah - Understanding", description: "Understanding and comprehension"),
                    SpreadPosition(id: 4, title: "Chesed - Mercy", description: "Mercy, love, and expansion"),
                    SpreadPosition(id: 5, title: "Geburah - Severity", description: "Strength, discipline, and justice"),
                    SpreadPosition(id: 6, title: "Tiphareth - Beauty", description: "Balance, harmony, and beauty"),
                    SpreadPosition(id: 7, title: "Netzach - Victory", description: "Victory, persistence, and endurance"),
                    SpreadPosition(id: 8, title: "Hod - Glory", description: "Glory, splendor, and form"),
                    SpreadPosition(id: 9, title: "Yesod - Foundation", description: "Foundation, stability, and connection"),
                    SpreadPosition(id: 10, title: "Malkuth - Kingdom", description: "The material world and manifestation")
                ]
            ),
            "celtic-knot": TarotSpreadDetail(
                id: "celtic-knot",
                name: "Celtic Knot",
                cardCount: 9,
                description: "Interconnected paths and choices",
                instructions: [],
                difficulty: "Advanced",
                bestFor: "Complex decision-making",
                positions: [
                    SpreadPosition(id: 1, title: "Center", description: "The core issue or question"),
                    SpreadPosition(id: 2, title: "Path A", description: "One possible path or choice"),
                    SpreadPosition(id: 3, title: "Path B", description: "Another possible path or choice"),
                    SpreadPosition(id: 4, title: "Path C", description: "A third possible path or choice"),
                    SpreadPosition(id: 5, title: "Path D", description: "A fourth possible path or choice"),
                    SpreadPosition(id: 6, title: "Connection AB", description: "The relationship between paths A and B"),
                    SpreadPosition(id: 7, title: "Connection BC", description: "The relationship between paths B and C"),
                    SpreadPosition(id: 8, title: "Connection CD", description: "The relationship between paths C and D"),
                    SpreadPosition(id: 9, title: "Connection DA", description: "The relationship between paths D and A")
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
            
            if spread != nil {
                // Reading Section - Immersive Canvas View
                ZStack {
                    // Canvas View - Full Screen Immersive Experience
                    GeometryReader { geometry in
                        let screenSize = geometry.size
                        let initialZoom = TarotSpreadLayout.calculateInitialZoom(
                            for: spreadId,
                            canvasSize: canvasSize,
                            screenSize: screenSize
                        )
                        let cardPositions = TarotSpreadLayout.getLayout(
                            for: spreadId,
                            canvasSize: canvasSize
                        )
                        
                        ZStack {
                            // Always render canvas, even if cards are empty
                            TarotCanvasView(
                                canvasSize: canvasSize,
                                initialScale: initialZoom,
                                currentScale: $canvasScale
                            ) {
                                ZStack {
                                    // Test: Visible background to verify canvas renders
                                    Rectangle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: canvasSize.width, height: canvasSize.height)
                                    
                                    // Test: Center marker
                                    Circle()
                                        .fill(Color.green.opacity(0.6))
                                        .frame(width: 50, height: 50)
                                        .position(x: canvasSize.width / 2, y: canvasSize.height / 2)
                                    
                                    if !readingCards.isEmpty && !cardPositions.isEmpty {
                                        let _ = print("🎴 Rendering \(readingCards.count) cards")
                                        
                                        ForEach(Array(readingCards.enumerated()), id: \.element.id) { index, readingCard in
                                            if index < cardPositions.count {
                                                let pos = cardPositions[index].point
                                                let _ = print("   Card \(index): \(readingCard.card.name) at (\(pos.x), \(pos.y))")
                                                
                                                CanvasTarotCard(
                                                    readingCard: readingCard,
                                                    position: cardPositions[index],
                                                    showPositionLabel: canvasScale > 1.2,
                                                    onFlip: {
                                                        flipCard(at: readingCard.id)
                                                    },
                                                    onViewDetails: {
                                                        showingCardDetail = readingCard.card
                                                    }
                                                )
                                                .position(cardPositions[index].point)
                                            }
                                        }
                                    } else {
                                        // Debug text
                                        Text("Cards: \(readingCards.count), Positions: \(cardPositions.count)")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                            .position(x: canvasSize.width / 2, y: canvasSize.height / 2 + 100)
                                        
                                        let _ = print("⚠️ Cards empty: readingCards=\(readingCards.count), cardPositions=\(cardPositions.count)")
                                    }
                                }
                                .frame(width: canvasSize.width, height: canvasSize.height)
                            }
                        }
                    }
                    .ignoresSafeArea()
                    
                    // Top Controls Overlay - Buttons are interactive, rest passes through
                    VStack {
                        // Header with controls
                        HStack {
                            // Back button
                            Button(action: { dismiss() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Close")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                }
                                .foregroundColor(DesignColors.foreground)
                                .padding(.horizontal, DesignSpacing.md)
                                .padding(.vertical, DesignSpacing.sm)
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.4))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                            
                            Spacer()
                            
                            // Action buttons
                            HStack(spacing: 12) {
                                // Reveal All Cards button
                                if !allCardsFlipped {
                                    Button(action: revealAllCards) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "eye.fill")
                                                .font(.system(size: 14))
                                            Text("Reveal All")
                                                .font(DesignTypography.caption1Font(weight: .medium))
                                        }
                                        .foregroundColor(DesignColors.foreground)
                                        .padding(.horizontal, DesignSpacing.md)
                                        .padding(.vertical, DesignSpacing.sm)
                                        .background(
                                            Capsule()
                                                .fill(DesignColors.accent.opacity(0.2))
                                                .overlay(
                                                    Capsule()
                                                        .stroke(DesignColors.accent.opacity(0.4), lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                                
                                // Save Reading button
                                Button(action: saveReading) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "bookmark.fill")
                                            .font(.system(size: 14))
                                        Text("Save")
                                            .font(DesignTypography.caption1Font(weight: .medium))
                                    }
                                    .foregroundColor(DesignColors.foreground)
                                    .padding(.horizontal, DesignSpacing.md)
                                    .padding(.vertical, DesignSpacing.sm)
                                    .background(
                                        Capsule()
                                            .fill(Color.black.opacity(0.4))
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        .padding(.top, DesignSpacing.md)
                        
                        Spacer()
                            .allowsHitTesting(false)  // Spacer doesn't block touches
                        
                        // Bottom Controls
                        HStack {
                            // Restart Reading Button
                            Button(action: restartReading) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 14))
                                    Text("Restart")
                                        .font(DesignTypography.caption1Font(weight: .medium))
                                }
                                .foregroundColor(DesignColors.foreground)
                                .padding(.horizontal, DesignSpacing.md)
                                .padding(.vertical, DesignSpacing.sm)
                                .background(
                                    Capsule()
                                        .fill(Color.black.opacity(0.4))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                            
                            Spacer()
                                .allowsHitTesting(false)  // Spacer doesn't block touches
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        .padding(.bottom, DesignSpacing.lg)
                    }
                    .background(
                        // Transparent background that allows touches to pass through
                        Color.clear
                            .contentShape(Rectangle())
                            .allowsHitTesting(false)
                    )
                }
            } else {
                // Spread not found
                ScrollView {
                    VStack(spacing: 12) {
                        BaseHeader(
                            title: "Reading",
                            subtitle: nil,
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            ),
                            alignment: .leading,
                            horizontalPadding: 0
                        )
                        .padding(.top, 0)
                        
                        BaseCard {
                            VStack {
                                Text("Spread not found")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, 16)
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                }
                .navigationBarHidden(true)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            checkAccessAndDrawCards()
        }
        .sheet(isPresented: $showUnlockModal) {
            UnlockSpreadModal(
                spreadId: spreadId,
                isPresented: $showUnlockModal,
                onUnlock: {
                    handleUnlockSpread()
                }
            )
        }
        .sheet(item: $showingCardDetail) { card in
            TarotCardDetailSheet(card: card)
        }
    }
    
    private func checkAccessAndDrawCards() {
        guard spread != nil else { return }
        
        // Check access
        let (allowed, _, _, isPremiumOnly) = AccessControlService.shared.canAccessSpread(spreadId: spreadId)
        
        if !allowed {
            if isPremiumOnly {
                // Show premium upgrade modal
                showUnlockModal = true
            } else {
                // Show unlock modal
                showUnlockModal = true
            }
            return
        }
        
        drawCards()
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
    
    private func handleUnlockSpread() {
        let (_, cost, permanentCost, _) = AccessControlService.shared.canAccessSpread(spreadId: spreadId)
        
        // Try permanent unlock first if available
        if let permanentCost = permanentCost {
            let result = PointsService.shared.spendPoints(event: "unlock_spread_permanent", cost: permanentCost)
            if result.success {
                AccessControlService.shared.unlockContent(contentId: spreadId, contentType: .tarotSpread, permanent: true)
                drawCards()
                return
            }
        }
        
        // Try temporary unlock
        if let cost = cost {
            let result = PointsService.shared.spendPoints(event: "unlock_spread_temp", cost: cost)
            if result.success {
                AccessControlService.shared.unlockContent(contentId: spreadId, contentType: .tarotSpread, permanent: false)
                drawCards()
            }
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
        }
        drawCards()
    }
    
    private func saveReading() {
        // TODO: Implement save reading functionality
        // This could save the reading to user's saved readings or history
        // For now, this is a placeholder
        print("Save reading: \(spreadId) with \(readingCards.count) cards")
        
        // Award points for completing spread
        if allCardsFlipped {
            _ = PointsService.shared.earnPoints(event: "complete_tarot_spread", points: 10)
            JourneyService.shared.recordActivity(type: "spread", points: 10)
            DailyStateManager.shared.checkAndAwardStreakBonus()
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
                        .frame(width: TarotSpreadCardLayout.defaultWidth, height: TarotSpreadCardLayout.defaultHeight * 0.7)
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
                        .frame(width: TarotSpreadCardLayout.defaultWidth, height: TarotSpreadCardLayout.defaultHeight * 0.7)
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


