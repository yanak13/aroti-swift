//
//  RatingBadgeShowcase.swift
//  Aroti
//

import SwiftUI

struct RatingBadgeShowcase: View {
    var body: some View {
        DesignCard(title: "Rating Badge") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(DesignColors.accent)
                    Text("4.9")
                        .font(DesignTypography.bodyFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    Text("(127 reviews)")
                        .font(DesignTypography.subheadFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                }
                
                Text("Badge / rating / Star + rating + reviews text")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

