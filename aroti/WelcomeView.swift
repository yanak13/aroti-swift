//
//  WelcomeView.swift
//  Aroti
//
//  Welcome page - Screen 1 of onboarding (Cinematic)
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var sparklePositions: [CGPoint] = []
    @State private var constellationOpacity: Double = 0
    @State private var buttonPulse: Double = 1.0
    @State private var titleLineOpacity: Double = 0
    @State private var titleLineWidth: CGFloat = 0
    @State private var titleOffset: CGFloat = 20
    @State private var titleOpacity: Double = 0
    @State private var subtitleOffset: CGFloat = 15
    @State private var subtitleOpacity: Double = 0
    @State private var ctaOffset: CGFloat = 40
    @State private var ctaOpacity: Double = 0
    @State private var orbitingSparkles: [CGPoint] = []
    
    var body: some View {
        ZStack {
            // Full-screen dark gradient background (curved, organic fade)
            ZStack {
                // Base gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 13/255, green: 12/255, blue: 18/255), // #0D0C12
                        Color(red: 20/255, green: 18/255, blue: 33/255), // #1A1821
                        Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.12) // terracotta glow (reduced)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Curved organic fade (center brighter, edges darker)
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.08),
                        Color.clear
                    ]),
                    center: UnitPoint(x: 0.5, y: 0.7),
                    startRadius: 200,
                    endRadius: 600
                )
            }
            .ignoresSafeArea()
            
            // Subtle vignette for depth
            VignetteView()
            
            // Subtle noise texture overlay
            NoiseTextureView()
            
            // Subtle star particles slowly drifting (sparkles rise slowly)
            ForEach(0..<25, id: \.self) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 1.5, height: 1.5)
                    .opacity(0.1)
                    .position(
                        x: sparklePositions[safe: index]?.x ?? 0,
                        y: sparklePositions[safe: index]?.y ?? 0
                    )
                    .animation(
                        .linear(duration: 25 + Double(index) * 1.5)
                            .repeatForever(autoreverses: false),
                        value: sparklePositions[safe: index]?.y
                    )
            }
            
            // Thin line appears (hero entrance)
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.3),
                            Color(red: 227/255, green: 177/255, blue: 116/255).opacity(0.2),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: titleLineWidth, height: 1)
                .blur(radius: 1)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.25)
                .opacity(titleLineOpacity)
            
            // Faint constellation lines behind text (fade in/out, occasionally brighten)
            Canvas { context, size in
                let points: [CGPoint] = [
                    CGPoint(x: size.width * 0.2, y: size.height * 0.3),
                    CGPoint(x: size.width * 0.5, y: size.height * 0.25),
                    CGPoint(x: size.width * 0.8, y: size.height * 0.35),
                    CGPoint(x: size.width * 0.3, y: size.height * 0.6),
                    CGPoint(x: size.width * 0.7, y: size.height * 0.65)
                ]
                
                // Connecting lines with varying opacity
                let lineOpacity = 0.1 + (constellationOpacity * 0.05)
                context.stroke(
                    Path { path in
                        path.move(to: points[0])
                        path.addLine(to: points[1])
                        path.move(to: points[1])
                        path.addLine(to: points[2])
                        path.move(to: points[1])
                        path.addLine(to: points[3])
                        path.move(to: points[2])
                        path.addLine(to: points[4])
                    },
                    with: .color(.white.opacity(lineOpacity)),
                    lineWidth: 0.5
                )
            }
            .opacity(constellationOpacity)
            
            // Light sparkles orbit slowly
            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 2, height: 2)
                    .position(
                        x: orbitingSparkles[safe: i]?.x ?? 0,
                        y: orbitingSparkles[safe: i]?.y ?? 0
                    )
            }
            
            // Soft glowing orb behind title (8% opacity, atmospheric)
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
                .frame(width: 250, height: 250)
                .blur(radius: 150)
            
            // Subtle vignette layer for depth (2% opacity)
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(0.02)
                ]),
                center: .center,
                startRadius: 200,
                endRadius: 400
            )
            .blur(radius: 100)
            .ignoresSafeArea()
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.35)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    OnboardingSkipButton()
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                }
                
                Spacer()
                
                VStack(spacing: 32) {
                    // Title (fades in with slight upward movement)
                    Text("Your journey to clarity starts here")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .lineSpacing(4)
                        .offset(y: titleOffset)
                        .opacity(titleOpacity)
                    
                    // Subtitle (fades in after 0.2s)
                    Text("A personalized journey shaped from your birth data and energy.")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(ArotiColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .lineSpacing(2)
                        .offset(y: subtitleOffset)
                        .opacity(subtitleOpacity)
                    
                    // Emotional microcopy
                    Text("Let intuition, clarity, and meaning guide you forward.")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(ArotiColor.textSecondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                        .opacity(subtitleOpacity)
                }
                
                Spacer()
                
                // Premium CTA Button with outer glow and soft orange-pink glow (slides up last)
                ZStack {
                    // Outer glow (faint)
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.3),
                                    Color(red: 255/255, green: 180/255, blue: 150/255).opacity(0.2) // soft orange-pink
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 56)
                        .blur(radius: 15)
                        .scaleEffect(buttonPulse)
                        .offset(y: ctaOffset)
                        .opacity(ctaOpacity)
                    
                    Button(action: {
                        onboardingManager.currentScreen = .valueCarousel
                    }) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 201/255, green: 120/255, blue: 72/255), // terracotta
                                        Color(red: 227/255, green: 177/255, blue: 116/255) // amber
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
                                                Color(red: 255/255, green: 200/255, blue: 170/255).opacity(0.3), // soft orange-pink
                                                Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.2)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(color: Color(red: 201/255, green: 120/255, blue: 72/255).opacity(0.4), radius: 20, x: 0, y: 8)
                            .shadow(color: Color(red: 255/255, green: 180/255, blue: 150/255).opacity(0.2), radius: 30, x: 0, y: 0)
                            .scaleEffect(buttonPulse)
                    }
                    .offset(y: ctaOffset)
                    .opacity(ctaOpacity)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            setupSparkles()
            setupOrbitingSparkles()
            startWelcomeAnimation()
            
            withAnimation(.easeIn(duration: 1.5)) {
                constellationOpacity = 1.0
            }
            
            // Button pulse animation
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                buttonPulse = 1.02
            }
        }
    }
    
    private func setupSparkles() {
        let screenSize = UIScreen.main.bounds.size
        sparklePositions = (0..<25).map { index in
            CGPoint(
                x: CGFloat.random(in: 0...screenSize.width),
                y: screenSize.height + CGFloat.random(in: 0...100) // Start below screen
            )
        }
        
        // Animate particles rising slowly (sparkles drift upward)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var updatedPositions: [CGPoint] = []
            for i in 0..<25 {
                let startX = sparklePositions[i].x
                let targetX = startX + CGFloat.random(in: -50...50)
                let targetY = -100.0 // Move above screen
                updatedPositions.append(CGPoint(x: targetX, y: targetY))
            }
            withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
                sparklePositions = updatedPositions
            }
        }
        
        // Constellation lines fade in/out and occasionally brighten
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 2)) {
                constellationOpacity = Double.random(in: 0.8...1.0)
            }
        }
    }
    
    private func setupOrbitingSparkles() {
        let centerX = UIScreen.main.bounds.width / 2
        let centerY = UIScreen.main.bounds.height * 0.35
        let radius: CGFloat = 150
        
        orbitingSparkles = (0..<8).map { i in
            let angle = Double(i) * (2 * .pi / 8)
            return CGPoint(
                x: centerX + radius * cos(angle),
                y: centerY + radius * sin(angle)
            )
        }
        
        // Animate sparkles orbiting slowly
        for i in 0..<8 {
            withAnimation(.linear(duration: 20 + Double(i) * 2).repeatForever(autoreverses: false)) {
                let angle = Double(i) * (2 * .pi / 8) + 2 * .pi
                orbitingSparkles[i] = CGPoint(
                    x: centerX + radius * cos(angle),
                    y: centerY + radius * sin(angle)
                )
            }
        }
    }
    
    private func startWelcomeAnimation() {
        // Step 1: Thin line appears
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.6)) {
                titleLineOpacity = 1.0
                titleLineWidth = 200
            }
        }
        
        // Step 2: Title fades in with slight upward movement (after line)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.6)) {
                titleOffset = 0
                titleOpacity = 1.0
            }
        }
        
        // Step 3: Subtitle fades in after 0.2s
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.6)) {
                subtitleOffset = 0
                subtitleOpacity = 1.0
            }
        }
        
        // Step 4: CTA slides up last
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                ctaOffset = 0
                ctaOpacity = 1.0
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}

