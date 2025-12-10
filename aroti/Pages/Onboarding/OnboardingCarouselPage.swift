//
//  OnboardingCarouselPage.swift
//  Aroti
//
//  Individual carousel page component
//

import SwiftUI

struct OnboardingCarouselPage: View {
    let title: String
    let subtitle: String
    let heroView: AnyView
    let isLastPage: Bool
    let bottomControlsHeight: CGFloat
    
    init(title: String, subtitle: String, heroView: AnyView, isLastPage: Bool = false, bottomControlsHeight: CGFloat = 0) {
        self.title = title
        self.subtitle = subtitle
        self.heroView = heroView
        self.isLastPage = isLastPage
        self.bottomControlsHeight = bottomControlsHeight
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Floating particles - very subtle
                FloatingParticles()
                    .opacity(0.2)
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geometry.size.height * 0.12)
                    
                    // Hero area - visual center slightly above midline
                    ZStack {
                        heroView
                            .frame(height: geometry.size.height * 0.42)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, DesignSpacing.lg)
                    }
                    .frame(height: geometry.size.height * 0.45)
                    
                    // Consistent spacing from hero to content
                    Spacer()
                        .frame(height: geometry.size.height * 0.06)
                    
                    // Content area - title, body
                    VStack(spacing: DesignSpacing.lg) {
                        // Title
                        Text(title)
                            .font(ArotiTextStyle.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(ArotiColor.textPrimary)
                            .multilineTextAlignment(.center)
                            .lineLimit(isLastPage ? 2 : nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, DesignSpacing.xl)
                        
                        // Subtitle - allow multiple lines
                        Text(subtitle)
                            .font(ArotiTextStyle.body)
                            .foregroundColor(ArotiColor.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, DesignSpacing.xl)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Bottom spacing - account for controls
                    if bottomControlsHeight > 0 {
                        Spacer()
                            .frame(height: bottomControlsHeight)
                    } else {
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingCarouselPage(
        title: "See Your Path More Clearly",
        subtitle: "Track your emotional cycles, understand your challenges, and move forward with clarity and purpose — guided every step of the way.",
        heroView: AnyView(LifeRoadmapHero()),
        isLastPage: true
    )
}
