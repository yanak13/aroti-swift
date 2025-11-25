//
//  TarotModalDemo.swift
//  Aroti
//

import SwiftUI

struct TarotModalDemo: View {
    var body: some View {
        DesignCard(title: "Tarot Card Modal") {
            VStack(alignment: .leading, spacing: 12) {
                ArotiButton(kind: .custom(.accentCard()), title: "Open Tarot Modal", action: {})
                
                Text("Card image, name, tag chips, interpretation, guidance list, Share + Image buttons")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

