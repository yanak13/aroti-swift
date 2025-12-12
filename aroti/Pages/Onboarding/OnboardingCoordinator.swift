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
    
    // Onboarding data
    @Published var emotionalState: [String] = []
    @Published var personalFocus: [String] = []
    @Published var guidanceFrequency: String?
    @Published var relationshipFocus: String?
    @Published var birthDate: Date?
    @Published var birthTime: Date?
    @Published var birthLocation: String?
    @Published var userName: String?
    
    private let totalPages = 17 // Total onboarding pages
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
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage -= 1
            }
        }
    }
    
    func goToPage(_ page: Int) {
        if page >= 0 && page < totalPages {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage = page
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
    
    func canGoBack() -> Bool {
        return currentPage > 0 && currentPage != 15 // Premium offer page disables back button (now at index 15)
    }
}
