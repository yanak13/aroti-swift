//
//  TarotCardCarousel.swift
//  Aroti
//
//  Premium 3D tarot card carousel with swipe gestures and flip animations
//
//  DESIGN NOTES:
//  - This carousel should live near the top of the Home view hierarchy, below the header
//  - The selectedIndex should be owned by the parent view (HomeView) or a HomeViewModel
//  - For locked cards: tap shows paywall sheet instead of reveal; the card appears dimmed with a lock icon
//

import SwiftUI

// MARK: - TarotCardCarousel

struct TarotCardCarousel: View {
    
    // MARK: - Item Model
    
    struct Item: Identifiable, Hashable {
        let id: UUID
        let title: String
        let cardFrontImageName: String   // Asset name for card front
        let cardBackImageName: String    // Asset name for card back
        let isLocked: Bool               // Premium lock support
        
        init(
            id: UUID = UUID(),
            title: String,
            cardFrontImageName: String,
            cardBackImageName: String = "tarot_back",
            isLocked: Bool = false
        ) {
            self.id = id
            self.title = title
            self.cardFrontImageName = cardFrontImageName
            self.cardBackImageName = cardBackImageName
            self.isLocked = isLocked
        }
    }
    
    // MARK: - Properties
    
    let items: [Item]
    @Binding var selectedIndex: Int
    
    /// Called when user reveals a card (flip animation complete)
    var onReveal: ((Item) -> Void)?
    /// Called when selection changes (swipe or tap to center)
    var onSelect: ((Item) -> Void)?
    
    /// Enable auto-advance timer (default: disabled)
    var autoAdvanceEnabled: Bool = false
    var autoAdvanceInterval: TimeInterval = 4.0
    
    /// Whether the center card can be revealed (default: true)
    var canRevealCenterCard: Bool = true
    
    /// Set of card IDs that are already revealed (external control)
    var revealedCardIDs: Set<UUID> = []
    
    // MARK: - Private State
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var internalRevealedCardIDs: Set<UUID> = []
    @State private var flipProgress: [UUID: CGFloat] = [:]
    @State private var autoAdvanceTimer: Timer?
    // Track which index we've already given haptic feedback for during a drag
    @State private var dragHapticIndex: Int? = nil
    // Flip lift/scale state for active card
    @State private var activeFlipItemID: UUID? = nil
    @State private var flipLiftScale: CGFloat = 1.0
    @State private var flipLiftOffset: CGFloat = 0
    
    // Card dimensions (slightly larger, keeping 2:3 aspect ratio)
    private let cardWidth: CGFloat = 340
    private let cardHeight: CGFloat = 510
    private let cardSpacing: CGFloat = 20
    
    // Animation thresholds
    private let snapThreshold: CGFloat = 40
    
    /// Enable circular/infinite navigation
    var isCircular: Bool = true
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            let containerWidth = geometry.size.width
            
