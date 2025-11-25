//
//  GridLayoutDemo.swift
//  Aroti
//

import SwiftUI

struct GridLayoutDemo: View {
    private let items = ["Grid Item 1", "Grid Item 2", "Grid Item 3", "Grid Item 4"]
    
    var body: some View {
        DesignCard(title: "Grid Layout") {
            VStack(alignment: .leading, spacing: 12) {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        gridItemCard(text: item)
                    }
                }
                
                Text("2-column grid layout")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
    
    private func gridItemCard(text: String) -> some View {
        Text(text)
            .font(DesignTypography.bodyFont())
            .foregroundColor(DesignColors.foreground)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: DesignRadius.card)
                    .fill(DesignColors.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignRadius.card)
                            .stroke(DesignColors.border.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

