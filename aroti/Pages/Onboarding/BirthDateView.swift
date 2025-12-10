//
//  BirthDateView.swift
//  Aroti
//
//  Screen 4A: Date of Birth
//

import SwiftUI

struct BirthDateView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selectedDate = Date()
    
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
                
                // Step Label
                Text("Step 1 of 3")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                
                VStack(spacing: 8) {
                    Text("When were you born?")
                        .font(ArotiTextStyle.title1)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Your birthday shapes your core cosmic blueprint.")
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                BaseCard {
                    VStack(spacing: 16) {
                        DatePicker(
                            "Date of Birth",
                            selection: $selectedDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)
                    }
                    .padding(24)
                }
                .padding(.horizontal, 24)
                
                Text("You can edit this later in your profile.")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                ArotiButton(
                    kind: .primary,
                    title: "Continue",
                    action: {
                        onboardingManager.updateData { data in
                            data.birthDate = selectedDate
                        }
                        onboardingManager.currentScreen = .birthTime
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let existingDate = onboardingManager.data.birthDate {
                selectedDate = existingDate
            }
        }
    }
}
