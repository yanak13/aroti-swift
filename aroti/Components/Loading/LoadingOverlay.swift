//
//  LoadingOverlay.swift
//  Aroti
//
//  Full-screen loading overlay
//

import SwiftUI

struct LoadingOverlay: View {
    var message: String? = nil
    var isVisible: Bool = true
    
    var body: some View {
        if isVisible {
            ZStack {
                // Background overlay
                ArotiColor.overlayScrim
                    .ignoresSafeArea()
                
                // Loading content
                VStack(spacing: 16) {
                    LoadingIndicator(size: 32, color: ArotiColor.accent)
                    
                    if let message = message {
                        Text(message)
                            .font(ArotiTextStyle.body)
                            .foregroundColor(ArotiColor.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .fill(ArotiColor.surfaceHi)
                        .overlay(
                            RoundedRectangle(cornerRadius: ArotiRadius.lg)
                                .stroke(ArotiColor.border, lineWidth: 1)
                        )
                )
                .padding(32)
            }
            .transition(.opacity)
        }
    }
}

struct LoadingViewModifier: ViewModifier {
    @Binding var isLoading: Bool
    var message: String? = nil
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
            
            if isLoading {
                LoadingOverlay(message: message, isVisible: isLoading)
            }
        }
    }
}

extension View {
    func loadingOverlay(isLoading: Binding<Bool>, message: String? = nil) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading, message: message))
    }
}

#Preview {
    ZStack {
        ArotiColor.bg
            .ignoresSafeArea()
        
        VStack {
            Text("Content")
                .foregroundColor(ArotiColor.textPrimary)
        }
        .loadingOverlay(isLoading: .constant(true), message: "Loading data...")
    }
}
