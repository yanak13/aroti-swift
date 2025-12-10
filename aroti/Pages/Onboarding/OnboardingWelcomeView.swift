//
//  OnboardingWelcomeView.swift
//  Aroti
//
//  Welcome screen - first screen of onboarding
//

import SwiftUI

struct OnboardingWelcomeView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        OnboardingLayout {
            // Hero
            ConstellationHero()
        } content: {
            VStack(spacing: DesignSpacing.lg) {
                // Title
                Text("Welcome to Aroti")
                    .font(ArotiTextStyle.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(ArotiColor.textPrimary)
                    .multilineTextAlignment(.center)
                
                // Subtitle
                Text("Your personal space for clarity, growth, and daily guidance.")
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, DesignSpacing.xl)
                
                // Button
                ArotiButton(
                    kind: .primary,
                    title: "Get Started",
                    action: {
                        HapticFeedback.impactOccurred(.medium)
                        coordinator.nextPage()
                    }
                )
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.md)
            }
        }
    }
}

#Preview {
    OnboardingWelcomeView(coordinator: OnboardingCoordinator())
}
