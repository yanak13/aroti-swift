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
        "A few times a week",
        "Weekly",
        "Only when I need it"
    ]
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                EmptyView()
            },
            title: "How often do you want guidance?",
            subtitle: "We'll tune Aroti to support your daily rhythm.",
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
