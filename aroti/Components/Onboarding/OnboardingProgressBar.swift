//
//  OnboardingProgressBar.swift
//  Aroti
//
//  Premium progress bar for onboarding flow
//

import SwiftUI

struct OnboardingProgressBar: View {
    let progress: Double // 0.0 to 1.0
    @State private var glowPulse: Double = 0.5
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track - very subtle, blends with background
                RoundedRectangle(cornerRadius: 1.5)
                    .fill(Color.white.opacity(0.06))
                    .frame(height: 2)
                
                // Progress fill with warm animated glow
                ZStack {
                    // Soft glow trail
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(
                            LinearGradient(
                                colors: [
                                    ArotiColor.accent.opacity(0.5 * glowPulse),
                                    ArotiColor.accent.opacity(0.25 * glowPulse),
                                    Color.clear
                                ],
                                startPoint: .trailing,
                                endPoint: .leading
                            )
                        )
                        .frame(width: geometry.size.width * max(0, min(1, progress)) + 16, height: 5)
                        .blur(radius: 3)
                        .offset(x: -8)
                    
                    // Main progress bar - warm orange gradient
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(
                            LinearGradient(
                                colors: [
                                    ArotiColor.accent,
                                    ArotiColor.accent.opacity(0.9)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * max(0, min(1, progress)), height: 2)
                        .shadow(color: ArotiColor.accent.opacity(0.3), radius: 2, x: 0, y: 0)
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: progress)
            }
        }
        .frame(height: 2)
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        OnboardingProgressBar(progress: 0.0)
        OnboardingProgressBar(progress: 0.33)
        OnboardingProgressBar(progress: 0.66)
        OnboardingProgressBar(progress: 1.0)
    }
    .padding()
    .background(CelestialBackground())
}
