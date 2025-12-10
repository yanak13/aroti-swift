//
//  ValueCarouselView.swift
//  Aroti
//
//  Screen 2-4: What You'll Get carousel (Premium Modern)
//

import SwiftUI

struct ValueCarouselView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var currentIndex = 0
    @State private var buttonPulse: Double = 1.0
    @State private var slideAnimationComplete: [Bool] = [false, false, false]
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var ctaOffset: [CGFloat] = [40, 40, 40] // CTA starts below for each slide
    
    let slides = [
        ValueSlide(
            title: "Your Cosmic Profile",
            subtitle: "Your cosmic fingerprint — the map of your inner world.",
            benefit: "See your patterns, cycles, and hidden strengths clearly.",
            why: "Understand yourself with more precision than ever.",
            iconType: .constellation
        ),
        ValueSlide(
            title: "Daily Guidance",
            subtitle: "Your daily energy, translated into guidance you can use.",
            benefit: "Stay aligned with what today is trying to tell you.",
            why: "A daily touchpoint to stay aligned and grounded.",
            iconType: .sunrise
        ),
        ValueSlide(
            title: "Tarot Readings",
            subtitle: "The cards reveal what your intuition already knows.",
            benefit: "Our spreads uncover the emotional truth behind your questions.",
            why: "Get clarity when emotions feel overwhelming.",
            iconType: .tarot
        )
    ]
    
    var body: some View {
        ZStack {
            // Vertical atmospheric gradient (starts above icon, smooth fade)
            // Top: pure transparent black (opacity 0 → 20%)
            // Middle: soft dark purple #0A0810
            // Bottom: warm terracotta fade (#D19561 at 5-8% opacity)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.black.opacity(0.0), location: 0.0), // Top: transparent
                    .init(color: Color.black.opacity(0.1), location: 0.15), // Top fade
                    .init(color: Color(red: 10/255, green: 8/255, blue: 16/255), location: 0.4), // Middle: soft dark purple #0A0810
                    .init(color: Color(red: 20/255, green: 18/255, blue: 33/255), location: 0.7), // Transition
                    .init(color: Color(red: 209/255, green: 149/255, blue: 97/255).opacity(0.08), location: 1.0) // Bottom: warm terracotta #D19561 at 8%
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Subtle radial glow for depth (very faint, centered)
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.04),
                    Color.clear
                ]),
                center: UnitPoint(x: 0.5, y: 0.5),
                startRadius: 0,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            // Subtle vignette for depth (2% opacity)
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(0.02)
                ]),
                center: .center,
                startRadius: 200,
                endRadius: 600
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    OnboardingBackButton()
                    Spacer()
                    OnboardingSkipButton()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            ValueSlideView(
                                slide: slides[index],
                                index: index,
                                animationComplete: Binding(
                                    get: { index < slideAnimationComplete.count ? slideAnimationComplete[index] : false },
                                    set: { if index < slideAnimationComplete.count { slideAnimationComplete[index] = $0 } }
                                ),
                                dragOffset: $dragOffset,
                                isDragging: $isDragging
                            )
                            .frame(width: geometry.size.width)
                            .tag(index)
                        }
                    }
                    .offset(x: -CGFloat(currentIndex) * geometry.size.width + dragOffset)
                    .animation(isDragging ? nil : .spring(response: 0.5, dampingFraction: 0.8), value: currentIndex)
                    .animation(isDragging ? nil : .spring(response: 0.5, dampingFraction: 0.8), value: dragOffset)
                    .gesture(
                        DragGesture(minimumDistance: 10) // Reduced threshold for easier swiping
                            .onChanged { value in
                                isDragging = true
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                isDragging = false
                                
                                // Calculate swipe threshold (30% of screen width)
                                let threshold = geometry.size.width * 0.3
                                let velocity = value.predictedEndTranslation.width - value.translation.width
                                
                                // Determine next page based on drag distance and velocity
                                if value.translation.width > threshold || velocity > 500 {
                                    // Swipe right - go to previous page
                                    if currentIndex > 0 {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            currentIndex -= 1
                                        }
                                    }
                                } else if value.translation.width < -threshold || velocity < -500 {
                                    // Swipe left - go to next page
                                    if currentIndex < slides.count - 1 {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            currentIndex += 1
                                        }
                                    }
                                }
                                
                                // Reset drag offset with spring animation
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                    dragOffset = 0
                                }
                            }
                    )
                }
                .frame(height: 500)
                
                // Modern Pagination Dots
                HStack(spacing: 12) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        if index == currentIndex {
                            // Active dot = glowing orb
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 201/255, green: 120/255, blue: 72/255),
                                            Color(red: 227/255, green: 177/255, blue: 116/255)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 12, height: 12)
                                .shadow(color: Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.6), radius: 8, x: 0, y: 0)
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        } else {
                            // Inactive dots = faint circles
                            Circle()
                                .fill(ArotiColor.textSecondary.opacity(0.2))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        }
                    }
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Premium CTA Button with outer glow (slides up LAST - syncs with animation completion)
                ZStack {
                    // Outer glow (only when animation complete and on last slide)
                    if currentIndex == slides.count - 1 {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.3),
                                        Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.2)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 56)
                            .blur(radius: 15)
                            .scaleEffect(buttonPulse)
                            .opacity(buttonPulse > 1.0 ? 1.0 : 0.5)
                            .offset(y: currentIndex < ctaOffset.count ? ctaOffset[currentIndex] : 40)
                            .opacity(currentIndex == slides.count - 1 && currentIndex < slideAnimationComplete.count && slideAnimationComplete[currentIndex] ? 1.0 : 0.0)
                    }
                    
                    Button(action: {
                        onboardingManager.currentScreen = .createAccount
                    }) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 201/255, green: 120/255, blue: 72/255),
                                        Color(red: 227/255, green: 177/255, blue: 116/255)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.3),
                                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.2)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(color: Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.4), radius: 20, x: 0, y: 8)
                            .shadow(color: Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.2), radius: 30, x: 0, y: 0)
                            .scaleEffect((currentIndex == slides.count - 1 && currentIndex < slideAnimationComplete.count && slideAnimationComplete[currentIndex]) ? buttonPulse : 1.0)
                            .opacity((currentIndex == slides.count - 1 && currentIndex < slideAnimationComplete.count && slideAnimationComplete[currentIndex]) ? 1.0 : 0.5)
                    }
                    .disabled(!(currentIndex == slides.count - 1 && currentIndex < slideAnimationComplete.count && slideAnimationComplete[currentIndex]))
                    .offset(y: currentIndex < ctaOffset.count ? ctaOffset[currentIndex] : 40)
                    .opacity(currentIndex == slides.count - 1 && currentIndex < slideAnimationComplete.count && slideAnimationComplete[currentIndex] ? 1.0 : 0.0)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if currentIndex == slides.count - 1 && currentIndex < slideAnimationComplete.count && slideAnimationComplete[currentIndex] {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    buttonPulse = 1.02
                }
            }
        }
        .onChange(of: currentIndex) { oldValue, newIndex in
            if newIndex == slides.count - 1 && newIndex < slideAnimationComplete.count && slideAnimationComplete[newIndex] {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    buttonPulse = 1.02
                }
            } else {
                buttonPulse = 1.0
            }
        }
        .onChange(of: slideAnimationComplete) { oldValue, newValue in
            // When animation completes on last slide, activate CTA
            if currentIndex == slides.count - 1 && currentIndex < slideAnimationComplete.count && slideAnimationComplete[currentIndex] {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    buttonPulse = 1.02
                }
            }
        }
    }
}

