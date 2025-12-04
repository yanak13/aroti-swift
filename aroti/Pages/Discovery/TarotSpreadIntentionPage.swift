//
//  TarotSpreadIntentionPage.swift
//  Aroti
//
//  Page for setting intention/question before tarot reading
//

import SwiftUI

struct TarotSpreadIntentionPage: View {
    @Environment(\.dismiss) private var dismiss
    let spreadId: String
    
    @State private var intention: String = ""
    @State private var showTextarea: Bool = false
    
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
                positions: []
            ),
            "three-card": TarotSpreadDetail(
                id: "three-card",
                name: "Three Card Spread",
                cardCount: 3,
                description: "Past, present, future",
                instructions: [],
                difficulty: "Beginner",
                bestFor: "Quick insights and daily guidance",
                positions: []
            ),
            "past-present-future": TarotSpreadDetail(
                id: "past-present-future",
                name: "Past Present Future",
                cardCount: 3,
                description: "Timeline insights",
                instructions: [],
                difficulty: "Beginner",
                bestFor: "Understanding your journey through time",
                positions: []
            ),
            "moon-guidance": TarotSpreadDetail(
                id: "moon-guidance",
                name: "Moon Guidance",
                cardCount: 5,
                description: "Lunar cycle wisdom",
                instructions: [],
                difficulty: "Beginner",
                bestFor: "Aligning with lunar energy and cycles",
                positions: []
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
                        title: spread?.name ?? "Set Your Intention",
                        subtitle: "Set your intention",
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
                            // Introduction Section
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Take a Pause")
                                        .font(DesignTypography.title3Font(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text("Before we begin, take a moment to focus on what you'd like clarity on. This helps your reading feel more aligned and meaningful.")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Intention Input Section
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Your Intention (Optional)")
                                        .font(DesignTypography.headlineFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    DesignTextarea(
                                        text: $intention,
                                        placeholder: "What's on your mind today?"
                                    )
                                    .frame(minHeight: 150)
                                    .opacity(showTextarea ? 1.0 : 0.0)
                                    .animation(.easeIn(duration: 0.25), value: showTextarea)
                                    
                                    Text("You can skip this step if you prefer.")
                                        .font(DesignTypography.footnoteFont())
                                        .italic()
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            // Continue Button
                            NavigationLink(destination: TarotSpreadReadingPage(spreadId: spread.id, intention: intention.isEmpty ? nil : intention)) {
                                HStack(spacing: 8) {
                                    Text("Begin Reading")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(DesignColors.accent)
                                        .shadow(color: DesignColors.accent.opacity(0.35), radius: 10, x: 0, y: 6)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.top, 16)
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
            .onAppear {
                // Trigger textarea fade-in animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showTextarea = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TarotSpreadIntentionPage(spreadId: "celtic-cross")
    }
}

