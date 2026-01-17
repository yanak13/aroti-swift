//
//  HeaderBadge.swift
//  Aroti
//
//  Premium badge component for StickyHeaderBar
//

import SwiftUI

struct HeaderBadge: View {
    let iconName: String
    let text: String?
    let action: (() -> Void)?
    let showUnreadDot: Bool
    
    init(
        iconName: String,
        text: String? = nil,
        action: (() -> Void)? = nil,
        showUnreadDot: Bool = false
    ) {
        self.iconName = iconName
        self.text = text
        self.action = action
        self.showUnreadDot = showUnreadDot
    }
    
    var body: some View {
        let content = ZStack(alignment: .topTrailing) {
            HStack(spacing: 6) {
                Image(systemName: iconName)
                    .font(.system(size: text != nil ? 13 : 16, weight: .semibold))
                    .foregroundColor(DesignColors.accent)
                
                if let text = text {
                    Text(text)
                        .font(DesignTypography.caption1Font(weight: .semibold))
                        .foregroundColor(DesignColors.accent)
                }
            }
            .padding(.horizontal, text != nil ? 12 : 0)
            .padding(.vertical, 8)
            .frame(height: 36)
            .frame(minWidth: text != nil ? nil : 36)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                DesignColors.accent.opacity(0.12),
                                DesignColors.accent.opacity(0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignColors.accent.opacity(0.25), lineWidth: 1)
                    )
            )
            .shadow(color: DesignColors.accent.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Unread indicator dot
            if showUnreadDot {
                Circle()
                    .fill(DesignColors.accent)
                    .frame(width: 8, height: 8)
                    .offset(x: -2, y: 2)
            }
        }
        
        if let action = action {
            Button(action: action) {
                content
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            content
        }
    }
}
