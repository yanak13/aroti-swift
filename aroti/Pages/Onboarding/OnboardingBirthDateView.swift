//
//  OnboardingBirthDateView.swift
//
//  Page 10 - Birth Date
//

import SwiftUI

struct OnboardingBirthDateView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    private var hasDateSelected: Bool {
        coordinator.birthDate != nil
    }
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                BirthDateHero()
            },
            title: "What's your birth date?",
            content: {
                OnboardingInputCard(
                    label: "Select your birth date",
                    placeholder: "Select your birth date",
                    isSelected: hasDateSelected
                ) {
                    OnboardingDatePicker(
                        date: Binding(
                            get: { coordinator.birthDate },
                            set: { newDate in
                                coordinator.birthDate = newDate
                            }
                        ),
                        displayedComponents: [.date],
                        placeholder: "Select your birth date",
                        title: "Select Birth Date"
                    )
                }
            },
            canContinue: coordinator.birthDate != nil,
            onContinue: {
                coordinator.nextPage()
            }
        )
    }
}
