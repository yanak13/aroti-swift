//
//  LoadingIndicator.swift
//  Aroti
//
//  Reusable loading spinner component matching design system
//

import SwiftUI

struct LoadingIndicator: View {
    var size: CGFloat = 24
    var color: Color = ArotiColor.accent
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .scaleEffect(size / 24)
    }
}

struct LoadingIndicatorWithText: View {
    var text: String = "Loading..."
    var size: CGFloat = 24
    var color: Color = ArotiColor.accent
    
    var body: some View {
        VStack(spacing: 12) {
            LoadingIndicator(size: size, color: color)
            
            Text(text)
                .font(ArotiTextStyle.caption1)
                .foregroundColor(ArotiColor.textSecondary)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        LoadingIndicator()
        LoadingIndicatorWithText(text: "Loading specialists...")
    }
    .padding()
    .background(ArotiColor.bg)
}
