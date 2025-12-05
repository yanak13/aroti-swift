//
//  TarotDetailSheet.swift
//  Aroti
//
//  Tarot card explanation sheet
//

import SwiftUI

struct TarotDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let card: TarotCard
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with tarot card preview and metadata
                        VStack(spacing: 16) {
                            // Card artwork
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(hue: 235/360, saturation: 0.30, brightness: 0.11),
                                                Color(hue: 240/360, saturation: 0.28, brightness: 0.13)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 180, height: 300)
                                    .shadow(color: DesignColors.accent.opacity(0.35), radius: 24, x: 0, y: 18)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(DesignColors.accent.opacity(0.35), lineWidth: 1)
                                    )
                                
                                if let imageName = card.imageName, !imageName.isEmpty {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 180, height: 300)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } else {
                                    VStack(spacing: 12) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 36, weight: .semibold))
                                            .foregroundColor(DesignColors.accent)
                                        Text(card.name)
                                            .font(DesignTypography.subheadFont(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                    }
                                    .frame(width: 160, height: 260)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            Text(card.name)
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            // Keywords chips
                            HStack(spacing: 8) {
                                ForEach(card.keywords, id: \.self) { keyword in
                                    Text(keyword)
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
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        
                        // Interpretation Section
                        if let interpretation = card.interpretation {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Interpretation")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(interpretation)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Guidance Section
                        if let guidance = card.guidance, !guidance.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Today's Guidance")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(guidance, id: \.self) { tip in
                                        HStack(alignment: .top, spacing: 12) {
                                            Circle()
                                                .fill(DesignColors.accent)
                                                .frame(width: 6, height: 6)
                                                .padding(.top, 6)
                                            
                                            Text(tip)
                                                .font(DesignTypography.bodyFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                                .lineSpacing(4)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Share Button
                        Button(action: {
                            // Share functionality
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
                        .padding(.top, 8)
                    }
                    .padding(DesignSpacing.sm)
                    .padding(.bottom, 40) // Extra padding to ensure content is fully visible
                }
            }
            .navigationTitle("Tarot Card")
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
    
    private func shareTarotCard() {
        // Share implementation
        let text = "\(card.name)\n\n\(card.interpretation ?? "")\n\nKeywords: \(card.keywords.joined(separator: ", "))"
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