struct ValueSlide {
    let title: String
    let subtitle: String
    let benefit: String
    let why: String
    let iconType: IconType
}

enum IconType {
    case constellation
    case sunrise
    case tarot
}

struct ValueSlideView: View {
    let slide: ValueSlide
    let index: Int
    @Binding var animationComplete: Bool
    @Binding var dragOffset: CGFloat
    @Binding var isDragging: Bool
    @State private var rotation: Double = 0
    @State private var shimmer: Double = 0
    @State private var pulse: Double = 0.6
    @State private var cardOffset: CGFloat = 0
    @State private var iconRotation: Double = 0
    
    // Calculate parallax offset based on drag
    private var parallaxOffset: CGFloat {
        dragOffset
    }
    
    // Entrance animation states
    @State private var backgroundOpacity: Double = 0
    @State private var iconScale: Double = 0.8
    @State private var iconOpacity: Double = 0
    @State private var titleOffset: CGFloat = 30
    @State private var titleOpacity: Double = 0
    @State private var subtitleOffset: CGFloat = 20
    @State private var subtitleOpacity: Double = 0
    @State private var benefitOpacity: Double = 0
    @State private var whyOpacity: Double = 0
    @State private var ctaOffset: CGFloat = 40
    @State private var ctaOpacity: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Layer 1 - Background Stars (parallax depth far - very slow movement)
                ForEach(0..<20, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.03))
                        .frame(width: 1.5, height: 1.5)
                        .position(
                            x: CGFloat.random(in: 50...350),
                            y: CGFloat.random(in: 100...400)
                        )
                        .offset(x: parallaxOffset * 0.15) // Very slow - background layer
                        .opacity(backgroundOpacity)
                }
                
                // Layer 2 - Glows + Flares + Sparkles (move faster - fastest layer, 8% opacity)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.08),
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.04),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 300)
                    .blur(radius: 150)
                    .offset(x: parallaxOffset * 0.8) // Fastest - glow/particles layer
                    .opacity(backgroundOpacity)
                
                // Sparkles layer (fastest movement)
                ForEach(0..<15, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 1.5, height: 1.5)
                        .position(
                            x: CGFloat.random(in: 80...320),
                            y: CGFloat.random(in: 120...380)
                        )
                        .offset(x: parallaxOffset * 0.9) // Fastest - particles
                        .opacity(backgroundOpacity * 0.6)
                }
                
                // Very faint vertical beam behind icon (2% opacity)
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.02),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 2, height: 300)
                    .blur(radius: 30)
                    .offset(x: parallaxOffset * 0.7) // Fast - glow layer
                    .opacity(backgroundOpacity)
                
                // Soft vignette/glow behind icon (8% opacity)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.08),
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.04),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)
                    .blur(radius: 80)
                    .offset(x: parallaxOffset * 0.6) // Fast - glow layer
                    .opacity(backgroundOpacity)
                
                // Faint circular glow halo (8% opacity)
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.08),
                                Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                    .frame(width: 200, height: 200)
                    .blur(radius: 20)
                    .offset(x: parallaxOffset * 0.5) // Moderate - glow layer
                    .opacity(backgroundOpacity)
            
                // Layer 3 - Main Icon (moves the most - foreground parallax, moderate movement)
                VStack(spacing: 48) {
                    Group {
                        switch slide.iconType {
                        case .constellation:
                            ConstellationIcon(rotation: $rotation, shimmer: $shimmer, index: index, animationComplete: Binding(
                                get: { animationComplete },
                                set: { animationComplete = $0 }
                            ))
                        case .sunrise:
                            SunriseIcon(pulse: $pulse, index: index, animationComplete: Binding(
                                get: { animationComplete },
                                set: { animationComplete = $0 }
                            ))
                        case .tarot:
                            TarotIcon(offset: $cardOffset, index: index, animationComplete: Binding(
                                get: { animationComplete },
                                set: { animationComplete = $0 }
                            ))
                        }
                    }
                    .frame(height: 200)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)
                    .offset(x: parallaxOffset * 0.5) // Moderate movement - icon layer
                    .offset(y: parallaxOffset * 0.1) // Slight vertical parallax
                    .rotationEffect(.degrees(Double(parallaxOffset) * 0.03)) // Subtle tilt during drag (inertial effect)
                    
                    VStack(spacing: 20) {
                        Text(slide.title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(ArotiColor.textPrimary)
                            .multilineTextAlignment(.center)
                            .offset(y: titleOffset)
                            .opacity(titleOpacity)
                        
                        Text(slide.subtitle)
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(ArotiColor.textPrimary.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .offset(y: subtitleOffset)
                            .opacity(subtitleOpacity)
                        
                        Text(slide.benefit)
                            .font(.system(size: 15, weight: .light))
                            .foregroundColor(ArotiColor.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .padding(.top, 4)
                            .opacity(benefitOpacity)
                        
                        Text(slide.why)
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(ArotiColor.textSecondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                            .opacity(whyOpacity)
                    }
                    .padding(.horizontal, 32)
                    .offset(x: (parallaxOffset + dragOffset) * 0.3)
                }
                
                // Subtle noise texture overlay for depth (2-3% opacity)
                NoiseTextureView()
                    .opacity(backgroundOpacity)
            }
        }
        .onAppear {
            startEntranceAnimation()
            startAnimations()
        }
        .onChange(of: index) { oldValue, newValue in
            // Reset entrance animation when slide changes
            resetEntranceAnimation()
            startEntranceAnimation()
        }
    }
    
    private func resetEntranceAnimation() {
        backgroundOpacity = 0
        iconScale = 0.8
        iconOpacity = 0
        titleOffset = 30
        titleOpacity = 0
        subtitleOffset = 20
        subtitleOpacity = 0
        benefitOpacity = 0
        whyOpacity = 0
        ctaOffset = 40
        ctaOpacity = 0
        animationComplete = false
    }
    
    private func startEntranceAnimation() {
        // Step 1: Background stars fade in (0.0s - FIRST)
        withAnimation(.easeOut(duration: 0.4)) {
            backgroundOpacity = 1.0
        }
        
        // Step 2: Icon animates (0.3s delay - AFTER background)
        // Icon animation (drawing, shuffle, sun rising) is handled by individual icon components
        // They will start their animations after this delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }
        }
        
        // Step 3: Title fades upward (0.8s delay - AFTER icon starts animating)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.6)) {
                titleOffset = 0
                titleOpacity = 1.0
            }
        }
        
        // Step 4: Subtitle fades (1.1s delay - AFTER title)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            withAnimation(.easeOut(duration: 0.5)) {
                subtitleOffset = 0
                subtitleOpacity = 1.0
            }
        }
        
        // Step 5: Benefit appears (1.4s delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.easeOut(duration: 0.4)) {
                benefitOpacity = 1.0
            }
        }
        
        // Step 6: Why appears (1.6s delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeOut(duration: 0.4)) {
                whyOpacity = 1.0
            }
        }
        
        // Mark animation complete when icon animation finishes (syncs with CTA)
        // This will be set by individual icon components when their animations complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            // Icon animations should be complete by now
            if !animationComplete {
                animationComplete = true
            }
        }
    }
    
    private func startAnimations() {
        switch slide.iconType {
        case .constellation:
            // Constellation drawing animation will be handled in ConstellationIcon
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                rotation = 2 // Sway 1-2 degrees
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                shimmer = 1.0
            }
        case .sunrise:
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                pulse = 0.75 // Orb expands 5% and contracts
            }
        case .tarot:
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                cardOffset = 3 // Cards float 2-3px
            }
        }
    }
}

