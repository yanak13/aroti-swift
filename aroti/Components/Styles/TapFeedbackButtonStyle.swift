//
//  TapFeedbackButtonStyle.swift
//  Aroti
//
//  Shared tap feedback styles for cards and text links
//

import SwiftUI

struct CardTapButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 14
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.08 : 0))
            )
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct TextTapButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.6 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}


