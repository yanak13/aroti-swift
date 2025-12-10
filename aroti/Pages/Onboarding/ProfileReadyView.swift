//
//  ProfileReadyView.swift
//  Aroti
//
//  Screen 15: Profile ready
//

import SwiftUI

struct ProfileReadyView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @Binding var showHomePage: Bool
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        ArotiColor.accent.opacity(0.3),
                                        ArotiColor.accent.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 128, height: 128)
                            .blur(radius: 20)
                        
                        Image(systemName: "sparkles")
                            .font(.system(size: 64))
                            .foregroundColor(ArotiColor.accent)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Your personal cosmic profile is ready")
                            .font(ArotiTextStyle.title1)
                            .foregroundColor(ArotiColor.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("Explore your traits, strengths, challenges, and guidance designed uniquely for you.")
                            .font(ArotiTextStyle.body)
                            .foregroundColor(ArotiColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
                
                ArotiButton(
                    kind: .primary,
                    title: "Begin your journey",
                    icon: Image(systemName: "sparkles"),
                    action: {
                        // Save to user profile/service
                        let profile = onboardingManager.getCompiledProfile()
                        // TODO: Save to backend/user service
                        
                        showHomePage = true
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