// MARK: - Icon Components

struct ConstellationIcon: View {
    @Binding var rotation: Double
    @Binding var shimmer: Double
    let index: Int
    @Binding var animationComplete: Bool
    @State private var dotsOpacity: [Double] = [0, 0, 0, 0, 0, 0, 0]
    @State private var linesOpacity: [Double] = [0, 0, 0, 0, 0, 0]
    @State private var linesStrokeEnd: [Double] = [0, 0, 0, 0, 0, 0]
    @State private var constellationScale: Double = 0.9
    @State private var glowIntensity: Double = 0.3
    @State private var hasDrawn: Bool = false
    @State private var twinkleTimer: Timer?
    
    var body: some View {
        ZStack {
            // Radial glow behind icon (8% opacity, 150px blur, positioned behind icon)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 201/255, green: 126/255, blue: 74/255).opacity(0.08),
                            Color(red: 201/255, green: 126/255, blue: 74/255).opacity(0.04),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 300, height: 300)
                .blur(radius: 150)
                .opacity(glowIntensity * 0.5) // Reduce intensity multiplier
            
            // Glow pulse every 5s (8% max opacity)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.08),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .blur(radius: 30)
                .opacity(glowIntensity * 0.4) // Reduced multiplier
            
            // Abstract constellation: 7 dots connected by lines
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius: CGFloat = 40
                let points: [CGPoint] = [
                    CGPoint(x: center.x, y: center.y - radius),
                    CGPoint(x: center.x + radius * 0.7, y: center.y - radius * 0.3),
                    CGPoint(x: center.x + radius * 0.5, y: center.y + radius * 0.5),
                    CGPoint(x: center.x - radius * 0.5, y: center.y + radius * 0.5),
                    CGPoint(x: center.x - radius * 0.7, y: center.y - radius * 0.3),
                    CGPoint(x: center.x, y: center.y + radius * 0.3),
                    CGPoint(x: center.x + radius * 0.3, y: center.y)
                ]
                
                // Line segments (drawing animation)
                let lineSegments: [(Int, Int)] = [
                    (0, 1), (1, 2), (0, 4), (4, 3), (1, 6), (4, 5), (2, 5), (3, 5)
                ]
                
                for (idx, segment) in lineSegments.enumerated() {
                    if idx < linesOpacity.count && idx < linesStrokeEnd.count && segment.0 < points.count && segment.1 < points.count {
                        // Create path for line segment
                        let startPoint = points[segment.0]
                        let endPoint = points[segment.1]
                        
                        // Calculate strokeEnd position (0 → 1)
                        let strokeProgress = linesStrokeEnd[idx]
                        let currentEndX = startPoint.x + (endPoint.x - startPoint.x) * CGFloat(strokeProgress)
                        let currentEndY = startPoint.y + (endPoint.y - startPoint.y) * CGFloat(strokeProgress)
                        
                        let path = Path { path in
                            path.move(to: startPoint)
                            path.addLine(to: CGPoint(x: currentEndX, y: currentEndY))
                        }
                        
                        // Glowing line (terracotta → gold gradient effect)
                        let startColor = Color(red: 201/255, green: 120/255, blue: 72/255)
                        
                        // Use opacity to simulate gradient along line
                        let lineOpacity = 0.5 + (linesOpacity[idx] * 0.3)
                        
                        context.stroke(
                            path,
                            with: .color(startColor.opacity(lineOpacity)),
                            lineWidth: 2.0 // Slightly thicker for visibility
                        )
                    }
                }
                
                // Dots with twinkle animation
                for (idx, point) in points.enumerated() {
                    if idx < dotsOpacity.count {
                        // Glow around dots
                        context.fill(
                            Path(ellipseIn: CGRect(x: point.x - 6, y: point.y - 6, width: 12, height: 12)),
                            with: .color(Color(red: 201/255, green: 120/255, blue: 72/255).opacity(dotsOpacity[idx] * 0.4))
                        )
                        
                        // Dots
                        context.fill(
                            Path(ellipseIn: CGRect(x: point.x - 3, y: point.y - 3, width: 6, height: 6)),
                            with: .color(.white.opacity(dotsOpacity[idx]))
                        )
                    }
                }
            }
            .frame(width: 120, height: 120)
            .scaleEffect(constellationScale)
            .rotationEffect(.degrees(rotation))
            
