//
//  PremiumToolkitCarousel.swift
//  Aroti
//
//  Premium card stack carousel with embossed icon previews
//

import SwiftUI
import Combine

struct PremiumToolkitCarousel: View {
    @State private var currentSlide: Int = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var autoRotateCancellable: AnyCancellable?
    @State private var hapticDebounceTimer: Timer?
    
    private let autoRotateInterval: TimeInterval = 3.5
    private let cardWidth: CGFloat = UIScreen.main.bounds.width - 32
    private let cardHeight: CGFloat = 240
    private let cardSpacing: CGFloat = 16
    
    var body: some View {
        let slides = PremiumToolkitSlide.allCases
        
        return VStack(spacing: DesignSpacing.md) {
            // Carousel
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: cardSpacing) {
                            ForEach(slides.indices, id: \.self) { index in
                                PremiumCardView(
                                    slide: slides[index],
                                    index: index,
                                    currentIndex: currentSlide,
                                    scrollOffset: scrollOffset,
                                    cardWidth: cardWidth,
                                    cardHeight: cardHeight,
                                    containerWidth: geometry.size.width
                                )
                                .id(index)
                            }
                        }
                        .padding(.horizontal, 16)
                        .background(
                            GeometryReader { scrollGeometry in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: scrollGeometry.frame(in: .named("scroll")).minX)
                            }
                        )
                    }
                    .coordinateSpace(name: "scroll")
                    .scrollTargetBehavior(.paging)
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollOffset = value
                        updateCurrentSlide(from: value, containerWidth: geometry.size.width)
                    }
                    .onChange(of: currentSlide) { oldValue, newValue in
                        if oldValue != newValue {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                    }
                }
            }
            .frame(height: cardHeight)
            
            // Segmented Progress Bar
            segmentedProgressBar(slides: slides)
        }
        .onAppear {
            startAutoRotate()
        }
        .onDisappear {
            stopAutoRotate()
            hapticDebounceTimer?.invalidate()
        }
    }
    
    private func segmentedProgressBar(slides: [PremiumToolkitSlide]) -> some View {
        HStack(spacing: 4) {
            ForEach(slides.indices, id: \.self) { index in
                Capsule()
                    .fill(index == currentSlide ? ArotiColor.accent : ArotiColor.textMuted.opacity(0.3))
                    .frame(height: 3)
                    .shadow(
                        color: index == currentSlide ? ArotiColor.accent.opacity(0.4) : .clear,
                        radius: 4,
                        x: 0,
                        y: 0
                    )
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentSlide)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
    
    private func updateCurrentSlide(from offset: CGFloat, containerWidth: CGFloat) {
        let cardWidthWithSpacing = cardWidth + cardSpacing
        let centerOffset = containerWidth / 2 - cardWidth / 2
        let adjustedOffset = -offset + centerOffset
        let newIndex = Int(round(adjustedOffset / cardWidthWithSpacing))
        let clampedIndex = max(0, min(newIndex, PremiumToolkitSlide.allCases.count - 1))
        
        if clampedIndex != currentSlide {
            currentSlide = clampedIndex
            triggerHapticOnSettle()
        }
    }
    
    private func triggerHapticOnSettle() {
        hapticDebounceTimer?.invalidate()
        hapticDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { _ in
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    // MARK: - Carousel Rotation
    
    private func startAutoRotate() {
        stopAutoRotate()
        
        autoRotateCancellable = Timer.publish(every: autoRotateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                    advanceSlide()
                }
            }
    }
    
    private func stopAutoRotate() {
        autoRotateCancellable?.cancel()
        autoRotateCancellable = nil
    }
    
    private func advanceSlide() {
        let next = (currentSlide + 1) % PremiumToolkitSlide.allCases.count
        if next != currentSlide {
            currentSlide = next
        }
    }
}

// MARK: - Premium Card View

private struct PremiumCardView: View {
    let slide: PremiumToolkitSlide
    let index: Int
    let currentIndex: Int
    let scrollOffset: CGFloat
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let containerWidth: CGFloat
    
    @State private var cardPosition: CGFloat = 0
    
    private let cardSpacing: CGFloat = 16
    
    private var distanceFromCenter: CGFloat {
        let screenCenter = containerWidth / 2
        return abs(cardPosition - screenCenter)
    }
    
    private var scale: CGFloat {
        let normalizedDistance = distanceFromCenter / cardWidth
        let scaleValue = 1.0 - (normalizedDistance * 0.08)
        return max(0.92, min(1.0, scaleValue))
    }
    
    private var opacity: Double {
        let normalizedDistance = distanceFromCenter / cardWidth
        let opacityValue = 1.0 - (normalizedDistance * 0.45)
        return max(0.55, min(1.0, opacityValue))
    }
    
    private var parallaxOffset: CGFloat {
        let screenCenter = containerWidth / 2
        let relativeOffset = cardPosition - screenCenter
        return relativeOffset * 0.3
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                // Chip
                HStack {
                    Text("Premium Tool")
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(ArotiColor.accent.opacity(0.12))
                        )
                    
                    Spacer()
                }
                .padding(.horizontal, DesignSpacing.md)
                .padding(.top, DesignSpacing.md)
                
                // Preview Window (top half)
                EmbossedIconPreview(
                    iconName: slide.iconName,
                    parallaxOffset: parallaxOffset
                )
                .frame(height: 120)
                .padding(.top, DesignSpacing.sm)
                
                // Content (bottom half)
                VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                    // Title
                    Text(slide.title)
                        .font(ArotiTextStyle.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(ArotiColor.textPrimary)
                        .lineLimit(1)
                    
                    // Bullets
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(slide.bullets, id: \.self) { bullet in
                            HStack(alignment: .top, spacing: 6) {
                                Text("•")
                                    .font(ArotiTextStyle.caption1)
                                    .foregroundColor(ArotiColor.textSecondary)
                                Text(bullet)
                                    .font(ArotiTextStyle.caption1)
                                    .foregroundColor(ArotiColor.textSecondary)
                            }
                        }
                    }
                    
                    // Output line
                    Text(slide.outputLine)
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.textMuted)
                        .padding(.top, 2)
                }
                .padding(.horizontal, DesignSpacing.md)
                .padding(.top, DesignSpacing.sm)
                .padding(.bottom, DesignSpacing.md)
            }
            .frame(width: cardWidth, height: cardHeight)
            .background(
                ZStack {
                    // Dark glass background
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 12/255, green: 10/255, blue: 18/255).opacity(0.95),
                                    Color(red: 8/255, green: 6/255, blue: 14/255).opacity(0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color.black.opacity(0.3))
                        )
                    
                    // Subtle border
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                }
            )
            .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 8)
            .scaleEffect(scale)
            .opacity(opacity)
            .background(
                GeometryReader { cardGeometry in
                    Color.clear
                        .preference(key: CardPositionPreferenceKey.self, value: cardGeometry.frame(in: .named("scroll")).midX)
                }
            )
            .onPreferenceChange(CardPositionPreferenceKey.self) { position in
                cardPosition = position
            }
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}

