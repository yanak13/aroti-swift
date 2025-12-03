//
//  TarotSpreadDetailPage.swift
//  Aroti
//
//  Tarot spread detail page with instructions
//

import SwiftUI

struct SpreadPosition: Identifiable {
    let id: Int  // 1-based index matching position order
    let title: String  // e.g., "Past", "Current Situation"
    let description: String?  // Optional explanation of what this position means
}

struct TarotSpreadDetail: Identifiable {
    let id: String
    let name: String
    let cardCount: Int
    let description: String
    let instructions: [String]
    let difficulty: String
    let bestFor: String
    let positions: [SpreadPosition]  // Card positions for the spread
}

struct TarotSpreadDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    let spreadId: String
    
    // Helper function to format instruction text with bold highlights
    private func formattedInstructionText(_ text: String) -> Text {
        let parts = text.components(separatedBy: "**")
        var result = Text("")
        
        for (index, part) in parts.enumerated() {
            if index % 2 == 0 {
                // Regular text
                result = result + Text(part)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground)
            } else {
                // Bold text (between ** markers)
                result = result + Text(part)
                    .font(DesignTypography.bodyFont(weight: .semibold))
                    .foregroundColor(DesignColors.accent)
            }
        }
        
        return result
    }
    
    private var spread: TarotSpreadDetail? {
        let spreads: [String: TarotSpreadDetail] = [
            "celtic-cross": TarotSpreadDetail(
                id: "celtic-cross",
                name: "Celtic Cross",
                cardCount: 10,
                description: "Comprehensive 10-card spread",
                instructions: [
                    "Center yourself and focus on your question. Shuffle your deck with intention.",
                    "Place **Card 1 (Current Situation)** in the center, horizontal.",
                    "Place **Card 2 (Challenge/Opportunity)** across Card 1, vertical.",
                    "Place **Card 3 (Distant Past)** below the cross.",
                    "Place **Card 4 (Recent Past)** to the left of the cross.",
                    "Place **Card 5 (Possible Future)** above the cross.",
                    "Place **Card 6 (Near Future)** to the right of the cross.",
                    "Place **Card 7 (Your Approach)** below the staff.",
                    "Place **Card 8 (External Influences)** to the left of the staff.",
                    "Place **Card 9 (Hopes and Fears)** above the staff.",
                    "Place **Card 10 (Outcome)** at the top of the staff."
                ],
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
                instructions: [
                    "Focus on your question and shuffle your deck with intention.",
                    "Place **Card 1 (Past)** on the left.",
                    "Place **Card 2 (Present)** in the center.",
                    "Place **Card 3 (Future)** on the right.",
                    "Read the cards from left to right to see the story unfold."
                ],
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
                instructions: [
                    "Focus on a specific area of your life. Shuffle and place three cards in a row.",
                    "**Card 1 (Past)** represents influences affecting the present.",
                    "**Card 2 (Present)** shows your current situation and energies.",
                    "**Card 3 (Future)** reveals potential outcomes ahead."
                ],
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
                instructions: [
                    "Connect with the current moon phase. Shuffle your deck with lunar intention.",
                    "**Card 1 (Waning Moon)**: What to release and let go.",
                    "**Card 2 (New Moon)**: What intentions to set for new beginnings.",
                    "**Card 3 (Waxing Moon)**: What to nurture and grow.",
                    "**Card 4 (Full Moon)**: What to celebrate and acknowledge.",
                    "**Card 5 (Overall Guidance)**: Comprehensive lunar wisdom for this cycle."
                ],
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
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    // Header
                    BaseHeader(
                        title: spread?.name ?? "Spread",
                        subtitle: spread != nil ? "\(spread!.cardCount) Card Spread" : nil,
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
                                                .multilineTextAlignment(.leading)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
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
                                                .multilineTextAlignment(.leading)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Instructions Section
                            BaseCard {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("How to Perform This Spread")
                                        .font(DesignTypography.title3Font(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    VStack(spacing: 16) {
                                        ForEach(Array(spread.instructions.enumerated()), id: \.offset) { index, instruction in
                                            HStack(alignment: .top, spacing: 16) {
                                                ZStack {
                                                    Circle()
                                                        .fill(DesignColors.accent.opacity(0.2))
                                                        .frame(width: 32, height: 32)
                                                        .overlay(
                                                            Circle()
                                                                .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                                        )
                                                    
                                                    Text("\(index + 1)")
                                                        .font(DesignTypography.footnoteFont(weight: .medium))
                                                        .foregroundColor(DesignColors.accent)
                                                }
                                                
                                                formattedInstructionText(instruction)
                                                    .multilineTextAlignment(.leading)
                                                    .lineSpacing(4)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.top, 2)
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Start Reading Button
                            NavigationLink(destination: TarotSpreadIntentionPage(spreadId: spread.id)) {
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
                        }
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
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 16)
                .padding(.bottom, 60)
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

