//
//  OnboardingGeneratingBlueprintView.swift
//
//  Page 13 - Mapping Your Blueprint (Animation Page)
//

import SwiftUI

struct OnboardingGeneratingBlueprintView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var canContinue: Bool = false
    @State private var buttonGlow: Bool = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var currentSubtitle: String = "Collecting your personal signals"
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                MappingBlueprintHero(
                    onPhaseChange: { phase, subtitle in
                        // Update subtitle with cross-fade
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentSubtitle = subtitle
                            }
                        }
                    },
                    onGatheringStart: {
                        // Very soft tick at phase 2 start
                        HapticFeedback.impactOccurred(.light)
                    },
                    onFormationComplete: {
                        // Gentle confirmation haptic when structure completes
                        HapticFeedback.impactOccurred(.medium)
                        
                        // Enable button with subtle animation
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            canContinue = true
                            buttonScale = 1.03  // 3% scale-in
                            buttonGlow = true
                        }
                        
                        // Return to normal scale after brief moment
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                buttonScale = 1.0
                            }
                        }
                    }
                )
            },
            title: "Creating your personal blueprint",
            subtitle: currentSubtitle,
            content: {
                EmptyView()
            },
            canContinue: canContinue,
            onContinue: {
                coordinator.nextPage()
            },
            showBackButton: false, // Disable back on animation page
            buttonScale: buttonScale,
            buttonGlow: buttonGlow
        )
    }
}
