//
//  IdentityHeaderCard.swift
//  Aroti
//
//  Header card component for identity profile tabs
//

import SwiftUI

struct IdentityHeaderCard: View {
    let title: String
    let primaryLine: String
    let secondaryLine: String?
    let summary: String?
    
    init(title: String, primaryLine: String, secondaryLine: String? = nil, summary: String? = nil) {
        self.title = title
        self.primaryLine = primaryLine
        self.secondaryLine = secondaryLine
        self.summary = summary
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(title)
                .font(DesignTypography.title3Font())
                .foregroundColor(DesignColors.foreground)
            
            // Primary line
            Text(primaryLine)
                .font(DesignTypography.bodyFont(weight: .semibold))
                .foregroundColor(DesignColors.foreground)
            
            // Secondary line (optional)
            if let secondaryLine = secondaryLine {
                Text(secondaryLine)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            // Summary (optional, deprecated - use Free Insight card instead)
            if let summary = summary, !summary.isEmpty {
                Text(summary)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
