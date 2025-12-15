//
//  PremiumCTACard.swift
//  Aroti
//
//  Single premium CTA card at bottom of tab
//

import SwiftUI

struct PremiumCTACard: View {
    let title: String
    let subtitle: String
    let onUnlockClick: () -> Void
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(DesignTypography.subheadFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text(subtitle)
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                Button(action: onUnlockClick) {
                    HStack {
                        Spacer()
                        Text("Unlock Premium")
                            .font(DesignTypography.subheadFont(weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(DesignColors.accent)
                    )
                }
            }
        }
    }
}
