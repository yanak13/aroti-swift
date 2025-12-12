//
//  SelectionOptionButton.swift
//
//  Reusable selection option button for onboarding questions
//

import SwiftUI

struct SelectionOptionButton: View {
    let title: String
    let icon: String?
    let isSelected: Bool
    let isMultiSelect: Bool
    let action: () -> Void
    
    init(
        title: String,
        icon: String? = nil,
        isSelected: Bool,
        isMultiSelect: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.isMultiSelect = isMultiSelect
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            HapticFeedback.impactOccurred(.light)
            action()
        }) {
            HStack(spacing: DesignSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? ArotiColor.accent : ArotiColor.textSecondary)
                }
                
                Text(title)
                    .font(ArotiTextStyle.body)
                    .foregroundColor(isSelected ? ArotiColor.accent : ArotiColor.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isMultiSelect {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? ArotiColor.accent : ArotiColor.textMuted)
                }
            }
            .padding(.horizontal, DesignSpacing.lg)
            .padding(.vertical, DesignSpacing.md)
            .frame(height: 68) // Fixed height to match OnboardingInputCard
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
        .buttonStyle(.plain)
    }
}
