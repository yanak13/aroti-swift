//
//  OnboardingPageView.swift
//
//  Unified page component with consistent back button, progress bar, and continue button positioning
//

import SwiftUI

struct OnboardingPageView<Hero: View, Content: View>: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    let hero: Hero
    let title: String
    let subtitle: String?
    let content: Content
    let canContinue: Bool
    let continueButtonTitle: String
    let onContinue: () -> Void
    let showBackButton: Bool
    let showProgressBar: Bool
    let showPaginationDots: Bool
    let paginationCurrentPage: Int?
    let paginationTotalPages: Int?
    let showHero: Bool
    
    init(
        coordinator: OnboardingCoordinator,
        @ViewBuilder hero: () -> Hero,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content,
        canContinue: Bool = true,
        continueButtonTitle: String = "Continue",
        onContinue: @escaping () -> Void,
        showBackButton: Bool = true,
        showProgressBar: Bool = true,
        showPaginationDots: Bool = false,
        paginationCurrentPage: Int? = nil,
        paginationTotalPages: Int? = nil,
        showHero: Bool = true
    ) {
        self.coordinator = coordinator
        self.hero = hero()
        self.title = title
        self.subtitle = subtitle
        self.content = content()
        self.canContinue = canContinue
        self.continueButtonTitle = continueButtonTitle
        self.onContinue = onContinue
        self.showBackButton = showBackButton
        self.showProgressBar = showProgressBar
        self.showPaginationDots = showPaginationDots
        self.paginationCurrentPage = paginationCurrentPage
        self.paginationTotalPages = paginationTotalPages
        self.showHero = showHero
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                OnboardingBackground()
                
                // Floating particles
                FloatingParticles()
                    .opacity(0.2)
                
                VStack(spacing: 0) {
                    // Top navigation - back button + progress bar (position-locked)
                    VStack(spacing: DesignSpacing.xs) {
                        // Back button
                        if showBackButton && coordinator.canGoBack() {
                            HStack {
                                Button(action: {
                                    HapticFeedback.impactOccurred(.light)
                                    coordinator.previousPage()
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
                        } else {
                            // Spacer to maintain consistent positioning
                            Spacer()
                                .frame(height: geometry.safeAreaInsets.top + DesignSpacing.xxl)
                        }
                        
                        // Progress bar
                        if showProgressBar {
                            OnboardingProgressBar(progress: coordinator.getProgress())
                                .padding(.horizontal, DesignSpacing.lg)
                                .padding(.bottom, DesignSpacing.sm)
                        }
                    }
                    
                    // Main content area - optimized spacing
                    VStack(spacing: 0) {
                        // Small top spacing after progress bar - mindful spacing
                        Spacer()
                            .frame(height: DesignSpacing.lg)
                        
                        // Hero area - only shown if showHero is true
                        if showHero {
                            ZStack {
                                hero
                                    .frame(height: geometry.size.height * 0.20)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, DesignSpacing.lg)
                            }
                            .frame(height: geometry.size.height * 0.22)
                            
                            // Spacing from hero to content - minimal
                            Spacer()
                                .frame(height: DesignSpacing.md)
                        }
                        
                        // Content area - starts right after progress bar/hero
                        VStack(spacing: DesignSpacing.md) {
                            // Title
                            Text(title)
                                .font(ArotiTextStyle.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(ArotiColor.textPrimary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, DesignSpacing.xl)
                            
                            // Subtitle
                            if let subtitle = subtitle {
                                Text(subtitle)
                                    .font(ArotiTextStyle.body)
                                    .foregroundColor(ArotiColor.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, DesignSpacing.xl)
                            }
                            
                            // Custom content
                            content
                                .padding(.horizontal, DesignSpacing.lg)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    
                    // Bottom controls - position-locked
                    VStack(spacing: DesignSpacing.md) {
                        // Pagination dots
                        if showPaginationDots, let current = paginationCurrentPage, let total = paginationTotalPages {
                            HStack(spacing: 8) {
                                ForEach(0..<total, id: \.self) { index in
                                    Circle()
                                        .fill(index == current ? ArotiColor.accent : ArotiColor.textMuted.opacity(0.3))
                                        .frame(width: index == current ? 8 : 6, height: index == current ? 8 : 6)
                                        .scaleEffect(index == current ? 1.1 : 1.0)
                                        .shadow(color: index == current ? ArotiColor.accent.opacity(0.4) : .clear, radius: 4, x: 0, y: 0)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: current)
                                }
                            }
                            .padding(.vertical, DesignSpacing.sm)
                        }
                        
                        // Continue button
                        ArotiButton(
                            kind: .primary,
                            title: continueButtonTitle,
                            isDisabled: !canContinue,
                            action: {
                                HapticFeedback.impactOccurred(.medium)
                                onContinue()
                            }
                        )
                        .padding(.horizontal, DesignSpacing.lg)
                    }
                    .padding(.bottom, geometry.size.height * 0.11) // Match carousel button position
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
    }
}
