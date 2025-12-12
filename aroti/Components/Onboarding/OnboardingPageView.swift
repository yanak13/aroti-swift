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
    let keyboardHeight: CGFloat
    let titleTopPadding: CGFloat
    let heroHeightFactor: CGFloat
    let heroContainerHeightFactor: CGFloat
    let useNavigationSpacing: Bool
    
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
        showHero: Bool = true,
        keyboardHeight: CGFloat = 0,
        titleTopPadding: CGFloat = 0,
        heroHeightFactor: CGFloat = 0.20,
        heroContainerHeightFactor: CGFloat = 0.22,
        useNavigationSpacing: Bool = true
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
        self.keyboardHeight = keyboardHeight
        self.titleTopPadding = titleTopPadding
        self.heroHeightFactor = heroHeightFactor
        self.heroContainerHeightFactor = heroContainerHeightFactor
        self.useNavigationSpacing = useNavigationSpacing
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
                    // Top navigation - back button + progress bar (position-locked, never moves)
                    if useNavigationSpacing {
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
                                .padding(.top, geometry.safeAreaInsets.top + DesignSpacing.xxl + DesignSpacing.md)
                            } else {
                                // Spacer to maintain consistent positioning
                                Spacer()
                                    .frame(height: geometry.safeAreaInsets.top + DesignSpacing.xxl + DesignSpacing.md)
                            }
                            
                            // Progress bar
                            if showProgressBar {
                                OnboardingProgressBar(progress: coordinator.getProgress())
                                    .padding(.horizontal, DesignSpacing.lg)
                                    .padding(.bottom, DesignSpacing.sm)
                            }
                        }
                    } else {
                        // Minimal safe-area spacer when top navigation is hidden
                        Spacer()
                            .frame(height: geometry.safeAreaInsets.top + DesignSpacing.lg)
                    }
                    
                    // Main content area - scrollable when keyboard is active
                    ScrollView {
                        VStack(spacing: 0) {
                            // Fixed top spacing after progress bar - consistent across all pages
                            Spacer()
                                .frame(height: DesignSpacing.lg)
                            
                            // Content area - Tier A/B positioning system
                            VStack(spacing: 0) {
                                // Tier A: Hero icon starts at position X, then title below
                                // Tier B: Title starts at position X (where hero would start)
                                
                                if showHero {
                                    // TIER A: Hero icon centered, starts at fixed position
                                    ZStack {
                                        hero
                                            .frame(height: geometry.size.height * heroHeightFactor)
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal, DesignSpacing.lg)
                                    }
                                    .frame(height: geometry.size.height * heroContainerHeightFactor)
                                    
                                    // Fixed spacing from hero to title (Tier A)
                                    Spacer()
                                        .frame(height: DesignSpacing.md)
                                } else {
                                    // TIER B: No hero, title starts at same position where hero would start
                                    // This ensures all content starts from the same vertical point
                                }
                                
                                // Title + subtitle + content
                                VStack(spacing: DesignSpacing.md) {
                                    Spacer()
                                        .frame(height: titleTopPadding)
                                    
                                    // Title - positioned consistently
                                    Text(title)
                                        .font(ArotiTextStyle.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(ArotiColor.textPrimary)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(nil)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.horizontal, DesignSpacing.xl)
                                    
                                    // Subtitle - directly under title, same spacing
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
                                    
                                    // Custom content - cards, inputs, etc.
                                    content
                                        .padding(.horizontal, DesignSpacing.lg)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .offset(y: calculateContentOffset(geometry: geometry))
                            
                            // Bottom padding for scroll view - minimal when keyboard visible
                            Spacer()
                                .frame(height: keyboardHeight > 0 ? calculateScrollBottomPadding(keyboardHeight: keyboardHeight, safeAreaBottom: geometry.safeAreaInsets.bottom) : DesignSpacing.xl)
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    
                    // Bottom controls - Continue button (moves with keyboard)
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
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, calculateButtonBottom(safeAreaBottom: geometry.safeAreaInsets.bottom))
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
    
    // Calculate button bottom position based on keyboard state
    private func calculateButtonBottom(safeAreaBottom: CGFloat) -> CGFloat {
        if keyboardHeight > 0 {
            // Keyboard shown: buttonBottom = keyboardHeight + safeAreaBottom + 12-16
            return keyboardHeight + safeAreaBottom + 14 // Using 14pt (midpoint of 12-16 range)
        } else {
            // Keyboard hidden: buttonBottom = safeAreaBottom + 16 (moved higher/closer to content)
            return safeAreaBottom + 16
        }
    }
    
    // Calculate scroll view bottom padding to create space between input and button
    private func calculateScrollBottomPadding(keyboardHeight: CGFloat, safeAreaBottom: CGFloat) -> CGFloat {
        // Add minimal padding when keyboard is visible to create tight gap between input and button
        // Button is positioned separately below ScrollView, so we only need minimal spacing
        // Using very tight spacing: 4pt for mindful, minimal gap (just enough to prevent visual merging)
        let minimalSpacing: CGFloat = 4
        return minimalSpacing
    }
    
    // Calculate content offset to move content up when keyboard is visible
    private func calculateContentOffset(geometry: GeometryProxy) -> CGFloat {
        guard keyboardHeight > 0 else { return 0 }
        
        // Move content up minimally to position input close to button/keyboard
        // Avoid excessive upward movement - only shift enough to keep input visible
        // Hero icon and title should stay relatively still
        let buttonHeight: CGFloat = 48
        let inputHeight: CGFloat = 68
        let minimalSpacing: CGFloat = 4 // Minimal spacing between input and button
        
        // Calculate minimal offset - just enough to position input above button
        // Negative value moves content up
        let offset = -(buttonHeight + minimalSpacing + inputHeight / 2)
        
        // Clamp to reasonable range to prevent content from going too high
        // Keep hero and title visible - avoid moving them too far up
        let maxOffset: CGFloat = -120 // Limit upward movement
        return max(offset, maxOffset)
    }
}
