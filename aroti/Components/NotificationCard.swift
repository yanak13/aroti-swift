//
//  NotificationCard.swift
//  Aroti
//
//  Notification card component with Journey styling
//

import SwiftUI

struct NotificationCard: View {
    let notification: NotificationItem
    let onTap: () -> Void
    let onDismiss: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isSwiping: Bool = false
    
    var body: some View {
        Button(action: onTap) {
            // Borderless card with subtle surface
            HStack(spacing: 12) {
                // Simple glyph/dot (minimal, muted)
                Circle()
                    .fill(glyphColor)
                    .frame(width: 6, height: 6)
                    .padding(.leading, 4)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(DesignTypography.subheadFont(weight: .regular))
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(1)
                    
                    Text(notification.body)
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Unread indicator
                if !notification.isRead {
                    Circle()
                        .fill(DesignColors.accent)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                // Frosted surface without border
                RoundedRectangle(cornerRadius: ArotiRadius.md)
                    .fill(Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.4))
                    .shadow(color: shouldElevate ? DesignColors.accent.opacity(0.08) : Color.clear, radius: 12, x: 0, y: 4)
            )
            .opacity(isSwiping ? 0.5 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .offset(x: offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    // Only allow swipe right (positive translation)
                    if gesture.translation.width > 0 {
                        offset = gesture.translation.width
                        isSwiping = true
                    }
                }
                .onEnded { gesture in
                    // If swiped more than halfway, dismiss
                    if gesture.translation.width > UIScreen.main.bounds.width / 2 {
                        // Animate off screen
                        withAnimation(.easeOut(duration: 0.2)) {
                            offset = UIScreen.main.bounds.width
                        }
                        // Dismiss after animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onDismiss()
                        }
                    } else {
                        // Spring back
                        withAnimation(.spring()) {
                            offset = 0
                            isSwiping = false
                        }
                    }
                }
        )
    }
    
    // MARK: - Glyph Styling (Minimal & Muted)
    
    private var glyphColor: Color {
        // Premium moments get slightly brighter copper
        let isPremium = notification.type == .monthlyForecast || 
                       notification.type == .newLevelUnlocked ||
                       notification.type == .premiumFeatureUnlocked
        
        return isPremium 
            ? DesignColors.accent.opacity(0.6)
            : DesignColors.mutedForeground.opacity(0.4)
    }
    
    // Premium moments get extra spacing for subtle elevation
    private var shouldElevate: Bool {
        notification.type == .monthlyForecast || 
        notification.type == .newLevelUnlocked ||
        notification.type == .premiumFeatureUnlocked
    }
}
