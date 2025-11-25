//
//  BookingSummaryCardView.swift
//  Aroti
//

import SwiftUI

struct BookingSummaryCardView: View {
    var body: some View {
        DesignCard(title: "Card / Booking Summary") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                        .fill(DesignColors.accent.opacity(0.15))
                        .frame(width: 64, height: 64)
                        .overlay(
                            Text("SM")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.accent)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sarah Moon")
                            .font(DesignTypography.headlineFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        Text("Tarot Reading")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        HStack(spacing: 8) {
                            Text("$75 / session")
                            Text("•")
                            Text("50 min")
                        }
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                    }
                }
                
                summaryRow(label: "Date", value: "Tue, January 16")
                summaryRow(label: "Time", value: "09:30")
                summaryRow(label: "Platform", value: "Video call (Zoom)")
                
                Divider().background(Color.white.opacity(0.1))
                
                HStack {
                    Text("Total")
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    Spacer()
                    Text("$75")
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.accent)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: DesignRadius.main)
                    .fill(DesignColors.glassPrimary)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignRadius.main)
                            .stroke(DesignColors.glassBorder, lineWidth: 1)
                    )
            )
        }
    }
    
    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(DesignTypography.footnoteFont())
                .foregroundColor(DesignColors.mutedForeground)
            Spacer()
            Text(value)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground)
        }
    }
}

