//
//  PracticeCard.swift
//  Aroti
//
//  Reusable practice card component matching discovery page design
//

import SwiftUI

struct PracticeCard: View {
    let title: String
    let duration: String
    let mood: String
    let gradientColors: [Color]
    let action: (() -> Void)?
    
    init(
        title: String,
        duration: String,
        mood: String = "",
        gradientColors: [Color] = [
            Color(red: 31/255, green: 30/255, blue: 51/255),
            Color(red: 17/255, green: 17/255, blue: 25/255)
        ],
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.duration = duration
        self.mood = mood
        self.gradientColors = gradientColors
        self.action = action
    }
    
    private var detailLine: String {
        guard !mood.isEmpty else { return duration }
        return "\(duration) • \(mood)"
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.85),
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.05)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("Daily Practice".uppercased())
                        .font(DesignTypography.caption1Font(weight: .medium))
                        .foregroundColor(Color.white.opacity(0.85))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                        )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(DesignTypography.title3Font(weight: DesignTypography.semibold))
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.6), radius: 8, x: 0, y: 6)
                        
                        Text(detailLine)
                            .font(DesignTypography.subheadFont(weight: DesignTypography.normal))
                            .foregroundColor(Color.white.opacity(0.85))
                            .shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 4)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("Tap to start")
                            .font(DesignTypography.caption1Font(weight: .medium))
                            .foregroundColor(Color.white.opacity(0.8))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Color.white.opacity(0.8))
                    }
                }
                .padding(24)
            }
            .frame(width: 320, height: 200)
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.black.opacity(0.4), radius: 25, x: 0, y: 18)
            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

