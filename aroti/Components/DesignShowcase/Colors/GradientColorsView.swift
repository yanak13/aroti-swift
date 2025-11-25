//
//  GradientColorsView.swift
//  Aroti
//

import SwiftUI

struct GradientColorsView: View {
    var body: some View {
        DesignCard(title: "Gradients") {
            VStack(alignment: .leading, spacing: 16) {
                GradientSwatchView(
                    name: "Gradient Primary",
                    description: "from-accent/90 to-accent",
                    gradient: LinearGradient(
                        colors: [ArotiColor.accent.opacity(0.9), ArotiColor.accent],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                GradientSwatchView(
                    name: "Gradient Membership",
                    description: "from-accent/20 to-transparent",
                    gradient: LinearGradient(
                        colors: [ArotiColor.accent.opacity(0.2), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
        }
    }
}
