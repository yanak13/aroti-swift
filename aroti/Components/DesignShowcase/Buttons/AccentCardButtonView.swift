//
//  AccentCardButtonView.swift
//  Aroti
//

import SwiftUI

struct AccentCardButtonView: View {
    var body: some View {
        DesignCard(title: "Accent Button (from cards)") {
            VStack(alignment: .leading, spacing: 12) {
                ArotiButton(
                    kind: .custom(.accentCard()),
                    title: "Begin Practice",
                    action: {}
                )
                
                Text("Used in TodaysRitual, ReflectionSection, DailyQuiz")
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(ArotiColor.textSecondary)
                    .padding(.top, 4)
            }
        }
    }
}

