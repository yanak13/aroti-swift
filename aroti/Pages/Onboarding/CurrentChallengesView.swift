//
//  CurrentChallengesView.swift
//  Aroti
//
//  Screen 10: Current challenges (multi-select)
//

import SwiftUI

struct CurrentChallengesView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selected: Set<String> = []
    
    let options = [
        "Making decisions",
        "Emotional imbalance",
        "Feeling lost",
        "Relationship confusion",
        "Stress or anxiety",
        "Lack of motivation",
        "Difficulty understanding people"
    ]
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 24) {
                HStack {
                    OnboardingBackButton()
                    Spacer()
                    OnboardingSkipButton()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("What challenges do you face most often?")
                        .font(ArotiTextStyle.title1)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        MultiSelectOptionCard(
                            title: option,
                            isSelected: selected.contains(option),
                            action: {
                                if selected.contains(option) {
                                    selected.remove(option)
                                } else {
                                    selected.insert(option)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                ArotiButton(
                    kind: .primary,
                    title: "Continue",
                    isDisabled: selected.isEmpty,
                    action: {
                        onboardingManager.updateData { data in
                            data.challenges = Array(selected)
                        }
                        onboardingManager.currentScreen = .archetype
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selected = Set(onboardingManager.data.challenges)
        }
    }
}
