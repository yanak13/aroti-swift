//
//  TarotSpreadDetailPage.swift
//  Aroti
//
//  Tarot spread detail page with instructions
//

import SwiftUI

struct TarotSpreadDetail: Identifiable {
    let id: String
    let name: String
    let cardCount: Int
    let description: String
    let instructions: [String]
    let difficulty: String
    let bestFor: String
}

struct TarotSpreadDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    let spreadId: String
    
    private var spread: TarotSpreadDetail? {
        let spreads: [String: TarotSpreadDetail] = [
            "celtic-cross": TarotSpreadDetail(
                id: "celtic-cross",
                name: "Celtic Cross",
                cardCount: 10,
                description: "Comprehensive 10-card spread",
                instructions: [
                    "Shuffle your deck while focusing on your question or situation.",
                    "Place Card 1 (Current Situation) in the center, horizontal.",
                    "Place Card 2 (Challenge/Opportunity) across Card 1, vertical.",
                    "Place Card 3 (Distant Past) below the cross.",
                    "Place Card 4 (Recent Past) to the left of the cross.",
                    "Place Card 5 (Possible Future) above the cross.",
                    "Place Card 6 (Near Future) to the right of the cross.",
                    "Place Card 7 (Your Approach) below the staff.",
                    "Place Card 8 (External Influences) to the left of the staff.",
                    "Place Card 9 (Hopes and Fears) above the staff.",
                    "Place Card 10 (Outcome) at the top of the staff."
                ],
                difficulty: "Intermediate",
                bestFor: "General guidance and deep insights"
            ),
            "three-card": TarotSpreadDetail(
                id: "three-card",
                name: "Three Card Spread",
                cardCount: 3,
                description: "Past, present, future",
                instructions: [
                    "Shuffle your deck while thinking about your question.",
                    "Place Card 1 (Past) on the left.",
                    "Place Card 2 (Present) in the center.",
                    "Place Card 3 (Future) on the right.",
                    "Read the cards from left to right, seeing how they tell a story."
                ],
                difficulty: "Beginner",
                bestFor: "Quick insights and daily guidance"
            ),
            "past-present-future": TarotSpreadDetail(
                id: "past-present-future",
                name: "Past Present Future",
                cardCount: 3,
                description: "Timeline insights",
                instructions: [
                    "Focus on a specific area of your life.",
                    "Shuffle and place three cards in a row.",
                    "Card 1 represents influences from your past affecting the present.",
                    "Card 2 shows your current situation and energies.",
                    "Card 3 reveals potential outcomes based on current trajectory."
                ],
                difficulty: "Beginner",
                bestFor: "Understanding your journey through time"
            ),
            "moon-guidance": TarotSpreadDetail(
                id: "moon-guidance",
                name: "Moon Guidance",
                cardCount: 5,
                description: "Lunar cycle wisdom",
                instructions: [
                    "Connect with the current moon phase.",
                    "Card 1: What to release during the waning moon.",
                    "Card 2: What to set during the new moon.",
                    "Card 3: What to nurture during the waxing moon.",
                    "Card 4: What to celebrate during the full moon.",
                    "Card 5: Overall lunar guidance for this cycle."
                ],
                difficulty: "Beginner",
                bestFor: "Aligning with lunar energy and cycles"
            )
        ]
        return spreads[spreadId]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        BaseHeader(
                            title: spread?.name ?? "Spread",
                            subtitle: spread != nil ? "\(spread!.cardCount) Card Spread" : nil,
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            )
                        )
                        .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                        
                        if let spread = spread {
                            // Content
                            VStack(spacing: 16) {
                                // Hero Section
                                BaseCard {
                                    HStack(spacing: 16) {
                                        TarotCardBack()
                                            .frame(width: 96, height: 160)
                                        
                                        VStack(alignment: .leading, spacing: 12) {
                                            Text(spread.name)
                                                .font(DesignTypography.title1Font(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            Text(spread.description)
                                                .font(DesignTypography.bodyFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                            
                                            HStack(spacing: 8) {
                                                Text(spread.difficulty)
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
                                                
                                                Text("\(spread.cardCount) Cards")
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
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Best For Section
                                BaseCard {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 20))
                                            .foregroundColor(DesignColors.accent)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Best For")
                                                .font(DesignTypography.headlineFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            Text(spread.bestFor)
                                                .font(DesignTypography.bodyFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Instructions Section
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("How to Perform This Spread")
                                            .font(DesignTypography.title3Font(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        VStack(spacing: 12) {
                                            ForEach(Array(spread.instructions.enumerated()), id: \.offset) { index, instruction in
                                                HStack(alignment: .top, spacing: 12) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(DesignColors.accent.opacity(0.2))
                                                            .frame(width: 24, height: 24)
                                                        
                                                        Text("\(index + 1)")
                                                            .font(DesignTypography.footnoteFont(weight: .medium))
                                                            .foregroundColor(DesignColors.accent)
                                                    }
                                                    
                                                    Text(instruction)
                                                        .font(DesignTypography.bodyFont())
                                                        .foregroundColor(DesignColors.foreground)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Start Reading Button
                                Button(action: {
                                    // TODO: Navigate to reading interface
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(DesignColors.accent)
                                        
                                        Text("Start Reading")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                            .foregroundColor(DesignColors.accent)
                                        
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 16))
                                            .foregroundColor(DesignColors.accent)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(DesignColors.accent.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 60)
                        } else {
                            // Not Found
                            BaseCard {
                                VStack {
                                    Text("This spread could not be found.")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            .padding(.top, 16)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        TarotSpreadDetailPage(spreadId: "celtic-cross")
    }
}

