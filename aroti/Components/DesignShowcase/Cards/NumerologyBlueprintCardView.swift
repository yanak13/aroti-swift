//
//  NumerologyBlueprintCardView.swift
//  Aroti
//

import SwiftUI

struct NumerologyBlueprintCardView: View {
    var body: some View {
        DesignCard(title: "Card / Blueprint – Numerology") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Numerology")
                    .font(DesignTypography.title3Font(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                Text("Your life path number")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Life Path 3 — The Connector")
                        .font(DesignTypography.title3Font(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    Text("Creative energy • Expression • Communication")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
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
            .padding()
        }
    }
}

