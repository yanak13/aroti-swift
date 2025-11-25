//
//  SoftCardShowcase.swift
//  Aroti
//

import SwiftUI

struct SoftCardShowcase: View {
    var body: some View {
        DesignCard(title: "Card / SoftCard") {
            VStack(alignment: .leading, spacing: 8) {
                Text("This is a SoftCard component example.")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: DesignRadius.main)
                    .fill(DesignColors.glassPrimary.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignRadius.main)
                            .stroke(DesignColors.glassBorder.opacity(0.5), lineWidth: 1)
                    )
            )
        }
    }
}

