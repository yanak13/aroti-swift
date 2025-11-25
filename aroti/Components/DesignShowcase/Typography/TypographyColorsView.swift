//
//  TypographyColorsView.swift
//  Aroti
//

import SwiftUI

struct TypographyColorsView: View {
    var body: some View {
        DesignCard(title: "Text Colors") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Foreground (text-foreground)")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground)
                Text("Muted Foreground (text-muted-foreground)")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                Text("Accent (text-accent)")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.accent)
            }
        }
    }
}
