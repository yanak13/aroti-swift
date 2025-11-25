//
//  AstrologyBlueprintCardView.swift
//  Aroti
//

import SwiftUI

struct AstrologyBlueprintCardView: View {
    var body: some View {
        DesignCard(title: "Card / Blueprint – Astrology") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Astrology")
                    .font(DesignTypography.title3Font(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                Text("Your essential placements")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                blueprintItem(title: "Sun — Virgo", description: "Identity • How you move through the world")
                blueprintItem(title: "Moon — Pisces", description: "Inner world • How you feel and process emotion")
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
    
    private func blueprintItem(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(DesignTypography.bodyFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            Text(description)
                .font(DesignTypography.footnoteFont())
                .foregroundColor(DesignColors.mutedForeground)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DesignRadius.main)
                .fill(DesignColors.glassPrimary.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignRadius.main)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

