//
//  Badge.swift
//  Aroti
//
//  Unified badge/chip component with consistent styling
//

import SwiftUI

struct Badge: View {
    let text: String
    let backgroundColor: Color
    let textColor: Color
    let borderColor: Color?
    let fontSize: Font
    
    init(
        text: String,
        backgroundColor: Color,
        textColor: Color,
        borderColor: Color? = nil,
        fontSize: Font = DesignTypography.footnoteFont(weight: .medium)
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.fontSize = fontSize
    }
    
    var body: some View {
        Text(text)
            .font(fontSize)
            .foregroundColor(textColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(backgroundColor)
                    .overlay(
                        Capsule()
                            .stroke(borderColor ?? Color.clear, lineWidth: borderColor != nil ? 1 : 0)
                    )
            )
    }
}

