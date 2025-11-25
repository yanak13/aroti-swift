//
//  DisabledButtonsView.swift
//  Aroti
//

import SwiftUI

struct DisabledButtonsView: View {
    var body: some View {
        DesignCard(title: "Disabled State") {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 12) {
                    ArotiButton(kind: .primary, title: "Disabled Primary", isDisabled: true, action: {})
                    ArotiButton(kind: .secondary, title: "Disabled Secondary", isDisabled: true, action: {})
                    ArotiButton(kind: .ghost, title: "Disabled Ghost", isDisabled: true, action: {})
                }
                
                Text("Disabled buttons inherit the same shape, keeping opacity handling inside ArotiButton.")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
}
