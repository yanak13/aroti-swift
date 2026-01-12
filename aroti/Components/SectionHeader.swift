//
//  SectionHeader.swift
//  Aroti
//
//  Section header component with title and description (no View All button)
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let description: String?
    
    init(
        title: String,
        description: String? = nil
    ) {
        self.title = title
        self.description = description
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(DesignTypography.headlineFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            if let description = description {
                Text(description)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.top, 4)
            }
        }
    }
}

