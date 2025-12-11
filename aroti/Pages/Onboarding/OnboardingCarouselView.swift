//
//  OnboardingCarouselView.swift
//  Aroti
//
//  Carousel container for 3 onboarding screens
//

import SwiftUI

struct OnboardingCarouselView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var carouselPage: Int = 0
    
    private let carouselPages: [(title: String, subtitle: String, hero: AnyView)] = [
        (
            title: "Clarity for Every Day",
            subtitle: "Receive daily guidance uniquely shaped by your energy, emotions, and personal rhythm.",
            hero: AnyView(GuidancePathHero())
        ),
        (
            title: "Insights Created Just for You",
            subtitle: "Aroti blends astrology, numerology, and intuitive intelligence to reveal patterns, strengths, and deeper meaning in your life.",
            hero: AnyView(BirthChartHero())
        ),
        (
            title: "See Your Path More Clearly",
            subtitle: "Track your emotional cycles, understand your challenges, and move forward with clarity and purpose — guided every step of the way.",
            hero: AnyView(LifeRoadmapHero())
        )
    ]
    
    // Calculate overall progress (page 1-3 of 4 total pages, where 0 is welcome)
    private var overallProgress: Double {
        // Coordinator page 1 = first carousel (33%), page 2 = second (66%), page 3 = third (100%)
        return Double(coordinator.currentPage) / 3.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Single background for entire carousel - extends fully
                OnboardingBackground()
                
                VStack(spacing: 0) {
                    // Unified navigation system - back button + progress bar
                    VStack(spacing: DesignSpacing.xs) {
                        // Back button - top left (with safe area padding)
                        HStack {
                            Button(action: {
                                HapticFeedback.impactOccurred(.light)
                                if carouselPage == 0 {
                                    // Go back to welcome screen
                                    coordinator.currentPage = 0
                                } else {
                                    // Go to previous carousel page
                                    withAnimation {
                                        carouselPage -= 1
                                    }
                                }
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 14, weight: .medium))
                                    Text("Back")
                                        .font(ArotiTextStyle.subhead)
                                }
                                .foregroundColor(ArotiColor.textSecondary)
                            }
                            .padding(.leading, DesignSpacing.lg)
                            
                            Spacer()
                        }
                        .padding(.top, geometry.safeAreaInsets.top + DesignSpacing.xxl)
                        
                        // Progress bar - premium design
                        OnboardingProgressBar(progress: overallProgress)
                            .padding(.horizontal, DesignSpacing.lg)
                            .padding(.bottom, DesignSpacing.sm)
                    }
                    
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
                    .onChange(of: carouselPage) { newValue in
                        // Update coordinator: page 1, 2, or 3 (welcome is 0)
                        coordinator.currentPage = newValue + 1
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
                        
                        // Continue button - same position as Welcome screen
                        ArotiButton(
                            kind: .primary,
                            title: "Continue",
                            isDisabled: carouselPage < carouselPages.count - 1,
                            action: {
                                if carouselPage == carouselPages.count - 1 {
                                    HapticFeedback.impactOccurred(.medium)
                                    coordinator.completeOnboarding()
                                } else {
                                    withAnimation {
                                        carouselPage += 1
                                    }
                                }
                            }
                        )
                        .padding(.horizontal, DesignSpacing.lg)
                    }
                    .padding(.bottom, geometry.size.height * 0.11) // Match Welcome screen button position
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
            // Initialize carousel to first page (coordinator page 1)
            carouselPage = 0
            coordinator.currentPage = 1
        }
    }
}

#Preview {
    OnboardingCarouselView(coordinator: OnboardingCoordinator())
}
