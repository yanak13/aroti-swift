//
//  HoroscopeDetailSheet.swift
//  Aroti
//
//  Daily Horoscope explanation sheet
//

import SwiftUI

struct HoroscopeDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let horoscope: String
    let sign: String
    
    // Helpers for guidance rows
    @ViewBuilder
    private func guidanceRow(_ title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(DesignColors.accent)
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(DesignTypography.subheadFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                Text(detail)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .lineSpacing(3)
            }
        }
    }
    
    @ViewBuilder
    private func doDontRow(symbol: String, color: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
                .padding(.top, 2)
            Text(text)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.mutedForeground)
                .lineSpacing(3)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with zodiac symbol
                        VStack(spacing: 16) {
                            // Zodiac symbol icon
                            ZStack {
                                Circle()
                                    .fill(getZodiacColor(sign).opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Text(getZodiacSymbol(sign))
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Daily Horoscope")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            // Sign chip
                            Text(sign)
                                .font(DesignTypography.caption1Font())
                                .foregroundColor(getZodiacColor(sign))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(getZodiacColor(sign).opacity(0.2))
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        
                        // Forecast Section (concise)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Today's Forecast")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(horoscope)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineSpacing(4)
                            
                            Text("Cosmic Interpretation")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Your intuition is heightened. Keep plans simple, check in with your mood before committing, and favor reflective, steady actions over reactive ones.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Light guidance list
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Guidance for Today")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                guidanceRow("Morning", detail: "Two minutes of grounding breath; set one clear focus.")
                                guidanceRow("Midday", detail: "Handle one important task without multitasking.")
                                guidanceRow("Evening", detail: "Note one feeling and one win; set a gentle intention.")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Share Button
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
                        .padding(.top, 8)
                    }
                    .padding(DesignSpacing.sm)
                    .padding(.bottom, 40) // Extra padding to ensure content is fully visible
                }
            }
            .navigationTitle("Horoscope")
            .navigationBarTitleDisplayMode(.inline)
            // Match popup card background (liquid glass surface tone)
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
        horoscope: "Your intuitive nature is heightened today, making it an excellent time for spiritual practices and trusting your inner guidance.",
        sign: "Pisces"
    )
}

