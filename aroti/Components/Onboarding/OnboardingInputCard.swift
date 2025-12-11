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
    let content: Content
    let action: (() -> Void)?
    
    init(
        label: String? = nil,
        placeholder: String,
        isSelected: Bool = false,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.placeholder = placeholder
        self.isSelected = isSelected
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
        VStack(alignment: .leading, spacing: DesignSpacing.xs) {
            if let label = label {
                Text(label)
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
            }
            
            content
        }
        .padding(.horizontal, DesignSpacing.lg)
        .padding(.vertical, DesignSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.md)
                .fill(isSelected ? ArotiColor.accent.opacity(0.15) : ArotiColor.surface.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .stroke(
                            isSelected ? ArotiColor.accent.opacity(0.5) : ArotiColor.border,
                            lineWidth: isSelected ? 1.5 : 1
                        )
                )
        )
        .shadow(
            color: isSelected ? ArotiColor.accent.opacity(0.3) : Color.clear,
            radius: isSelected ? 8 : 0,
            x: 0,
            y: isSelected ? 4 : 0
        )
    }
}
