//
//  ShareImageButtonsView.swift
//  Aroti
//

import SwiftUI

struct ShareImageButtonsView: View {
    var body: some View {
        DesignCard(title: "Button / Share & Image (from Tarot Modal)") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    ArotiButton(
                        kind: .custom(.sharePrimary()),
                        isDisabled: false,
                        action: {},
                        label: {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16))
                                Text("Share")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                            }
                        }
                    )
                    
                    ArotiButton(
                        kind: .custom(.shareSecondary()),
                        isDisabled: false,
                        action: {},
                        label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.down")
                                    .font(.system(size: 16))
                                Text("Image")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                            }
                        }
                    )
                }
                
                Text("Gold solid Share button and outline Image button")
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

