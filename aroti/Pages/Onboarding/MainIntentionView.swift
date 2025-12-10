//
//  MainIntentionView.swift
//  Aroti
//
//  Screen 7: Main intention
//

import SwiftUI

struct MainIntentionView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selected: String? = nil
    
    let options = [
        "Love & connection",
        "Career & purpose",
        "Self-discovery",
        "Emotional clarity",
        "Spiritual growth",
        "Daily guidance",
        "A mix of everything"
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
                    Text("What is your main intention with Aroti?")
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
                            data.mainIntention = selected
                        }
                        onboardingManager.currentScreen = .emotionalNature
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selected = onboardingManager.data.mainIntention
        }
    }
}
