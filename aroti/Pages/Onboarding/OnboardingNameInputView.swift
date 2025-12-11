//
//  OnboardingNameInputView.swift
//
//  Page 13 - Name Input
//

import SwiftUI

struct OnboardingNameInputView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var nameText: String = ""
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                NameInputHero()
            },
            title: "What should we call you?",
            content: {
                OnboardingTextInput(
                    placeholder: "Enter your name",
                    text: Binding(
                        get: { coordinator.userName ?? nameText },
                        set: { newValue in
                            coordinator.userName = newValue.isEmpty ? nil : newValue
                            nameText = newValue
                        }
                    )
                )
            },
            canContinue: !(coordinator.userName?.isEmpty ?? true),
            onContinue: {
                coordinator.nextPage()
            }
        )
        .onAppear {
            nameText = coordinator.userName ?? ""
        }
    }
}