            ZStack {
                // Subtle radial glow background
                carouselBackground
                
                // Card stack (only render visible cards for performance)
                ZStack {
                    ForEach(visibleCardIndices, id: \.self) { index in
                        let item = items[index]
                        let position = positionForCard(at: index)
                        
                        carouselCard(
                            item: item,
                            index: index,
                            position: position,
                            containerWidth: containerWidth
                        )
                        .zIndex(zIndexForCard(position: position))
                    }
                }
                .frame(width: containerWidth, height: cardHeight + 60)
            }
            .frame(height: cardHeight + 80)
            .gesture(dragGesture)
            .onAppear {
                // Sync external revealedCardIDs with internal state
                internalRevealedCardIDs = revealedCardIDs
                // Initialize flip progress for already-revealed cards
                for item in items where revealedCardIDs.contains(item.id) {
                    flipProgress[item.id] = 1.0
                }
                startAutoAdvanceIfNeeded()
            }
            .onChange(of: revealedCardIDs) { _, newValue in
                // Update internal state when external state changes
                internalRevealedCardIDs = newValue
                // Update flip progress for newly revealed cards
                for item in items where newValue.contains(item.id) && !internalRevealedCardIDs.contains(item.id) {
                    flipProgress[item.id] = 1.0
                }
            }
            .onDisappear(perform: stopAutoAdvance)
        }
        .frame(height: cardHeight + 80)
    }
    
    // MARK: - Visible Card Indices
    
    /// Only render center + adjacent cards (max 5) for performance
    /// Supports circular navigation by wrapping indices
    private var visibleCardIndices: [Int] {
        guard !items.isEmpty else { return [] }
        
        var indices: [Int] = []
        
        // Add visible cards: center, left adjacent, right adjacent
        for offset in -2...2 {
            let index = wrappedIndex(selectedIndex + offset)
            if !indices.contains(index) {
                indices.append(index)
            }
        }
        
        // Sort for consistent rendering order (far cards first based on visual position)
        return indices.sorted { index1, index2 in
            abs(visualOffset(for: index1)) > abs(visualOffset(for: index2))
        }
    }
    
    /// Wrap index for circular navigation
    private func wrappedIndex(_ index: Int) -> Int {
        guard !items.isEmpty else { return 0 }
        let count = items.count
        return ((index % count) + count) % count
    }
    
    /// Calculate visual offset (position relative to center) accounting for wrap-around
    private func visualOffset(for index: Int) -> Int {
        guard !items.isEmpty else { return 0 }
        let count = items.count
        
        // Direct offset
        let directOffset = index - selectedIndex
        
        if !isCircular {
            return directOffset
        }
        
        // For circular navigation, find the shortest path
        let wrapForwardOffset = directOffset + count
        let wrapBackwardOffset = directOffset - count
        
        // Return the offset with smallest absolute value
        if abs(directOffset) <= abs(wrapForwardOffset) && abs(directOffset) <= abs(wrapBackwardOffset) {
            return directOffset
        } else if abs(wrapForwardOffset) <= abs(wrapBackwardOffset) {
            return wrapForwardOffset
        } else {
            return wrapBackwardOffset
        }
    }
    
    // MARK: - Position Calculation
    
    /// Calculate normalized position for card relative to center (supports circular navigation)
    private func positionForCard(at index: Int) -> CGFloat {
        let basePosition = CGFloat(visualOffset(for: index))
        let dragNormalized = dragOffset / (cardWidth + cardSpacing)
        return basePosition - dragNormalized
    }
    
    // MARK: - Carousel Card
    
    @ViewBuilder
    private func carouselCard(
        item: Item,
        index: Int,
        position: CGFloat,
        containerWidth: CGFloat
    ) -> some View {
        let isRevealed = internalRevealedCardIDs.contains(item.id) || revealedCardIDs.contains(item.id)
        let cardFlipProgress = flipProgress[item.id] ?? (isRevealed ? 1.0 : 0.0)
        let isCentered = abs(position) < 0.1
        
        ZStack {
            // Show back or front based on flip progress
            if cardFlipProgress < 0.5 {
                cardBackView(item: item, isCentered: isCentered)
            } else {
                cardFrontView(item: item)
                    .scaleEffect(x: -1, y: 1) // Correct orientation after flip
            }
            
            // Lock overlay for premium cards
            if item.isLocked && !isRevealed {
                lockOverlay
            }
        }
        .frame(width: cardWidth, height: cardHeight)
        .scaleEffect(scaleForCard(position: position))
        .offset(x: xOffsetForCard(position: position, containerWidth: containerWidth))
        .rotation3DEffect(
            .degrees(rotationForCard(position: position)),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.4
        )
        .rotation3DEffect(
            .degrees(Double(cardFlipProgress) * 180),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
        .opacity(opacityForCard(position: position))
        .blur(radius: blurForCard(position: position))
        .shadow(
            color: Color.black.opacity(isCentered ? 0.4 : 0.2),
            radius: isCentered ? 16 : 8,
            x: 0,
            y: isCentered ? 8 : 4
        )
        // Gentle lift/scale for the actively flipping card
        .scaleEffect(activeFlipItemID == item.id ? flipLiftScale : 1.0)
        .offset(y: activeFlipItemID == item.id ? flipLiftOffset : 0)
        .contentShape(Rectangle())
        .onTapGesture {
            handleCardTap(item: item, index: index, isCentered: isCentered)
        }
        .accessibilityLabel("\(item.title)\(item.isLocked ? ", locked" : "")\(isRevealed ? ", revealed" : "")")
        .accessibilityHint(
            isCentered 
                ? (canRevealCenterCard && !isRevealed ? "Double tap to reveal" : "Double tap to view details")
                : "Double tap to select"
        )
        .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.75), value: position)
    }
    
    // MARK: - Card Back View
    
    private func cardBackView(item: Item, isCentered: Bool) -> some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hue: 235/360, saturation: 0.32, brightness: 0.14),
                            Color(hue: 245/360, saturation: 0.30, brightness: 0.10)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Border with subtle gradient
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            ArotiColor.accent.opacity(0.5),
                            ArotiColor.accent.opacity(0.2),
                            ArotiColor.accent.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
            
            // Inner decorative border
            RoundedRectangle(cornerRadius: 20)
                .stroke(ArotiColor.accent.opacity(0.12), lineWidth: 1)
                .padding(8)
            
            // Decorative pattern
            VStack(spacing: 12) {
                Image(systemName: "sparkle")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(ArotiColor.accent.opacity(0.4))
                
                Image(systemName: "suit.spade.fill")
                    .font(.system(size: 36, weight: .light))
                    .foregroundColor(ArotiColor.accent.opacity(0.5))
                
                Image(systemName: "sparkle")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(ArotiColor.accent.opacity(0.4))
            }
            
            // Corner accents
            VStack {
                HStack {
                    cornerAccent
                    Spacer()
                    cornerAccent
                }
                Spacer()
                HStack {
                    cornerAccent
                    Spacer()
                    cornerAccent
                }
            }
            .padding(16)
            
            // Glow for centered card
            if isCentered {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        RadialGradient(
                            colors: [ArotiColor.accent.opacity(0.12), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 120
                        )
                    )
            }
        }
    }
    
    private var cornerAccent: some View {
        Circle()
            .fill(ArotiColor.accent.opacity(0.25))
            .frame(width: 5, height: 5)
    }
    
    // MARK: - Card Front View
    
    private func cardFrontView(item: Item) -> some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hue: 235/360, saturation: 0.32, brightness: 0.14),
                            Color(hue: 245/360, saturation: 0.30, brightness: 0.10)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Border
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            ArotiColor.accent.opacity(0.6),
                            ArotiColor.accent.opacity(0.3),
                            ArotiColor.accent.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
            
            // Inner decorative borders
            RoundedRectangle(cornerRadius: 20)
                .stroke(ArotiColor.accent.opacity(0.15), lineWidth: 1)
                .padding(8)
            
            RoundedRectangle(cornerRadius: 16)
                .stroke(ArotiColor.accent.opacity(0.08), lineWidth: 1)
                .padding(14)
            
            // Card content
            VStack(spacing: 8) {
                Spacer()
                
                // Card image placeholder or icon
                Image(systemName: getCardIcon(for: item.title))
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(ArotiColor.accent)
                    .shadow(color: ArotiColor.accent.opacity(0.5), radius: 12)
                
                Spacer()
                
                // Card title
                Text(item.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ArotiColor.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 16)
            }
            
            // Reveal glow
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    RadialGradient(
                        colors: [ArotiColor.accent.opacity(0.15), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
        }
    }
    
    // MARK: - Lock Overlay
    
    private var lockOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.4))
            
            VStack(spacing: 8) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 24))
                    .foregroundColor(ArotiColor.textSecondary)
                
                Text("Premium")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
    
    // MARK: - Background
    
    private var carouselBackground: some View {
        RadialGradient(
            colors: [
                ArotiColor.accent.opacity(0.06),
                ArotiColor.accent.opacity(0.02),
                Color.clear
            ],
            center: .center,
            startRadius: 40,
            endRadius: 250
        )
        .blur(radius: 30)
    }
    
    // MARK: - Transform Calculations
    
    private func scaleForCard(position: CGFloat) -> CGFloat {
        let absPos = min(abs(position), 2)
        if absPos < 0.5 {
            return 1.0
        } else if absPos < 1.5 {
            return 0.85
        } else {
            return 0.70
        }
    }
    
    private func xOffsetForCard(position: CGFloat, containerWidth: CGFloat) -> CGFloat {
        // Center + adjacent cards visible with overlap
        let spacing = cardWidth * 0.42
        return position * spacing
    }
    
    private func rotationForCard(position: CGFloat) -> Double {
        // Rotate around Y axis based on position
        return Double(position) * -10
    }
    
    private func opacityForCard(position: CGFloat) -> Double {
        let absPos = abs(position)
        if absPos < 0.5 {
            return 1.0
        } else if absPos < 1.5 {
            return 0.45
        } else {
            return 0.0
        }
    }
    
    private func blurForCard(position: CGFloat) -> CGFloat {
        let absPos = abs(position)
        if absPos < 0.5 {
            return 0
        } else if absPos < 1.5 {
            return 4
        } else {
            return 8
        }
    }
    
    private func zIndexForCard(position: CGFloat) -> Double {
        // Center card has highest z-index
        return Double(10 - abs(position))
    }
    
    // MARK: - Drag Gesture
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onChanged { value in
                isDragging = true
                stopAutoAdvance()
                dragOffset = value.translation.width
                
                // Continuous haptics while user scrolls quickly across cards
                let cardStride = cardWidth + cardSpacing
                guard cardStride > 0, !items.isEmpty else { return }
                
                let dragNormalized = dragOffset / cardStride
                let visualCenter = CGFloat(selectedIndex) - dragNormalized
                let tentativeIndex = wrappedIndex(Int(round(visualCenter)))
                
                if dragHapticIndex != tentativeIndex {
                    dragHapticIndex = tentativeIndex
                    HapticFeedback.impactOccurred(.light)
                }
            }
            .onEnded { value in
                isDragging = false
                
                let velocity = value.predictedEndTranslation.width - value.translation.width
                let shouldSnapNext = dragOffset < -snapThreshold || velocity < -200
                let shouldSnapPrev = dragOffset > snapThreshold || velocity > 200
                
                withAnimation(.interactiveSpring(response: 0.32, dampingFraction: 0.8)) {
                    if shouldSnapNext {
                        // Move to next card (circular)
                        if isCircular {
                            selectedIndex = wrappedIndex(selectedIndex + 1)
                        } else if selectedIndex < items.count - 1 {
                            selectedIndex += 1
                        }
                        HapticFeedback.impactOccurred(.medium)
                        notifySelection()
                    } else if shouldSnapPrev {
                        // Move to previous card (circular)
                        if isCircular {
                            selectedIndex = wrappedIndex(selectedIndex - 1)
                        } else if selectedIndex > 0 {
                            selectedIndex -= 1
                        }
                        HapticFeedback.impactOccurred(.medium)
                        notifySelection()
                    }
                    dragOffset = 0
                }
                
                dragHapticIndex = nil
                startAutoAdvanceIfNeeded()
            }
    }
    
    // MARK: - Tap Handling
    
    private func handleCardTap(item: Item, index: Int, isCentered: Bool) {
        if !isCentered {
            // Find the target index - for circular, we might need to adjust
            let targetIndex: Int
            if isCircular {
                // Use the visual offset to determine direction
                let offset = visualOffset(for: index)
                targetIndex = wrappedIndex(selectedIndex + offset)
            } else {
                targetIndex = index
            }
            
            // Animate to center
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.75)) {
                selectedIndex = targetIndex
            }
            HapticFeedback.impactOccurred(.light)
            notifySelection()
        } else {
            // Center card tapped
            let isAlreadyRevealed = internalRevealedCardIDs.contains(item.id) || revealedCardIDs.contains(item.id)
            
            // In revealed stage (or when card already revealed), just open insights
            if !canRevealCenterCard || isAlreadyRevealed {
                onReveal?(item)
                return
            }
            
            // Pre-revealed: actually perform flip if not locked
            if item.isLocked {
                // For locked cards, parent should show paywall
                onReveal?(item)
            } else {
                performFlipAnimation(for: item)
            }
        }
    }
    
    // MARK: - Flip Animation
    
    private func performFlipAnimation(for item: Item) {
        HapticFeedback.impactOccurred(.medium)
        
        activeFlipItemID = item.id
        
        // Step 1: quick lift + subtle scale up
        withAnimation(.easeOut(duration: 0.12)) {
            flipLiftScale = 1.04
            flipLiftOffset = -6
        }
        
        // Step 2: perform the 3D flip
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.easeInOut(duration: 0.4)) {
                flipProgress[item.id] = 1.0
            }
        }
        
        // Step 3: settle back, mark revealed, then notify parent (which opens the sheet)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12 + 0.4) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                flipLiftScale = 1.0
                flipLiftOffset = 0
            }
            
            internalRevealedCardIDs.insert(item.id)
            activeFlipItemID = nil
            HapticFeedback.impactOccurred(.light)
            onReveal?(item)
        }
    }
    
    // MARK: - Selection Notification
    
    private func notifySelection() {
        guard selectedIndex < items.count else { return }
        onSelect?(items[selectedIndex])
    }
    
    // MARK: - Auto Advance
    
    private func startAutoAdvanceIfNeeded() {
        guard autoAdvanceEnabled else { return }
        stopAutoAdvance()
        
        autoAdvanceTimer = Timer.scheduledTimer(
            withTimeInterval: autoAdvanceInterval,
            repeats: true
        ) { _ in
            guard !isDragging else { return }
            
            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.75)) {
                selectedIndex = wrappedIndex(selectedIndex + 1)
            }
            notifySelection()
        }
    }
    
    private func stopAutoAdvance() {
        autoAdvanceTimer?.invalidate()
        autoAdvanceTimer = nil
    }
    
    // MARK: - Card Icon Helper
    
    private func getCardIcon(for title: String) -> String {
        let lowercased = title.lowercased()
        
        if lowercased.contains("fool") { return "figure.walk" }
        if lowercased.contains("magician") { return "wand.and.stars" }
        if lowercased.contains("priestess") { return "moon.stars" }
        if lowercased.contains("empress") { return "crown" }
        if lowercased.contains("emperor") { return "building.columns" }
        if lowercased.contains("hierophant") { return "book.closed" }
        if lowercased.contains("lovers") { return "heart.fill" }
        if lowercased.contains("chariot") { return "car.fill" }
        if lowercased.contains("strength") { return "flame" }
        if lowercased.contains("hermit") { return "flashlight.on.fill" }
        if lowercased.contains("wheel") { return "circle.hexagongrid" }
        if lowercased.contains("justice") { return "scalemass" }
        if lowercased.contains("hanged") { return "figure.stand" }
        if lowercased.contains("death") { return "leaf" }
        if lowercased.contains("temperance") { return "drop.triangle" }
        if lowercased.contains("devil") { return "flame.fill" }
        if lowercased.contains("tower") { return "bolt.fill" }
        if lowercased.contains("star") { return "star.fill" }
        if lowercased.contains("moon") { return "moon.fill" }
        if lowercased.contains("sun") { return "sun.max.fill" }
        if lowercased.contains("judgement") { return "horn.blast" }
        if lowercased.contains("world") { return "globe" }
        
        // Minor arcana suits
        if lowercased.contains("wands") { return "wand.and.rays" }
        if lowercased.contains("cups") { return "cup.and.saucer" }
        if lowercased.contains("swords") { return "xmark" }
        if lowercased.contains("pentacles") { return "circle.fill" }
        
        return "sparkles"
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        CelestialBackground()
        
        VStack(spacing: 24) {
            Text("Pick a Card")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
            
            TarotCardCarousel(
                items: [
                    .init(title: "The Fool", cardFrontImageName: "tarot_the_fool"),
                    .init(title: "The Magician", cardFrontImageName: "tarot_the_magician"),
                    .init(title: "The High Priestess", cardFrontImageName: "tarot_the_priestess"),
                    .init(title: "The Empress", cardFrontImageName: "tarot_the_empress", isLocked: true),
                    .init(title: "The Emperor", cardFrontImageName: "tarot_the_emperor")
                ],
                selectedIndex: .constant(2),
                onReveal: { item in
                    print("Revealed: \(item.title)")
                },
                onSelect: { item in
                    print("Selected: \(item.title)")
                }
            )
            
            Spacer()
        }
        .padding(.top, 60)
    }
}

