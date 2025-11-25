//
//  StatusChipShowcase.swift
//  Aroti
//

import SwiftUI

struct StatusChipShowcase: View {
    var body: some View {
        DesignCard(title: "StatusChip") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    StatusChip(status: .confirmed)
                    StatusChip(status: .pending)
                    StatusChip(status: .completed)
                }
                
                Text("Badge / status / Confirmed, Pending, Completed")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

