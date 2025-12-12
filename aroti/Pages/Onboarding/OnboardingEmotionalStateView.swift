//
//  OnboardingEmotionalStateView.swift
//
//  Page 6 - Emotional State Question
//

import SwiftUI

struct OnboardingEmotionalStateView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    private let options = [
        ("Calm", "leaf.fill"),
        ("Anxious", "cloud.fill"),
        ("Motivated", "flame.fill"),
        ("Lost", "moon.fill"),
        ("Curious", "sparkles")
    ]
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                EmptyView()
            },
            title: "How have you been feeling lately?",
            subtitle: "Choose the option that fits you best.",
            content: {
                VStack(spacing: DesignSpacing.sm) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        SelectionOptionButton(
                            title: option.0,
                            icon: option.1,
                            isSelected: coordinator.emotionalState.contains(option.0),
                            isMultiSelect: true,
                            action: {
                                if coordinator.emotionalState.contains(option.0) {
                                    coordinator.emotionalState.removeAll { $0 == option.0 }
                                } else {
                                    coordinator.emotionalState.append(option.0)
                                }
                            }
                        )
                    }
                }
            },
            canContinue: !coordinator.emotionalState.isEmpty,
            onContinue: {
                coordinator.nextPage()
            },
            showHero: false
        )
    }
}
