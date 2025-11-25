//
//  TypographyWeightsView.swift
//  Aroti
//

import SwiftUI

struct TypographyWeightsView: View {
    var body: some View {
        DesignCard(title: "Font Weights") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Normal weight (font-normal)")
                    .font(DesignTypography.bodyFont(weight: .regular))
                    .foregroundColor(DesignColors.foreground)
                Text("Medium weight (font-medium)")
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                Text("Semibold weight (font-semibold)")
                    .font(DesignTypography.bodyFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                Text("Bold weight (font-bold)")
                    .font(DesignTypography.bodyFont(weight: .bold))
                    .foregroundColor(DesignColors.foreground)
            }
        }
    }
}
