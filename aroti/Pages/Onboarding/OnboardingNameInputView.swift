//
//  OnboardingNameInputView.swift
//
//  Page 13 - Name Input
//

import SwiftUI

struct OnboardingNameInputView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var nameText: String = ""
    @FocusState private var isFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    @State private var shakeOffset: CGFloat = 0
    
    private var hasText: Bool {
        !(coordinator.userName?.isEmpty ?? true)
    }
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                NameInputHero()
            },
            title: "What should we call you?",
            content: {
                OnboardingInputCard(
                    placeholder: "Enter your name",
                    isSelected: hasText,
                    isFocused: isFocused
                ) {
                    OnboardingTextInput(
                        placeholder: "Enter your name",
                        text: Binding(
                            get: { coordinator.userName ?? nameText },
                            set: { newValue in
                                coordinator.userName = newValue.isEmpty ? nil : newValue
                                nameText = newValue
                            }
                        ),
                        isFocused: $isFocused
                    )
                }
                .offset(x: shakeOffset)
            },
            canContinue: hasText,
            onContinue: {
                if hasText {
                    coordinator.nextPage()
                } else {
                    // Shake animation
                    withAnimation(.easeInOut(duration: 0.1).repeatCount(2, autoreverses: true)) {
                        shakeOffset = 10
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        shakeOffset = 0
                    }
                }
            },
            keyboardPadding: keyboardHeight
        )
        .onAppear {
            nameText = coordinator.userName ?? ""
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
               let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let safeAreaBottom = window.safeAreaInsets.bottom
                withAnimation(.easeOut(duration: 0.25)) {
                    keyboardHeight = keyboardFrame.height - safeAreaBottom + 16 // 16px margin
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeOut(duration: 0.25)) {
                keyboardHeight = 0
            }
        }
    }
}
