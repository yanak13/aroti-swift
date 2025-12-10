//
//  WelcomeView.swift
//  Aroti
//
//  Welcome page - Screen 1 of onboarding
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var sparklePositions: [CGPoint] = []
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            // Sparkle Animation
            ForEach(0..<12, id: \.self) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 2, height: 2)
                    .opacity(0.6)
                    .position(
                        x: sparklePositions[safe: index]?.x ?? 0,
                        y: sparklePositions[safe: index]?.y ?? 0
                    )
                    .animation(
                        Animation.easeInOut(duration: 2 + Double.random(in: 0...2))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: sparklePositions[safe: index]
                    )
            }
            
            // Constellation Drift
            Canvas { context, size in
                let points: [CGPoint] = [
                    CGPoint(x: size.width * 0.25, y: size.height * 0.25),
                    CGPoint(x: size.width * 0.75, y: size.height * 0.25),
                    CGPoint(x: size.width * 0.5, y: size.height * 0.5),
                    CGPoint(x: size.width * 0.25, y: size.height * 0.75),
                    CGPoint(x: size.width * 0.75, y: size.height * 0.75)
                ]
                
                for point in points {
                    context.fill(
                        Path(ellipseIn: CGRect(x: point.x - 1.5, y: point.y - 1.5, width: 3, height: 3)),
                        with: .color(.white.opacity(0.3))
                    )
                }
                
                // Connecting lines
                context.stroke(
                    Path { path in
                        path.move(to: points[0])
                        path.addLine(to: points[2])
                        path.move(to: points[1])
                        path.addLine(to: points[2])
                        path.move(to: points[2])
                        path.addLine(to: points[3])
                        path.move(to: points[2])
                        path.addLine(to: points[4])
                    },
                    with: .color(.white.opacity(0.2)),
                    lineWidth: 0.5
                )
            }
            .opacity(0.2)
            
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 24) {
                    Text("Your journey to clarity starts here")
                        .font(ArotiTextStyle.largeTitle)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Text("Astrology, Numerology, Tarot — all unified to guide your path.")
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    ArotiButton(
                        kind: .primary,
                        title: "Continue",
                        action: {
                            onboardingManager.currentScreen = .valueCarousel
                        }
                    )
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            setupSparkles()
        }
    }
    
    private func setupSparkles() {
        let screenSize = UIScreen.main.bounds.size
        sparklePositions = (0..<12).map { _ in
            CGPoint(
                x: CGFloat.random(in: 0...screenSize.width),
                y: CGFloat.random(in: 0...screenSize.height)
            )
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

