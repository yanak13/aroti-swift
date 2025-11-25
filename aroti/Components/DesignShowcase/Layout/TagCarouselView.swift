//
//  TagCarouselView.swift
//  Aroti
//

import SwiftUI

struct TagCarouselView: View {
    var body: some View {
        DesignCard(title: "Tag Carousel") {
            VStack(alignment: .leading, spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        CategoryChip(label: "Tarot", isActive: false, action: {})
                        CategoryChip(label: "Astrology", isActive: false, action: {})
                        CategoryChip(label: "Numerology", isActive: true, action: {})
                        CategoryChip(label: "Therapy", isActive: false, action: {})
                        CategoryChip(label: "Meditation", isActive: false, action: {})
                    }
                    .padding(.horizontal, 4)
                }
                
                Text("Horizontal scroll list of category chips")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

