//
//  ColorVariablesView.swift
//  Aroti
//

import SwiftUI

struct ColorVariablesView: View {
    var body: some View {
        DesignCard(title: "Color Variables") {
            VStack(alignment: .leading, spacing: 16) {
                ColorSwatchView(
                    name: "Foreground",
                    token: "ArotiColor.textPrimary",
                    color: ArotiColor.textPrimary,
                    description: "Primary foreground text"
                )
                ColorSwatchView(
                    name: "Muted Foreground",
                    token: "ArotiColor.textSecondary",
                    color: ArotiColor.textSecondary,
                    description: "Secondary text / muted label"
                )
                ColorSwatchView(
                    name: "Accent",
                    token: "ArotiColor.accent",
                    color: ArotiColor.accent,
                    description: "Accent / CTA background"
                )
                ColorSwatchView(
                    name: "Primary",
                    token: "DesignColors.primary",
                    color: DesignColors.primary,
                    description: "Legacy primary highlight"
                )
                ColorSwatchView(
                    name: "Secondary",
                    token: "DesignColors.secondary",
                    color: DesignColors.secondary,
                    description: "Secondary tint"
                )
                ColorSwatchView(
                    name: "Destructive / Error",
                    token: "DesignColors.destructive",
                    color: DesignColors.destructive,
                    description: "Error / alert action"
                )
            }
        }
    }
}
