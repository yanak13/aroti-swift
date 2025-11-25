//
//  DesignSystem.swift
//  Aroti
//
//  Unified design system tokens matching React app
//

import SwiftUI

// MARK: - Border Radius
enum ArotiRadius {
    static let xs: CGFloat = 8   // small badges, tiny chips
    static let sm: CGFloat = 12  // small buttons, small cards
    static let md: CGFloat = 16  // standard cards, inputs
    static let lg: CGFloat = 20  // big cards, modals
    static let pill: CGFloat = 999 // chips, category tags, pill buttons (fully rounded)
}

// MARK: - Colors
enum ArotiColor {
    // Backgrounds
    static let bg = Color(hue: 252/360, saturation: 0.38, brightness: 0.12)          // main background
    static let surface = Color(hue: 235/360, saturation: 0.30, brightness: 0.11)   // standard card
    static let surfaceHi = Color(red: 12/255, green: 10/255, blue: 18/255, opacity: 0.92) // elevated/modal (glass)
    
    // Borders
    static let border = Color(hue: 235/360, saturation: 0.25, brightness: 0.16)
    
    // Input colors (more visible for form fields)
    static let inputBorder = Color.white.opacity(0.25)  // highly visible border for inputs
    static let inputBorderFocus = Color(red: 185/255, green: 110/255, blue: 70/255)  // accent color for focused inputs (full opacity)
    static let inputBackground = Color(hue: 235/360, saturation: 0.30, brightness: 0.11).opacity(0.8)  // highly visible background
    static let inputPlaceholder = Color(hue: 0/360, saturation: 0.0, brightness: 0.55)  // placeholder text color (more visible)
    
    // Accent (premium terracotta - lighter: HSL(20, 52%, 48%))
    static let accent = Color(red: 185/255, green: 110/255, blue: 70/255)
    static let accentSoft = Color(red: 215/255, green: 150/255, blue: 115/255).opacity(0.2)  // soft accent/20 (HSL(20, 48%, 62%))
    static let accentText = Color.white  // text on accent
    
    // Text (neutral white/off-white, not beige)
    static let textPrimary = Color(hue: 0/360, saturation: 0.0, brightness: 0.96)   // pure off-white foreground
    static let textSecondary = Color(hue: 0/360, saturation: 0.0, brightness: 0.65)   // neutral gray (muted foreground)
    static let textMuted = Color(hue: 0/360, saturation: 0.0, brightness: 0.42)       // darker neutral gray
    
    // Status colors (emerald, amber, rose with /20 opacity)
    static let success = Color(hue: 142/360, saturation: 0.71, brightness: 0.53).opacity(0.2)      // emerald-500/20
    static let successBorder = Color(hue: 142/360, saturation: 0.71, brightness: 0.53).opacity(0.3) // emerald-500/30
    static let successText = Color(hue: 142/360, saturation: 0.71, brightness: 0.53)              // emerald-500
    
    static let warning = Color(hue: 43/360, saturation: 0.96, brightness: 0.50).opacity(0.2)     // amber-500/20
    static let warningBorder = Color(hue: 43/360, saturation: 0.96, brightness: 0.50).opacity(0.3) // amber-500/30
    static let warningText = Color(hue: 43/360, saturation: 0.96, brightness: 0.50)              // amber-500
    
    static let danger = Color(hue: 0/360, saturation: 0.84, brightness: 0.60).opacity(0.2)         // rose-500/20
    static let dangerBorder = Color(hue: 0/360, saturation: 0.84, brightness: 0.60).opacity(0.3)  // rose-500/30
    static let dangerText = Color(hue: 0/360, saturation: 0.84, brightness: 0.60)                // rose-500
    
    // Overlay & Disabled
    static let overlayScrim = Color.black.opacity(0.6)
    static let disabledBg = Color(hue: 235/360, saturation: 0.25, brightness: 0.15).opacity(0.3)
    static let disabledText = Color(hue: 0/360, saturation: 0.0, brightness: 0.35)
    
    // Utility & Brand
    static let pureWhite = Color.white
    static let pureBlack = Color.black
    static let shadowSoft = pureBlack.opacity(0.1)
    static let shadowMedium = pureBlack.opacity(0.3)
    
    static let brandApple = pureBlack
    static let brandGoogleSurface = pureWhite
    static let brandGoogleBlue = Color(red: 66/255, green: 133/255, blue: 244/255)
    static let brandGoogleText = Color(red: 60/255, green: 64/255, blue: 67/255)
    static let brandGoogleBorder = Color(red: 218/255, green: 220/255, blue: 224/255)
    
    // Legacy compatibility (will be deprecated)
    static let foreground = textPrimary  // neutral off-white
    static let mutedForeground = textSecondary  // neutral gray
    static let card = surface
    static let glassPrimary = surfaceHi
    static let glassBorder = Color.white.opacity(0.12)
}

// MARK: - Typography
enum ArotiTextStyle {
    // Titles
    static let largeTitle = Font.system(size: 34, weight: .bold)
    static let title1 = Font.system(size: 28, weight: .semibold)
    static let title2 = Font.system(size: 22, weight: .semibold)
    static let title3 = Font.system(size: 20, weight: .semibold)
    
    // Content
    static let headline = Font.system(size: 17, weight: .semibold)
    static let body = Font.system(size: 17, weight: .regular)
    static let callout = Font.system(size: 16, weight: .regular)
    static let subhead = Font.system(size: 15, weight: .regular)
    
    // Meta
    static let caption1 = Font.system(size: 13, weight: .regular)
    static let caption2 = Font.system(size: 11, weight: .regular)
}

