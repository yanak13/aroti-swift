//
//  OnboardingBirthDateView.swift
//
//  Page 10 - Birth Date
//

import SwiftUI

struct OnboardingBirthDateView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var isPickerOpen = false
    
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
                    placeholder: "MM / DD / YYYY",
                    isSelected: hasDateSelected
                ) {
                    OnboardingDatePicker(
                        date: Binding(
                            get: { coordinator.birthDate },
                            set: { newDate in
                                coordinator.birthDate = newDate
                            }
                        ),
                        isPickerOpen: $isPickerOpen,
                        displayedComponents: [.date],
                        placeholder: "MM / DD / YYYY",
                        title: "Select Birth Date"
                    )
                }
            },
            canContinue: coordinator.birthDate != nil,
            onContinue: {
                coordinator.nextPage()
            }
        )
        .blur(radius: isPickerOpen ? 8 : 0)
        .opacity(isPickerOpen ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isPickerOpen)
    }
}
