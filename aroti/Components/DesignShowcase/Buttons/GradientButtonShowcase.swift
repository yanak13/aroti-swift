//
//  GradientButtonShowcase.swift
//  Aroti
//

import SwiftUI

struct GradientButtonShowcase: View {
    private let gradientColors = [ArotiColor.accent.opacity(0.9), ArotiColor.accent]
    
    var body: some View {
        DesignCard(title: "GradientButton") {
            VStack(alignment: .leading, spacing: 14) {
                ArotiButton(
                    kind: .custom(.gradientFilled(colors: gradientColors)),
                    title: "Primary Gradient",
                    action: {}
                )
                
                ArotiButton(
                    kind: .custom(.gradientOutline(colors: gradientColors)),
                    title: "Outline Gradient",
                    action: {}
                )
            }
        }
    }
}
