//
//  Input.swift
//  Aroti
//
//  Text input component with improved visibility and focus states
//

import SwiftUI

struct DesignInput: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let placeholder: String
    let isDisabled: Bool
    let isError: Bool
    let leadingIcon: Image?
    let isSecure: Bool
    
    init(
        text: Binding<String>,
        placeholder: String = "",
        isDisabled: Bool = false,
        isError: Bool = false,
        leadingIcon: Image? = nil,
        isSecure: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isDisabled = isDisabled
        self.isError = isError
        self.leadingIcon = leadingIcon
        self.isSecure = isSecure
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let leadingIcon = leadingIcon {
                leadingIcon
                    .foregroundColor(isDisabled ? ArotiColor.disabledText : ArotiColor.textSecondary)
                    .frame(width: 16, height: 16)
            }
            
            ZStack(alignment: .leading) {
                // Placeholder (only shown when text is empty and not focused)
                if text.isEmpty && !isFocused {
                    Text(placeholder)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(isDisabled ? ArotiColor.disabledText.opacity(0.7) : ArotiColor.inputPlaceholder)
                }
                
                // Actual input field
                if isSecure {
                    SecureField("", text: $text)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(textColor)
                        .focused($isFocused)
                        .disabled(isDisabled)
                        .tint(ArotiColor.accent)
                } else {
                    TextField("", text: $text)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(textColor)
                        .focused($isFocused)
                        .disabled(isDisabled)
                        .tint(ArotiColor.accent)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: DesignRadius.small)
                .fill(ArotiColor.inputBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignRadius.small)
                        .stroke(borderColor, lineWidth: 2)
                )
        )
        .opacity(isDisabled ? 0.6 : 1.0)
    }
    
    private var textColor: Color {
        if isDisabled {
            return ArotiColor.disabledText
        } else {
            return ArotiColor.textPrimary
        }
    }
    
    private var borderColor: Color {
        if isError {
            return DesignColors.destructive
        } else if isFocused {
            return ArotiColor.inputBorderFocus
        } else {
            return ArotiColor.inputBorder
        }
    }
}

