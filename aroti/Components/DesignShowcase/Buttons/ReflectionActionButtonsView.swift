//
//  ReflectionActionButtonsView.swift
//  Aroti
//

import SwiftUI

struct ReflectionActionButtonsView: View {
    var body: some View {
        DesignCard(title: "Button / Tag / Add Reflection") {
            VStack(alignment: .leading, spacing: 14) {
                reflectionButton(title: "Add Reflection")
                reflectionButton(title: "Add Partner")
                
                Text("Large full-width button with leading plus icon")
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
    
    private func reflectionButton(title: String) -> some View {
        ArotiButton(
            kind: .custom(.pill(background: ArotiColor.accent, textColor: ArotiColor.accentText, height: 48)),
            isDisabled: false,
            action: {},
            label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16))
                    Text(title)
                        .font(DesignTypography.subheadFont(weight: .medium))
                }
            }
        )
    }
}

