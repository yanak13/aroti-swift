//
//  OnboardingGuidanceFrequencyView.swift
//
//  Page 8 - Guidance Frequency
//

import SwiftUI

struct OnboardingGuidanceFrequencyView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    private let options = [
        "Daily",
        "Every morning",
        "Every evening",
        "A few times a week",
        "Weekly"
    ]
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                EmptyView()
            },
            title: "How often do you want guidance?",
            subtitle: "Frequency influences notifications and your experience.",
            content: {
                VStack(spacing: DesignSpacing.sm) {
                    ForEach(options, id: \.self) { option in
                        SelectionOptionButton(
                            title: option,
                            isSelected: coordinator.guidanceFrequency == option,
                            action: {
                                coordinator.guidanceFrequency = option
                            }
                        )
                    }
                }
            },
            canContinue: coordinator.guidanceFrequency != nil,
            onContinue: {
                coordinator.nextPage()
            },
            showHero: false
        )
    }
}
