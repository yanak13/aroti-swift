//
//  PracticeTransitionView.swift
//  Aroti
//
//  Transition screen before practice begins
//

import SwiftUI

struct PracticeTransitionView: View {
    let practiceTitle: String
    let onComplete: () -> Void
    
    @State private var messageOpacity: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var hapticTimer: Timer?
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Take a moment to settle in...")
                    .font(DesignTypography.title2Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                    .opacity(messageOpacity)
                    .scaleEffect(pulseScale)
                
                Text(practiceTitle)
                    .font(DesignTypography.headlineFont(weight: .regular))
                    .foregroundColor(DesignColors.mutedForeground)
                    .opacity(messageOpacity * 0.8)
            }
            
            Spacer()
        }
        .padding(.horizontal, DesignSpacing.sm)
        .onAppear {
            // Initial haptic feedback (more intense)
            HapticFeedback.impactOccurred(.medium)
            
            // Fade in message
            withAnimation(.easeInOut(duration: 0.5)) {
                messageOpacity = 1
            }
            
            // Start pulsation animation after fade-in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                startPulsation()
                startHapticPulses()
            }
            
            // Auto-advance to first step after 3.5 seconds (gives user time to read)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                stopAnimations()
                onComplete()
            }
        }
        .onDisappear {
            stopAnimations()
        }
    }
    
    private func startPulsation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.08
        }
    }
    
    private func startHapticPulses() {
        // More intense haptic pulse every 2.0 seconds (matching pulsation rhythm)
        hapticTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            HapticFeedback.impactOccurred(.medium)
        }
    }
    
    private func stopAnimations() {
        hapticTimer?.invalidate()
        hapticTimer = nil
        withAnimation(.easeInOut(duration: 0.3)) {
            pulseScale = 1.0
        }
    }
}

