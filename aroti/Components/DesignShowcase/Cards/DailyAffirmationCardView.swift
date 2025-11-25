//
//  DailyAffirmationCardView.swift
//  Aroti
//

import SwiftUI

struct DailyAffirmationCardView: View {
    var body: some View {
        DesignCard(title: "Card / Daily Affirmation") {
            VStack(alignment: .leading, spacing: 12) {
                Text("I am worthy of love and abundance")
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                Text("You deserve all the good things life has to offer")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                HStack(spacing: 12) {
                    ArotiButton(
                        kind: .custom(.glassCardButton(textColor: DesignColors.accent, cornerRadius: DesignRadius.secondary, height: 40)),
                        title: "Shuffle",
                        action: {}
                    )
                    
                    ArotiButton(
                        kind: .custom(.glassCardButton(textColor: DesignColors.accent, cornerRadius: DesignRadius.secondary, height: 40)),
                        title: "View",
                        action: {}
                    )
                }
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
}

