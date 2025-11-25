//
//  FloatingActionButtonView.swift
//  Aroti
//

import SwiftUI

struct FloatingActionButtonView: View {
    var body: some View {
        DesignCard(title: "Special Buttons") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Button / FAB")
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                
                HStack {
                    Spacer()
                    ArotiButton(
                        kind: .custom(.floating()),
                        isDisabled: false,
                        action: {},
                        label: {
                            Image(systemName: "message.circle")
                                .font(.system(size: 24))
                        }
                    )
                    Spacer()
                }
                .frame(height: 80)
                
                Text("Floating Action Button (Guidance & Search)")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

