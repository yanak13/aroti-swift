//
//  ArotiButton.swift
//  Aroti
//
//  Unified button component with 3 styles: Primary, Secondary, Ghost
//

import SwiftUI

struct ArotiButtonStyle {
    var foregroundColor: Color
    var backgroundColor: Color
    var backgroundGradient: LinearGradient?
    var borderColor: Color
    var borderGradient: LinearGradient?
    var borderWidth: CGFloat
    var cornerRadius: CGFloat
    var height: CGFloat
    var horizontalPadding: CGFloat
    var fullWidth: Bool
    var font: Font
    var shadow: ArotiButtonShadow?
    var fixedWidth: CGFloat?
    var iconSpacing: CGFloat
    
    init(
        foregroundColor: Color = ArotiColor.accentText,
        backgroundColor: Color = ArotiColor.accent,
        backgroundGradient: LinearGradient? = nil,
        borderColor: Color = .clear,
        borderGradient: LinearGradient? = nil,
        borderWidth: CGFloat = 0,
        cornerRadius: CGFloat = DesignRadius.secondary,
        height: CGFloat = ArotiButtonHeight.standard,
        horizontalPadding: CGFloat = 16,
        fullWidth: Bool = true,
        font: Font = ArotiTextStyle.subhead,
        shadow: ArotiButtonShadow? = nil,
        fixedWidth: CGFloat? = nil,
        iconSpacing: CGFloat = 8
    ) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.backgroundGradient = backgroundGradient
        self.borderColor = borderColor
        self.borderGradient = borderGradient
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.height = height
        self.horizontalPadding = horizontalPadding
        self.fullWidth = fullWidth
        self.font = font
        self.shadow = shadow
        self.fixedWidth = fixedWidth
        self.iconSpacing = iconSpacing
    }
}

struct ArotiButtonShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum ButtonStyleKind {
    case primary
    case secondary
    case ghost
    case custom(ArotiButtonStyle)
    
    var style: ArotiButtonStyle {
        switch self {
        case .primary:
            return ArotiButtonStyle(
                foregroundColor: ArotiColor.accentText,
                backgroundColor: ArotiColor.accent,
                cornerRadius: DesignRadius.secondary
            )
        case .secondary:
            return ArotiButtonStyle(
                foregroundColor: ArotiColor.accent,
                backgroundColor: .clear,
                borderColor: ArotiColor.accent,
                borderWidth: 1,
                cornerRadius: DesignRadius.secondary
            )
        case .ghost:
            return ArotiButtonStyle(
                foregroundColor: ArotiColor.textPrimary,
                backgroundColor: .clear,
                borderColor: .clear,
                borderWidth: 0,
                cornerRadius: DesignRadius.secondary
            )
        case .custom(let style):
            return style
        }
    }
}

struct ArotiButton<Label: View>: View {
    private let style: ArotiButtonStyle
    private let isDisabled: Bool
    private let action: () -> Void
    private let label: () -> Label
    
    init(
        kind: ButtonStyleKind = .primary,
        isDisabled: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.style = kind.style
        self.isDisabled = isDisabled
        self.action = action
        self.label = label
    }
}

extension ArotiButton where Label == ArotiButtonLabel {
    init(
        kind: ButtonStyleKind = .primary,
        title: String,
        icon: Image? = nil,
        trailingIcon: Image? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        let resolvedStyle = kind.style
        self.init(kind: kind, isDisabled: isDisabled, action: action) {
            ArotiButtonLabel(
                title: title,
                icon: icon,
                trailingIcon: trailingIcon,
                font: resolvedStyle.font,
                spacing: resolvedStyle.iconSpacing
            )
        }
    }
}

extension ArotiButton {
    var body: some View {
        Button(action: action) {
            label()
                .font(style.font)
                .foregroundColor(style.foregroundColor)
                .frame(maxWidth: style.fullWidth ? .infinity : nil)
                .frame(height: style.height, alignment: .center)
                .frame(width: style.fixedWidth)
                .padding(.horizontal, style.horizontalPadding)
                .contentShape(RoundedRectangle(cornerRadius: style.cornerRadius))
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
        .background(backgroundView)
        .overlay(
            Group {
                if let borderGradient = style.borderGradient {
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(borderGradient, lineWidth: style.borderWidth)
                } else {
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .stroke(style.borderColor, lineWidth: style.borderWidth)
                }
            }
        )
        .shadow(color: style.shadow?.color ?? .clear,
                radius: style.shadow?.radius ?? 0,
                x: style.shadow?.x ?? 0,
                y: style.shadow?.y ?? 0)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if let gradient = style.backgroundGradient {
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(gradient)
        } else {
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.backgroundColor)
        }
    }
}

