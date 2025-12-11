//
//  OnboardingGeneratingBlueprintView.swift
//
//  Page 14 - Generating Blueprint (Animation Page)
//

import SwiftUI

struct OnboardingGeneratingBlueprintView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var canContinue: Bool = false
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                GeneratingBlueprintHero()
            },
            title: "Mapping your emotional and cosmic blueprint…",
            subtitle: "This helps Aroti create insights uniquely shaped for you.",
            content: {
                EmptyView()
            },
            canContinue: canContinue,
            onContinue: {
                coordinator.nextPage()
            },
            showBackButton: false // Disable back on animation page
        )
        .onAppear {
            // 1.5-2.5s unskippable animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    canContinue = true
                }
            }
        }
    }
}
