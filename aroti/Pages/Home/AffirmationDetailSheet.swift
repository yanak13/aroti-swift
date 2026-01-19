//
//  AffirmationDetailSheet.swift
//  Aroti
//
//  Daily Affirmation detail sheet - share-ready card format
//

import SwiftUI

struct AffirmationDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let affirmation: String
    let affirmationSubtitle: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Insight Card (everything inside, matching Horoscope and Numerology)
                        InsightCard(
                            systemIcon: AnyView(
                                AffirmationHeroIcon(color: ArotiColor.accent)
                                    .frame(width: 180, height: 180)
                            ),
                            identityChip: "Affirmation",
                            insightTitle: "", // Empty - remove "Today's Insight" title
                            insightSentence: affirmation,
                            interpretation: "", // Empty - we only show the affirmation phrase
                            chipColor: ArotiColor.accent
                        )
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, DesignSpacing.md)
                        
                        // Share Button (attached to card, not floating)
                        Button(action: {
                            shareAffirmation()
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
            .navigationTitle("Affirmation")
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
    
    private func shareAffirmation() {
        let text = "Today's Affirmation\n\n\"\(affirmation)\""
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    AffirmationDetailSheet(
        affirmation: "I am grounded, centered, and at peace.",
        affirmationSubtitle: "A grounding focus aligned with today"
    )
}
