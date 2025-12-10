//
//  NoiseTextureView.swift
//  Aroti
//
//  Subtle noise texture overlay for depth (2-3% opacity)
//

import SwiftUI

struct NoiseTextureView: View {
    var body: some View {
        Canvas { context, size in
            // Draw subtle noise pattern
            for _ in 0..<200 {
                let x = CGFloat.random(in: 0...size.width)
                let y = CGFloat.random(in: 0...size.height)
                let opacity = Double.random(in: 0.01...0.03)
                
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: 1, height: 1)),
                    with: .color(.white.opacity(opacity))
                )
            }
        }
        .blendMode(.overlay)
        .opacity(0.5)
    }
}

#Preview {
    NoiseTextureView()
        .background(Color.black)
}
