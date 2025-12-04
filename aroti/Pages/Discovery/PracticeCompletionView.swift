//
//  PracticeCompletionView.swift
//  Aroti
//
//  Completion screen after practice
//

import SwiftUI

struct PracticeCompletionView: View {
    let practiceTitle: String
    let onReturn: () -> Void
    
    @State private var contentOpacity: Double = 0
    @State private var contentScale: CGFloat = 0.9
    
    private var completionMessage: String {
        if practiceTitle.lowercased().contains("morning") {
            return "Your morning intention is set."
        } else if practiceTitle.lowercased().contains("evening") {
            return "You've completed your reflection."
        } else if practiceTitle.lowercased().contains("gratitude") {
            return "Gratitude fills your heart."
        } else if practiceTitle.lowercased().contains("breathing") {
            return "You've found your center."
        } else {
            return "Practice complete."
        }
    }
    
    private var encouragementMessage: String {
        if practiceTitle.lowercased().contains("morning") {
            return "Carry this clarity with you today."
        } else if practiceTitle.lowercased().contains("evening") {
            return "Rest well and wake refreshed."
        } else if practiceTitle.lowercased().contains("gratitude") {
            return "Let this feeling guide your day."
        } else {
            return "Well done."
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(minHeight: 60)
            
            VStack(spacing: 32) {
                // Completion icon (minimal, calm)
                ZStack {
                    Circle()
                        .fill(DesignColors.accent.opacity(0.15))
                        .frame(width: 72, height: 72)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 36, weight: .medium))
                        .foregroundColor(DesignColors.accent)
                }
                .scaleEffect(contentScale)
                
                // Completion message (breathable spacing)
                VStack(spacing: 16) {
                    Text(completionMessage)
                        .font(.system(size: 28, weight: .medium, design: .default))
                        .foregroundColor(DesignColors.foreground)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    
                    Text(encouragementMessage)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .opacity(contentOpacity)
                .padding(.horizontal, DesignSpacing.lg)
            }
            
            Spacer()
                .frame(minHeight: 60)
            
            // Completion button - personal and friendly (same position as Next button)
            VStack(spacing: 12) {
                Button(action: {
                    HapticFeedback.impactOccurred(.medium)
                    onReturn()
                }) {
                    Text("Continue Your Journey")
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
                
                // Invisible spacer to match Back button space (keeps button at same position as Next)
                Spacer()
                    .frame(height: 44)
            }
            .padding(.horizontal, DesignSpacing.sm)
            .padding(.bottom, 48)
            .opacity(contentOpacity)
        }
        .onAppear {
            // Gentle chime
            HapticFeedback.notificationOccurred(.success)
            
            // Animate content in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                contentScale = 1.0
            }
            
            withAnimation(.easeInOut(duration: 0.4).delay(0.2)) {
                contentOpacity = 1
            }
        }
    }
}

