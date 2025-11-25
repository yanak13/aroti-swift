//
//  SurfaceColorsView.swift
//  Aroti
//

import SwiftUI

struct SurfaceColorsView: View {
    var body: some View {
        DesignCard(title: "Surface Colors") {
            VStack(alignment: .leading, spacing: 12) {
                ColorSwatchView(
                    name: "Surface Background",
                    token: "hsl(var(--background))",
                    color: ArotiColor.bg,
                    description: "Base cosmic gradient start"
                )
                ColorSwatchView(
                    name: "Surface Elevated (Card)",
                    token: "hsl(var(--card))",
                    color: DesignColors.card,
                    description: "Standard card background"
                )
                ColorSwatchView(
                    name: "Surface Modal",
                    token: "ArotiColor.surfaceHi",
                    color: DesignColors.glassPrimary,
                    description: "Elevated glass modal"
                )
                ColorSwatchView(
                    name: "Overlay Scrim",
                    token: "rgba(0,0,0,0.6)",
                    color: ArotiColor.overlayScrim,
                    description: "Dimmed overlay behind modals"
                )
                BorderSwatchView(
                    name: "Border Divider",
                    token: "hsl(var(--border))",
                    color: DesignColors.border,
                    description: "Subtle dividers / outlines"
                )
            }
        }
    }
}
