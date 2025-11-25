//
//  CategoryChipShowcase.swift
//  Aroti
//

import SwiftUI

struct CategoryChipShowcase: View {
    @State private var active = "All"
    private let tabs = ["All", "Tarot", "Astrology", "Numerology"]
    
    var body: some View {
        DesignCard(title: "CategoryChip") {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    ForEach(tabs, id: \.self) { tab in
                        CategoryChip(label: tab, isActive: active == tab, action: { active = tab })
                    }
                }
                
                Text("Badge / category / Active and inactive states")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

