//
//  CourseCardView.swift
//  Aroti
//

import SwiftUI

struct CourseCardView: View {
    var body: some View {
        DesignCard(title: "Card / Course") {
            VStack(alignment: .leading, spacing: 8) {
                // Top row: Title, Lock icon, and Price tag aligned
                HStack {
                    Text("Tarot Fundamentals")
                        .font(DesignTypography.headlineFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    Spacer()
                    
                    Image(systemName: "lock")
                        .font(.system(size: 16))
                        .foregroundColor(DesignColors.mutedForeground)
                    
                    PriceTag(price: "$29.99")
                }
                
                // Description
                Text("Master the basics of tarot reading")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                // Metadata row
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "book")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.mutedForeground)
                        Text("8 Lessons")
                            .font(DesignTypography.caption2Font())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(DesignColors.mutedForeground)
                        Text("2h 30m")
                            .font(DesignTypography.caption2Font())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(DesignColors.mutedForeground)
                }
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
}

