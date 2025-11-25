//
//  LockIconButtonsView.swift
//  Aroti
//

import SwiftUI

struct LockIconButtonsView: View {
    var body: some View {
        DesignCard(title: "Lock Icon Button") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Button / Lock Icon")
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                
                HStack(spacing: 8) {
                    ArotiButton(
                        kind: .custom(.iconSquare()),
                        isDisabled: false,
                        action: {},
                        label: {
                            Image(systemName: "lock")
                                .font(.system(size: 16))
                        }
                    )
                    
                    ArotiButton(
                        kind: .custom(.iconSquare(isAccent: true)),
                        isDisabled: false,
                        action: {},
                        label: {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                        }
                    )
                }
                
                Text("Lock icon button (unlocked / locked states)")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.top, 4)
            }
        }
    }
}

