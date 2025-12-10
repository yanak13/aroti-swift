//
//  BirthPlaceView.swift
//  Aroti
//
//  Screen 4C: Place of Birth
//

import SwiftUI

struct BirthPlaceView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var showLocationPicker = false
    @State private var selectedLocation = ""
    
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
                Text("Step 3 of 3")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                
                VStack(spacing: 8) {
                    Text("Where were you born?")
                        .font(ArotiTextStyle.title1)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("This helps us generate accurate astrological positions.")
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                BaseCard {
                    VStack(spacing: 16) {
                        Button(action: {
                            showLocationPicker = true
                        }) {
                            HStack {
                                if selectedLocation.isEmpty {
                                    Text("Search for city, country…")
                                        .foregroundColor(ArotiColor.textSecondary)
                                } else {
                                    Text(selectedLocation)
                                        .foregroundColor(ArotiColor.textPrimary)
                                }
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(ArotiColor.textSecondary)
                            }
                            .padding(12)
                            .background(ArotiColor.inputBackground)
                            .cornerRadius(ArotiRadius.sm)
                            .overlay(
                                RoundedRectangle(cornerRadius: ArotiRadius.sm)
                                    .stroke(ArotiColor.inputBorder, lineWidth: 1)
                            )
                        }
                    }
                    .padding(24)
                }
                .padding(.horizontal, 24)
                
                Text("Your data is private and used only for chart calculation.")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Spacer()
                
                ArotiButton(
                    kind: .primary,
                    title: "Continue",
                    isDisabled: selectedLocation.isEmpty,
                    action: {
                        onboardingManager.updateData { data in
                            data.birthPlace = selectedLocation
                        }
                        onboardingManager.currentScreen = .gender
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showLocationPicker) {
            LocationPickerSheet(selectedLocation: $selectedLocation)
        }
        .onAppear {
            selectedLocation = onboardingManager.data.birthPlace ?? ""
        }
    }
}
