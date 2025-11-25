//
//  EditProfileButtonView.swift
//  Aroti
//

import SwiftUI

struct EditProfileButtonView: View {
    var body: some View {
        DesignCard(title: "Button / Edit Profile") {
            VStack(alignment: .leading, spacing: 12) {
                ArotiButton(
                    kind: .custom(
                        ArotiButtonStyle(
                            foregroundColor: DesignColors.foreground,
                            backgroundColor: .clear,
                            borderColor: DesignColors.glassBorder,
                            borderWidth: 1,
                            cornerRadius: DesignRadius.pill,
                            height: 38,
                            horizontalPadding: 16,
                            fullWidth: false,
                            font: DesignTypography.subheadFont(weight: .medium)
                        )
                    ),
                    title: "Edit Profile",
                    action: {}
                )
                
                Text("Small ghost/outline button used in Profile header")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

