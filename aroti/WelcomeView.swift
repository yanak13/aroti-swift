//
//  WelcomeView.swift
//  Aroti
//
//  Welcome page matching React Native design
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showHomePage: Bool
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 16) {
                    // Logo/Icon with glow effect
                    ZStack {
                        Image(systemName: "sparkles")
                            .font(.system(size: 112))
                            .foregroundColor(DesignColors.accent)
                            .shadow(color: DesignColors.accent.opacity(0.5), radius: 24, x: 0, y: 0)
                        
                        // Glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        DesignColors.accent.opacity(0.4),
                                        DesignColors.accent.opacity(0.25),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 120, height: 120)
                            .blur(radius: 20)
                    }
                    .padding(.bottom, 8)
                    
                    Text("Welcome to Aroti")
                        .font(DesignTypography.largeTitleFont())
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Your path to balance begins within")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignSpacing.lg)
                    
                    Text("Guidance through Tarot, Astrology & AI")
                        .font(DesignTypography.subheadFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignSpacing.lg)
                        .padding(.top, 8)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    ArotiButton(
                        kind: .primary,
                        title: "Go to Home Page",
                        icon: Image(systemName: "house.fill"),
                        action: {
                            showHomePage = true
                        }
                    )
                    .padding(.horizontal, DesignSpacing.lg)
                }
                .padding(.bottom, DesignSpacing.xl)
            }
        }
    }
}

#Preview {
    @Previewable @State var showHome = false
    NavigationStack {
        WelcomeView(showHomePage: $showHome)
    }
}

