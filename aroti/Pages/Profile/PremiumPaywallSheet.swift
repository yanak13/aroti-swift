//
//  PremiumPaywallSheet.swift
//  Aroti
//
//  Premium paywall modal
//

import SwiftUI

struct PremiumPaywallSheet: View {
    @Environment(\.dismiss) var dismiss
    let context: String?
    let title: String
    let description: String
    
    init(context: String? = nil, title: String? = nil, description: String? = nil) {
        self.context = context
        
        // Set title based on context if provided
        let defaultTitle: String
        let defaultDescription: String
        
        if let context = context {
            switch context {
            case "astrology":
                defaultTitle = "Unlock Full Astrology"
                defaultDescription = "Get access to all planets, 12 houses, aspects, and complete natal chart insights"
            case "numerology":
                defaultTitle = "Unlock Full Numerology"
                defaultDescription = "Get access to Destiny, Expression, Soul Urge numbers and complete numerology insights"
            case "compatibility":
                defaultTitle = "Unlock Full Compatibility"
                defaultDescription = "Get access to emotional compatibility, communication chemistry, and long-term potential insights"
            default:
                defaultTitle = "Unlock Premium Features"
                defaultDescription = "Get access to all premium features and unlock your full cosmic potential"
            }
        } else {
            defaultTitle = "Unlock Premium Features"
            defaultDescription = "Get access to all premium features and unlock your full cosmic potential"
        }
        
        self.title = title ?? defaultTitle
        self.description = description ?? defaultDescription
    }
    
    private var premiumBenefitsCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Premium Benefits")
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(ProfileData.premiumMembershipBenefits, id: \.self) { benefit in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.accent)
                            
                            Text(benefit)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 48))
                                .foregroundColor(DesignColors.accent)
                            
                            Text(title)
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                                .multilineTextAlignment(.center)
                            
                            Text(description)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        
                        premiumBenefitsCard
                        .padding(.horizontal)
                        
                        ArotiButton(
                            kind: .custom(ArotiButtonStyle(
                                foregroundColor: .white,
                                backgroundGradient: LinearGradient(
                                    colors: [DesignColors.accent, DesignColors.accent.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                cornerRadius: 10,
                                height: 48
                            )),
                            action: {
                                // Handle subscription
                                dismiss()
                            },
                            label: {
                                Text("Unlock Premium")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                            }
                        )
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground)
                }
            }
        }
    }
}

