//
//  IconicButtonsView.swift
//  Aroti
//

import SwiftUI

struct IconicButtonsView: View {
    var body: some View {
        DesignCard(title: "Buttons with Icons") {
            VStack(alignment: .leading, spacing: 12) {
                ArotiButton(kind: .primary, title: "Add Item", icon: Image(systemName: "plus"), action: {})
                ArotiButton(kind: .secondary, title: "Edit", icon: Image(systemName: "pencil"), action: {})
                ArotiButton(kind: .ghost, title: "Download", icon: Image(systemName: "arrow.down"), action: {})
                ArotiButton(kind: .primary, title: "Confirm", icon: Image(systemName: "checkmark"), action: {})
                
                Text("Use the icon parameter for SF Symbol support while preserving the same RoundedRectangle background.")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                    .padding(.top, 4)
            }
        }
    }
}
