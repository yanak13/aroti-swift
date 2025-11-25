//
//  BottomNavigationBar.swift
//  Aroti
//
//  Bottom navigation bar component
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Home"
    case discovery = "Discovery"
    case booking = "Booking"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .discovery: return "safari.fill"
        case .booking: return "calendar"
        case .profile: return "person.fill"
        }
    }
}

struct BottomNavigationBar: View {
    @Binding var selectedTab: TabItem
    let onTabSelected: (TabItem) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                    onTabSelected(tab)
                }) {
                    tabButtonContent(tab: tab, isSelected: selectedTab == tab)
                }
            }
        }
        .padding(.horizontal, DesignSpacing.sm)
        .padding(.top, DesignSpacing.xs)
        .padding(.bottom, 20)
        .background(
            // Match celestial background color - use the same gradient as page background
            LinearGradient(
                gradient: Gradient(colors: [ArotiColor.bg, Color(hue: 240/360, saturation: 0.30, brightness: 0.09)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: -2)
    }
    
    @ViewBuilder
    private func tabButtonContent(tab: TabItem, isSelected: Bool) -> some View {
        VStack(spacing: 4) {
            ZStack {
                if isSelected {
                    // Glowing background for active tab
                    RoundedRectangle(cornerRadius: 12)
                        .fill(DesignColors.accent.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .shadow(color: DesignColors.accent.opacity(0.4), radius: 8, x: 0, y: 0)
                }
                
                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isSelected ? DesignColors.accent : DesignColors.foreground)
            }
            
            Text(tab.rawValue)
                .font(DesignTypography.caption2Font(weight: .medium))
                .foregroundColor(isSelected ? DesignColors.accent : DesignColors.foreground)
            
            Circle()
                .fill(isSelected ? DesignColors.accent : Color.clear)
                .frame(width: 4, height: 4)
        }
        .frame(maxWidth: .infinity)
    }
}

