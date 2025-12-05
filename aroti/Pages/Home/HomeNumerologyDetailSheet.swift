//
//  HomeNumerologyDetailSheet.swift
//  Aroti
//
//  Daily Numerology explanation sheet for Home page
//

import SwiftUI

struct HomeNumerologyDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let numerology: NumerologyInsight
    
    // Helpers for guidance rows
    @ViewBuilder
    private func guidanceRow(title: String, detail: String) -> some View {
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
    
    // Generate traits based on number
    private var traits: [String] {
        let traitMap: [Int: [String]] = [
            1: ["Leadership", "Independence", "Originality"],
            2: ["Cooperation", "Harmony", "Diplomacy"],
            3: ["Creativity", "Expression", "Optimism"],
            4: ["Stability", "Foundation", "Practicality"],
            5: ["Freedom", "Adventure", "Versatility"],
            6: ["Love", "Responsibility", "Nurturing"],
            7: ["Spiritual", "Introspection", "Analytical"],
            8: ["Material Success", "Power", "Ambition"],
            9: ["Completion", "Wisdom", "Compassion"]
        ]
        return traitMap[numerology.number] ?? ["Intuitive", "Spiritual"]
    }
    
    // Generate guidance based on number
    private var guidance: String {
        let guidanceMap: [Int: String] = [
            1: "Focus on new beginnings and take the lead in your endeavors. Trust your unique vision and move forward with confidence.",
            2: "Embrace cooperation and harmony in your relationships. Balance is key today - listen to others and find common ground.",
            3: "Express your creativity freely. This is a day for communication, joy, and sharing your artistic side with the world.",
            4: "Build solid foundations for your future. Focus on practical matters, organization, and creating stability in your life.",
            5: "Embrace change and seek new experiences. Freedom and adventure call to you - be open to unexpected opportunities.",
            6: "Nurture your relationships and take responsibility for your commitments. Love and care for others brings fulfillment.",
            7: "Spend time in introspection and spiritual practices. Your analytical mind and intuition are particularly strong today.",
            8: "Focus on material success and achievement. Your ambition and determination can lead to significant accomplishments.",
            9: "Complete unfinished business and share your wisdom. Compassion and understanding guide you toward helping others."
        ]
        return guidanceMap[numerology.number] ?? "Your spiritual energy is particularly strong today. Focus on meditation and connecting with your higher self."
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with number
                        VStack(spacing: 16) {
                            // Number icon
                            ZStack {
                                Circle()
                                    .fill(DesignColors.accent.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Text("\(numerology.number)")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(DesignColors.accent)
                            }
                            
                            Text("Numerology")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            // Energy Number chip
                            Text("Energy Number \(numerology.number)")
                                .font(DesignTypography.caption1Font())
                                .foregroundColor(DesignColors.accent)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(DesignColors.accent.opacity(0.2))
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        
                        // Traits Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Traits")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            HStack(spacing: 8) {
                                ForEach(traits, id: \.self) { trait in
                                    Text(trait)
                                        .font(DesignTypography.caption1Font())
                                        .foregroundColor(DesignColors.accent)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            Capsule()
                                                .fill(DesignColors.accent.opacity(0.2))
                                        )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Guidance Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Today's Guidance")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(guidance)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineSpacing(4)
                            
                            // Add concise, parallel tips to match horoscope length/style
                            VStack(alignment: .leading, spacing: 10) {
                                guidanceRow(title: "Morning", detail: "Set one clear intention that aligns with your number's energy.")
                                guidanceRow(title: "Midday", detail: "Take a 3-minute pause to re-center; avoid unnecessary multitasking.")
                                guidanceRow(title: "Evening", detail: "Journal one insight and one action for tomorrow that supports your theme.")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Share Button
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
                        .padding(.top, 8)
                    }
                    .padding(DesignSpacing.sm)
                    .padding(.bottom, 40) // Extra padding to ensure content is fully visible
                }
            }
            .navigationTitle("Numerology")
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
    
    private func shareNumerology() {
        let text = "Numerology - Energy Number \(numerology.number)\n\nTraits: \(traits.joined(separator: ", "))\n\n\(guidance)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    HomeNumerologyDetailSheet(
        numerology: NumerologyInsight(number: 7, preview: "Spiritual focus and introspection")
    )
}

