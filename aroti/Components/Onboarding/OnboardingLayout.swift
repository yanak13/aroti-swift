//
//  OnboardingLayout.swift
//  Aroti
//
//  Consistent layout system for onboarding screens
//

import SwiftUI

struct OnboardingLayout<Hero: View, Content: View>: View {
    let hero: Hero
    let content: Content
    
    init(@ViewBuilder hero: () -> Hero, @ViewBuilder content: () -> Content) {
        self.hero = hero()
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                OnboardingBackground()
                
                // Floating particles - very subtle
                FloatingParticles()
                    .opacity(0.2)
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.12)
                    
                    // Hero area - visual center slightly above midline
                    ZStack {
                        hero
                            .frame(height: geometry.size.height * 0.42)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, DesignSpacing.lg)
                    }
                    .frame(height: geometry.size.height * 0.45)
                    
                    // Consistent spacing from hero to content
                    Spacer()
                        .frame(height: geometry.size.height * 0.06)
                    
                    // Content area - title, body, pager, button
                    content
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
        }
    }
}
