//
//  LocationSearchDropdown.swift
//
//  Dropdown panel for location search suggestions
//

import SwiftUI

struct LocationSearchDropdown: View {
    let suggestions: [String]
    let onSelect: (String) -> Void
    @State private var highlightedIndex: Int = 0
    
    var body: some View {
        if !suggestions.isEmpty {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(suggestions.enumerated()), id: \.offset) { index, suggestion in
                            Button(action: {
                                HapticFeedback.impactOccurred(.light)
                                onSelect(suggestion)
                            }) {
                                HStack {
                                    Text(suggestion)
                                        .font(ArotiTextStyle.body)
                                        .foregroundColor(ArotiColor.textPrimary.opacity(0.9))
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, DesignSpacing.lg)
                                .frame(height: 48)
                                .background(
                                    index == highlightedIndex ? ArotiColor.accent.opacity(0.1) : Color.clear
                                )
                            }
                            .buttonStyle(.plain)
                            
                            if index < suggestions.count - 1 {
                                Divider()
                                    .background(ArotiColor.textPrimary.opacity(0.1))
                                    .padding(.horizontal, DesignSpacing.lg)
                            }
                        }
                    }
                }
                .frame(maxHeight: 240) // Max 5 items (48px each)
            }
            .background(
                RoundedRectangle(cornerRadius: ArotiRadius.md)
                    .fill(ArotiColor.surface.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .stroke(ArotiColor.border, lineWidth: 1)
                    )
            )
            .shadow(
                color: ArotiColor.accent.opacity(0.1),
                radius: 12,
                x: 0,
                y: 4
            )
            .onAppear {
                highlightedIndex = 0
            }
        } else {
            // No results message
            VStack(spacing: 0) {
                Text("No results. Try another spelling or type full city name.")
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(DesignSpacing.lg)
                    .frame(height: 48)
            }
            .background(
                RoundedRectangle(cornerRadius: ArotiRadius.md)
                    .fill(ArotiColor.surface.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .stroke(ArotiColor.border, lineWidth: 1)
                    )
            )
            .shadow(
                color: ArotiColor.accent.opacity(0.1),
                radius: 12,
                x: 0,
                y: 4
            )
        }
    }
}
