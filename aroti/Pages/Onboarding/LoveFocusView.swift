//
//  LoveFocusView.swift
//  Aroti
//
//  Screen 12: Love focus (conditional)
//

import SwiftUI

struct LoveFocusView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selected: String? = nil
    
    let options = [
        "Attracting someone new",
        "Improving current relationship",
        "Healing from past",
        "Understanding compatibility",
        "Not sure yet"
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
                    Text("What guidance around love are you seeking?")
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
                            data.loveFocus = selected
                        }
                        
                        // Check if we need to show career focus too
                        if onboardingManager.data.mainIntention == "A mix of everything" && onboardingManager.data.careerFocus == nil {
                            onboardingManager.currentScreen = .careerFocus
                        } else {
                            onboardingManager.currentScreen = .building
                        }
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selected = onboardingManager.data.loveFocus
        }
    }
}
