//
//  OnboardingBirthLocationView.swift
//
//  Page 12 - Birth Location
//

import SwiftUI

struct OnboardingBirthLocationView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var locationText: String = ""
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                BirthLocationHero()
            },
            title: "Where were you born?",
            content: {
                OnboardingLocationSearch(
                    location: Binding(
                        get: { coordinator.birthLocation ?? locationText },
                        set: { newValue in
                            coordinator.birthLocation = newValue.isEmpty ? nil : newValue
                            locationText = newValue
                        }
                    )
                )
            },
            canContinue: !(coordinator.birthLocation?.isEmpty ?? true),
            onContinue: {
                coordinator.nextPage()
            }
        )
        .onAppear {
            locationText = coordinator.birthLocation ?? ""
        }
    }
}
