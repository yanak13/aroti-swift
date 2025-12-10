//
//  CareerFocusView.swift
//  Aroti
//
//  Screen 13: Career focus (conditional)
//

import SwiftUI

struct CareerFocusView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selected: String? = nil
    
    let options = [
        "Growing my career",
        "Changing direction",
        "Starting something new",
        "Feeling stuck",
        "Finding purpose"
    ]
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 24) {
                HStack {
                    OnboardingBackButton()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("Where do you feel you are in your career journey?")
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
                            data.careerFocus = selected
                        }
                        onboardingManager.currentScreen = .building
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selected = onboardingManager.data.careerFocus
        }
    }
}
