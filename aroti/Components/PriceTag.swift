//
//  PriceTag.swift
//  Aroti
//
//  Consistent price tag component with pill shape matching course card design
//

import SwiftUI

struct PriceTag: View {
    let price: String
    
    var body: some View {
        Text(price)
            .font(ArotiTextStyle.caption1.weight(.medium))
            .foregroundColor(ArotiColor.accent)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(ArotiColor.accent.opacity(0.2))
                    .overlay(
                        Capsule()
                            .stroke(ArotiColor.accent.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

