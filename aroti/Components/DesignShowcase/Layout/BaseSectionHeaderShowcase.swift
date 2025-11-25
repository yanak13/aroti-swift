//
//  BaseSectionHeaderShowcase.swift
//  Aroti
//
//  Showcase of BaseSectionHeader component
//

import SwiftUI

struct BaseSectionHeaderShowcase: View {
    var body: some View {
        DesignCard(title: "BaseSectionHeader") {
            VStack(alignment: .leading, spacing: 16) {
                BaseSectionHeader(
                    title: "Section Title",
                    subtitle: "Section description"
                )
                
                BaseSectionHeader(
                    title: "Section with Action",
                    subtitle: "Section with View All button",
                    onViewAll: {}
                )
            }
        }
    }
}

