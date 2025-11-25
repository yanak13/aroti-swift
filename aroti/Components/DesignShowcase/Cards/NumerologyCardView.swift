//
//  NumerologyCardView.swift
//  Aroti
//

import SwiftUI

struct NumerologyCardView: View {
    var body: some View {
        DesignCard(title: "Card / Numerology") {
            insightRow(title: "Numerology", preview: "Energy number 7 - spiritual focus")
        }
    }
    
    private func insightRow(title: String, preview: String) -> some View {
        HStack(spacing: 12) {
            Text("7")
                .font(.system(size: 24, weight: .bold))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(DesignColors.accent.opacity(0.15))
                )
            
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

