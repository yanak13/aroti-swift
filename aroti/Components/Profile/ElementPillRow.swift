//
//  ElementPillRow.swift
//  Aroti
//
//  Element pill tags component
//

import SwiftUI

struct ElementPillRow: View {
    let elements: [Element]
    let label: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let label = label {
                Text(label)
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            HStack(spacing: 8) {
                ForEach(elements, id: \.self) { element in
                    ElementPill(element: element)
                }
            }
        }
    }
}

struct ElementPill: View {
    let element: Element
    
    private var elementColor: Color {
        switch element {
        case .fire:
            return Color(red: 1.0, green: 0.4, blue: 0.2) // Orange-red
        case .earth:
            return Color(red: 0.6, green: 0.4, blue: 0.2) // Brown
        case .air:
            return Color(red: 0.7, green: 0.8, blue: 1.0) // Light blue
        case .water:
            return Color(red: 0.2, green: 0.5, blue: 0.9) // Blue
        }
    }
    
    var body: some View {
        Text(element.rawValue)
            .font(DesignTypography.caption2Font(weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(elementColor.opacity(0.8))
            )
    }
}
