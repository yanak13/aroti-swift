//
//  AffirmationDetailSheet.swift
//  Aroti
//
//  Daily Affirmation explanation sheet for Home page
//

import SwiftUI

struct AffirmationDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let affirmation: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Text("Today's Affirmation")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Repeat this throughout your day to anchor your energy.")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        
                        // Main affirmation card
                        BaseCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(DesignColors.accent.opacity(0.18))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "quote.bubble")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(DesignColors.accent)
                                    }
                                    
                                    Text("Affirmation for today")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Spacer()
                                }
                                
                                Text(affirmation)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .lineSpacing(6)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Gentle usage guidance
                        VStack(alignment: .leading, spacing: 14) {
                            Text("How to work with this affirmation")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                guidanceRow(
                                    title: "Morning",
                                    detail: "Read the affirmation slowly 3 times while taking gentle breaths."
                                )
                                guidanceRow(
                                    title: "Midday",
                                    detail: "Repeat it once before opening your phone or switching tasks."
                                )
                                guidanceRow(
                                    title: "Evening",
                                    detail: "Write down one moment from today where this affirmation felt true."
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Share button
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
                        .padding(.top, 8)
                    }
                    .padding(DesignSpacing.sm)
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
    
    // MARK: - Helpers
    
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
    
    private func shareAffirmation() {
        let text = "Today's affirmation:\n\n\"\(affirmation)\""
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    AffirmationDetailSheet(
        affirmation: "I am grounded, centered, and at peace."
    )
}


