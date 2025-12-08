//
//  ScrollReveal.swift
//  Aroti
//
//  Scroll reveal component for fade-in animations as sections become visible
//

import SwiftUI

struct ScrollReveal<Content: View>: View {
    let content: Content
    let delay: Double
    
    @State private var isVisible = false
    
    init(delay: Double = 0, @ViewBuilder content: () -> Content) {
        self.delay = delay
        self.content = content()
    }
    
    var body: some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(.easeOut(duration: 0.7).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

