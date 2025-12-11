//
//  OnboardingPersonalFocusView.swift
//
//  Page 7 - Personal Focus Question
//

import SwiftUI

struct OnboardingPersonalFocusView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    private let options = [
        "Self-growth",
        "Love & relationships",
        "Emotional clarity",
        "Career direction",
        "All of the above"
    ]
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                EmptyView()
            },
            title: "What do you want to focus on right now?",
            subtitle: "Your preferences help Aroti shape the guidance you receive.",
            content: {
                VStack(spacing: DesignSpacing.sm) {
                    ForEach(options, id: \.self) { option in
                        SelectionOptionButton(
                            title: option,
                            isSelected: coordinator.personalFocus.contains(option),
                            isMultiSelect: true,
                            action: {
                                if coordinator.personalFocus.contains(option) {
                                    coordinator.personalFocus.removeAll { $0 == option }
                                } else {
                                    coordinator.personalFocus.append(option)
                                }
                            }
                        )
                    }
                }
            },
            canContinue: !coordinator.personalFocus.isEmpty,
            onContinue: {
                coordinator.nextPage()
            },
            showHero: false
        )
    }
}
