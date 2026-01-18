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
                                // Number in circular container matching onboarding style
                                ZStack {
                                    // Soft outer glow
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [
                                                    DesignColors.accent.opacity(0.25),
                                                    DesignColors.accent.opacity(0.12),
                                                    Color.clear
                                                ],
                                                center: .center,
                                                startRadius: 30,
                                                endRadius: 60
                                            )
                                        )
                                        .frame(width: 120, height: 120)
                                        .blur(radius: 8)
                                    
                                    // Inner circle background with gradient
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [
                                                    DesignColors.accent.opacity(0.3),
                                                    DesignColors.accent.opacity(0.2),
                                                    DesignColors.accent.opacity(0.15)
                                                ],
                                                center: .center,
                                                startRadius: 20,
                                                endRadius: 50
                                            )
                                        )
                                        .frame(width: 100, height: 100)
                                    
                                    // Number - larger size
                                    Text("\(numerology.number)")
                                        .font(.system(size: 56, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 100, height: 100)
                            ),
                            identityChip: "Number \(numerology.number)",
                            insightSentence: numerology.preview,
                            interpretation: interpretation,
                            chipColor: DesignColors.accent
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
