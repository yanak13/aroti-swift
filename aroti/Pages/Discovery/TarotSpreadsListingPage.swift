//
//  TarotSpreadsListingPage.swift
//  Aroti
//
//  Tarot spreads listing page with difficulty filter
//

import SwiftUI

struct TarotSpreadItem: Identifiable {
    let id: String
    let name: String
    let cardCount: Int
    let description: String
    let difficulty: String
    let bestFor: String
}

struct TarotSpreadsListingPage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var difficultyFilter: String = "All"
    
    let tarotSpreads: [TarotSpreadItem] = [
        TarotSpreadItem(id: "celtic-cross", name: "Celtic Cross", cardCount: 10, description: "Comprehensive 10-card spread", difficulty: "Intermediate", bestFor: "General guidance and deep insights"),
        TarotSpreadItem(id: "three-card", name: "Three Card Spread", cardCount: 3, description: "Past, present, future", difficulty: "Beginner", bestFor: "Quick insights and daily guidance"),
        TarotSpreadItem(id: "past-present-future", name: "Past Present Future", cardCount: 3, description: "Timeline insights", difficulty: "Beginner", bestFor: "Understanding your journey through time"),
        TarotSpreadItem(id: "relationship", name: "Relationship Spread", cardCount: 7, description: "Connection dynamics", difficulty: "Intermediate", bestFor: "Understanding partnerships and connections"),
        TarotSpreadItem(id: "moon-guidance", name: "Moon Guidance", cardCount: 5, description: "Lunar cycle wisdom", difficulty: "Beginner", bestFor: "Aligning with lunar energy and cycles"),
        TarotSpreadItem(id: "career-path", name: "Career Path Spread", cardCount: 6, description: "Professional guidance and direction", difficulty: "Intermediate", bestFor: "Career decisions and professional growth"),
        TarotSpreadItem(id: "wheel-of-fortune", name: "Wheel of Fortune", cardCount: 8, description: "Life cycles and turning points", difficulty: "Advanced", bestFor: "Understanding life patterns and cycles"),
        TarotSpreadItem(id: "horseshoe", name: "Horseshoe Spread", cardCount: 7, description: "Seven-card arc for comprehensive reading", difficulty: "Intermediate", bestFor: "Detailed situation analysis"),
        TarotSpreadItem(id: "one-card", name: "Daily Card", cardCount: 1, description: "Single card for daily guidance", difficulty: "Beginner", bestFor: "Quick daily insights and reflection"),
        TarotSpreadItem(id: "pentagram", name: "Pentagram Spread", cardCount: 5, description: "Five elements alignment", difficulty: "Intermediate", bestFor: "Balancing different aspects of life"),
        TarotSpreadItem(id: "tree-of-life", name: "Tree of Life", cardCount: 10, description: "Kabbalistic wisdom spread", difficulty: "Advanced", bestFor: "Spiritual growth and enlightenment"),
        TarotSpreadItem(id: "celtic-knot", name: "Celtic Knot", cardCount: 9, description: "Interconnected paths and choices", difficulty: "Advanced", bestFor: "Complex decision-making")
    ]
    
    private var filteredSpreads: [TarotSpreadItem] {
        if difficultyFilter == "All" {
            return tarotSpreads
        }
        return tarotSpreads.filter { $0.difficulty == difficultyFilter }
    }
    
    private let difficultyOptions = ["All", "Beginner", "Intermediate", "Advanced"]
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    BaseHeader(
                        title: "Tarot Spreads",
                        subtitle: "Explore different reading layouts",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back to Discovery",
                            action: { dismiss() }
                        )
                    )
                    .padding(.top, 12)
                    
                    // Filter Section
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(difficultyOptions, id: \.self) { option in
                                Button(action: {
                                    difficultyFilter = option
                                }) {
                                    Text(option)
                                        .font(DesignTypography.footnoteFont(weight: .medium))
                                        .foregroundColor(difficultyFilter == option ? DesignColors.accent : DesignColors.mutedForeground)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            Capsule()
                                                .fill(difficultyFilter == option ? DesignColors.accent.opacity(0.2) : Color.white.opacity(0.05))
                                                .overlay(
                                                    Capsule()
                                                        .stroke(difficultyFilter == option ? DesignColors.accent.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                                                )
                                        )
                                }
                            }
                        }
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 12)
                    
                    // Spreads List
                    if filteredSpreads.isEmpty {
                        BaseCard {
                            VStack {
                                Text("No spreads found for this difficulty level.")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    } else {
                        ForEach(filteredSpreads) { spread in
                            NavigationLink(destination: TarotSpreadDetailPage(spreadId: spread.id)) {
                                BaseCard(variant: .interactive, action: {}) {
                                    HStack(spacing: 16) {
                                        TarotCardBack()
                                            .frame(width: 80, height: 128)
                                            .cornerRadius(12)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(spread.name)
                                                .font(DesignTypography.headlineFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            Text(spread.description)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                            
                                            HStack(spacing: 8) {
                                                Text(spread.difficulty)
                                                    .font(DesignTypography.caption2Font(weight: .medium))
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
                                                
                                                Text("\(spread.cardCount) \(spread.cardCount == 1 ? "Card" : "Cards")")
                                                    .font(DesignTypography.caption2Font(weight: .medium))
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
                                            
                                            Text(spread.bestFor)
                                                .font(DesignTypography.caption2Font())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .buttonStyle(CardTapButtonStyle(cornerRadius: 16))
                        }
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 12)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        TarotSpreadsListingPage()
    }
}

