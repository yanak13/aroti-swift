//
//  TarotDetailSheet.swift
//  Aroti
//
//  Tarot card detail sheet - share-ready card format
//

import SwiftUI

struct TarotDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let card: TarotCard
    
    private let contentService = DailyContentService.shared
    
    private var insightSentence: String {
        // Derive observational insight sentence from card keywords
        let primaryKeyword = card.keywords.first ?? "insight"
        let variations: [String] = [
            "\(primaryKeyword.capitalized) patterns become more noticeable today",
            "\(primaryKeyword.capitalized) themes play a stronger role today",
            "\(primaryKeyword.capitalized) feels more accessible today"
        ]
        let dayOfYear = contentService.getDayOfYear()
        let index = (dayOfYear + card.id.hashValue) % variations.count
        return variations[index]
    }
    
    private var interpretation: String {
        let dayOfYear = contentService.getDayOfYear()
        return contentService.generateTarotInterpretation(card: card, dayOfYear: dayOfYear)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Insight Card (everything inside, no duplicate identity)
                        InsightCard(
                            systemIcon: AnyView(
                                Group {
                                    if let imageName = card.imageName, !imageName.isEmpty {
                                        Image(imageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 120) // Increased to match larger icon containers
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } else {
                                        // Fallback icon in square container matching onboarding style
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 40, weight: .semibold))
                                            .foregroundColor(.white)
                                            .frame(width: 80, height: 80)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(DesignColors.accent.opacity(0.3))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                                    )
                                            )
                                    }
                                }
                            ),
                            identityChip: card.name,
                            insightSentence: insightSentence,
                            interpretation: interpretation,
                            chipColor: DesignColors.accent
                        )
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, DesignSpacing.md)
                        
                        // Share Button (attached to card, not floating)
                        Button(action: {
                            shareTarotCard()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 16))
                                Text("Share")
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
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, DesignSpacing.sm) // Reduced to 16px for tighter spacing
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Tarot Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
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
    
    private func shareTarotCard() {
        let text = "\(card.name) - Today's Tarot Card\n\n\(insightSentence)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    TarotDetailSheet(
        card: TarotCard(
            id: "fool",
            name: "The Fool",
            keywords: ["New beginnings", "Innocence", "Adventure"],
            interpretation: "A new beginning, innocence, spontaneity, and a free spirit. Embrace new opportunities with an open heart.",
            guidance: ["Trust your instincts", "Take a leap of faith", "Embrace the unknown"],
            imageName: nil
        )
    )
}
