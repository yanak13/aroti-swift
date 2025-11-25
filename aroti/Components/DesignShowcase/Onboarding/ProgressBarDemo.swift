//
//  ProgressBarDemo.swift
//  Aroti
//

import SwiftUI

struct ProgressBarDemo: View {
    var body: some View {
        DesignCard(title: "ProgressBar") {
            VStack(alignment: .leading, spacing: 12) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: DesignRadius.pill)
                            .fill(DesignColors.card.opacity(0.3))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: DesignRadius.pill)
                            .fill(DesignColors.accent)
                            .frame(width: geometry.size.width * 0.6, height: 4)
                    }
                }
                .frame(height: 4)
                
                Text("Step 3 of 5")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

