//
//  CoreGuidanceDetailSheet.swift
//  Aroti
//
//  Premium Forecast shareable popup - Moonly-inspired design
//

import SwiftUI

struct CoreGuidanceDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let card: CoreGuidanceCard
    @State private var showLegitimacySheet = false
    @State private var backgroundOpacity: Double = 0.0
    @State private var symbolScale: CGFloat = 0.96
    @State private var textOpacity: [Double] = []
    @State private var shareButtonVisible = false
    
    var body: some View {
        ZStack {
            // Background with darkening effect
            CelestialBackground()
                .opacity(1.0 - (backgroundOpacity * 0.2))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar with title and actions
                HStack {
                    Text("Core Guidance")
                        .font(DesignTypography.caption1Font())
                        .foregroundColor(DesignColors.mutedForeground)
                    
                    Spacer()
                    
                    // Info icon (subtle)
                    Button(action: {
                        showLegitimacySheet = true
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 18))
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                    }
                    
                    // Done button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                            .font(DesignTypography.subheadFont(weight: .medium))
                            .foregroundColor(DesignColors.accent)
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                Spacer()
                
                // Hero Zone - Centered content
                VStack(spacing: 40) {
                    // Animated symbol
                    AnimatedGuidanceSymbol(cardType: card.type)
                        .scaleEffect(symbolScale)
                    
                    // Large headline
                    Text(card.displayHeadline)
                        .font(DesignTypography.title1Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .multilineTextAlignment(.center)
                        .opacity(textOpacity[0])
                    
                    // Body text (line-by-line)
                    VStack(alignment: .center, spacing: 12) {
                        ForEach(Array(card.displayBodyLines.enumerated()), id: \.offset) { index, line in
                            Text(line)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .opacity(textOpacity[min(index + 1, textOpacity.count - 1)])
                        }
                    }
                    .padding(.horizontal, DesignSpacing.lg)
                    
                    // Share button (appears after 400ms)
                    if shareButtonVisible {
                        ShareButton(onShare: {
                            shareCard()
                        })
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding(.vertical, 40)
                
                Spacer()
            }
        }
        .onAppear {
            // Initialize text opacity array based on number of body lines + headline
            let totalLines = card.displayBodyLines.count + 1 // +1 for headline
            textOpacity = Array(repeating: 0.0, count: max(totalLines, 4))
            startEntryAnimations()
        }
        .sheet(isPresented: $showLegitimacySheet) {
            CoreGuidanceLegitimacySheet(cardType: card.type)
        }
    }
    
    private func startEntryAnimations() {
        // 1. Background slightly darkens
        withAnimation(.easeOut(duration: 0.3)) {
            backgroundOpacity = 1.0
        }
        
        // 2. Symbol scales in (0.96 → 1.0) with soft glow pulse
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                symbolScale = 1.0
            }
        }
        
        // 3. Text fades in line-by-line (80ms stagger)
        let lines = card.displayBodyLines
        for i in 0..<min(lines.count + 1, textOpacity.count) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4 + Double(i) * 0.08) {
                withAnimation(.easeOut(duration: 0.4)) {
                    textOpacity[i] = 1.0
                }
            }
        }
        
        // 4. Share button appears after 400ms
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                shareButtonVisible = true
            }
        }
    }
    
    private func shareCard() {
        // Generate share image
        let symbolName = getIconForType(card.type)
        if let shareImage = ShareCardImageGenerator.generateShareImage(
            headline: card.displayHeadline,
            bodyLines: card.displayBodyLines,
            cardType: card.type,
            symbolName: symbolName
        ) {
            // Share image for Stories
            let activityVC = UIActivityViewController(
                activityItems: [shareImage],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(activityVC, animated: true)
            }
        } else {
            // Fallback: Share text
            let shareText = "\(card.displayHeadline)\n\n\(card.displayBodyLines.joined(separator: "\n"))\n\nFrom Aroti"
            let activityVC = UIActivityViewController(
                activityItems: [shareText],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                rootViewController.present(activityVC, animated: true)
            }
        }
    }
    
    private func getIconForType(_ type: CoreGuidanceCardType) -> String {
        switch type {
        case .rightNow:
            return "sparkles"
        case .thisPeriod:
            return "moon.stars"
        case .whereToFocus:
            return "target"
        case .whatsComingUp:
            return "calendar"
        case .personalInsight:
            return "person.circle"
        }
    }
}

#Preview {
    CoreGuidanceDetailSheet(
        card: CoreGuidanceCard(
            id: "1",
            type: .rightNow,
            preview: "A Quiet Shift",
            fullInsight: "Something is changing beneath the surface. You don't need to name it yet. Noticing is enough for now.",
            headline: "A Quiet Shift",
            bodyLines: [
                "Something is changing beneath the surface.",
                "You don't need to name it yet.",
                "Noticing is enough for now."
            ],
            lastUpdated: Date(),
            contentVersion: "v1"
        )
    )
}