struct ArotiButtonLabel: View {
    let title: String
    let icon: Image?
    let trailingIcon: Image?
    let font: Font
    let spacing: CGFloat
    
    var body: some View {
        HStack(spacing: spacing) {
            if let icon = icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            
            Text(title)
            
            if let trailingIcon = trailingIcon {
                trailingIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
        }
    }
}

extension ArotiButtonStyle {
    static func accentFilled(
        height: CGFloat = ArotiButtonHeight.standard,
        cornerRadius: CGFloat = DesignRadius.secondary,
        shadow: Bool = true
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: ArotiColor.accentText,
            backgroundColor: ArotiColor.accent,
            borderColor: .clear,
            borderWidth: 0,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 16,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: shadow ? ArotiButtonShadow(color: ArotiColor.accent.opacity(0.3), radius: 6, x: 0, y: 3) : nil
        )
    }
    
    static func accentOutline(
        height: CGFloat = ArotiButtonHeight.standard,
        cornerRadius: CGFloat = DesignRadius.secondary
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: ArotiColor.accent,
            backgroundColor: .clear,
            borderColor: ArotiColor.accent,
            borderWidth: 1,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 16,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: nil
        )
    }
    
    static func glass(
        textColor: Color = ArotiColor.textPrimary,
        borderColor: Color = DesignColors.glassBorder,
        cornerRadius: CGFloat = DesignRadius.secondary,
        height: CGFloat = ArotiButtonHeight.standard
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: textColor,
            backgroundColor: DesignColors.glassPrimary.opacity(0.4),
            borderColor: borderColor,
            borderWidth: 1,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 16,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: ArotiColor.shadowSoft, radius: 8, x: 0, y: 4)
        )
    }
    
    static func pill(
        background: Color,
        textColor: Color,
        height: CGFloat = ArotiButtonHeight.standard,
        horizontalPadding: CGFloat = 24,
        cornerRadius: CGFloat = DesignRadius.pill,
        fullWidth: Bool = true
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: textColor,
            backgroundColor: background,
            borderColor: .clear,
            borderWidth: 0,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: horizontalPadding,
            fullWidth: fullWidth,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: background.opacity(0.4), radius: 6, x: 0, y: 2)
        )
    }
    
    static func floating(
        diameter: CGFloat = ArotiButtonHeight.floating,
        background: Color = DesignColors.glassPrimary,
        border: Color = DesignColors.glassBorder,
        iconColor: Color = ArotiColor.accent
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: iconColor,
            backgroundColor: background,
            borderColor: border,
            borderWidth: 1,
            cornerRadius: diameter / 2,
            height: diameter,
            horizontalPadding: 0,
            fullWidth: false,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: ArotiColor.shadowMedium, radius: 12, x: 0, y: 6),
            fixedWidth: diameter
        )
    }
    
    static func accentCard(
        height: CGFloat = ArotiButtonHeight.compact,
        cornerRadius: CGFloat = 10
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: ArotiColor.accentText,
            backgroundColor: ArotiColor.accent,
            borderColor: .clear,
            borderWidth: 0,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 12,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: ArotiColor.accent.opacity(0.35), radius: 10, x: 0, y: 6)
        )
    }
    
    static func glassCardButton(
        textColor: Color = ArotiColor.textPrimary,
        cornerRadius: CGFloat = 10,
        height: CGFloat = ArotiButtonHeight.compact
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: textColor,
            backgroundColor: Color.white.opacity(0.05),
            borderColor: DesignColors.glassBorder,
            borderWidth: 1,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 12,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: ArotiColor.shadowSoft, radius: 6, x: 0, y: 4)
        )
    }
    
    static func premiumUnlock(
        cornerRadius: CGFloat = 10,
        height: CGFloat = ArotiButtonHeight.compact
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: ArotiColor.accent,
            backgroundColor: ArotiColor.accent.opacity(0.1),
            borderColor: ArotiColor.accent.opacity(0.5),
            borderWidth: 1,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 12,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: nil
        )
    }
    
    static func datePill(isActive: Bool) -> ArotiButtonStyle {
        if isActive {
            return ArotiButtonStyle(
                foregroundColor: ArotiColor.accent,
                backgroundColor: ArotiColor.accent.opacity(0.2),
                borderColor: ArotiColor.accent.opacity(0.5),
                borderWidth: 1,
                cornerRadius: ArotiRadius.md,
                height: ArotiButtonHeight.datePill,
                horizontalPadding: 10,
                fullWidth: false,
                font: ArotiTextStyle.subhead,
                shadow: ArotiButtonShadow(color: ArotiColor.accent.opacity(0.45), radius: 12, x: 0, y: 6),
                fixedWidth: 46
            )
        }
        
        return ArotiButtonStyle(
            foregroundColor: ArotiColor.textPrimary,
            backgroundColor: Color.white.opacity(0.05),
            borderColor: DesignColors.glassBorder,
            borderWidth: 1,
            cornerRadius: ArotiRadius.md,
            height: ArotiButtonHeight.datePill,
            horizontalPadding: 10,
            fullWidth: false,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: ArotiColor.shadowSoft, radius: 6, x: 0, y: 4),
            fixedWidth: 46
        )
    }
    
    static func timeSlot(isSelected: Bool) -> ArotiButtonStyle {
        if isSelected {
            return ArotiButtonStyle(
                foregroundColor: ArotiColor.accent,
                backgroundColor: ArotiColor.accent.opacity(0.2),
                borderColor: ArotiColor.accent.opacity(0.5),
                borderWidth: 1,
                cornerRadius: ArotiRadius.md,
                height: ArotiButtonHeight.compact,
                horizontalPadding: 12,
                fullWidth: true,
                font: ArotiTextStyle.subhead,
                shadow: ArotiButtonShadow(color: ArotiColor.accent.opacity(0.35), radius: 8, x: 0, y: 4)
            )
        }
        
        return ArotiButtonStyle(
            foregroundColor: ArotiColor.textPrimary,
            backgroundColor: Color.white.opacity(0.05),
            borderColor: DesignColors.glassBorder,
            borderWidth: 1,
            cornerRadius: ArotiRadius.md,
            height: ArotiButtonHeight.compact,
            horizontalPadding: 12,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: ArotiColor.shadowSoft, radius: 4, x: 0, y: 2)
        )
    }
    
    static func iconSquare(
        size: CGFloat = 40,
        isAccent: Bool = false
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: isAccent ? ArotiColor.accent : ArotiColor.textSecondary,
            backgroundColor: Color.white.opacity(0.05),
            borderColor: DesignColors.glassBorder,
            borderWidth: 1,
            cornerRadius: 8,
            height: size,
            horizontalPadding: 0,
            fullWidth: false,
            font: ArotiTextStyle.subhead,
            shadow: nil,
            fixedWidth: size
        )
    }
    
    static func sharePrimary(
        cornerRadius: CGFloat = 10,
        height: CGFloat = ArotiButtonHeight.compact
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: ArotiColor.accentText,
            backgroundColor: ArotiColor.accent,
            borderColor: .clear,
            borderWidth: 0,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 12,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: ArotiColor.accent.opacity(0.35), radius: 8, x: 0, y: 4)
        )
    }
    
    static func shareSecondary(
        cornerRadius: CGFloat = 10,
        height: CGFloat = ArotiButtonHeight.compact
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: ArotiColor.textSecondary,
            backgroundColor: Color.white.opacity(0.05),
            borderColor: DesignColors.glassBorder,
            borderWidth: 1,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 12,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: nil
        )
    }
    
    static func gradientFilled(
        colors: [Color],
        height: CGFloat = ArotiButtonHeight.large,
        cornerRadius: CGFloat = DesignRadius.secondary
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: ArotiColor.accentText,
            backgroundColor: .clear,
            backgroundGradient: LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            ),
            borderColor: .clear,
            borderWidth: 0,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 24,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: ArotiButtonShadow(color: ArotiColor.accent.opacity(0.3), radius: 10, x: 0, y: 4)
        )
    }
    
    static func gradientOutline(
        colors: [Color],
        height: CGFloat = ArotiButtonHeight.large,
        cornerRadius: CGFloat = DesignRadius.secondary
    ) -> ArotiButtonStyle {
        ArotiButtonStyle(
            foregroundColor: ArotiColor.textPrimary,
            backgroundColor: .clear,
            backgroundGradient: nil,
            borderColor: .clear,
            borderGradient: LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing),
            borderWidth: 2,
            cornerRadius: cornerRadius,
            height: height,
            horizontalPadding: 24,
            fullWidth: true,
            font: ArotiTextStyle.subhead,
            shadow: nil
        )
    }
}
