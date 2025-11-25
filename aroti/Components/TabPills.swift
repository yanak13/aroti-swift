//
//  TabPills.swift
//  Aroti
//
//  Tab navigation pills component
//

import SwiftUI

struct TabPills: View {
    let tabs: [String]
    @Binding var activeTab: String
    let onTabChange: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tabs, id: \.self) { tab in
                    Button(action: {
                        activeTab = tab
                        onTabChange(tab)
                    }) {
                        Text(tab)
                            .font(DesignTypography.subheadFont(weight: .medium))
                            .foregroundColor(activeTab == tab ? .white : DesignColors.mutedForeground)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(activeTab == tab ? DesignColors.accent : Color.clear)
                                    .overlay(
                                        Capsule()
                                            .stroke(activeTab == tab ? Color.clear : Color.clear, lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal, DesignSpacing.sm)
        }
    }
}

