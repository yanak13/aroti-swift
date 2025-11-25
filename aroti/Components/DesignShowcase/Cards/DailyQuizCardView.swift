//
//  DailyQuizCardView.swift
//  Aroti
//
//  Daily Quiz card matching discovery page design
//

import SwiftUI

struct DailyQuizCardView: View {
    var body: some View {
        DesignCard(title: "Card / Daily Quiz") {
            VStack(alignment: .leading, spacing: 16) {
                DailyQuizChip()
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Start Quiz")
                        .font(ArotiTextStyle.headline.weight(.medium))
                        .foregroundColor(ArotiColor.textPrimary)
                        .lineSpacing(2)
                    
                    Text("Test your tarot knowledge and earn points")
                        .font(ArotiTextStyle.subhead)
                        .foregroundColor(ArotiColor.textSecondary)
                        .lineSpacing(2)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 184, alignment: .topLeading)
            .padding(24)
            .background(
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
            )
            .shadow(color: Color.black.opacity(0.45), radius: 16, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.35), radius: 4, x: 0, y: 1)
        }
    }
}

private struct DailyQuizChip: View {
    var body: some View {
        Text("Daily Quiz")
            .font(ArotiTextStyle.caption1)
            .fontWeight(.medium)
            .foregroundColor(ArotiColor.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
    }
}
