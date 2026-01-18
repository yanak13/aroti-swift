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
    
    private let contentService = DailyContentService.shared
    
    private var interpretation: String {
        let dayOfYear = contentService.getDayOfYear()
        return contentService.generateAffirmationInterpretation(dayOfYear: dayOfYear)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Insight Card (everything inside, no duplicate identity)
                        GeometryReader { geometry in
                            let cardHeight = geometry.size.height * 0.70 // ~70% of available height (reduced to ensure CTA visibility)
                            
                            VStack(spacing: 0) {
                                // System icon (matching onboarding circular style)
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
                                    
                                    // Quote bubble icon - larger size
                                    Image(systemName: "quote.bubble")
                                        .font(.system(size: 56, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: 100, height: 100)
                                .padding(.top, DesignSpacing.lg) // More generous top padding
                                
                                // Today's Insight title (reduced size, medium spacing)
                                Text("Today's Insight")
                                    .font(DesignTypography.title3Font()) // Reduced from title2
                                    .foregroundColor(DesignColors.foreground)
                                    .padding(.top, 28) // Increased gap (was 20)
                                
                                // Insight sentence (subtitle) - largest visual weight, breathing space
                                Text(affirmationSubtitle)
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .lineSpacing(6) // Increased line-height
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 16) // Breathing space
                                    .padding(.horizontal, DesignSpacing.sm)
                                
                                // Full affirmation text (prominently displayed)
                                Text(affirmation)
                                    .font(DesignTypography.title3Font())
                                    .foregroundColor(DesignColors.foreground)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(6)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 16)
                                    .padding(.horizontal, DesignSpacing.md)
                                
                                // Interpretation (fully visible, no truncation, readable)
                                Text(interpretation)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground.opacity(0.7)) // Reduced opacity more
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(5)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.top, 28) // Generous spacing
                                    .padding(.horizontal, DesignSpacing.md)
                                
                                Spacer(minLength: 0)
                                
                                // Brand mark (signature - intentional spacing, moved up)
                                Text("Aroti")
                                    .font(DesignTypography.caption2Font())
                                    .foregroundColor(DesignColors.foreground.opacity(0.45)) // Increased opacity slightly
                                    .padding(.top, 16) // Small spacing from interpretation
                                    .padding(.bottom, DesignSpacing.md) // Generous bottom padding
                            }
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: cardHeight) // Minimum height - content can expand if needed
                            .padding(DesignSpacing.md)
                            .background(
                                ZStack {
                                    // Gentle background gradient
                                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.85),
                                                    Color(red: 20/255, green: 18/255, blue: 28/255, opacity: 0.85)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                    
                                    // Liquid glass highlight at top
                                    VStack {
                                        Rectangle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.clear, Color.white.opacity(0.08), Color.clear],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(height: 1)
                                            .opacity(0.8)
                                        Spacer()
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 4)
                        }
                        .frame(minHeight: UIScreen.main.bounds.height * 0.70) // Minimum height - reduced to ensure CTA visibility
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
        let text = "Today's Affirmation\n\n\(affirmationSubtitle)\n\n\"\(affirmation)\""
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
