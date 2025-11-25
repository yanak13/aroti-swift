//
//  Slider.swift
//  Aroti
//
//  Slider component for range selection
//

import SwiftUI

struct DesignSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...100,
        step: Double = 1
    ) {
        self._value = value
        self.range = range
        self.step = step
    }
    
    var body: some View {
        Slider(value: $value, in: range, step: step)
            .tint(DesignColors.accent)
    }
}

