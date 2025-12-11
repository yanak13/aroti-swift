//
//  OnboardingBirthLocationView.swift
//
//  Page 12 - Birth Location - Bottom Sheet Picker
//

import SwiftUI

struct OnboardingBirthLocationView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var isPickerOpen = false
    
    private var hasLocation: Bool {
        coordinator.birthLocation != nil
    }
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                BirthLocationHero()
            },
            title: "Where were you born?",
            subtitle: "Selecting your birth location improves your natal chart accuracy.",
            content: {
                OnboardingInputCard(
                    placeholder: "Select your birth location",
                    isSelected: hasLocation
                ) {
                    OnboardingLocationPicker(
                        location: Binding(
                            get: { coordinator.birthLocation },
                            set: { newLocation in
                                coordinator.birthLocation = newLocation
                            }
                        ),
                        isPickerOpen: $isPickerOpen,
                        placeholder: "Select your birth location",
                        title: "Select Birth Location"
                    )
                }
            },
            canContinue: hasLocation,
            onContinue: {
                coordinator.nextPage()
            }
        )
        .blur(radius: isPickerOpen ? 8 : 0)
        .opacity(isPickerOpen ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isPickerOpen)
    }
}
