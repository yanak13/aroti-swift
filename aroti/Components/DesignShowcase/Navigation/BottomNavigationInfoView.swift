//
//  BottomNavigationInfoView.swift
//  Aroti
//

import SwiftUI

struct BottomNavigationInfoView: View {
    var body: some View {
        DesignCard(title: "Bottom Navigation") {
            VStack(alignment: .leading, spacing: 12) {
                Text("The bottom navigation bar is shown at the bottom of the page. It includes: Home, Discovery, Booking, Profile")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                CategoryChip(label: "Bottom nav is rendered via PageWrapper component", isActive: false, action: {})
            }
        }
    }
}

