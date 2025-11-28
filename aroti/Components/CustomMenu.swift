//
//  CustomMenu.swift
//  Aroti
//
//  Custom styled menu matching app design
//

import SwiftUI

struct CustomMenu<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    let alignment: Alignment
    
    init(
        isPresented: Binding<Bool>,
        alignment: Alignment = .trailing,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.alignment = alignment
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: alignment) {
            if isPresented {
                // Backdrop
                Color.black.opacity(0.1)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                    .ignoresSafeArea()
                
                // Menu content
                VStack(alignment: .leading, spacing: 0) {
                    content
                }
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 23/255, green: 20/255, blue: 31/255).opacity(0.85))
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.55), radius: 48, x: 0, y: 16)
                        .shadow(color: Color.black.opacity(0.45), radius: 16, x: 0, y: 4)
                )
                .frame(width: 192)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPresented)
    }
}

struct CustomMenuItem: View {
    let title: String
    let icon: String
    let isDestructive: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    init(
        title: String,
        icon: String,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(isDestructive ? Color.red : DesignColors.foreground)
                    .frame(width: 20)
                
                Text(title)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(isDestructive ? Color.red : DesignColors.foreground)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isHovered ? DesignColors.accent.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct CustomMenuSeparator: View {
    var body: some View {
        Divider()
            .background(Color.white.opacity(0.1))
            .padding(.vertical, 4)
    }
}

