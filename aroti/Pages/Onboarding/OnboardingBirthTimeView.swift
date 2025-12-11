//
//  OnboardingBirthTimeView.swift
//
//  Page 11 - Birth Time
//

import SwiftUI

struct OnboardingBirthTimeView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var isUnknown: Bool = false
    
    private var hasTimeSelected: Bool {
        coordinator.birthTime != nil && !isUnknown
    }
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                BirthTimeHero()
            },
            title: "Do you know your birth time?",
            subtitle: "Even an approximate time helps improve accuracy.",
            content: {
                VStack(spacing: DesignSpacing.md) {
                    // Time picker card - always visible, highlightable
                    OnboardingInputCard(
                        label: "Select your birth time",
                        placeholder: "Select your time",
                        isSelected: hasTimeSelected,
                        action: {
                            isUnknown = false
                        }
                    ) {
                        HStack {
                            Spacer()
                            OnboardingDatePicker(
                                date: Binding(
                                    get: { coordinator.birthTime },
                                    set: { newTime in
                                        coordinator.birthTime = newTime
                                        isUnknown = false
                                    }
                                ),
                                displayedComponents: [.hourAndMinute],
                                placeholder: "Select your time",
                                title: "Select Birth Time"
                            )
                            Spacer()
                        }
                    }
                    
                    // "I'm not sure" option - always visible
                    SelectionOptionButton(
                        title: "I'm not sure",
                        isSelected: isUnknown,
                        action: {
                            isUnknown = true
                            coordinator.birthTime = nil
                        }
                    )
                }
            },
            canContinue: true, // Always can continue (time is optional)
            onContinue: {
                coordinator.nextPage()
            }
        )
    }
}
