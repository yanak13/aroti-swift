//
//  HomeNumerologyDetailSheet.swift
//  Aroti
//
//  Daily Numerology detail sheet - share-ready card format
//

import SwiftUI

struct HomeNumerologyDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let numerology: NumerologyInsight
    
    private let contentService = DailyContentService.shared
    
    private var interpretation: String {
        let dayOfYear = contentService.getDayOfYear()
        return contentService.generateNumerologyInterpretation(number: numerology.number, dayOfYear: dayOfYear)
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
                                NumerologyHeroIcon(number: numerology.number, color: ArotiColor.accent)
                                    .frame(width: 140, height: 140)
                            ),
                            identityChip: "Number \(numerology.number)",
                            insightTitle: "", // Remove "Today's Insight" title
                            insightSentence: numerology.preview,
                            interpretation: interpretation,
                            chipColor: ArotiColor.accent
                        )
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, DesignSpacing.md)
                        
                        // Share Button (attached to card, not floating)
                        Button(action: {
                            shareNumerology()
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
            .navigationTitle("Numerology")
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
    
    private func shareNumerology() {
        let text = "Numerology - Energy Number \(numerology.number)\n\n\(numerology.preview)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    HomeNumerologyDetailSheet(
        numerology: NumerologyInsight(number: 7, preview: "Introspection patterns play a stronger role")
    )
}
