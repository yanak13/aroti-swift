//
//  SpecialistCardShowcase.swift
//  Aroti
//

import SwiftUI

struct SpecialistCardShowcase: View {
    var body: some View {
        DesignCard(title: "Card / Specialist") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(DesignColors.accent.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text("SM")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.accent)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sarah Moon")
                            .font(DesignTypography.headlineFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        Text("Tarot Reader")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        HStack(spacing: 4) {
                            Text("$75")
                                .font(DesignTypography.footnoteFont(weight: .medium))
                                .foregroundColor(DesignColors.mutedForeground)
                            Text("/ session")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                    
                    Spacer()
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

