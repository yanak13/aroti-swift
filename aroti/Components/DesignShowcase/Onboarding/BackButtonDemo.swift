//
//  BackButtonDemo.swift
//  Aroti
//

import SwiftUI

struct BackButtonDemo: View {
    var body: some View {
        DesignCard(title: "BackButton") {
            ArotiButton(
                kind: .custom(
                    ArotiButtonStyle(
                        foregroundColor: DesignColors.foreground,
                        backgroundColor: .clear,
                        borderColor: DesignColors.glassBorder,
                        borderWidth: 1,
                        cornerRadius: DesignRadius.secondary,
                        height: ArotiButtonHeight.compact,
                        horizontalPadding: 16,
                        fullWidth: false
                    )
                ),
                isDisabled: false,
                action: {},
                label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16))
                        Text("Back")
                            .font(DesignTypography.bodyFont())
                    }
                }
            )
        }
    }
}