// MARK: - Spacing
struct DesignSpacing {
    static let xs: CGFloat = 8
    static let sm: CGFloat = 16
    static let md: CGFloat = 24
    static let lg: CGFloat = 32
    static let xl: CGFloat = 48
    static let xxl: CGFloat = 64
}

// MARK: - Button Heights
enum ArotiButtonHeight {
    static let standard: CGFloat = 48  // Default button height (iOS HIG minimum touch target)
    static let compact: CGFloat = 44  // Small/compact buttons (minimum touch target)
    static let large: CGFloat = 52    // Prominent CTAs, SSO buttons
    static let floating: CGFloat = 56  // Floating action buttons (circular)
    static let datePill: CGFloat = 80 // Date/time selection buttons (custom)
}

// MARK: - Legacy Compatibility (for gradual migration)
struct DesignColors {
    static let backgroundStart = ArotiColor.bg
    static let backgroundEnd = Color(hue: 240/360, saturation: 0.30, brightness: 0.09)
    static let foreground = ArotiColor.textPrimary
    static let mutedForeground = ArotiColor.textSecondary
    static let accent = ArotiColor.accent
    static let accentGlow = ArotiColor.accent
    static let accentMuted = ArotiColor.accent.opacity(0.3)
    static let primary = Color(red: 185/255, green: 110/255, blue: 70/255)  // matches accent (lighter)
    static let secondary = Color(red: 215/255, green: 150/255, blue: 115/255)  // soft accent (lighter)
    static let card = ArotiColor.surface
    static let cardForeground = ArotiColor.textPrimary
    static let glassPrimary = ArotiColor.surfaceHi
    static let glassBorder = ArotiColor.glassBorder
    static let glassHighlight = ArotiColor.glassBorder
    static let overlayScrim = ArotiColor.overlayScrim
    static let border = ArotiColor.border
    static let success = ArotiColor.success
    static let successBorder = ArotiColor.successBorder
    static let danger = ArotiColor.danger
    static let dangerBorder = ArotiColor.dangerBorder
    static let warning = ArotiColor.warning
    static let warningBorder = ArotiColor.warningBorder
    static let destructive = Color(hue: 0/360, saturation: 0.70, brightness: 0.58)
}

struct DesignTypography {
    static let largeTitle: CGFloat = 34
    static let title1: CGFloat = 28
    static let title2: CGFloat = 22
    static let title3: CGFloat = 20
    static let headline: CGFloat = 17
    static let body: CGFloat = 17
    static let callout: CGFloat = 16
    static let subhead: CGFloat = 15
    static let footnote: CGFloat = 13
    static let caption1: CGFloat = 12
    static let caption2: CGFloat = 11
    
    static let normal: Font.Weight = .regular
    static let medium: Font.Weight = .medium
    static let semibold: Font.Weight = .semibold
    static let bold: Font.Weight = .bold
    
    static func largeTitleFont(weight: Font.Weight = .bold) -> Font {
        .system(size: largeTitle, weight: weight, design: .default)
    }
    
    static func title1Font(weight: Font.Weight = .semibold) -> Font {
        .system(size: title1, weight: weight, design: .default)
    }
    
    static func title2Font(weight: Font.Weight = .semibold) -> Font {
        .system(size: title2, weight: weight, design: .default)
    }
    
    static func title3Font(weight: Font.Weight = .semibold) -> Font {
        .system(size: title3, weight: weight, design: .default)
    }
    
    static func headlineFont(weight: Font.Weight = .semibold) -> Font {
        .system(size: headline, weight: weight, design: .default)
    }
    
    static func bodyFont(weight: Font.Weight = .regular) -> Font {
        .system(size: body, weight: weight, design: .default)
    }
    
    static func calloutFont(weight: Font.Weight = .regular) -> Font {
        .system(size: callout, weight: weight, design: .default)
    }
    
    static func subheadFont(weight: Font.Weight = .regular) -> Font {
        .system(size: subhead, weight: weight, design: .default)
    }
    
    static func footnoteFont(weight: Font.Weight = .regular) -> Font {
        .system(size: footnote, weight: weight, design: .default)
    }
    
    static func caption1Font(weight: Font.Weight = .regular) -> Font {
        .system(size: caption1, weight: weight, design: .default)
    }
    
    static func caption2Font(weight: Font.Weight = .regular) -> Font {
        .system(size: caption2, weight: weight, design: .default)
    }
}

struct DesignRadius {
    static let main: CGFloat = ArotiRadius.sm
    static let card: CGFloat = ArotiRadius.md
    static let secondary: CGFloat = ArotiRadius.md
    static let small: CGFloat = ArotiRadius.xs
    static let pill: CGFloat = ArotiRadius.pill
}

// MARK: - Background Gradient
struct CelestialBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [ArotiColor.bg, Color(hue: 240/360, saturation: 0.30, brightness: 0.09)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: - Design Card Component (for showcase sections)
struct DesignCard<Content: View>: View {
    let title: String
    let subtitle: String?
    @ViewBuilder let content: () -> Content
    
    init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let subtitle = subtitle {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(ArotiTextStyle.title3)
                        .foregroundColor(ArotiColor.textPrimary)
                    Text(subtitle)
                        .font(ArotiTextStyle.caption1)
                        .foregroundColor(ArotiColor.textSecondary)
                }
            } else {
                Text(title)
                    .font(ArotiTextStyle.title3)
                    .foregroundColor(ArotiColor.textPrimary)
            }
            
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.md)
                .fill(ArotiColor.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .stroke(ArotiColor.border, lineWidth: 1)
                )
        )
    }
}
