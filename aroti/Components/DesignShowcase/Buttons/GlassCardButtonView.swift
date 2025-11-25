//
//  GlassCardButtonView.swift
//  Aroti
//

import SwiftUI

struct GlassCardButtonView: View {
    var body: some View {
        DesignCard(title: "Glass Button (from cards)") {
            VStack(alignment: .leading, spacing: 12) {
                ArotiButton(
                    kind: .custom(.glassCardButton()),
                    title: "Text",
                    action: {}
                )
                
                Text("Used in SpecialistCard, Profile buttons")
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(ArotiColor.textSecondary)
                    .padding(.top, 4)
            }
        }
    }
}

