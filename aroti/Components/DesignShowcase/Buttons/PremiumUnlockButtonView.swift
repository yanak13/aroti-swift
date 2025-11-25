//
//  PremiumUnlockButtonView.swift
//  Aroti
//

import SwiftUI

struct PremiumUnlockButtonView: View {
    var body: some View {
        DesignCard(title: "Premium Unlock Button") {
            VStack(alignment: .leading, spacing: 12) {
                ArotiButton(
                    kind: .custom(.premiumUnlock()),
                    isDisabled: false,
                    action: {},
                    label: {
                        HStack(spacing: 8) {
                            Image(systemName: "lock")
                                .font(.system(size: 16))
                            Text("Unlock Full Astrology Report")
                                .font(DesignTypography.subheadFont(weight: .medium))
                        }
                    }
                )
                
                Text("Used in Profile pages for premium features")
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.top, 4)
            }
        }
    }
}

