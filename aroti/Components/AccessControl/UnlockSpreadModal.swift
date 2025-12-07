//
//  UnlockSpreadModal.swift
//  Aroti
//
//  Modal for unlocking tarot spreads
//

import SwiftUI

struct UnlockSpreadModal: View {
    let spreadId: String
    @Binding var isPresented: Bool
    let onUnlock: () -> Void
    
    private var accessInfo: (allowed: Bool, cost: Int?, permanentCost: Int?, isPremiumOnly: Bool) {
        AccessControlService.shared.canAccessSpread(spreadId: spreadId)
    }
    
    private var balance: PointsBalance {
        PointsService.shared.getBalance()
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: accessInfo.isPremiumOnly ? "crown.fill" : "lock.fill")
                        .font(.system(size: 40))
                        .foregroundColor(accessInfo.isPremiumOnly ? Color(red: 1.0, green: 0.84, blue: 0.0) : DesignColors.accent)
                    
                    Text(accessInfo.isPremiumOnly ? "Premium Spread" : "Unlock Spread")
                        .font(DesignTypography.title2Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text(accessInfo.isPremiumOnly ? "This spread is available exclusively for Premium members." : "Unlock this spread to access it.")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                if !accessInfo.isPremiumOnly {
                    // Unlock Options
                    VStack(spacing: 16) {
                        if let permanentCost = accessInfo.permanentCost {
                            UnlockOptionCard(
                                title: "Permanent Unlock",
                                cost: permanentCost,
                                description: "Unlock forever",
                                isSelected: true,
                                canAfford: balance.totalPoints >= permanentCost
                            )
                        }
                        
                        if let tempCost = accessInfo.cost {
                            UnlockOptionCard(
                                title: "24-Hour Access",
                                cost: tempCost,
                                description: "Access for 24 hours",
                                isSelected: false,
                                canAfford: balance.totalPoints >= tempCost
                            )
                        }
                    }
                    .padding(24)
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                }
                
                // Actions
                VStack(spacing: 12) {
                    if accessInfo.isPremiumOnly {
                        Button(action: {
                            // Navigate to premium upgrade
                            isPresented = false
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 14))
                                Text("Upgrade to Premium")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.65, blue: 0.0)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else if let permanentCost = accessInfo.permanentCost, balance.totalPoints >= permanentCost {
                        Button(action: {
                            onUnlock()
                            isPresented = false
                        }) {
                            Text("Unlock Permanently - \(permanentCost) points")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(DesignColors.accent)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else if let tempCost = accessInfo.cost, balance.totalPoints >= tempCost {
                        Button(action: {
                            onUnlock()
                            isPresented = false
                        }) {
                            Text("Unlock for 24h - \(tempCost) points")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(DesignColors.accent)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Button(action: {
                            // Navigate to premium upgrade or points earning
                            isPresented = false
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 14))
                                Text("Upgrade to Premium")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.65, blue: 0.0)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .font(DesignTypography.subheadFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(24)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hue: 240/360, saturation: 0.25, brightness: 0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 24)
        }
    }
}

struct UnlockOptionCard: View {
    let title: String
    let cost: Int
    let description: String
    let isSelected: Bool
    let canAfford: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                Text(description)
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            Spacer()
            
            Text("\(cost) pts")
                .font(DesignTypography.bodyFont(weight: .semibold))
                .foregroundColor(canAfford ? DesignColors.accent : Color.red)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? DesignColors.accent.opacity(0.1) : Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? DesignColors.accent.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

