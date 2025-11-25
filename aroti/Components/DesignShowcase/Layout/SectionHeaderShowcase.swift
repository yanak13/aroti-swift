//
//  SectionHeaderShowcase.swift
//  Aroti
//

import SwiftUI

struct SectionHeaderShowcase: View {
    var body: some View {
        DesignCard(title: "SectionHeader") {
            SectionHeader(
                title: "Section Title",
                description: "Section description"
            )
        }
    }
}

