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
            title: "Unlock Your Full Guidance Experience",
            subtitle: "Deeper insights, unlimited clarity messages, and personalized reports.",
            content: {
                VStack(spacing: DesignSpacing.md) {
                    // Comparison section
                    VStack(spacing: DesignSpacing.sm) {
                        // Header
                        HStack {
                            Text("Free")
                                .font(ArotiTextStyle.subhead)
                                .foregroundColor(ArotiColor.textSecondary)
                                .frame(maxWidth: .infinity)
                            
                            Text("Premium")
                                .font(ArotiTextStyle.subhead)
                                .foregroundColor(ArotiColor.accent)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.bottom, DesignSpacing.xs)
                        
                        Divider()
                            .background(ArotiColor.border)
                        
                        // Features
                        ComparisonRow(feature: "Daily messages", free: "Basic", premium: "Deep insights")
                        ComparisonRow(feature: "AI guidance", free: "Limited", premium: "Unlimited")
                        ComparisonRow(feature: "Emotional cycles", free: "No", premium: "Full analysis")
                        ComparisonRow(feature: "Reports", free: "No", premium: "Monthly personalized")
                    }
                    .padding(DesignSpacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .fill(ArotiColor.surface.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: ArotiRadius.md)
                                    .stroke(ArotiColor.border, lineWidth: 1)
                            )
                    )
                    
                    // Continue with Free Version link
                    Button(action: {
                        coordinator.nextPage()
                    }) {
                        Text("Continue with Free Version")
                            .font(ArotiTextStyle.subhead)
                            .foregroundColor(ArotiColor.textSecondary)
                    }
                    .padding(.top, DesignSpacing.sm)
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

struct ComparisonRow: View {
    let feature: String
    let free: String
    let premium: String
    
    var body: some View {
        VStack(spacing: DesignSpacing.xs) {
            HStack {
                Text(feature)
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(free)
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.textSecondary)
                    .frame(maxWidth: .infinity)
                
                Text(premium)
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.accent)
                    .frame(maxWidth: .infinity)
            }
            
            Divider()
                .background(ArotiColor.border.opacity(0.5))
        }
    }
}
