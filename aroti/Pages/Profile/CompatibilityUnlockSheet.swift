//
//  CompatibilityUnlockSheet.swift
//  Aroti
//
//  Sheet for unlocking compatibility checks with points
//

import SwiftUI

struct CompatibilityUnlockSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    let onUnlock: () -> Void
    
    private var accessInfo: (allowed: Bool, type: CompatibilityAccessType, cost: Int?) {
        AccessControlService.shared.canAccessCompatibility()
    }
    
    private var balance: PointsBalance {
        PointsService.shared.getBalance()
    }
    
    private var pointsCost: Int {
        AccessControlService.shared.getCompatibilityPointsCost()
    }
    
    private var hasEnoughPoints: Bool {
        balance.totalPoints >= pointsCost
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 48))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Unlock Compatibility Check")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                                .multilineTextAlignment(.center)
                            
                            Text("Get detailed compatibility insights for \(pointsCost) points")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        
                        // Points Balance Card
                        BaseCard {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your Points Balance")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text("\(balance.totalPoints)")
                                        .font(DesignTypography.title3Font(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "star.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(DesignColors.accent)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Cost Display
                        BaseCard {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Compatibility Check Cost")
                                        .font(DesignTypography.bodyFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text("One-time unlock")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                
                                Spacer()
                                
                                Text("\(pointsCost)")
                                    .font(DesignTypography.title3Font(weight: .bold))
                                    .foregroundColor(DesignColors.accent)
                                + Text(" pts")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.accent)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Insufficient Points Warning
                        if !hasEnoughPoints {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("You need \(pointsCost - balance.totalPoints) more points to unlock this check.")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Button(action: {
                                        // Navigate to wallet/points earning
                                        dismiss()
                                    }) {
                                        HStack {
                                            Text("Earn More Points")
                                                .font(DesignTypography.subheadFont(weight: .medium))
                                            Image(systemName: "arrow.right")
                                                .font(.system(size: 14))
                                        }
                                        .foregroundColor(DesignColors.accent)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Premium Upgrade Option
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 20))
                                        .foregroundColor(DesignColors.accent)
                                    
                                    Text("Upgrade to Premium")
                                        .font(DesignTypography.bodyFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                }
                                
                                Text("Get unlimited compatibility checks plus exclusive relationship timing insights")
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                
                                Button(action: {
                                    // Navigate to premium upgrade
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 14))
                                        Text("View Premium Plans")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                    }
                                    .foregroundColor(DesignColors.accent)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(DesignColors.accent.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        
                        // Unlock Button
                        if hasEnoughPoints {
                            ArotiButton(
                                kind: .primary,
                                action: {
                                    onUnlock()
                                    dismiss()
                                },
                                label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 14))
                                        Text("Unlock for \(pointsCost) Points")
                                            .font(DesignTypography.subheadFont(weight: .semibold))
                                    }
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Unlock Compatibility")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground)
                }
            }
        }
    }
}

