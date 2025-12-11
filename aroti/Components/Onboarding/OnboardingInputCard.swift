//
//  OnboardingInputCard.swift
//
//  Unified input card component for onboarding
//  Matches SelectionOptionButton styling for consistency
//

import SwiftUI

struct OnboardingInputCard<Content: View>: View {
    let label: String?
    let placeholder: String
    let isSelected: Bool
    let isFocused: Bool
    let icon: String?
    let iconPulse: Bool
    let content: Content
    let action: (() -> Void)?
    
    init(
        label: String? = nil,
        placeholder: String,
        isSelected: Bool = false,
        isFocused: Bool = false,
        icon: String? = nil,
        iconPulse: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.placeholder = placeholder
        self.isSelected = isSelected
        self.isFocused = isFocused
        self.icon = icon
        self.iconPulse = iconPulse
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Group {
            if let action = action {
                Button(action: {
                    HapticFeedback.impactOccurred(.light)
                    action()
                }) {
                    cardContent
                }
                .buttonStyle(.plain)
            } else {
                cardContent
            }
        }
    }
    
    private var cardContent: some View {
        HStack(spacing: DesignSpacing.sm) {
            // Left icon (if provided) - aligned with placeholder baseline
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected || isFocused ? ArotiColor.accent : ArotiColor.textSecondary)
                    .scaleEffect(iconPulse ? 1.1 : 1.0)
                    .opacity(iconPulse ? 0.8 : 1.0)
            }
            
            // Content area
            if let label = label {
                VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                    Text(label)
                        .font(ArotiTextStyle.caption1)
                        .foregroundColor(ArotiColor.textSecondary)
                    
                    content
                }
            } else {
                content
            }
        }
        .padding(.horizontal, DesignSpacing.lg)
        .padding(.vertical, DesignSpacing.md)
        .frame(height: 68) // Fixed height to match SelectionOptionButton (24pt padding * 2 + ~20pt text)
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.md)
                .fill((isSelected || isFocused) ? ArotiColor.accent.opacity(0.15) : ArotiColor.surface.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .stroke(
                            (isSelected || isFocused) ? ArotiColor.accent.opacity(0.5) : ArotiColor.border,
                            lineWidth: (isSelected || isFocused) ? 1.5 : 1
                        )
                )
        )
        .shadow(
            color: (isSelected || isFocused) ? ArotiColor.accent.opacity(0.3) : Color.clear,
            radius: (isSelected || isFocused) ? 8 : 0,
            x: 0,
            y: (isSelected || isFocused) ? 4 : 0
        )
    }
}
