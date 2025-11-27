//
//  PremiumPaywallSheet.swift
//  Aroti
//
//  Premium paywall modal
//

import SwiftUI

struct PremiumPaywallSheet: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    let description: String
    
    init(title: String = "Unlock Premium Features", description: String = "Get access to all premium features and unlock your full cosmic potential") {
        self.title = title
        self.description = description
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
                        
                        BaseCard {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Premium Benefits")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(ProfileData.membershipBenefits, id: \.self) { benefit in
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

