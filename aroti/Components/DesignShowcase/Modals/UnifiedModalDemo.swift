//
//  UnifiedModalDemo.swift
//  Aroti
//

import SwiftUI

struct UnifiedModalDemo: View {
    var body: some View {
        DesignCard(title: "UnifiedModal") {
            VStack(alignment: .leading, spacing: 12) {
                ArotiButton(kind: .custom(.accentCard()), title: "Open Unified Modal", action: {})
                
                Text("A unified modal component with primary and secondary actions")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

