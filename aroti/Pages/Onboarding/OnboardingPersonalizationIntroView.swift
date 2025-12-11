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
            subtitle: "Your answers help Aroti shape the emotional tone, depth, and clarity of your daily guidance.",
            content: {
                EmptyView()
            },
            onContinue: {
                coordinator.nextPage()
            }
        )
    }
}
