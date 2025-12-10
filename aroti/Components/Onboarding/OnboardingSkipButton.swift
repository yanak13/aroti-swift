//
//  OnboardingSkipButton.swift
//  Aroti
//
//  Skip button for onboarding screens
//

import SwiftUI

struct SkipOnboardingKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var skipOnboarding: (() -> Void)? {
        get { self[SkipOnboardingKey.self] }
        set { self[SkipOnboardingKey.self] = newValue }
    }
}

struct OnboardingSkipButton: View {
    @Environment(\.skipOnboarding) var skipOnboarding
    
    var body: some View {
        if let skipAction = skipOnboarding {
            Button(action: {
                skipAction()
            }) {
                Text("Skip")
                    .font(ArotiTextStyle.subhead)
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
}
