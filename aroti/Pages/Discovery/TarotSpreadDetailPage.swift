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
    
    // Helper function to get pattern type
    private func getPatternType(for spreadId: String) -> String {
        switch spreadId {
        case "celtic-cross", "tree-of-life":
            return "Classic Pattern"
        case "three-card", "past-present-future", "one-card":
            return "Simple Pattern"
        case "moon-guidance":
            return "Lunar Pattern"
        case "relationship", "career-path", "horseshoe", "pentagram":
            return "Intermediate Pattern"
        case "wheel-of-fortune", "celtic-knot":
            return "Advanced Pattern"
        default:
            return "Traditional Pattern"
        }
    }
    
    // Helper function to get duration
    private func getDuration(for spreadId: String) -> String {
        switch spreadId {
        case "celtic-cross", "tree-of-life":
            return "5–10 min"
        case "three-card", "past-present-future", "one-card":
            return "2–3 min"
        case "moon-guidance", "pentagram":
            return "3–5 min"
        case "relationship", "career-path", "horseshoe":
            return "4–7 min"
        case "wheel-of-fortune", "celtic-knot":
            return "7–12 min"
        default:
            return "5–10 min"
        }
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
            ),
            "relationship": TarotSpreadDetail(
                id: "relationship",
                name: "Relationship Spread",
                cardCount: 7,
                description: "Connection dynamics",
                instructions: [
                    "Focus on a specific relationship. Shuffle your deck with intention.",
                    "Place **Card 1 (You)** on the left, representing your perspective.",
                    "Place **Card 2 (Them)** on the right, representing their perspective.",
                    "Place **Card 3 (Connection)** in the center, showing the bond between you.",
                    "Place **Card 4 (Past)** below, showing what brought you together.",
                    "Place **Card 5 (Present)** above, showing the current state.",
                    "Place **Card 6 (Challenges)** to the left, showing obstacles.",
                    "Place **Card 7 (Future)** to the right, showing potential outcomes."
                ],
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
                instructions: [
                    "Focus on your career or professional life. Shuffle your deck with intention.",
                    "Place **Card 1 (Current Role)** in the center, showing where you are now.",
                    "Place **Card 2 (Skills & Strengths)** to the left, showing your abilities.",
                    "Place **Card 3 (Opportunities)** to the right, showing potential paths.",
                    "Place **Card 4 (Challenges)** below, showing obstacles to overcome.",
                    "Place **Card 5 (Advice)** above, showing guidance for your path.",
                    "Place **Card 6 (Outcome)** at the top, showing potential career direction."
                ],
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
                instructions: [
                    "Focus on the cycles in your life. Shuffle your deck with intention.",
                    "Place **Card 1 (Center)** in the middle, representing the current cycle.",
                    "Place **Card 2 (Ascending)** above, showing what's rising.",
                    "Place **Card 3 (Peak)** to the top-right, showing the highest point.",
                    "Place **Card 4 (Descending)** to the right, showing what's declining.",
                    "Place **Card 5 (Bottom)** below, showing the lowest point.",
                    "Place **Card 6 (Rising)** to the left, showing what's emerging.",
                    "Place **Card 7 (Past Cycle)** to the top-left, showing previous patterns.",
                    "Place **Card 8 (Future Cycle)** to the bottom-right, showing upcoming patterns."
                ],
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
                instructions: [
                    "Focus on your question. Shuffle your deck with intention.",
                    "Place **Card 1 (Past)** on the far left, showing past influences.",
                    "Place **Card 2 (Present)** to the left of center, showing current situation.",
                    "Place **Card 3 (Near Future)** in the center, showing immediate future.",
                    "Place **Card 4 (Distant Future)** to the right of center, showing long-term future.",
                    "Place **Card 5 (Your Approach)** above center, showing your attitude.",
                    "Place **Card 6 (External Influences)** below center, showing outside factors.",
                    "Place **Card 7 (Outcome)** on the far right, showing the final outcome."
                ],
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
                instructions: [
                    "Focus on your day ahead. Shuffle your deck with intention.",
                    "Draw **Card 1 (Daily Guidance)** and place it in the center.",
                    "Reflect on how this card's energy relates to your day.",
                    "Use it as a focus point for meditation or intention setting."
                ],
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
                instructions: [
                    "Focus on balancing different aspects of your life. Shuffle your deck with intention.",
                    "Place **Card 1 (Spirit)** at the top point, representing your spiritual self.",
                    "Place **Card 2 (Air)** at the top-left, representing thoughts and communication.",
                    "Place **Card 3 (Fire)** at the top-right, representing passion and action.",
                    "Place **Card 4 (Water)** at the bottom-left, representing emotions and intuition.",
                    "Place **Card 5 (Earth)** at the bottom-right, representing material and physical aspects."
                ],
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
                instructions: [
                    "Focus on spiritual growth. Shuffle your deck with intention.",
                    "Place **Card 1 (Kether - Crown)** at the top, representing divine will.",
                    "Place **Card 2 (Chokmah - Wisdom)** to the top-right, representing wisdom.",
                    "Place **Card 3 (Binah - Understanding)** to the top-left, representing understanding.",
                    "Place **Card 4 (Chesed - Mercy)** to the right, representing mercy and expansion.",
                    "Place **Card 5 (Geburah - Severity)** to the left, representing strength and discipline.",
                    "Place **Card 6 (Tiphareth - Beauty)** in the center, representing balance and harmony.",
                    "Place **Card 7 (Netzach - Victory)** to the bottom-right, representing victory and persistence.",
                    "Place **Card 8 (Hod - Glory)** to the bottom-left, representing glory and splendor.",
                    "Place **Card 9 (Yesod - Foundation)** below center, representing foundation and stability.",
                    "Place **Card 10 (Malkuth - Kingdom)** at the bottom, representing the material world."
                ],
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
                instructions: [
                    "Focus on a complex decision or situation. Shuffle your deck with intention.",
                    "Place **Card 1 (Center)** in the middle, representing the core issue.",
                    "Place **Card 2 (Path A)** to the top-left, showing one possible path.",
                    "Place **Card 3 (Path B)** to the top-right, showing another possible path.",
                    "Place **Card 4 (Path C)** to the bottom-right, showing a third path.",
                    "Place **Card 5 (Path D)** to the bottom-left, showing a fourth path.",
                    "Place **Card 6 (Connection AB)** between paths A and B, showing their relationship.",
                    "Place **Card 7 (Connection BC)** between paths B and C, showing their relationship.",
                    "Place **Card 8 (Connection CD)** between paths C and D, showing their relationship.",
                    "Place **Card 9 (Connection DA)** between paths D and A, showing their relationship."
                ],
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
                            // Single centered card placeholder (55% width)
                            GeometryReader { geometry in
                                TarotCardBack()
                                    .frame(width: geometry.size.width * 0.55)
                                    .aspectRatio(3/5, contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(height: 340)
                            
                            // Combined Spread Summary and How It Works Panel
                            BaseCard {
                                VStack(alignment: .leading, spacing: 20) {
                                    // Spread Summary Section
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text(spread.name)
                                            .font(DesignTypography.title1Font(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Text(spread.bestFor)
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .multilineTextAlignment(.leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        HStack(spacing: 8) {
                                            // Intermediate badge
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
                                            
                                            // Classic Pattern badge
                                            Text(getPatternType(for: spread.id))
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
                                            
                                            // Duration badge
                                            Text(getDuration(for: spread.id))
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
                                        }
                                    }
                                    
                                    // Divider
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                    
                                    // How It Works Section
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("How It Works")
                                            .font(DesignTypography.title3Font(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Text("Your cards will be automatically drawn and arranged in the traditional \(spread.name) pattern. Focus on your question and begin when you feel ready.")
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .multilineTextAlignment(.leading)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
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
            }
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                if let spread = spread {
                    NavigationLink(destination: TarotSpreadIntentionPage(spreadId: spread.id)) {
                        Text("Start Reading")
                            .font(ArotiTextStyle.subhead)
                            .foregroundColor(ArotiColor.accentText)
                            .frame(maxWidth: .infinity)
                            .frame(height: ArotiButtonHeight.compact)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(ArotiColor.accent)
                                    .shadow(color: ArotiColor.accent.opacity(0.35), radius: 10, x: 0, y: 6)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, DesignSpacing.sm)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TarotSpreadDetailPage(spreadId: "celtic-cross")
    }
}

