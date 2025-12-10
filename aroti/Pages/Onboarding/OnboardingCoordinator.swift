//
//  OnboardingCoordinator.swift
//  Aroti
//
//  Manages onboarding state and navigation flow
//

import SwiftUI

class OnboardingCoordinator: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var isOnboardingComplete: Bool = false
    
    private let totalPages = 4 // Welcome + 3 carousel screens
    private let onboardingCompleteKey = "hasCompletedOnboarding"
    
    init() {
        // Don't check completion on launch - always show onboarding
        // Completion will be tracked when user finishes onboarding
        isOnboardingComplete = false
    }
    
    func nextPage() {
        if currentPage < totalPages - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: onboardingCompleteKey)
        withAnimation {
            isOnboardingComplete = true
        }
    }
    
    func getProgress() -> Double {
        return Double(currentPage) / Double(totalPages - 1)
    }
}
