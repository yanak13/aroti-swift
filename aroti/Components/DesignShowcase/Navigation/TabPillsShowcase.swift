//
//  TabPillsShowcase.swift
//  Aroti
//

import SwiftUI

struct TabPillsShowcase: View {
    @State private var activeTab = "Overview"
    
    var body: some View {
        DesignCard(title: "TabPills") {
            TabPills(
                tabs: ["Overview", "Settings", "History"],
                activeTab: $activeTab,
                onTabChange: { activeTab = $0 }
            )
        }
    }
}

