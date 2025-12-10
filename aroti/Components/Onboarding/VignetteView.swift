//
//  VignetteView.swift
//  Aroti
//
//  Subtle vignette for depth (2% opacity)
//

import SwiftUI

struct VignetteView: View {
    var body: some View {
        RadialGradient(
            gradient: Gradient(colors: [
                Color.clear,
                Color.black.opacity(0.02)
            ]),
            center: .center,
            startRadius: 200,
            endRadius: 600
        )
        .ignoresSafeArea()
    }
}

#Preview {
    VignetteView()
        .background(Color.gray)
}
