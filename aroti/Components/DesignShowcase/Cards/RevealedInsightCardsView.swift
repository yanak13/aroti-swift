//
//  RevealedInsightCardsView.swift
//  Aroti
//

import SwiftUI

struct RevealedInsightCardsView: View {
    var body: some View {
        DesignCard(title: "Card / Revealed Insight") {
            VStack(alignment: .leading, spacing: 12) {
                insightRow(title: "Your Tarot Card", preview: "The Fool - New beginnings await")
                insightRow(title: "Your Horoscope", preview: "Pisces - Intuitive nature heightened")
                insightRow(title: "Your Numerology", preview: "Energy number 7 - spiritual focus")
            }
        }
    }
    
    private func insightRow(title: String, preview: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "star.fill")
                .font(.system(size: 20))
                .foregroundColor(DesignColors.accent)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                Text(preview)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(DesignColors.mutedForeground)
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

