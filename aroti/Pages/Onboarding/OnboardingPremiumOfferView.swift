//
//  OnboardingPremiumOfferView.swift
//
//  Page 15 - Premium Offer (Subscription Paywall)
//

import SwiftUI

struct OnboardingPremiumOfferView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                PremiumOfferHero()
            },
            title: "Your Premium Toolkit Is Ready",
            subtitle: "These tools are locked on the free plan",
            content: {
                VStack(spacing: DesignSpacing.lg) {
                    // Premium toolkit carousel
                    PremiumToolkitCarousel()
                    
                    // Trust badge
                    VStack(spacing: 4) {
                        Text("Included with Premium")
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textPrimary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.06))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                            )
                    }
                    .padding(.top, DesignSpacing.sm)
                    
                    // Continue with Free Version link
                    Button(action: {
                        coordinator.nextPage()
                    }) {
                        Text("Continue with Free Version")
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textMuted)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, DesignSpacing.xs)
                }
            },
            continueButtonTitle: "Start Free Trial",
            onContinue: {
                // Handle premium subscription
                coordinator.nextPage()
            },
            showBackButton: false // Industry standard - no back button on paywall
        )
    }
}