// MARK: - Embossed Icon Preview

private struct EmbossedIconPreview: View {
    let iconName: String
    let parallaxOffset: CGFloat
    
    var body: some View {
        ZStack {
            // Radial glow background
            RadialGradient(
                colors: [
                    ArotiColor.accent.opacity(0.15),
                    ArotiColor.accent.opacity(0.05),
                    Color.clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 80
            )
            
            // Embossed icon
            Image(systemName: iconName)
                .font(.system(size: 52, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            ArotiColor.textPrimary,
                            ArotiColor.textPrimary.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.white.opacity(0.3), radius: 2, x: -1, y: -1)
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 1)
                .offset(x: parallaxOffset)
        }
    }
}

// MARK: - Preference Keys

// Note: ScrollOffsetPreferenceKey is now defined in StickyHeaderBar.swift as a shared public key

private struct CardPositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Slide Model

enum PremiumToolkitSlide: CaseIterable {
    case guidance
    case cycles
    case reports
    case unlimited
    
    var title: String {
        switch self {
        case .guidance:
            return "Daily Personalized Guidance"
        case .cycles:
            return "Emotional Cycles Analysis"
        case .reports:
            return "Monthly Personalized Reports"
        case .unlimited:
            return "Unlimited Access Mode"
        }
    }
    
    var bullets: [String] {
        switch self {
        case .guidance:
            return [
                "Unlimited daily messages",
                "Action steps tailored to your profile"
            ]
        case .cycles:
            return [
                "Weekly + monthly pattern mapping",
                "Phase-based recommendations"
            ]
        case .reports:
            return [
                "Full monthly summary",
                "Downloadable share-ready format"
            ]
        case .unlimited:
            return [
                "No limits, no lock screens",
                "Full access to premium tools"
            ]
        }
    }
    
    var outputLine: String {
        switch self {
        case .guidance:
            return "New guidance every day"
        case .cycles:
            return "See your current phase"
        case .reports:
            return "1 new report each month"
        case .unlimited:
            return "Everything unlocked"
        }
    }
    
    var iconName: String {
        switch self {
        case .guidance:
            return "sparkles"
        case .cycles:
            return "waveform.path"
        case .reports:
            return "doc.richtext"
        case .unlimited:
            return "lock.open.display"
        }
    }
}
