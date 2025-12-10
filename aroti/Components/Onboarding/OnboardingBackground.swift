//
//  OnboardingBackground.swift
//  Aroti
//
//  Unified atmospheric background for premium onboarding
//

import SwiftUI

struct OnboardingBackground: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base dark indigo gradient - continuous from top to bottom
                LinearGradient(
                    colors: [
                        // Dark, nearly-black indigo at top
                        Color(red: 5/255, green: 3/255, blue: 11/255),
                        // Slightly lighter deep purple around hero area
                        Color(red: 12/255, green: 8/255, blue: 20/255),
                        Color(red: 15/255, green: 10/255, blue: 25/255),
                        // Rich dark tone near bottom
                        Color(red: 8/255, green: 6/255, blue: 15/255),
                        Color(red: 5/255, green: 3/255, blue: 11/255)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Soft radial glow under hero area - desaturated warm orange
                RadialGradient(
                    colors: [
                        ArotiColor.accent.opacity(0.08),
                        ArotiColor.accent.opacity(0.04),
                        ArotiColor.accent.opacity(0.02),
                        Color.clear
                    ],
                    center: UnitPoint(x: 0.5, y: 0.35),
                    startRadius: geometry.size.width * 0.3,
                    endRadius: geometry.size.width * 1.2
                )
                .blendMode(.plusLighter)
            }
        }
        .ignoresSafeArea(.all)
    }
}
