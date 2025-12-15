//
//  PremiumAvatarView.swift
//  Aroti
//
//  Premium avatar component with cosmic gradient ring
//

import SwiftUI
import UIKit

struct PremiumAvatarView: View {
    let imageName: String?
    let userName: String
    let size: CGFloat
    
    init(imageName: String? = nil, userName: String = "", size: CGFloat = 50) {
        self.imageName = imageName
        self.userName = userName
        self.size = size
    }
    
    private var initials: String {
        let components = userName.components(separatedBy: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1)) + String(components[1].prefix(1))
        } else if !userName.isEmpty {
            return String(userName.prefix(2))
        }
        return "?"
    }
    
    private var gradientRing: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [
                        Color(hue: 250/360, saturation: 0.45, brightness: 0.55), // muted indigo - slightly increased contrast
                        Color(hue: 40/360, saturation: 0.65, brightness: 0.75)  // warm gold - slightly increased contrast
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 2.5
            )
    }
    
    var body: some View {
        ZStack {
            // Gradient ring
            gradientRing
                .frame(width: size, height: size)
            
            // Avatar content
            Group {
                if let imageName = imageName, let image = UIImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    // Initials fallback
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            Text(initials.uppercased())
                                .font(.system(size: size * 0.35, weight: .semibold))
                                .foregroundColor(DesignColors.foreground.opacity(0.8))
                        )
                }
            }
            .frame(width: size - 5, height: size - 5)
            .clipShape(Circle())
        }
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

