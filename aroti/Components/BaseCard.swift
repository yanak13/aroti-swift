//
//  BaseCard.swift
//  Aroti
//
//  Base card component with glass effect
//

import SwiftUI

enum BaseCardVariant {
    case standard
    case interactive
    case secondary
}

struct BaseCard<Content: View>: View {
    let variant: BaseCardVariant
    let content: Content
    let action: (() -> Void)?
    
    init(
        variant: BaseCardVariant = .standard,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.variant = variant
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Group {
            if variant == .interactive && action != nil {
                Button(action: action!) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                cardContent
            }
        }
    }
    
    private var cardContent: some View {
        content
            .padding(16)
            .background(
                ZStack {
                    // Glass card background - dark purple-tinted color without material blur
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .fill(variant == .secondary ? ArotiColor.surface.opacity(0.5) : Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.9))
                    
                    // Liquid glass highlight at top
                    VStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.clear, Color.white.opacity(0.12), Color.clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 1)
                            .opacity(0.8)
                        Spacer()
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
            )
            .shadow(color: Color.black.opacity(0.45), radius: 8, x: 0, y: 2)
    }
}

