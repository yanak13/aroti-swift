//
//  CoreGuidanceService.swift
//  Aroti
//
//  Service for managing Core Guidance content and updates
//

import Foundation

class CoreGuidanceService {
    static let shared = CoreGuidanceService()
    
    private var state: CoreGuidanceState
    private static let stateKey = "core_guidance_state"
    private let contentGenerator = CoreGuidanceContentGenerator.shared
    
    private init() {
        self.state = Self.loadState() ?? CoreGuidanceState.default()
        ensureCardsExist()
    }
    
    // MARK: - Public API
    
    /// Get all Core Guidance cards in order (excluding "Right Now")
    func getCards() -> [CoreGuidanceCard] {
        ensureCardsExist()
        return state.cards
            .filter { $0.type != .rightNow }
            .sorted { $0.type.order < $1.type.order }
    }
    
    /// Get a specific card by type
    func getCard(type: CoreGuidanceCardType) -> CoreGuidanceCard? {
        return state.cards.first { $0.type == type }
    }
    
    /// Get a specific card by ID
    func getCard(id: String) -> CoreGuidanceCard? {
        return state.cards.first { $0.id == id }
    }
    
    /// Check if a card has new content (hasn't been opened since last update)
    func hasNewContent(cardId: String) -> Bool {
        guard let card = state.cards.first(where: { $0.id == cardId }) else {
            return false
        }
        
        // Check if content version has changed since last seen
        if let lastSeenVersion = state.contentVersions[cardId],
           lastSeenVersion == card.contentVersion {
            return false
        }
        
        // If never opened, it's new
        if state.lastOpenedDates[cardId] == nil {
            return true
        }
        
        // If content was updated after last open, it's new
        if let lastOpened = state.lastOpenedDates[cardId],
           card.lastUpdated > lastOpened {
            return true
        }
        
        return false
    }
    
    /// Mark a card as opened (clears "New" chip)
    func markCardOpened(cardId: String) {
        state.lastOpenedDates[cardId] = Date()
        state.contentVersions[cardId] = state.cards.first(where: { $0.id == cardId })?.contentVersion
        saveState()
    }
    
    /// Update card content (triggers "New" chip if user hasn't seen it)
    func updateCard(_ card: CoreGuidanceCard) {
        if let index = state.cards.firstIndex(where: { $0.id == card.id }) {
            state.cards[index] = card
        } else {
            state.cards.append(card)
        }
        saveState()
    }
    
    // MARK: - Private Helpers
    
    private func ensureCardsExist() {
        // Ensure all card types exist (excluding "Right Now")
        for cardType in CoreGuidanceCardType.allCases where cardType != .rightNow {
            if state.cards.first(where: { $0.type == cardType }) == nil {
                let newCard = generateDefaultCard(for: cardType)
                state.cards.append(newCard)
            }
        }
        saveState()
    }
    
    private func generateDefaultCard(for type: CoreGuidanceCardType) -> CoreGuidanceCard {
        let (preview, fullInsight, headline, bodyLines) = getDefaultContent(for: type)
        
        // Default timeframe labels
        let timeframeLabel: String
        switch type {
        case .rightNow: timeframeLabel = "Daily Focus"
        case .thisPeriod: timeframeLabel = "Weekly Focus"
        case .whereToFocus: timeframeLabel = "Monthly Focus"
        case .whatsComingUp: timeframeLabel = "Upcoming"
        case .personalInsight: timeframeLabel = "Personal Cycle"
        }
        
        // Default summary sentence
        let summarySentence = bodyLines.first ?? headline
        
        return CoreGuidanceCard(
            id: UUID().uuidString,
            type: type,
            preview: preview,
            fullInsight: fullInsight,
            headline: headline,
            bodyLines: bodyLines,
            lastUpdated: Date(),
            contentVersion: UUID().uuidString,
            contextInfo: nil,
            astrologicalContext: nil,
            numerologyContext: nil,
            expandedContent: nil,
            timeframeLabel: timeframeLabel,
            summarySentence: summarySentence
        )
    }
    
    private func getDefaultContent(for type: CoreGuidanceCardType) -> (preview: String, fullInsight: String, headline: String, bodyLines: [String]) {
        switch type {
        case .rightNow:
            return (
                preview: "A Quiet Shift",
                fullInsight: "Something is changing beneath the surface. You don't need to name it yet. Noticing is enough for now.",
                headline: "A Quiet Shift",
                bodyLines: [
                    "Something is changing beneath the surface.",
                    "You don't need to name it yet.",
                    "Noticing is enough for now."
                ]
            )
        case .thisPeriod:
            return (
                preview: "Re-Evaluating Priorities",
                fullInsight: "What mattered before may not carry the same weight now. This pause has a reason.",
                headline: "Re-Evaluating Priorities",
                bodyLines: [
                    "What mattered before",
                    "may not carry the same weight now.",
                    "This pause has a reason."
                ]
            )
        case .whereToFocus:
            return (
                preview: "Honest Conversations",
                fullInsight: "Harmony isn't the priority right now. Clarity is. Even if it feels uncomfortable.",
                headline: "Honest Conversations",
                bodyLines: [
                    "Harmony isn't the priority right now.",
                    "Clarity is.",
                    "Even if it feels uncomfortable."
                ]
            )
        case .whatsComingUp:
            return (
                preview: "An Emotional Window",
                fullInsight: "A moment is approaching where feelings surface more easily. Staying present will matter.",
                headline: "An Emotional Window",
                bodyLines: [
                    "A moment is approaching",
                    "where feelings surface more easily.",
                    "Staying present will matter."
                ]
            )
        case .personalInsight:
            return (
                preview: "Certainty Before Action",
                fullInsight: "You tend to wait for clarity before moving forward. That instinct has protected you.",
                headline: "Certainty Before Action",
                bodyLines: [
                    "You tend to wait for clarity",
                    "before moving forward.",
                    "That instinct has protected you."
                ]
            )
        }
    }
    
