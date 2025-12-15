//
//  OnboardingReadyView.swift
//
//  Page 17 - Final Ready Page
//  Arrival moment: completion, readiness, and anticipation
//

import SwiftUI

struct OnboardingReadyView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                ReadyHero()
            },
            title: "You're all set",
            subtitle: "Your personal insights are ready to explore.",
            content: {
                EmptyView()
            },
            continueButtonTitle: "Enter Aroti",
            onContinue: {
                coordinator.completeOnboarding()
            },
            showBackButton: false // Final page - no back button
        )
        .onAppear {
            // Single soft haptic tap on screen appear - subtle confirmation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                HapticFeedback.impactOccurred(.light)
            }
        }
    }
}
