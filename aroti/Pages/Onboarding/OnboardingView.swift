//
//  OnboardingView.swift
//  Aroti
//
//  Main onboarding view that coordinates welcome and carousel screens
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        ZStack {
            if coordinator.currentPage == 0 {
                OnboardingWelcomeView(coordinator: coordinator)
                    .transition(.opacity)
            } else {
                OnboardingCarouselView(coordinator: coordinator)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: coordinator.currentPage)
    }
}

#Preview {
    OnboardingView(coordinator: OnboardingCoordinator())
}
