//
//  ReflectionCardView.swift
//  Aroti
//

import SwiftUI

struct ReflectionCardView: View {
    var body: some View {
        DesignCard(title: "Card / Reflection") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Your Reflection")
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Text("Today was a day of growth and reflection. I felt more connected to my inner self.")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground)
                
                Text("Added today at 2:30 PM")
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
    }
}

