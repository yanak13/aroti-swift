//
//  PriceBadgeShowcase.swift
//  Aroti
//

import SwiftUI

struct PriceBadgeShowcase: View {
    var body: some View {
        DesignCard(title: "Price Badge") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    PriceTag(price: "$29.99")
                    PriceTag(price: "$11.99")
                }
                
                Text("Badge / price / Used in course and report cards")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
}

