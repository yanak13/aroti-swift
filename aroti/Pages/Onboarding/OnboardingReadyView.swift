//
//  OnboardingReadyView.swift
//
//  Page 17 - Final Ready Page
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
            title: "Your Journey Begins Now",
            subtitle: "Aroti is ready to guide you with clarity, intuition, and meaning.",
            content: {
                EmptyView()
            },
            continueButtonTitle: "Start My Journey",
            onContinue: {
                coordinator.completeOnboarding()
            },
            showBackButton: false // Final page - no back button
        )
    }
}
