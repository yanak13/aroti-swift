//
//  BuildingProfileView.swift
//  Aroti
//
//  Screen 14: Building profile loading
//

import SwiftUI

struct BuildingProfileView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 32) {
                Spacer()
                
                BuildingAnimationView()
                    .frame(height: 256)
                
                VStack(spacing: 12) {
                    Text("Creating your personalized cosmic profile…")
                        .font(ArotiTextStyle.title2)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("This may take a moment.")
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Compile user profile
            let profile = onboardingManager.getCompiledProfile()
            print("Compiled profile: \(profile)")
            
            // Auto-navigate after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onboardingManager.currentScreen = .ready
            }
        }
    }
}
