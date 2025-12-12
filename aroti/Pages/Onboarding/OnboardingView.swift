//
//  OnboardingView.swift
//
//  Main onboarding view that coordinates all onboarding screens
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        ZStack {
            switch coordinator.currentPage {
            case 0...3:
                // Welcome carousel (4 pages: Welcome + 3 carousel pages)
                OnboardingCarouselView(coordinator: coordinator)
                    .transition(.opacity)
            case 4:
                OnboardingPersonalizationIntroView(coordinator: coordinator)
                    .transition(.opacity)
            case 5:
                OnboardingEmotionalStateView(coordinator: coordinator)
                    .transition(.opacity)
            case 6:
                OnboardingPersonalFocusView(coordinator: coordinator)
                    .transition(.opacity)
            case 7:
                OnboardingGuidanceFrequencyView(coordinator: coordinator)
                    .transition(.opacity)
            case 8:
                OnboardingRelationshipFocusView(coordinator: coordinator)
                    .transition(.opacity)
            case 9:
                OnboardingBirthDateView(coordinator: coordinator)
                    .transition(.opacity)
            case 10:
                OnboardingBirthTimeView(coordinator: coordinator)
                    .transition(.opacity)
            case 11:
                OnboardingBirthLocationView(coordinator: coordinator)
                    .transition(.opacity)
            case 12:
                OnboardingNameInputView(coordinator: coordinator)
                    .transition(.opacity)
            case 13:
                OnboardingGeneratingBlueprintView(coordinator: coordinator)
                    .transition(.opacity)
            case 14:
                OnboardingPremiumOfferView(coordinator: coordinator)
                    .transition(.opacity)
            case 15:
                OnboardingCreateAccountView(coordinator: coordinator)
                    .transition(.opacity)
            case 16:
                OnboardingReadyView(coordinator: coordinator)
                    .transition(.opacity)
            default:
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
