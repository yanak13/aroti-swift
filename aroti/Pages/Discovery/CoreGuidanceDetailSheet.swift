//
//  CoreGuidanceDetailSheet.swift
//  Aroti
//
//  Premium Insight Detail Page - Minimal Premium V1
//

import SwiftUI

struct CoreGuidanceDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let card: CoreGuidanceCard
    @Binding var selectedTab: TabItem
    @State private var showLegitimacySheet = false
    @State private var showReflectionSheet = false
    @State private var displayedCard: CoreGuidanceCard?
    
    private let manager = DailyStateManager.shared
    private let guidanceService = CoreGuidanceService.shared
    private let stateManager = DailyStateManager.shared
    
    // Use displayedCard if available, otherwise fall back to card
    private var currentCard: CoreGuidanceCard {
        displayedCard ?? card
    }
    
    // Computed property for full insight text to attach to guidance message
    private var fullInsightText: String {
        guard let expanded = currentCard.expandedContent else {
            return currentCard.displayHeadline
        }
        
        var text = expanded.oneLineInsight + "\n\n"
        text += expanded.insightBullets.joined(separator: "\n") + "\n\n"
        text += expanded.guidance.joined(separator: "\n")
        
        return text
    }
    
    // Computed property for timeframe label
    private var timeframeLabel: String {
        currentCard.timeframeLabel ?? getDefaultTimeframeLabel(for: currentCard.type)
    }
    
    private func getDefaultTimeframeLabel(for type: CoreGuidanceCardType) -> String {
        switch type {
        case .rightNow: return "Daily Focus"
        case .thisPeriod: return "Weekly Focus"
        case .whereToFocus: return "Monthly Focus"
        case .whatsComingUp: return "Upcoming"
        case .personalInsight: return "Personal Cycle"
        }
    }
    
    // Computed property for date range string
    private var timeframeDateRange: String {
        let calendar = Calendar.current
        let today = Date()
        
        switch currentCard.type {
        case .rightNow:
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: today)
            
        case .thisPeriod:
            // Weekly: Start of week to end of week
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) ?? today
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? today
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
            
        case .whereToFocus:
            // Monthly: Current month
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: today)
            
        case .whatsComingUp:
            // Next 1-2 months
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: today) ?? today
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            return "\(formatter.string(from: today)) - \(formatter.string(from: nextMonth))"
            
        case .personalInsight:
            // Current month/year
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: today)
        }
    }
    
    private var hasReflectionToday: Bool {
        !manager.loadTodayReflections().isEmpty
    }
    
    private var todayReflections: [ReflectionEntry] {
        manager.loadTodayReflections()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Hero Section (matching LearningIntroCard style)
                        heroSection()
                            .padding(.horizontal, DesignSpacing.sm)
                            .padding(.top, DesignSpacing.md)
                            .padding(.bottom, DesignSpacing.md)
                        
                        // Main Content Sections (matching ArticleDetailPage style)
                        if let expanded = currentCard.expandedContent {
                            mainContentSections(expanded: expanded)
                                .padding(.horizontal, DesignSpacing.sm)
                        } else {
                            // Loading state
                            VStack(spacing: 16) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: DesignColors.accent))
                                Text("Loading content...")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                        
                        // Ask Aroti Button
                        VStack(spacing: 8) {
                            Button(action: {
                                navigateToGuidance()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "message.fill")
                                        .font(.system(size: 16))
                                    Text("Ask Aroti")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                                        .fill(DesignColors.accent)
                                )
                            }
                            
                            // Optional supporting hint
                            Text("Explore what this means for you")
                                .font(DesignTypography.caption1Font())
                                .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, DesignSpacing.lg)
                        
                        // Reflection Section (if needed)
                        if hasReflectionToday {
                            reflectionSection()
                                .padding(.horizontal, DesignSpacing.sm)
                                .padding(.top, DesignSpacing.lg)
                        }
                        
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
            .navigationTitle(currentCard.headline ?? currentCard.type.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Done button only
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.accent)
                }
            }
        }
        .onAppear {
            refreshCardIfNeeded()
        }
        .sheet(isPresented: $showLegitimacySheet) {
            CoreGuidanceLegitimacySheet(cardType: currentCard.type)
        }
        .sheet(isPresented: $showReflectionSheet) {
            ReflectionSheet(
                prompt: currentCard.expandedContent?.reflectionQuestions.first ?? ""
            )
        }
    }
    
    // MARK: - Card Refresh
    
    private func refreshCardIfNeeded() {
        // Check if this is a premium event card (ID starts with "premium_event_")
        let isPremiumEventCard = currentCard.id.hasPrefix("premium_event_")
        
        if let userData = stateManager.loadUserData() {
            // If card doesn't have expandedContent, refresh it first
            if currentCard.expandedContent == nil {
                if isPremiumEventCard {
                    // For premium event cards, refresh by regenerating from events
                    // The card will be regenerated when getPremiumEventCards is called
                } else {
                    guidanceService.refreshCard(type: currentCard.type, userData: userData)
                }
            }
            
            // Get the latest card from service
            // For premium event cards, use ID lookup; for regular cards, use type lookup
            if isPremiumEventCard {
                // Look up by ID for premium event cards
                if let latestCard = guidanceService.getCard(id: currentCard.id) {
                    displayedCard = latestCard
                } else {
                    // If card not found, try to get it from premium event cards
                    let premiumCards = guidanceService.getPremiumEventCards(userData: userData)
                    if let matchingCard = premiumCards.first(where: { $0.id == currentCard.id }) {
                        displayedCard = matchingCard
                    }
                }
            } else {
                // For regular cards, use type lookup
                if let latestCard = guidanceService.getCard(type: currentCard.type) {
                    displayedCard = latestCard
                }
            }
        }
    }
    
    // MARK: - Hero Section (matching LearningIntroCard)
    
    private func heroSection() -> some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                // Category chips (matching ArticleDetailPage style)
                HStack(spacing: 8) {
                    // Premium chip
                    Text("Premium Forecast")
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
                    
                    // Event type chip (extract from contextInfo or use timeframe)
                    if let contextInfo = currentCard.contextInfo {
                        Text(contextInfo)
                            .font(DesignTypography.footnoteFont(weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    } else if let timeframeLabel = currentCard.timeframeLabel {
                        Text(timeframeLabel)
                            .font(DesignTypography.footnoteFont(weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                }
                
                // Title (matching ArticleDetailPage)
                Text(currentCard.headline ?? currentCard.type.title)
                    .font(DesignTypography.title2Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                // REMOVED: Subtitle/One-line description - this duplicates Overview section below
                // The Overview section will show this content instead
                
                // Divider (matching ArticleDetailPage)
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Meta info (date range, timeframe, etc.)
                if let metaInfo = getMetaInfo() {
                    Text(metaInfo)
                        .font(DesignTypography.caption2Font())
                        .foregroundColor(DesignColors.mutedForeground)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // Helper to generate meta info string
    private func getMetaInfo() -> String? {
        var metaParts: [String] = []
        
        // Add timeframe date range if available
        let dateRange = timeframeDateRange
        if !dateRange.isEmpty {
            metaParts.append(dateRange)
        }
        
        // Add astrological/numerological context if available
        if let astroContext = currentCard.astrologicalContext {
            metaParts.append(astroContext.components(separatedBy: " • ").first ?? astroContext)
        }
        if let numContext = currentCard.numerologyContext {
            metaParts.append(numContext.components(separatedBy: " • ").first ?? numContext)
        }
        
        return metaParts.isEmpty ? nil : metaParts.joined(separator: " • ")
    }
    
    // MARK: - Main Content Sections (matching ArticleDetailPage style)
    
    @ViewBuilder
    private func mainContentSections(expanded: ExpandedGuidanceContent) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            // Overview Section (expanded oneLineInsight as paragraph with justified text)
            VStack(alignment: .leading, spacing: 12) {
                Text("Overview")
                    .font(DesignTypography.title3Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                Text(justifiedText(expanded.oneLineInsight))
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Key Insights Section
            if !expanded.insightBullets.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Insights")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(expanded.insightBullets, id: \.self) { bullet in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.accent)
                                
                                // Parse bullet to emphasize label if it contains ":"
                                let parts = bullet.components(separatedBy: ":")
                                if parts.count == 2 {
                                    (Text(parts[0] + ":")
                                        .font(DesignTypography.bodyFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                     + Text(" " + parts[1])
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.foreground))
                                    .fixedSize(horizontal: false, vertical: true)
                                } else {
                                    Text(bullet)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.foreground)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Detailed Guidance Section
            if !expanded.guidance.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Guidance")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(expanded.guidance, id: \.self) { item in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.accent)
                                
                                // Parse guidance item to emphasize label if it contains ":"
                                let parts = item.components(separatedBy: ":")
                                if parts.count == 2 {
                                    (Text(parts[0] + ":")
                                        .font(DesignTypography.bodyFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                     + Text(" " + parts[1])
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.foreground))
                                    .fixedSize(horizontal: false, vertical: true)
                                } else {
                                    Text(item)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.foreground)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Why This Matters Now Section (enhanced with more context)
            if let contextSection = expanded.contextSection, !contextSection.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Why This Matters Now")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        // Show astrological and numerological context as highlighted tags
                        if let astroContext = currentCard.astrologicalContext {
                            Text(astroContext)
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                        }
                        
                        if let numContext = currentCard.numerologyContext, numContext != currentCard.astrologicalContext {
                            Text(numContext)
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                        }
                        
                        // Detailed context explanation
                        Text(justifiedText(contextSection))
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(4)
                            .padding(.top, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else if let astroContext = currentCard.astrologicalContext, let numContext = currentCard.numerologyContext {
                // Fallback: show context even without detailed explanation
                VStack(alignment: .leading, spacing: 12) {
                    Text("Why This Matters Now")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(astroContext)
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.accent)
                        
                        if numContext != astroContext {
                            Text(numContext)
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Reflection Questions Section
            if !expanded.reflectionQuestions.isEmpty {
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reflection")
                        .font(DesignTypography.title3Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(expanded.reflectionQuestions, id: \.self) { question in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.accent)
                                Text(question)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 16) // Align with text inside BaseCard (BaseCard has 16pt internal padding)
    }
    
    // Helper function to create justified text (matching ArticleDetailPage)
    private func justifiedText(_ text: String) -> AttributedString {
        return createJustifiedText(text)
    }
    
    // MARK: - Minimal Premium Card (deprecated - keeping for backward compatibility)
    
    private func minimalPremiumCard() -> some View {
        guard let expanded = currentCard.expandedContent else {
            return AnyView(
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: DesignColors.accent))
                    Text("Loading content...")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            )
        }
        
        return AnyView(
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    // System icon
                    AnimatedGuidanceSymbol(cardType: currentCard.type)
                        .frame(width: 140, height: 140)
                        .padding(.top, DesignSpacing.lg)
                
                // Timeframe chip (replaces category badge)
                Text(timeframeLabel)
                    .font(ArotiTextStyle.caption1.weight(.semibold))
                    .foregroundColor(ArotiColor.accent)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 5)
                    .frame(height: 28)
                    .background(
                        Capsule()
                            .fill(ArotiColor.accent.opacity(0.2))
                    )
                    .overlay(
                        Capsule()
                            .stroke(ArotiColor.accent.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.top, 8)
                
                // Timeframe date range (below chip)
                Text(timeframeDateRange)
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                    .padding(.top, 8)
                
                // One-Line Insight (MANDATORY - largest text in content area)
                Text(expanded.oneLineInsight)
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 32)
                    .padding(.horizontal, DesignSpacing.sm)
                    .frame(maxWidth: .infinity)
                
                // Insight Breakdown (3 bullets MAX)
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(expanded.insightBullets.prefix(3), id: \.self) { bullet in
                        bulletRow(bullet: bullet)
                    }
                }
                .padding(.top, 32)
                .padding(.horizontal, DesignSpacing.sm)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // "Why Now" (Metadata Only)
                if let astroContext = currentCard.astrologicalContext, let numContext = currentCard.numerologyContext {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Why Now")
                            .font(DesignTypography.bodyFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                            .padding(.top, 32)
                        
                        Text("\(astroContext) · \(numContext)")
                            .font(DesignTypography.bodyFont(weight: .semibold))
                            .foregroundColor(ArotiColor.accent)
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Guidance (MANDATORY - Do, Try, Avoid)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Guidance")
                        .font(DesignTypography.bodyFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                        .padding(.top, 24)
                    
                    ForEach(expanded.guidance.prefix(3), id: \.self) { item in
                        bulletRow(bullet: item)
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Reflection (Short, Specific - max 3 questions)
                if !expanded.reflectionQuestions.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reflection")
                            .font(DesignTypography.bodyFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                            .padding(.top, 24)
                        
                        ForEach(expanded.reflectionQuestions.prefix(3), id: \.self) { question in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.accent)
                                Text(question)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Brand mark at bottom
                Text("Aroti")
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.foreground.opacity(0.45))
                    .padding(.top, 32)
                    .padding(.bottom, DesignSpacing.md)
                }
                .frame(maxWidth: .infinity)
                .padding(DesignSpacing.sm)
                
                // Info button (top right of card)
                Button(action: {
                    showLegitimacySheet = true
                }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 18))
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                        .padding(DesignSpacing.sm)
                }
                .padding(.top, DesignSpacing.md)
                .padding(.trailing, DesignSpacing.md)
            }
            .background(
                // Same card background as InsightCard
                ZStack {
                    // Base gradient
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 16/255, green: 14/255, blue: 24/255, opacity: 0.95),
                                    Color(red: 20/255, green: 17/255, blue: 28/255, opacity: 0.92),
                                    Color(red: 18/255, green: 16/255, blue: 26/255, opacity: 0.93),
                                    Color(red: 22/255, green: 19/255, blue: 30/255, opacity: 0.90)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Secondary radial gradient
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(red: 28/255, green: 24/255, blue: 38/255, opacity: 0.4),
                                    Color(red: 25/255, green: 22/255, blue: 35/255, opacity: 0.25),
                                    Color.clear
                                ],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 250
                            )
                        )
                    
                    // Accent glow
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            RadialGradient(
                                colors: [
                                    ArotiColor.accent.opacity(0.12),
                                    ArotiColor.accent.opacity(0.06),
                                    ArotiColor.accent.opacity(0.02),
                                    Color.clear
                                ],
                                center: .topTrailing,
                                startRadius: 0,
                                endRadius: 180
                            )
                        )
                    
                    // Glass highlight
                    VStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.clear,
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.10),
                                        Color.white.opacity(0.08),
                                        Color.clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 3)
                            .opacity(0.95)
                        Spacer()
                    }
                    
                    // Texture overlay
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.03),
                                    Color.black.opacity(0.015),
                                    Color.white.opacity(0.02),
                                    Color.black.opacity(0.01)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.overlay)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.08),
                                    Color.white.opacity(0.12)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            )
            .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 6)
            .shadow(color: ArotiColor.accent.opacity(0.1), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Helper Views
    
    @ViewBuilder
    private func bulletRow(bullet: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("•")
                .font(DesignTypography.bodyFont(weight: .medium))
                .foregroundColor(DesignColors.accent)
            // Parse bullet to emphasize label (Theme / Best use / Watch for / Do / Try / Avoid)
            let parts = bullet.components(separatedBy: ":")
            if parts.count == 2 {
                (Text(parts[0] + ":")
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                 + Text(" " + parts[1])
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground))
            } else {
                Text(bullet)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    // MARK: - Reflection Section
    
    private func reflectionSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Reflections")
                .font(DesignTypography.subheadFont(weight: .semibold))
                .foregroundColor(DesignColors.foreground)
                .padding(.bottom, 8)
            
            VStack(spacing: DesignSpacing.md) {
                ForEach(Array(todayReflections.enumerated()), id: \.offset) { index, entry in
                    reflectionCardView(entry: entry)
                }
                
                // Add Reflection button
                Button(action: {
                    showReflectionSheet = true
                }) {
                    Text("Add Reflection")
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: ArotiRadius.md)
                                .fill(DesignColors.accent.opacity(0.7))
                        )
                }
            }
        }
    }
    
    private func reflectionCardView(entry: ReflectionEntry) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(formatTimeLabel(entry.timestamp))
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground)
                Spacer()
            }
            
            Text(entry.text)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)
            
            Rectangle()
                .fill(DesignColors.mutedForeground.opacity(0.1))
                .frame(height: 1)
                .padding(.top, 8)
            
            HStack {
                Spacer()
                Text("Aroti")
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.foreground.opacity(0.2))
            }
        }
        .padding(DesignSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.lg)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 16/255, green: 14/255, blue: 24/255, opacity: 0.95),
                            Color(red: 20/255, green: 17/255, blue: 28/255, opacity: 0.92),
                            Color(red: 18/255, green: 16/255, blue: 26/255, opacity: 0.93),
                            Color(red: 22/255, green: 19/255, blue: 30/255, opacity: 0.90)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: ArotiRadius.lg)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.05),
                            Color.clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Navigation
    
    private func navigateToGuidance() {
        // Store the insight text for GuidanceView to pick up
        NotificationCenter.default.post(
            name: NSNotification.Name("NavigateToGuidanceWithInsight"),
            object: nil,
            userInfo: ["insightText": fullInsightText]
        )
        
        // Navigate to guidance tab
        selectedTab = .guidance
        
        // Dismiss the sheet
        dismiss()
    }
    
    // MARK: - Helpers
    
    private func formatTimeLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: date)
        return "Today • \(timeString)"
    }
}

