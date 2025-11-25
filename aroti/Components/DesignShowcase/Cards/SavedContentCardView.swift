//
//  SavedContentCardView.swift
//  Aroti
//

import SwiftUI

struct SavedContentCardView: View {
    var body: some View {
        DesignCard(title: "Card / Saved Content") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    savedContentCard(title: "Celtic Cross Spread", subtitle: "Tap to view your saved content", tag: "Readings")
                }
            }
        }
    }
    
    private func savedContentCard(title: String, subtitle: String, tag: String) -> some View {
        ZStack(alignment: .topLeading) {
            // Background
            ZStack {
                // Glass card background (rgba(23, 20, 31, 0.75))
                RoundedRectangle(cornerRadius: DesignRadius.main)
                    .fill(Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.75))
                
                // Ultra thin material for glass effect
                RoundedRectangle(cornerRadius: DesignRadius.main)
                    .fill(.ultraThinMaterial)
                
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
                
                // Decorative shimmer element (top right)
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 8, height: 8)
                            .padding(.top, 8)
                            .padding(.trailing, 8)
                    }
                    Spacer()
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: DesignRadius.main)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text(tag.uppercased())
                    .font(DesignTypography.caption1Font(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.08))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            )
                    )
                
                Text(title)
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Text(subtitle)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            .padding(24)
        }
        .shadow(color: Color.black.opacity(0.45), radius: 16, x: 0, y: 4)
        .shadow(color: Color.black.opacity(0.35), radius: 4, x: 0, y: 1)
    }
}

