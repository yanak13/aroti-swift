//
//  AvailabilityBadgeShowcase.swift
//  Aroti
//

import SwiftUI

struct AvailabilityBadgeShowcase: View {
    var body: some View {
        DesignCard(title: "Availability Badge") {
            VStack(alignment: .leading, spacing: 12) {
                Badge(
                    text: "Available",
                    backgroundColor: Color.green.opacity(0.2),
                    textColor: Color.green.opacity(0.9),
                    borderColor: Color.green.opacity(0.3)
                )
                
                Text("Badge / availability / Green pill in specialist profile")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

