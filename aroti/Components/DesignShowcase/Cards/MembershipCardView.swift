//
//  MembershipCardView.swift
//  Aroti
//

import SwiftUI

struct MembershipCardView: View {
    var body: some View {
        DesignCard(title: "Card / Membership") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Premium Membership")
                    .font(DesignTypography.title3Font(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                Text("Unlock all features and insights")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                VStack(alignment: .leading, spacing: 8) {
                    membershipFeature("Unlimited readings")
                    membershipFeature("Full astrology reports")
                    membershipFeature("Premium courses")
                }
                
                ArotiButton(kind: .custom(.accentCard()), title: "Upgrade Now", action: {})
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: DesignRadius.main)
                    .fill(DesignColors.glassPrimary)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignRadius.main)
                            .stroke(DesignColors.glassBorder, lineWidth: 1)
                    )
            )
        }
    }
    
    private func membershipFeature(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(DesignColors.accent)
            Text(text)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground)
        }
    }
}

