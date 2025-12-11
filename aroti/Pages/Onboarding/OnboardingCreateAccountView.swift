//
//  OnboardingCreateAccountView.swift
//
//  Page 16 - Create Account
//

import SwiftUI

struct OnboardingCreateAccountView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                CreateAccountHero()
            },
            title: "Save Your Insights Across Devices",
            subtitle: "You'll keep your emotional cycles, history, and guidance synced.",
            content: {
                VStack(spacing: DesignSpacing.sm) {
                    // Sign in with Apple
                    ArotiButton(
                        kind: .custom(
                            ArotiButtonStyle(
                                foregroundColor: ArotiColor.textPrimary,
                                backgroundColor: ArotiColor.brandApple,
                                cornerRadius: ArotiRadius.md,
                                height: ArotiButtonHeight.large
                            )
                        ),
                        action: {
                            // Handle Apple sign in
                            coordinator.nextPage()
                        }
                    ) {
                        HStack {
                            Image(systemName: "applelogo")
                                .font(.system(size: 18, weight: .medium))
                            Text("Sign in with Apple")
                                .font(ArotiTextStyle.subhead)
                        }
                    }
                    
                    // Sign in with Google
                    ArotiButton(
                        kind: .custom(
                            ArotiButtonStyle(
                                foregroundColor: ArotiColor.brandGoogleText,
                                backgroundColor: ArotiColor.brandGoogleSurface,
                                borderColor: ArotiColor.brandGoogleBorder,
                                borderWidth: 1,
                                cornerRadius: ArotiRadius.md,
                                height: ArotiButtonHeight.large
                            )
                        ),
                        action: {
                            // Handle Google sign in
                            coordinator.nextPage()
                        }
                    ) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.system(size: 18, weight: .medium))
                            Text("Sign in with Google")
                                .font(ArotiTextStyle.subhead)
                        }
                    }
                    
                    // Email Sign Up
                    ArotiButton(
                        kind: .secondary,
                        action: {
                            // Handle email sign up
                            coordinator.nextPage()
                        }
                    ) {
                        Text("Email Sign Up")
                            .font(ArotiTextStyle.subhead)
                    }
                }
            },
            canContinue: false, // Disable main continue, use individual buttons
            continueButtonTitle: "Continue",
            onContinue: {
                // This will be handled by individual buttons
            }
        )
    }
}
