//
//  PremiumFeaturesSection.swift
//  Aroti
//
//  Reusable premium features section component
//

import SwiftUI

struct PremiumFeaturesSection: View {
    let features: [String]
    let unlockButtonText: String
    let onUnlockClick: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Premium Locked Items
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.top, 16)
            
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(DesignColors.accent)
                    
                    Text("Premium Features")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.accent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Features list
                VStack(spacing: 12) {
                    ForEach(features, id: \.self) { feature in
                        Button(action: onUnlockClick) {
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(DesignColors.accent)
                                
                                Text(feature)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                
                                Spacer()
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.02))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.top, 16)
            
            // Unlock button
            Button(action: onUnlockClick) {
                HStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16))
                    
                    Text(unlockButtonText)
                        .font(DesignTypography.subheadFont(weight: .medium))
                }
                .foregroundColor(DesignColors.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(DesignColors.accent.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 16)
        }
    }
}

