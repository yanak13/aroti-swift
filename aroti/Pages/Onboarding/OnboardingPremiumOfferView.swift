//
//  OnboardingPremiumOfferView.swift
//
//  Page 15 - Premium Offer (Subscription Paywall)
//  Uses the new Nebula-style PremiumPaywallSheet
//

import SwiftUI

struct OnboardingPremiumOfferView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    var body: some View {
        // Use the new PremiumPaywallSheet directly
        PremiumPaywallSheet(
            context: "onboarding",
            onDismiss: {
                // When user dismisses (either by purchasing or skipping), continue to next page
                coordinator.nextPage()
            }
        )
    }
}
