//
//  PremiumSection.swift
//  Aroti
//
//  Wrapper component for expanded premium content sections
//

import SwiftUI

struct PremiumSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(DesignTypography.bodyFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            content
        }
    }
}