    // MARK: - Persistence
    
    private static func loadState() -> CoreGuidanceState? {
        guard let data = UserDefaults.standard.data(forKey: stateKey),
              let state = try? JSONDecoder().decode(CoreGuidanceState.self, from: data) else {
            return nil
        }
        return state
    }
    
    private func saveState() {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: Self.stateKey)
        }
    }
    
    // MARK: - Update Logic (called periodically or on-demand)
    
    /// Check if a card should update based on its cadence and cycles
    func shouldUpdateCard(type: CoreGuidanceCardType) -> Bool {
        guard let card = state.cards.first(where: { $0.type == type }) else {
            return true
        }
        
        let hoursSinceUpdate = Date().timeIntervalSince(card.lastUpdated) / 3600
        
        // Check time-based cadence
        let timeBasedUpdate: Bool
        switch type {
        case .rightNow:
            timeBasedUpdate = hoursSinceUpdate >= 48 // 48-72 hours
        case .thisPeriod:
            timeBasedUpdate = hoursSinceUpdate >= 168 // Weekly
        case .whereToFocus:
            timeBasedUpdate = hoursSinceUpdate >= 168 // Weekly
        case .whatsComingUp:
            timeBasedUpdate = hoursSinceUpdate >= 72 // 3-5 days
        case .personalInsight:
            timeBasedUpdate = hoursSinceUpdate >= 168 // Weekly
        }
        
        // Check cycle-based updates (e.g., Mercury retrograde, new personal month)
        // For V1, we'll rely on time-based updates, but this can be enhanced
        return timeBasedUpdate
    }
    
    /// Get reason why card should update
    func getUpdateReason(type: CoreGuidanceCardType) -> String? {
        let astroService = AstrologicalCycleService.shared
        
        if astroService.isMercuryRetrograde() {
            return "Mercury retrograde"
        }
        
        // Check for other significant cycles
        let moonPhase = astroService.getCurrentMoonPhase()
        if moonPhase == .new || moonPhase == .full {
            return moonPhase.rawValue
        }
        
        return nil
    }
    
    /// Generate dynamic content for a card type
    func generateDynamicContent(
        cardType: CoreGuidanceCardType,
        userData: UserData
    ) -> (preview: String, fullInsight: String, headline: String, bodyLines: [String], contextInfo: String?, astrologicalContext: String?, numerologyContext: String?, expandedContent: ExpandedGuidanceContent?, timeframeLabel: String?, summarySentence: String?) {
        let generated = contentGenerator.generateContent(cardType: cardType, userData: userData)
        return (
            preview: generated.preview,
            fullInsight: generated.fullInsight,
            headline: generated.headline,
            bodyLines: generated.bodyLines,
            contextInfo: generated.contextInfo,
            astrologicalContext: generated.astrologicalContext,
            numerologyContext: generated.numerologyContext,
            expandedContent: generated.expandedContent,
            timeframeLabel: generated.timeframeLabel,
            summarySentence: generated.summarySentence
        )
    }
    
    /// Update card content with dynamic generation
    func refreshCard(type: CoreGuidanceCardType, userData: UserData) {
        guard let index = state.cards.firstIndex(where: { $0.type == type }) else {
            return
        }
        
        var card = state.cards[index]
        let generated = contentGenerator.generateContent(cardType: card.type, userData: userData)
        
        card = CoreGuidanceCard(
            id: card.id,
            type: card.type,
            preview: generated.preview,
            fullInsight: generated.fullInsight,
            headline: generated.headline,
            bodyLines: generated.bodyLines,
            lastUpdated: Date(),
            contentVersion: UUID().uuidString, // New version triggers "New" chip
            contextInfo: generated.contextInfo,
            astrologicalContext: generated.astrologicalContext,
            numerologyContext: generated.numerologyContext,
            expandedContent: generated.expandedContent,
            timeframeLabel: generated.timeframeLabel,
            summarySentence: generated.summarySentence
        )
        
        state.cards[index] = card
        saveState()
    }
    
    /// Update card content (backward compatibility - uses default content)
    func refreshCard(type: CoreGuidanceCardType) {
        guard let index = state.cards.firstIndex(where: { $0.type == type }) else {
            return
        }
        
        var card = state.cards[index]
        let (preview, fullInsight, headline, bodyLines) = getDefaultContent(for: card.type)
        
        // Default timeframe labels
        let timeframeLabel: String
        switch card.type {
        case .rightNow: timeframeLabel = "Daily Focus"
        case .thisPeriod: timeframeLabel = "Weekly Focus"
        case .whereToFocus: timeframeLabel = "Monthly Focus"
        case .whatsComingUp: timeframeLabel = "Upcoming"
        case .personalInsight: timeframeLabel = "Personal Cycle"
        }
        
        // Default summary sentence
        let summarySentence = bodyLines.first ?? headline
        
        card = CoreGuidanceCard(
            id: card.id,
            type: card.type,
            preview: preview,
            fullInsight: fullInsight,
            headline: headline,
            bodyLines: bodyLines,
            lastUpdated: Date(),
            contentVersion: UUID().uuidString,
            contextInfo: nil,
            astrologicalContext: nil,
            numerologyContext: nil,
            expandedContent: nil,
            timeframeLabel: timeframeLabel,
            summarySentence: summarySentence
        )
        
        state.cards[index] = card
        saveState()
    }
}

