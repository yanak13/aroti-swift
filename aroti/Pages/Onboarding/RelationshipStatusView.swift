//
//  RelationshipStatusView.swift
//  Aroti
//
//  Screen 6: Relationship status
//

import SwiftUI

struct RelationshipStatusView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selected: String? = nil
    
    let options = ["Single", "In a relationship", "Married", "It's complicated", "Prefer not to say"]
    
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
                    Text("What best describes your current situation?")
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
                            data.relationshipStatus = selected
                        }
                        onboardingManager.currentScreen = .intention
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selected = onboardingManager.data.relationshipStatus
        }
    }
}
