//
//  SSOButtonShowcase.swift
//  Aroti
//

import SwiftUI

struct SSOButtonShowcase: View {
    private let appleStyle = ArotiButtonStyle(
        foregroundColor: ArotiColor.accentText,
        backgroundColor: ArotiColor.brandApple,
        borderColor: .clear,
        borderWidth: 0,
        cornerRadius: DesignRadius.secondary,
        height: ArotiButtonHeight.large,
        horizontalPadding: 24,
        fullWidth: true,
        font: ArotiTextStyle.subhead
    )
    
    private let googleStyle = ArotiButtonStyle(
        foregroundColor: ArotiColor.brandGoogleText,
        backgroundColor: ArotiColor.brandGoogleSurface,
        borderColor: ArotiColor.brandGoogleBorder,
        borderWidth: 1,
        cornerRadius: DesignRadius.secondary,
        height: ArotiButtonHeight.large,
        horizontalPadding: 24,
        fullWidth: true,
        font: ArotiTextStyle.subhead
    )
    
    var body: some View {
        DesignCard(title: "SSOButton") {
            VStack(alignment: .leading, spacing: 14) {
                ArotiButton(
                    kind: .custom(appleStyle),
                    isDisabled: false,
                    action: {},
                    label: {
                        HStack(spacing: 8) {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 20))
                            Text("Continue with Apple")
                                .font(DesignTypography.subheadFont(weight: .medium))
                        }
                    }
                )
                
                ArotiButton(
                    kind: .custom(googleStyle),
                    isDisabled: false,
                    action: {},
                    label: {
                        HStack(spacing: 8) {
                            Text("G")
                                .font(DesignTypography.subheadFont(weight: .bold))
                                .foregroundColor(ArotiColor.brandGoogleBlue)
                            Text("Continue with Google")
                                .font(DesignTypography.subheadFont(weight: .medium))
                        }
                    }
                )
                
                ArotiButton(
                    kind: .custom(appleStyle),
                    isDisabled: true,
                    action: {},
                    label: {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: ArotiColor.accentText))
                            Spacer()
                        }
                    }
                )
            }
        }
    }
}
