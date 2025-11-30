//
//  MainTabView.swift
//  Aroti
//
//  Main tab view container for navigation between tabs
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView(selectedTab: $selectedTab)
                    .tag(TabItem.home)
            case .discovery:
                DiscoveryView(selectedTab: $selectedTab)
                    .tag(TabItem.discovery)
            case .booking:
                BookingView(selectedTab: $selectedTab)
                    .tag(TabItem.booking)
            case .profile:
                ProfileView(selectedTab: $selectedTab)
                    .tag(TabItem.profile)
            case .guidance:
                GuidanceView(selectedTab: $selectedTab)
                    .tag(TabItem.guidance)
            }
        }
    }
}

#Preview {
    MainTabView()
}

