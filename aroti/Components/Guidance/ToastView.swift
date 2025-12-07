//
//  ToastView.swift
//  Aroti
//
//  Simple toast notification overlay
//

import SwiftUI

struct ToastView: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    @State private var opacity: Double = 0
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    
                    Text(message)
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.black.opacity(0.8))
                                .blur(radius: 10)
                        )
                        .opacity(opacity)
                        .padding(.bottom, 100)
                }
                .transition(.opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.2)) {
                        opacity = 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            opacity = 0
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        modifier(ToastView(isPresented: isPresented, message: message))
    }
}

