//
//  YourJourneyCardView.swift
//  Aroti
//

import SwiftUI

struct YourJourneyCardView: View {
    var body: some View {
        DesignCard(title: "Card / Your Journey") {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Your Journey")
                        .font(ArotiTextStyle.headline)
                        .foregroundColor(ArotiColor.textPrimary)
                    Spacer()
                    Circle()
                        .fill(ArotiColor.textMuted)
                        .frame(width: 4, height: 4)
                }
                
                HStack(spacing: 8) {
                    metric("7-day streak")
                    dividerDot
                    metric("24 readings")
                    dividerDot
                    metric("12 reflections")
                    dividerDot
                    metric("8 rituals")
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(ArotiColor.border)
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(ArotiColor.accent)
                            .frame(width: geometry.size.width * 0.33, height: 4)
                    }
                }
                .frame(height: 4)
                
                ArotiButton(kind: .custom(.accentCard()), isDisabled: false, action: {}, label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                        Text("View full journey")
                            .font(ArotiTextStyle.subhead)
                    }
                })
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: ArotiRadius.md)
                    .fill(ArotiColor.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .stroke(ArotiColor.border, lineWidth: 1)
                    )
            )
        }
    }
    
    private func metric(_ text: String) -> some View {
        Text(text)
            .font(ArotiTextStyle.body)
            .foregroundColor(ArotiColor.textPrimary)
    }
    
    private var dividerDot: some View {
        Text("•")
            .font(ArotiTextStyle.body)
            .foregroundColor(ArotiColor.textMuted)
    }
}

