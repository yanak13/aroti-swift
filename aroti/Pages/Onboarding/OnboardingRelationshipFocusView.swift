//
//  OnboardingRelationshipFocusView.swift
//
//  Page 9 - Relationship Focus
//

import SwiftUI

struct OnboardingRelationshipFocusView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    
    private let options = [
        "Single",
        "In a relationship",
        "It’s complicated",
        "Prefer not to say"
    ]
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                RelationshipFocusHero()
            },
            title: "Are you currently in a relationship?",
            content: {
                VStack(spacing: DesignSpacing.sm) {
                    ForEach(options, id: \.self) { option in
                        SelectionOptionButton(
                            title: option,
                            isSelected: coordinator.relationshipFocus == option,
                            action: {
                                coordinator.relationshipFocus = option
                            }
                        )
                    }
                }
            },
            canContinue: coordinator.relationshipFocus != nil,
            onContinue: {
                coordinator.nextPage()
            }
        )
    }
}
