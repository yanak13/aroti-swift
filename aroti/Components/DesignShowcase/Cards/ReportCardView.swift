//
//  ReportCardView.swift
//  Aroti
//

import SwiftUI

struct ReportCardView: View {
    var body: some View {
        DesignCard(title: "Card / Report") {
            VStack(alignment: .leading, spacing: 12) {
                reportItem(title: "Birth Chart Report", description: "Comprehensive analysis of your natal chart", price: "$11.99")
                reportItem(title: "Numerology Report", description: "Complete numerology analysis and insights", price: "$7.99")
            }
        }
    }
    
    private func reportItem(title: String, description: String, price: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                Text(description)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            Spacer()
            
            PriceTag(price: price)
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

