//
//  DifficultyBadgeShowcase.swift
//  Aroti
//

import SwiftUI

struct DifficultyBadgeShowcase: View {
    var body: some View {
        DesignCard(title: "Difficulty Badge (from SpreadCard)") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Badge(
                        text: "Beginner",
                        backgroundColor: ArotiColor.success,
                        textColor: ArotiColor.successText,
                        borderColor: ArotiColor.successBorder
                    )
                    Badge(
                        text: "Intermediate",
                        backgroundColor: ArotiColor.warning,
                        textColor: ArotiColor.warningText,
                        borderColor: ArotiColor.warningBorder
                    )
                    Badge(
                        text: "Advanced",
                        backgroundColor: ArotiColor.danger,
                        textColor: ArotiColor.dangerText,
                        borderColor: ArotiColor.dangerBorder
                    )
                }
                
                Text("Badge / difficulty / Beginner, Intermediate, Advanced")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
}

