//
//  HoroscopeDetailSheet.swift
//  Aroti
//
//  Daily Horoscope detail sheet - share-ready card format
//

import SwiftUI

struct HoroscopeDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let horoscope: String
    let sign: String
    
    private let contentService = DailyContentService.shared
    
    private var interpretation: String {
        let dayOfYear = contentService.getDayOfYear()
        return contentService.generateHoroscopeInterpretation(sign: sign, dayOfYear: dayOfYear)
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
                                HoroscopeHeroIcon(sign: sign, color: ArotiColor.accent)
                                    .frame(width: 140, height: 140)
                            ),
                            identityChip: sign,
                            insightTitle: "", // Remove "Today's Insight" title
                            insightSentence: horoscope,
                            interpretation: interpretation,
                            chipColor: ArotiColor.accent
                        )
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, DesignSpacing.md)
                        
                        // Share Button (attached to card, not floating)
                        Button(action: {
                            shareHoroscope()
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
            .navigationTitle("Horoscope")
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
    
    private func getZodiacSymbol(_ sign: String) -> String {
        let symbols: [String: String] = [
            "Aries": "♈",
            "Taurus": "♉",
            "Gemini": "♊",
            "Cancer": "♋",
            "Leo": "♌",
            "Virgo": "♍",
            "Libra": "♎",
            "Scorpio": "♏",
            "Sagittarius": "♐",
            "Capricorn": "♑",
            "Aquarius": "♒",
            "Pisces": "♓"
        ]
        return symbols[sign] ?? "♓"
    }
    
    private func getZodiacColor(_ sign: String) -> Color {
        if sign == "Pisces" {
            return Color(hue: 270/360, saturation: 0.7, brightness: 0.8)
        }
        return DesignColors.accent
    }
    
    private func shareHoroscope() {
        let text = "Daily Horoscope - \(sign)\n\n\(horoscope)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    HoroscopeDetailSheet(
        horoscope: "Intuition plays a stronger role today",
        sign: "Pisces"
    )
}
