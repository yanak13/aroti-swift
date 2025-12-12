//
//  OnboardingPersonalizationIntroView.swift
//
//  Page 5 - Personalization Intro
//

import SwiftUI

struct OnboardingPersonalizationIntroView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                PersonalizationIntroHero()
            },
            title: "Let's Make Your Insights Truly Personal",
            subtitle: "Your answers help Aroti create guidance uniquely shaped for you.",
            content: {
                EmptyView()
            },
            onContinue: {
                coordinator.nextPage()
            },
            showBackButton: false,
            showProgressBar: false,
            titleTopPadding: 0,
            heroHeightFactor: 0.42,
            heroContainerHeightFactor: 0.45,
            useNavigationSpacing: false
        )
    }
}
