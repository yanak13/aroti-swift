//
//  CompatibilityToolPage.swift
//  Aroti
//
//  Compatibility Report tool page
//

import SwiftUI

struct CompatibilityToolPage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPartnerInput = false
    @State private var showCompatibilityResults = false
    @State private var showUnlockSheet = false
    @State private var partnerData: (name: String, birthDate: Date, birthTime: Date?, location: String)?
    
    private let accessControl = AccessControlService.shared
    private let userSubscription = UserSubscriptionService.shared
    
    private var isPremium: Bool {
        userSubscription.isPremium
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    BaseHeader(
                        title: "Compatibility Report",
                        subtitle: "Astrology compatibility analysis for relationships",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, DesignSpacing.sm)
                    
                    // Description card
                    BaseCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(DesignColors.accent)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        Circle()
                                            .fill(DesignColors.accent.opacity(0.15))
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("How It Works")
                                        .font(DesignTypography.headlineFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text("Enter your partner's birth details to generate a comprehensive compatibility analysis")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.1))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("What You'll Get")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .foregroundColor(DesignColors.accent)
                                        Text("Overall compatibility score")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .foregroundColor(DesignColors.accent)
                                        Text("Emotional compatibility analysis")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .foregroundColor(DesignColors.accent)
                                        Text("Communication chemistry insights")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("•")
                                            .foregroundColor(DesignColors.accent)
                                        Text("Long-term potential assessment")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Start button
                    Button(action: {
                        // Check access before showing input
                        let access = accessControl.canAccessCompatibility()
                        if access.allowed {
                            showPartnerInput = true
                        } else {
                            showUnlockSheet = true
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 16))
                            Text("Start Compatibility Report")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: ArotiRadius.md)
                                .fill(DesignColors.accent)
                        )
                    }
                    
                    // Access info
                    if !isPremium {
                        BaseCard {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Image(systemName: "info.circle.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(DesignColors.accent)
                                    Text("Access Information")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                }
                                
                                let access = accessControl.canAccessCompatibility()
                                if access.type == .free {
                                    let remaining = accessControl.getFreeCompatibilityRemaining()
                                    Text("You have \(remaining) free compatibility check(s) remaining today.")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                } else if access.type == .points, let cost = access.cost {
                                    Text("This tool costs \(cost) points per use.")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                } else if access.type == .premium {
                                    Text("Premium users have unlimited access to this tool.")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
                .padding(.top, DesignSpacing.md)
                .padding(.bottom, 60)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showPartnerInput) {
            PartnerInputSheet { name, birthDate, birthTime, location in
                partnerData = (name: name, birthDate: birthDate, birthTime: birthTime, location: location)
                showPartnerInput = false
                
                // Record usage
                let success = accessControl.recordCompatibilityCheck()
                if success {
                    showCompatibilityResults = true
                } else {
                    showUnlockSheet = true
                }
            }
        }
        .sheet(isPresented: $showCompatibilityResults) {
            if let partner = partnerData {
                CompatibilityResultsSheet(
                    partnerName: partner.name,
                    partnerBirthDate: partner.birthDate,
                    partnerBirthTime: partner.birthTime,
                    partnerBirthLocation: partner.location
                )
            }
        }
        .sheet(isPresented: $showUnlockSheet) {
            CompatibilityUnlockSheet(
                isPresented: Binding(
                    get: { showUnlockSheet },
                    set: { showUnlockSheet = $0 }
                ),
                onUnlock: {
                    showUnlockSheet = false
                    showPartnerInput = true
                }
            )
        }
    }
}
