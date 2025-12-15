//
//  TextCard.swift
//  Aroti
//
//  Simple text card component for Core Summary and Core Theme
//

import SwiftUI

struct TextCard: View {
    let title: String?
    let content: String
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 8) {
                if let title = title {
                    Text(title)
                        .font(DesignTypography.bodyFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                }
                
                Text(content)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
