//
//  ShareButton.swift
//  Aroti
//
//  Share button for Core Guidance cards with Moonly-inspired design
//

import SwiftUI

struct ShareButton: View {
    let onShare: () -> Void
    @State private var isVisible: Bool = false
    @State private var scale: CGFloat = 0.9
    @State private var opacity: Double = 0.0
    @State private var autoHideTimer: Timer?
    
    var body: some View {
        Button(action: {
            onShare()
        }) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 18, weight: .medium))
                Text("Stories")
                    .font(DesignTypography.subheadFont(weight: .medium))
            }
            .foregroundColor(DesignColors.foreground)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(
                        // Frosted glass effect
                        .ultraThinMaterial
                            .opacity(0.8)
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .opacity(opacity)
        .scaleEffect(scale)
        .onAppear {
            // Appear after 400ms
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    opacity = 1.0
                    scale = 1.0
                }
                
                // Auto-hide after ~3s
                autoHideTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                    withAnimation(.easeOut(duration: 0.3)) {
                        opacity = 0.0
                    }
                }
            }
        }
        .onTapGesture {
            // Reappear on tap if hidden
            if opacity < 0.5 {
                autoHideTimer?.invalidate()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    opacity = 1.0
                    scale = 1.0
                }
                
                // Auto-hide again after 3s
                autoHideTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                    withAnimation(.easeOut(duration: 0.3)) {
                        opacity = 0.0
                    }
                }
            }
        }
        .onDisappear {
            autoHideTimer?.invalidate()
        }
    }
}

#Preview {
    ZStack {
        CelestialBackground()
        ShareButton(onShare: {
            print("Share tapped")
        })
    }
}

