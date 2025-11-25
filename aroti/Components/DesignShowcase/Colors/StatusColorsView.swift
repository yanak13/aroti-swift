//
//  StatusColorsView.swift
//  Aroti
//

import SwiftUI

struct StatusColorsView: View {
    var body: some View {
        DesignCard(title: "Status Colors") {
            VStack(alignment: .leading, spacing: 16) {
                StatusColorSwatchView(
                    name: "Success / Available",
                    background: ArotiColor.success,
                    border: ArotiColor.successBorder,
                    description: "emerald-500/20"
                )
                StatusColorSwatchView(
                    name: "Danger / Error",
                    background: ArotiColor.danger,
                    border: ArotiColor.dangerBorder,
                    description: "rose-500/20"
                )
                StatusColorSwatchView(
                    name: "Warning",
                    background: ArotiColor.warning,
                    border: ArotiColor.warningBorder,
                    description: "amber-500/20"
                )
            }
        }
    }
}
