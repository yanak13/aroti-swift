//
//  OnboardingBackButton.swift
//  Aroti
//
//  Back button for onboarding screens
//

import SwiftUI

struct OnboardingBackButton: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    let action: (() -> Void)?
    
    init(action: (() -> Void)? = nil) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if let action = action {
                action()
            } else {
                goBack()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                Text("Back")
                    .font(ArotiTextStyle.subhead)
            }
            .foregroundColor(ArotiColor.textPrimary.opacity(0.8)) // Increased contrast
        }
        .opacity(1) // Start visible, will fade in smoothly
    }
    
    private func goBack() {
        switch onboardingManager.currentScreen {
        case .welcome:
            break
        case .valueCarousel:
            onboardingManager.currentScreen = .welcome
        case .createAccount:
            onboardingManager.currentScreen = .valueCarousel
        case .birthDate:
            onboardingManager.currentScreen = .createAccount
        case .birthTime:
            onboardingManager.currentScreen = .birthDate
        case .birthPlace:
            onboardingManager.currentScreen = .birthTime
        case .gender:
            onboardingManager.currentScreen = .birthPlace
        case .relationship:
            onboardingManager.currentScreen = .gender
        case .intention:
            onboardingManager.currentScreen = .relationship
        case .emotionalNature:
            onboardingManager.currentScreen = .intention
        case .currentFocus:
            onboardingManager.currentScreen = .emotionalNature
        case .challenges:
            onboardingManager.currentScreen = .currentFocus
        case .archetype:
            onboardingManager.currentScreen = .challenges
        case .loveFocus:
            onboardingManager.currentScreen = .archetype
        case .careerFocus:
            // If coming from love focus, go back to love focus
            if onboardingManager.data.loveFocus != nil {
                onboardingManager.currentScreen = .loveFocus
            } else {
                onboardingManager.currentScreen = .archetype
            }
        case .building:
            // Go back based on what was shown before
            let mainIntention = onboardingManager.data.mainIntention
            if mainIntention == "Love & connection" {
                onboardingManager.currentScreen = .loveFocus
            } else if mainIntention == "Career & purpose" {
                onboardingManager.currentScreen = .careerFocus
            } else if mainIntention == "A mix of everything" {
                if onboardingManager.data.careerFocus != nil {
                    onboardingManager.currentScreen = .careerFocus
                } else {
                    onboardingManager.currentScreen = .loveFocus
                }
            } else {
                onboardingManager.currentScreen = .archetype
            }
        case .ready:
            onboardingManager.currentScreen = .building
        }
    }
}