            // 3-5 tiny sparkles drift slowly behind icon
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 1.5, height: 1.5)
                    .offset(
                        x: CGFloat.random(in: -60...60),
                        y: CGFloat.random(in: -60...60)
                    )
                    .animation(
                        .linear(duration: 8 + Double(i) * 2)
                            .repeatForever(autoreverses: false),
                        value: shimmer
                    )
            }
        }
        .onAppear {
            if !hasDrawn {
                drawConstellation()
            } else {
                // Shortened version if returning
                startIdleAnimations()
            }
        }
        .onChange(of: animationComplete) { oldValue, newValue in
            if newValue {
                // Signal that constellation drawing is complete
            }
        }
    }
    
    private func drawConstellation() {
        // Step 1: Dots appear first (fade 0 → 0.3 opacity)
        withAnimation(.easeOut(duration: 0.3)) {
            for i in 0..<dotsOpacity.count {
                dotsOpacity[i] = 0.3
            }
            constellationScale = 1.0
        }
        
        // Step 2: Glowing line travels from dot to dot (strokeEnd: 0 → 1)
        let lineSegments: [(Int, Int)] = [
            (0, 1), (1, 2), (0, 4), (4, 3), (1, 6), (4, 5), (2, 5), (3, 5)
        ]
        
        for (idx, segment) in lineSegments.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 + Double(idx) * 0.15) {
                // Dot brightens as line reaches it
                withAnimation(.easeOut(duration: 0.15)) {
                    if segment.1 < dotsOpacity.count {
                        dotsOpacity[segment.1] = 1.0
                    }
                }
                
                // Line draws itself (strokeEnd: 0 → 1)
                withAnimation(.easeOut(duration: 0.2)) {
                    if idx < linesOpacity.count && idx < linesStrokeEnd.count {
                        linesOpacity[idx] = 1.0
                        linesStrokeEnd[idx] = 1.0
                    }
                }
            }
        }
        
        // Step 3: Once constellation is completed - tiny 2-3% bounce
        let totalDuration = 0.3 + Double(lineSegments.count) * 0.15
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            // Bounce animation (2-3% scale)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                constellationScale = 1.03
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    constellationScale = 1.0
                }
                
                hasDrawn = true
                startIdleAnimations()
                
                // Signal animation complete (after bounce completes)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    animationComplete = true
                }
            }
        }
    }
    
    private func startIdleAnimations() {
        // Idle rotation: 1-2° over 8 seconds
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            rotation = 2.0 // 1-2 degrees
        }
        
        // Random dot twinkles every 2-4 seconds
        twinkleTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            let randomDot = Int.random(in: 0..<dotsOpacity.count)
            
            // Random dot twinkles (brightens then returns)
            withAnimation(.easeInOut(duration: 0.4)) {
                dotsOpacity[randomDot] = 1.3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    dotsOpacity[randomDot] = 1.0
                }
            }
        }
        
        // Occasional line pulse (less frequent)
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { _ in
            let randomLine = Int.random(in: 0..<linesOpacity.count)
            
            withAnimation(.easeInOut(duration: 0.5)) {
                if randomLine < linesOpacity.count {
                    linesOpacity[randomLine] = 0.8
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    if randomLine < linesOpacity.count {
                        linesOpacity[randomLine] = 0.5
                    }
                }
            }
        }
    }
}

