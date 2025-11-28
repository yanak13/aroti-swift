//
//  CustomMenuButton.swift
//  Aroti
//
//  Custom menu button with styled menu for chat history
//

import SwiftUI

struct CustomMenuButton: View {
    let onShare: () -> Void
    let onRename: () -> Void
    let onArchive: () -> Void
    let onDelete: () -> Void
    let isArchived: Bool
    
    @State private var isMenuPresented = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                withAnimation {
                    isMenuPresented.toggle()
                }
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.05))
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            if isMenuPresented {
                CustomMenu(isPresented: $isMenuPresented, alignment: .topTrailing) {
                    CustomMenuItem(
                        title: "Share",
                        icon: "square.and.arrow.up",
                        action: {
                            isMenuPresented = false
                            onShare()
                        }
                    )
                    
                    CustomMenuItem(
                        title: "Rename",
                        icon: "pencil",
                        action: {
                            isMenuPresented = false
                            onRename()
                        }
                    )
                    
                    CustomMenuItem(
                        title: isArchived ? "Unarchive" : "Archive",
                        icon: "archivebox",
                        action: {
                            isMenuPresented = false
                            onArchive()
                        }
                    )
                    
                    CustomMenuSeparator()
                    
                    CustomMenuItem(
                        title: "Delete",
                        icon: "trash",
                        isDestructive: true,
                        action: {
                            isMenuPresented = false
                            onDelete()
                        }
                    )
                }
                .offset(x: -160, y: 40)
            }
        }
    }
}

