//
//  LifeFocusAreaCard.swift
//  Aroti
//
//  Card component for life focus areas (houses)
//

import SwiftUI

struct LifeFocusAreaCard: View {
    let area: LifeFocusArea
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 8) {
                // House number badge
                HStack {
                    Text("House \(area.id)")
                        .font(DesignTypography.caption2Font(weight: .medium))
                        .foregroundColor(DesignColors.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(DesignColors.accent.opacity(0.15))
                        )
                    
                    Spacer()
                }
                
                // Title
                Text(area.title)
                    .font(DesignTypography.bodyFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                // Meaning
                Text(area.shortMeaning)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