struct SunriseIcon: View {
    @Binding var pulse: Double
    let index: Int
    @Binding var animationComplete: Bool
    @State private var horizonShimmer: [CGFloat] = [0, 0, 0]
    @State private var horizonOffset: [CGFloat] = [0, 0, 0] // Left-right movement
    @State private var mistParticles: [CGPoint] = []
    @State private var mistOpacity: [Double] = []
    @State private var sunRiseOffset: CGFloat = 50
    @State private var sunOpacity: Double = 0
    @State private var sunScale: Double = 1.0
    @State private var radialFlicker: Double = 1.0
    
    var body: some View {
        ZStack {
            // Dust particles rise like morning mist
            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 2, height: 2)
                    .position(
                        x: i < mistParticles.count ? mistParticles[i].x : 0,
                        y: i < mistParticles.count ? mistParticles[i].y : 0
                    )
                    .opacity(i < mistOpacity.count ? mistOpacity[i] : 0)
            }
            
            // Vertical light streak animation (8% max opacity)
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.08),
                            Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.03),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 6, height: 250)
                .blur(radius: 25)
                .offset(y: -30)
            
            // Glowing orb rising (grows 3% and shrinks, with radial flicker - 8% max opacity)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 227/255, green: 177/255, blue: 116/255).opacity(pulse * sunOpacity * 0.1 * radialFlicker), // Radial flicker
                            Color(red: 201/255, green: 120/255, blue: 72/255).opacity(pulse * 0.7 * sunOpacity * 0.1 * radialFlicker)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: 100 * sunScale * (1 + (pulse - 0.6) * 0.03), height: 100 * sunScale * (1 + (pulse - 0.6) * 0.03)) // 3% growth
                .blur(radius: 15)
                .shadow(color: Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.08), radius: 30, x: 0, y: 0)
                .offset(y: sunRiseOffset)
                .opacity(sunOpacity)
            
            // 3 minimal horizon lines with shimmer
            VStack(spacing: 8) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.2 + Double(horizonShimmer[0]) * 0.05), // Reduced opacity
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.08)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 120 + horizonShimmer[0], height: 1)
                    .offset(x: horizonShimmer[0] * 0.5 + horizonOffset[0]) // Left-right movement (water reflection)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.15 + Double(horizonShimmer[1]) * 0.05), // Reduced opacity
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.06)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 140 + horizonShimmer[1], height: 1)
                    .offset(x: horizonShimmer[1] * 0.5 + horizonOffset[1]) // Left-right movement
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.12 + Double(horizonShimmer[2]) * 0.05), // Reduced opacity
                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.05)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 160 + horizonShimmer[2], height: 1)
                    .offset(x: horizonShimmer[2] * 0.5 + horizonOffset[2]) // Left-right movement
            }
            .offset(y: 30)
        }
        .onAppear {
            setupMistParticles()
            startHorizonShimmer()
            startSunRising()
        }
        .onChange(of: animationComplete) { oldValue, newValue in
            if newValue {
                // Sun has fully risen
            }
        }
    }
    
    private func startSunRising() {
        // Sun "dawns" upward - hero entrance animation
        sunRiseOffset = 50
        sunOpacity = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 1.0)) {
                sunRiseOffset = 0
                sunOpacity = 1.0
            }
        }
        
        // Horizon line sweeps softly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.8)) {
                // Horizon shimmer starts
            }
        }
        
        // Signal animation complete (after sun fully rises)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            animationComplete = true
        }
    }
    
    private func setupMistParticles() {
        mistParticles = (0..<8).map { _ in
            CGPoint(
                x: CGFloat.random(in: 80...220),
                y: CGFloat.random(in: 100...200)
            )
        }
        mistOpacity = (0..<8).map { _ in Double.random(in: 0.3...0.6) }
        
        // Animate particles rising
        for i in 0..<8 {
            withAnimation(.linear(duration: 4 + Double(i) * 0.5).repeatForever(autoreverses: false)) {
                if i < mistParticles.count {
                    mistParticles[i].y -= 100
                    mistOpacity[i] = 0
                }
            }
        }
    }
    
    private func startHorizonShimmer() {
        // Horizon lines move slightly left and right (like water reflection)
        for i in 0..<3 {
            withAnimation(.easeInOut(duration: 3 + Double(i) * 0.4).repeatForever(autoreverses: true)) {
                horizonShimmer[i] = CGFloat.random(in: -2...2)
                horizonOffset[i] = CGFloat.random(in: -3...3) // Left-right movement
            }
        }
        
        // Sun orb grows 3% and shrinks
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
            sunScale = 1.03 // 3% growth
        }
        
        // Slight radial flicker (very subtle)
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            radialFlicker = 0.95 // Very subtle flicker
        }
    }
}

