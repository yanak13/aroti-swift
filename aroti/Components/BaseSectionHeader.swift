//
//  BaseSectionHeader.swift
//  Aroti
//
//  Section header with title and subtitle
//

import SwiftUI

struct BaseSectionHeader: View {
    let title: String
    let subtitle: String
    let onViewAll: (() -> Void)?
    
    init(
        title: String,
        subtitle: String,
        onViewAll: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.onViewAll = onViewAll
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(DesignTypography.title3Font())
                    .foregroundColor(DesignColors.foreground)
                
                Text(subtitle)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            Spacer()
            
            if let onViewAll = onViewAll {
                Button(action: onViewAll) {
                    Text("View All")
                        .font(DesignTypography.subheadFont())
                        .foregroundColor(DesignColors.accent)
                }
            }
        }
    }
}

