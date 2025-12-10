//
//  ValueCarouselView.swift
//  Aroti
//
//  Screen 2: What You'll Get carousel
//

import SwiftUI

struct ValueCarouselView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var currentIndex = 0
    
    let slides = [
        ValueSlide(
            title: "Your Cosmic Profile",
            subtitle: "Astrology, Numerology, and Chinese Zodiac combined.",
            icon: "star.fill"
        ),
        ValueSlide(
            title: "Daily Guidance",
            subtitle: "Messages tailored to your energy and events.",
            icon: "sunrise.fill"
        ),
        ValueSlide(
            title: "Tarot Readings",
            subtitle: "Real spreads with meaningful interpretation.",
            icon: "rectangle.stack.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 0) {
                HStack {
                    OnboardingBackButton()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                TabView(selection: $currentIndex) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        ValueSlideView(slide: slides[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 400)
                
                // Pagination Dots
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? ArotiColor.accent : ArotiColor.textSecondary.opacity(0.3))
                            .frame(width: index == currentIndex ? 32 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    }
                }
                .padding(.top, 32)
                
                Spacer()
                
                ArotiButton(
                    kind: .primary,
                    title: "Continue",
                    isDisabled: currentIndex != slides.count - 1,
                    action: {
                        onboardingManager.currentScreen = .createAccount
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct ValueSlide {
    let title: String
    let subtitle: String
    let icon: String
}

struct ValueSlideView: View {
    let slide: ValueSlide
    
    var body: some View {
        VStack(spacing: 24) {
            BaseCard {
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        ArotiColor.accent.opacity(0.2),
                                        ArotiColor.accent.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: slide.icon)
                            .font(.system(size: 40))
                            .foregroundColor(ArotiColor.accent)
                    }
                    
                    Text(slide.title)
                        .font(ArotiTextStyle.title2)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(slide.subtitle)
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(48)
            }
            .padding(.horizontal, 24)
        }
    }
}
