//
//  OnboardingTextInput.swift
//
//  Text input field for onboarding - works within OnboardingInputCard
//

import SwiftUI

struct OnboardingTextInput: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    @FocusState.Binding var isFocused: Bool
    
    init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        isFocused: FocusState<Bool>.Binding
    ) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self._isFocused = isFocused
    }
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(ArotiColor.textPrimary.opacity(0.6)))
            .font(ArotiTextStyle.body)
            .foregroundColor(ArotiColor.textPrimary)
            .keyboardType(keyboardType)
            .autocapitalization(.words)
            .focused($isFocused)
    }
}
