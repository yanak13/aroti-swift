//
//  PremiumPreviewCard.swift
//  Aroti
//
//  Compact premium preview card with list of preview rows
//

import SwiftUI

struct PremiumPreviewRow {
    let title: String
    let preview: String
}

struct PremiumPreviewCard: View {
    let title: String
    let rows: [PremiumPreviewRow]
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(DesignTypography.subheadFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(row.title)
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(row.preview)
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                .lineLimit(2)
                        }
                        
                        if index < rows.count - 1 {
                            Divider()
                                .background(Color.white.opacity(0.1))
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
    }
}
