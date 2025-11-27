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
                // Placeholder for Booking view
                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        CelestialBackground()
                        VStack {
                            Spacer()
                            Text("Booking")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            Spacer()
                            BottomNavigationBar(selectedTab: $selectedTab) { tab in
                                selectedTab = tab
                            }
                        }
                    }
                }
                .tag(TabItem.booking)
            case .profile:
                // Placeholder for Profile view
                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        CelestialBackground()
                        VStack {
                            Spacer()
                            Text("Profile")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            Spacer()
                            BottomNavigationBar(selectedTab: $selectedTab) { tab in
                                selectedTab = tab
                            }
                        }
                    }
                }
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

