//
//  ConversationStartersModal.swift
//  Aroti
//
//  Full-height sheet modal for conversation starters (matching HoroscopeDetailSheet style)
//

import SwiftUI

struct ConversationStartersModal: View {
    @Environment(\.dismiss) var dismiss
    let onDismiss: () -> Void
    let onSelectStarter: (String) -> Void
    let onSelectFreeTopic: () -> Void
    
    // Dynamic starters - can be loaded from config/service
    // For now, using static list with fallback
    private var starters: [String] {
        // TODO: Load from config/service
        return [
            "What's my energy today?",
            "What should I focus on this week?",
            "How do my current transits affect my mood?",
            "What opportunities are coming my way?",
            "Help me understand my chart better"
        ]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        // Scrollable list of starters
                            ForEach(starters, id: \.self) { starter in
                                Button(action: {
                                    HapticFeedback.impactOccurred(.light)
                                    onSelectStarter(starter)
                                    dismiss()
                                }) {
                                    HStack {
                                        Text(starter)
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.foreground)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.white.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                            )
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Free Topic option
                            Button(action: {
                                HapticFeedback.impactOccurred(.light)
                                onSelectFreeTopic()
                                dismiss()
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(DesignColors.primary)
                                    
                                    Text("Start a free topic")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(DesignColors.primary.opacity(0.6))
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(DesignColors.primary.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(DesignColors.primary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                    }
                    .padding(DesignSpacing.sm)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Conversation Starters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                        dismiss()
                    }
                    .foregroundColor(DesignColors.accent)
                }
            }
        }
    }
}

