//
//  ArotiChip.swift
//  Aroti
//
//  Unified chip/badge component for all tags, badges, and status indicators
//

import SwiftUI

enum ChipVariant {
    case neutral          // transparent bg, border, textSecondary
    case selected         // accentSoft bg, accent text
    case success          // success bg, successText
    case warning          // warning bg, warningText
    case danger           // danger bg, dangerText
}

struct ArotiChip: View {
    let text: String
    let variant: ChipVariant
    let action: (() -> Void)?
    
    init(
        text: String,
        variant: ChipVariant = .neutral,
        action: (() -> Void)? = nil
    ) {
        self.text = text
        self.variant = variant
        self.action = action
    }
    
    var body: some View {
        let content = Text(text)
            .font(ArotiTextStyle.caption1.weight(.semibold))
            .foregroundColor(textColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .frame(height: 28)
            .background(backgroundColor)
            .cornerRadius(ArotiRadius.pill)
            .overlay(
                Capsule()
                    .stroke(borderColor, lineWidth: borderWidth)
            )
        
        if let action = action {
            Button(action: action) {
                content
            }
        } else {
            content
        }
    }
    
    private var backgroundColor: Color {
        switch variant {
        case .neutral:
            return Color.clear
        case .selected:
            return ArotiColor.accentSoft
        case .success:
            return ArotiColor.success
        case .warning:
            return ArotiColor.warning
        case .danger:
            return ArotiColor.danger
        }
    }
    
    private var textColor: Color {
        switch variant {
        case .neutral:
            return ArotiColor.textSecondary
        case .selected:
            return ArotiColor.accent
        case .success:
            return ArotiColor.successText
        case .warning:
            return ArotiColor.warningText
        case .danger:
            return ArotiColor.dangerText
        }
    }
    
    private var borderColor: Color {
        switch variant {
        case .neutral:
            return ArotiColor.border
        case .selected:
            return ArotiColor.accent.opacity(0.5)
        case .success:
            return ArotiColor.successBorder
        case .warning:
            return ArotiColor.warningBorder
        case .danger:
            return ArotiColor.dangerBorder
        }
    }
    
    private var borderWidth: CGFloat {
        switch variant {
        case .neutral, .selected:
            return 1
        case .success, .warning, .danger:
            return 1
        }
    }
}

