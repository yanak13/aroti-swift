//
//  CardCountBadgeShowcase.swift
//  Aroti
//

import SwiftUI

struct CardCountBadgeShowcase: View {
    var body: some View {
        DesignCard(title: "Card Count Badge (from SpreadCard)") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Badge(
                        text: "10 cards",
                        backgroundColor: ArotiColor.overlayScrim,
                        textColor: ArotiColor.accentText,
                        borderColor: ArotiColor.pureWhite.opacity(0.1)
                    )
                    Badge(
                        text: "3 cards",
                        backgroundColor: ArotiColor.overlayScrim,
                        textColor: ArotiColor.accentText,
                        borderColor: ArotiColor.pureWhite.opacity(0.1)
                    )
                }
                
                Text("Badge / card count / Number of cards in spread")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
}

