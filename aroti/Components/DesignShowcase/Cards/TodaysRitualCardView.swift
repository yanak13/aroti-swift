//
//  TodaysRitualCardView.swift
//  Aroti
//

import SwiftUI

struct TodaysRitualCardView: View {
    var body: some View {
        DesignCard(title: "Card / Today's Ritual") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today's Ritual")
                            .font(DesignTypography.headlineFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("Morning meditation and intention setting")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        CategoryChip(label: "15 min", isActive: false, action: {})
                        CategoryChip(label: "Meditation", isActive: false, action: {})
                    }
                }
                
                ArotiButton(kind: .custom(.accentCard()), title: "Begin Practice", action: {})
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
}

