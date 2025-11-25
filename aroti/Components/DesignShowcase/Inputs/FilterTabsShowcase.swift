//
//  FilterTabsShowcase.swift
//  Aroti
//

import SwiftUI

struct FilterTabsShowcase: View {
    @State private var selected = "All"
    private let tabs = ["All", "Astrology", "Therapy", "Numerology"]
    
    var body: some View {
        DesignCard(title: "Filter Tabs") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(tabs, id: \.self) { tab in
                        tabButton(title: tab, isActive: selected == tab)
                    }
                }
            }
        }
    }
    
    private func tabButton(title: String, isActive: Bool) -> some View {
        ArotiButton(
            kind: .custom(
                .pill(
                    background: isActive ? ArotiColor.accent : DesignColors.glassPrimary,
                    textColor: isActive ? ArotiColor.accentText : ArotiColor.textSecondary,
                    height: 38,
                    horizontalPadding: 20,
                    cornerRadius: DesignRadius.pill,
                    fullWidth: false
                )
            ),
            title: title,
            action: { selected = title }
        )
    }
}

