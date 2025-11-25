//
//  Textarea.swift
//  Aroti
//
//  Multi-line text input component with improved visibility and focus states
//

import SwiftUI

struct DesignTextarea: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let placeholder: String
    let isDisabled: Bool
    
    init(
        text: Binding<String>,
        placeholder: String = "",
        isDisabled: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Placeholder (only shown when text is empty and not focused)
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(isDisabled ? ArotiColor.disabledText.opacity(0.7) : ArotiColor.inputPlaceholder)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
            }
            
            TextEditor(text: $text)
                .font(DesignTypography.bodyFont())
                .foregroundColor(textColor)
                .focused($isFocused)
                .tint(ArotiColor.accent)
                .padding(12)
                .frame(minHeight: 100)
                .scrollContentBackground(.hidden)
        }
        .background(
            RoundedRectangle(cornerRadius: DesignRadius.small)
                .fill(ArotiColor.inputBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignRadius.small)
                        .stroke(borderColor, lineWidth: 2)
                )
        )
        .opacity(isDisabled ? 0.6 : 1.0)
        .disabled(isDisabled)
    }
    
    private var textColor: Color {
        if isDisabled {
            return ArotiColor.disabledText
        } else {
            return ArotiColor.textPrimary
        }
    }
    
    private var borderColor: Color {
        if isFocused {
            return ArotiColor.inputBorderFocus
        } else {
            return ArotiColor.inputBorder
        }
    }
}

