//
//  BirthTimeView.swift
//  Aroti
//
//  Screen 4B: Time of Birth (Optional)
//

import SwiftUI

struct BirthTimeView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selectedTime = Date()
    @State private var hasTime = false
    
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
                
                // Step Label
                Text("Step 2 of 3")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                
                VStack(spacing: 8) {
                    Text("Do you know your birth time?")
                        .font(ArotiTextStyle.title1)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Exact time helps calculate precise charts.")
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                if hasTime {
                    BaseCard {
                        DatePicker(
                            "Time of Birth",
                            selection: $selectedTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding(24)
                    }
                    .padding(.horizontal, 24)
                }
                
                Text("If you're not sure, skip this step.")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                VStack(spacing: 12) {
                    ArotiButton(
                        kind: .primary,
                        title: "Continue",
                        isDisabled: !hasTime,
                        action: {
                            onboardingManager.updateData { data in
                                data.birthTime = selectedTime
                            }
                            onboardingManager.currentScreen = .birthPlace
                        }
                    )
                    
                    ArotiButton(
                        kind: .secondary,
                        title: "Skip, I'm not sure",
                        action: {
                            onboardingManager.updateData { data in
                                data.birthTime = nil
                            }
                            onboardingManager.currentScreen = .birthPlace
                        }
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Show time picker by default, user can toggle
            hasTime = true
            if let existingTime = onboardingManager.data.birthTime {
                selectedTime = existingTime
                hasTime = true
            }
        }
    }
}