#Preview {
    CoreGuidanceDetailSheet(
        card: CoreGuidanceCard(
            id: "1",
            type: CoreGuidanceCardType.whereToFocus,
            preview: "Build the structure that will support you long-term.",
            fullInsight: "Build the structure that will support you long-term.",
            headline: "Building Foundations",
            bodyLines: ["Build the structure that will support you long-term."],
            lastUpdated: Date(),
            contentVersion: "v1",
            contextInfo: "Personal Year 1 · Personal Month 2",
            astrologicalContext: "Full Moon",
            numerologyContext: "Personal Year 1 · Personal Month 2",
            expandedContent: ExpandedGuidanceContent(
                oneLineInsight: "Build the structure that will support you long-term.",
                insightBullets: [
                    "Theme: responsibility and routine",
                    "Best use: steady progress on one priority",
                    "Watch for: rushing or overcommitting"
                ],
                guidance: [
                    "Do: simplify your plan",
                    "Try: one daily commitment you can keep",
                    "Avoid: adding new pressure"
                ],
                reflectionQuestions: [
                    "What area needs structure most this month?",
                    "What would steady progress look like for you?",
                    "What can move slower without breaking?"
                ],
                contextSection: "Personal Year 1 · Personal Month 2",
                deeperInsight: nil,
                practicalReflection: nil
            ),
            timeframeLabel: "Monthly Focus",
            summarySentence: "Build the structure that will support you long-term."
        ),
        selectedTab: .constant(.home)
    )
}
