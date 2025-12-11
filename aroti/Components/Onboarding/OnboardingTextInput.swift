//
//  OnboardingTextInput.swift
//
//  Text input field for onboarding
//

import SwiftUI

struct OnboardingTextInput: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    
    init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(ArotiTextStyle.body)
            .foregroundColor(ArotiColor.textPrimary)
            .keyboardType(keyboardType)
            .autocapitalization(.words)
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.vertical, DesignSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: ArotiRadius.md)
                    .fill(ArotiColor.inputBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .stroke(ArotiColor.inputBorder, lineWidth: 1)
                    )
            )
    }
}
