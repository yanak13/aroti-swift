//
//  TypeBadgeShowcase.swift
//  Aroti
//

import SwiftUI

struct TypeBadgeShowcase: View {
    private let labels = ["Practice", "Spread", "Card", "Learn"]
    
    var body: some View {
        DesignCard(title: "Type Badge (from cards)") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    ForEach(labels, id: \.self) { label in
                        Badge(
                            text: label,
                            backgroundColor: ArotiColor.pureWhite.opacity(0.05),
                            textColor: ArotiColor.textSecondary,
                            borderColor: ArotiColor.pureWhite.opacity(0.1)
                        )
                    }
                }
                
                Text("Badge / type / Content type indicators")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
}

