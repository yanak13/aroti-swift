//
//  BaseCardVariantsView.swift
//  Aroti
//

import SwiftUI

struct BaseCardVariantsView: View {
    var body: some View {
        DesignCard(title: "BaseCard Variants") {
            VStack(alignment: .leading, spacing: 14) {
                BaseCard {
                    Text("Standard BaseCard")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .padding()
                }
                
                BaseCard(variant: .interactive, action: {}) {
                    Text("Interactive BaseCard (clickable)")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .padding()
                }
                
                BaseCard(variant: .secondary) {
                    Text("Secondary BaseCard")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                        .padding()
                }
            }
        }
    }
}

