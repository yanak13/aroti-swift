//
//  UpcomingSessionCardView.swift
//  Aroti
//

import SwiftUI

struct UpcomingSessionCardView: View {
    var body: some View {
        DesignCard(title: "Card / Upcoming Session") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(DesignColors.accent.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text("SM")
                                .font(DesignTypography.title2Font(weight: .semibold))
                                .foregroundColor(DesignColors.accent)
                        )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Sarah Moon")
                            .font(DesignTypography.headlineFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        Text("Tarot Reader")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        HStack(spacing: 4) {
                            Text("Tomorrow")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.mutedForeground)
                            Text("at")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            Text("2:00 PM")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.mutedForeground)
                            Text("•")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            Text("60 min")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    ArotiButton(
                        kind: .custom(.glassCardButton(textColor: DesignColors.mutedForeground)),
                        title: "Text",
                        action: {}
                    )
                    
                    ArotiButton(
                        kind: .custom(.accentCard()),
                        title: "View Details",
                        action: {}
                    )
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
}

