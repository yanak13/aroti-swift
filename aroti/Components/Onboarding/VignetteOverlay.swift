//
//  VignetteOverlay.swift
//  Aroti
//
//  Subtle vignette effect for premium atmospheric fade
//

import SwiftUI

struct VignetteOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Top vignette - smooth fade
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.15),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
                .frame(height: geometry.size.height * 0.3)
                .frame(maxHeight: .infinity, alignment: .top)
                
                // Bottom vignette - smooth fade
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.12)
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(height: geometry.size.height * 0.3)
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                // Side vignettes - subtle
                HStack {
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.08),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.15)
                    
                    Spacer()
                    
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.black.opacity(0.08)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.15)
                }
            }
        }
        .allowsHitTesting(false)
    }
}