struct TarotIcon: View {
    @Binding var offset: CGFloat
    let index: Int
    @Binding var animationComplete: Bool
    @State private var glowPulse: Double = 0.3
    @State private var cardScale: [Double] = [0.8, 0.8, 0.8]
    @State private var cardShuffle: [CGFloat] = [0, 0, 0]
    @State private var sparklePositions: [CGPoint] = []
    @State private var sparkleOpacity: [Double] = []
    @State private var cardsOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Soft glow pulse behind cards every 5s (8% max opacity)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 201/255, green: 120/255, blue: 72/255).opacity(glowPulse * 0.2), // Reduced multiplier
                            Color(red: 227/255, green: 177/255, blue: 116/255).opacity(glowPulse * 0.1),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .blur(radius: 40)
            
            // Soft swirling gradient behind (8% max opacity)
            Circle()
                .fill(
                    AngularGradient(
                        colors: [
                            Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.08),
                            Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.04),
                            Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.08)
                        ],
                        center: .center,
                        angle: .degrees(45)
                    )
                )
                .frame(width: 180, height: 180)
                .blur(radius: 40)
            
            // 3-5 tiny sparkles drift slowly behind icon
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 2, height: 2)
                    .position(
                        x: i < sparklePositions.count ? sparklePositions[i].x : 0,
                        y: i < sparklePositions.count ? sparklePositions[i].y : 0
                    )
                    .opacity(i < sparkleOpacity.count ? sparkleOpacity[i] : 0.3)
            }
            
            // Three abstract card outlines with slight offset/overlap
            HStack(spacing: -8) {
                // Card 1
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255),
                                Color(red: 227/255, green: 177/255, blue: 116/255)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 50, height: 70)
                    .offset(y: offset + cardShuffle[0])
                    .offset(x: cardShuffle[0] * 0.5)
                    .rotationEffect(.degrees(Double(cardShuffle[0]) * 0.5)) // Slight tilt (shuffle-like)
                    .scaleEffect(cardScale[0])
                    .opacity(0.9 * cardsOpacity)
                
                // Card 2
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255),
                                Color(red: 227/255, green: 177/255, blue: 116/255)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 50, height: 70)
                    .offset(y: -offset * 0.5 + cardShuffle[1])
                    .offset(x: cardShuffle[1] * 0.5)
                    .rotationEffect(.degrees(Double(cardShuffle[1]) * 0.5)) // Slight tilt
                    .scaleEffect(cardScale[1])
                    .opacity(0.95 * cardsOpacity)
                
                // Card 3
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 201/255, green: 120/255, blue: 72/255),
                                Color(red: 227/255, green: 177/255, blue: 116/255)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 50, height: 70)
                    .offset(y: offset * 0.7 + cardShuffle[2])
                    .offset(x: cardShuffle[2] * 0.5)
                    .rotationEffect(.degrees(Double(cardShuffle[2]) * 0.5)) // Slight tilt
                    .scaleEffect(cardScale[2])
                    .opacity(0.9 * cardsOpacity)
            }
            .shadow(color: Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.3), radius: 10, x: 0, y: 4)
        }
        .onAppear {
            setupSparkles()
            startCardShuffle()
            startGlowPulse()
        }
        .onChange(of: animationComplete) { oldValue, newValue in
            if newValue {
                // Cards have shuffled and sparkles are in place
            }
        }
    }
    
    private func setupSparkles() {
        sparklePositions = (0..<5).map { _ in
            CGPoint(
                x: CGFloat.random(in: 60...180),
                y: CGFloat.random(in: 60...180)
            )
        }
        sparkleOpacity = (0..<5).map { _ in Double.random(in: 0.2...0.5) }
        
        // Animate sparkles drifting
        for i in 0..<5 {
            withAnimation(.linear(duration: 6 + Double(i) * 1).repeatForever(autoreverses: false)) {
                if i < sparklePositions.count {
                    sparklePositions[i] = CGPoint(
                        x: sparklePositions[i].x + CGFloat.random(in: -30...30),
                        y: sparklePositions[i].y + CGFloat.random(in: -30...30)
                    )
                }
            }
        }
    }
    
    private func startCardShuffle() {
        // Cards slide into place one by one with shuffle-like tilt
        cardsOpacity = 0
        
        // Initial positions (off-screen or offset)
        for i in 0..<3 {
            cardScale[i] = 0.7
            cardShuffle[i] = CGFloat.random(in: -15...15) // Initial shuffle offset
        }
        
        // Card 1 slides in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                cardScale[0] = 1.0
                cardShuffle[0] = CGFloat.random(in: -2...2) // Slight tilt (shuffle-like)
                cardsOpacity = 1.0
            }
        }
        
        // Card 2 slides in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                cardScale[1] = 1.0
                cardShuffle[1] = CGFloat.random(in: -2...2) // Slight tilt
            }
        }
        
        // Card 3 slides in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                cardScale[2] = 1.0
                cardShuffle[2] = CGFloat.random(in: -2...2) // Slight tilt
            }
        }
        
        // Soft sparkles drift across
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Sparkles are already animating in setupSparkles
        }
        
        // Glow pulse behind cards at 10% intensity
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowPulse = 0.1 // 10% intensity (0.1 * 0.2 multiplier = 0.02 = 2% opacity)
            }
        }
        
        // Signal animation complete (after all cards have shuffled in)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            animationComplete = true
        }
    }
    
    private func startGlowPulse() {
        // Glow pulse behind cards at 10% intensity (called after shuffle completes)
        // This is handled in startCardShuffle, but keep this for continuous pulse
    }
}
