//
//  PaywallCarouselView.swift
//  Aroti
//
//  Hero carousel for paywall with 4 feature slides
//

import SwiftUI

struct PaywallCarouselView: View {
    @Binding var selectedSlideIndex: Int
    @State private var parallaxOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Carousel with TabView
            TabView(selection: $selectedSlideIndex) {
                ForEach(0..<PaywallSlide.allCases.count, id: \.self) { index in
                    PaywallSlideView(slide: PaywallSlide.allCases[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selectedSlideIndex) { oldValue, newValue in
                // Trigger haptic on slide change
                HapticFeedback.impactOccurred(.light)
            }
            
            // Page dots indicator
            HStack(spacing: 8) {
                ForEach(0..<PaywallSlide.allCases.count, id: \.self) { index in
                    Circle()
                        .fill(index == selectedSlideIndex ? ArotiColor.accent : ArotiColor.textMuted.opacity(0.3))
                        .frame(width: index == selectedSlideIndex ? 8 : 6, height: index == selectedSlideIndex ? 8 : 6)
                        .scaleEffect(index == selectedSlideIndex ? 1.1 : 1.0)
                        .shadow(
                            color: index == selectedSlideIndex ? ArotiColor.accent.opacity(0.4) : .clear,
                            radius: 4,
                            x: 0,
                            y: 0
                        )
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedSlideIndex)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedSlideIndex = index
                            }
                            HapticFeedback.impactOccurred(.light)
                        }
                }
            }
            .padding(.top, DesignSpacing.sm)
            .padding(.bottom, DesignSpacing.xs)
        }
    }
}

// MARK: - Paywall Slide View

private struct PaywallSlideView: View {
    let slide: PaywallSlide
    @State private var parallaxOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: DesignSpacing.md) {
            // Fixed top spacing instead of flexible Spacer()
            Spacer()
                .frame(height: 16)
            
            // Hero illustration - reduced height to save space
            PaywallHeroIllustration(
                slide: slide,
                parallaxOffset: parallaxOffset
            )
            .frame(height: 100)
            .onAppear {
                // Subtle parallax drift animation
                withAnimation(
                    Animation.easeInOut(duration: 4.0)
                        .repeatForever(autoreverses: true)
                ) {
                    parallaxOffset = 3.0
                }
            }
            
            // Title
            Text(slide.title)
                .font(ArotiTextStyle.title1)
                .fontWeight(.bold)
                .foregroundColor(ArotiColor.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.xs)
            
            // Subline - allow full text wrapping
            Text(slide.subline)
                .font(ArotiTextStyle.body)
                .foregroundColor(ArotiColor.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.xs)
            
            // Minimal bottom spacing
            Spacer()
                .frame(height: 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, DesignSpacing.sm)
    }
}

// MARK: - Paywall Slide Model

enum PaywallSlide: CaseIterable {
    case personalProfile
    case compatibility
    case tarot
    case aiGuidance
    
    var title: String {
        switch self {
        case .personalProfile:
            return "Your Complete Personal Profile"
        case .compatibility:
            return "Compatibility Reports"
        case .tarot:
            return "Unlimited Tarot Readings"
        case .aiGuidance:
            return "Personal AI Guidance"
        }
    }
    
    var subline: String {
        switch self {
        case .personalProfile:
            return "Astrology, Numerology, Matrix of Fate, and Elemental profiles — fully explained using your birth data."
        case .compatibility:
            return "Check detailed compatibility with your partner or anyone important to you."
        case .tarot:
            return "Access all tarot spreads and readings without limits."
        case .aiGuidance:
            return "Ask unlimited questions and get personalized answers based on your profile and history."
        }
    }
    
}
