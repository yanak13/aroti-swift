//
//  OnboardingCarouselView.swift
//
//  Welcome carousel - 4 pages including Welcome screen
//

import SwiftUI

struct OnboardingCarouselView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var carouselPage: Int = 0
    @State private var isProgrammaticNavigation: Bool = false
    
    private let carouselPages: [(title: String, subtitle: String, hero: AnyView)] = [
        // Page 0: Welcome
        (
            title: "Welcome to Aroti",
            subtitle: "Your personal space for clarity, growth, and daily guidance.",
            hero: AnyView(ConstellationHero())
        ),
        // Page 1: Clarity
        (
            title: "Clarity for Every Day",
            subtitle: "Receive daily guidance uniquely shaped by your energy, emotions, and personal rhythm.",
            hero: AnyView(GuidancePathHero())
        ),
        // Page 2: Insights
        (
            title: "Insights Created Just for You",
            subtitle: "Aroti blends astrology, numerology, and intuitive intelligence to reveal patterns, strengths, and deeper meaning in your life.",
            hero: AnyView(BirthChartHero())
        ),
        // Page 3: Path
        (
            title: "See Your Path More Clearly",
            subtitle: "Track your emotional cycles, understand your challenges, and move forward with clarity and purpose — guided every step of the way.",
            hero: AnyView(LifeRoadmapHero())
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Single background for entire carousel - extends fully
                OnboardingBackground()
                
                // Floating particles
                FloatingParticles()
                    .opacity(0.2)
                
                VStack(spacing: 0) {
                    // Carousel - fills remaining space, no clipping
                    TabView(selection: $carouselPage) {
                        ForEach(0..<carouselPages.count, id: \.self) { index in
                            OnboardingCarouselPage(
                                title: carouselPages[index].title,
                                subtitle: carouselPages[index].subtitle,
                                heroView: carouselPages[index].hero,
                                isLastPage: index == carouselPages.count - 1,
                                bottomControlsHeight: 140
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: carouselPage) { oldValue, newValue in
                        // Only update coordinator when user swipes (not programmatic navigation)
                        // Also ensure we're still in carousel range (0-3)
                        if !isProgrammaticNavigation && newValue >= 0 && newValue < carouselPages.count {
                            coordinator.currentPage = newValue
                        }
                        // Reset flag after change
                        isProgrammaticNavigation = false
                    }
                    
                    // Bottom controls - pinned at same position as Welcome screen button
                    VStack(spacing: DesignSpacing.md) {
                        // Pagination dots with animation
                        HStack(spacing: 8) {
                            ForEach(0..<carouselPages.count, id: \.self) { index in
                                Circle()
                                    .fill(index == carouselPage ? ArotiColor.accent : ArotiColor.textMuted.opacity(0.3))
                                    .frame(width: index == carouselPage ? 8 : 6, height: index == carouselPage ? 8 : 6)
                                    .scaleEffect(index == carouselPage ? 1.1 : 1.0)
                                    .shadow(color: index == carouselPage ? ArotiColor.accent.opacity(0.4) : .clear, radius: 4, x: 0, y: 0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: carouselPage)
                            }
                        }
                        .padding(.vertical, DesignSpacing.sm)
                        
                        // Continue button - always enabled, advances pages or proceeds to onboarding
                        ArotiButton(
                            kind: .primary,
                            title: "Continue",
                            isDisabled: false,
                            action: {
                                HapticFeedback.impactOccurred(.medium)
                                if carouselPage < 3 {
                                    // Advance to next page programmatically
                                    isProgrammaticNavigation = true
                                    carouselPage += 1
                                } else {
                                    // Proceed to onboarding - ensure we're on the last page
                                    guard carouselPage == 3 else { return }
                                    // Prevent multiple rapid clicks
                                    guard coordinator.currentPage < 4 else { return }
                                    // Set flag to prevent onChange interference
                                    isProgrammaticNavigation = true
                                    // Navigate to next onboarding step (page 4) with animation
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        coordinator.currentPage = 4
                                    }
                                }
                            }
                        )
                        .padding(.horizontal, DesignSpacing.lg)
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 16) // Consistent with other onboarding pages
                    .frame(maxWidth: .infinity)
                    .background(
                        // Subtle fade to blend with background
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.black.opacity(0.08)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            // Initialize carousel to match coordinator page (only if still in carousel range)
            if coordinator.currentPage >= 0 && coordinator.currentPage < carouselPages.count {
                carouselPage = coordinator.currentPage
            }
        }
    }
}

#Preview {
    OnboardingCarouselView(coordinator: OnboardingCoordinator())
}
