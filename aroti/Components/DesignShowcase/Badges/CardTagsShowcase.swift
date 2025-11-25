//
//  CardTagsShowcase.swift
//  Aroti
//

import SwiftUI

struct CardTagsShowcase: View {
    var body: some View {
        DesignCard(title: "Card Tags (from Ritual Card)") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Badge(
                        text: "5 min",
                        backgroundColor: DesignColors.accent.opacity(0.2),
                        textColor: DesignColors.accent,
                        fontSize: DesignTypography.caption2Font()
                    )
                    Badge(
                        text: "Mindfulness",
                        backgroundColor: DesignColors.accent.opacity(0.2),
                        textColor: DesignColors.accent,
                        fontSize: DesignTypography.caption2Font()
                    )
                }
                
                Text("Badge / tag / Duration and type")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

