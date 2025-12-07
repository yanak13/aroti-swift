//
//  PracticeStepView.swift
//  Aroti
//
//  Individual step screen in guided practice
//

import SwiftUI

struct PracticeStepView: View {
    let practice: PracticeDetail
    let currentStepIndex: Int
    let totalSteps: Int
    let onNext: () -> Void
    let onBack: () -> Void
    
    @State private var contentOpacity: Double = 0
    @State private var backButtonOpacity: Double = 0
    
    private var currentStep: String {
        guard currentStepIndex < practice.steps.count else {
            return ""
        }
        return practice.steps[currentStepIndex]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator at top (minimal)
            VStack(spacing: 12) {
                Text("Step \(currentStepIndex + 1) of \(totalSteps)")
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.top, 24)
                
                // Subtle progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.white.opacity(0.08))
                            .frame(height: 1.5)
                        
                        Rectangle()
                            .fill(DesignColors.accent.opacity(0.6))
                            .frame(width: geometry.size.width * CGFloat(currentStepIndex + 1) / CGFloat(totalSteps), height: 1.5)
                    }
                }
                .frame(height: 1.5)
            }
            .padding(.horizontal, DesignSpacing.sm)
            
            Spacer()
                .frame(minHeight: 60)
            
            // Main instruction (centered, large, breathable)
            VStack(spacing: 0) {
                Text(currentStep)
                    .font(.system(size: 26, weight: .regular, design: .default))
                    .foregroundColor(DesignColors.foreground)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, DesignSpacing.lg)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .opacity(contentOpacity)
            
            Spacer()
                .frame(minHeight: 60)
            
            // Navigation buttons at bottom (fixed position, no jumping)
            VStack(spacing: 12) {
                // Next button (always visible, fixed position)
                Button(action: {
                    HapticFeedback.impactOccurred(.medium)
                    onNext()
                }) {
                    Text(currentStepIndex < totalSteps - 1 ? "Next" : "Complete")
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(DesignColors.accent)
                                .shadow(color: DesignColors.accent.opacity(0.35), radius: 10, x: 0, y: 6)
                        )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Back button (always reserves space, smoothly fades in/out)
                Button(action: {
                    HapticFeedback.impactOccurred(.light)
                    onBack()
                }) {
                    Text("Back")
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(DesignColors.mutedForeground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(backButtonOpacity)
                .disabled(backButtonOpacity < 0.5)
                // Always reserve space (44px height) to keep Next button position fixed
            }
            .padding(.horizontal, DesignSpacing.sm)
            .padding(.bottom, 48)
        }
        .onAppear {
            // Animate content in
            withAnimation(.easeInOut(duration: 0.4)) {
                contentOpacity = 1
            }
            
            // Animate back button
            withAnimation(.easeInOut(duration: 0.3).delay(0.2)) {
                backButtonOpacity = currentStepIndex > 0 ? 1.0 : 0.0
            }
        }
        .onChange(of: currentStepIndex) { _, newIndex in
            // Smooth cross-fade for text
            withAnimation(.easeInOut(duration: 0.2)) {
                contentOpacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    contentOpacity = 1
                }
            }
            
            // Smooth back button fade
            withAnimation(.easeInOut(duration: 0.3)) {
                backButtonOpacity = newIndex > 0 ? 1.0 : 0.0
            }
        }
    }
}

