//
//  CurrentFocusView.swift
//  Aroti
//
//  Screen 9: Current focus
//

import SwiftUI

struct CurrentFocusView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selected: String? = nil
    
    let options = [
        "Love",
        "Career",
        "Inner healing",
        "Self-discovery",
        "Health",
        "Spirituality",
        "Multiple areas"
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
                    Text("What area of life feels most important right now?")
                        .font(ArotiTextStyle.title1)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        OptionCard(
                            title: option,
                            isSelected: selected == option,
                            action: {
                                selected = option
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                ArotiButton(
                    kind: .primary,
                    title: "Continue",
                    isDisabled: selected == nil,
                    action: {
                        onboardingManager.updateData { data in
                            data.currentFocus = selected
                        }
                        onboardingManager.currentScreen = .challenges
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selected = onboardingManager.data.currentFocus
        }
    }
}
