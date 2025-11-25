//
//  ButtonVariantsMatrixView.swift
//  Aroti
//
//  Showcase of ArotiButton variants: Primary, Secondary, and Ghost
//

import SwiftUI

struct ButtonVariantsMatrixView: View {
    var body: some View {
        DesignCard(
            title: "Button Variants",
            subtitle: "Primary hierarchy built with RoundedRectangle(cornerRadius: DesignRadius.secondary)"
        ) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    ArotiButton(kind: .primary, title: "Primary", action: {})
                    ArotiButton(kind: .secondary, title: "Secondary", action: {})
                    ArotiButton(kind: .ghost, title: "Ghost", action: {})
                }
                
                Text("Each variant shares the 48pt height, full-width layout, and ArotiRadius.md rounding.")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
}
