//
//  SliderShowcase.swift
//  Aroti
//

import SwiftUI

struct SliderShowcase: View {
    @State private var value: Double = 50
    
    var body: some View {
        DesignCard(title: "Slider") {
            VStack(alignment: .leading, spacing: 12) {
                DesignSlider(value: $value, in: 0...100, step: 1)
                Text("Value: \(Int(value))")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

