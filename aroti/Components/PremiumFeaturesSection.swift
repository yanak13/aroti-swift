//
//  PremiumFeaturesSection.swift
//  Aroti
//
//  Reusable premium features section component
//

import SwiftUI

struct PremiumFeaturesSection: View {
    let title: String
    let summary: String
    let features: [String]
    let unlockButtonText: String
    let onUnlockClick: () -> Void
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(DesignTypography.subheadFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text(summary)
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .lineLimit(2)
                    }
                    
                    Spacer(minLength: 8)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(DesignColors.accent)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.32, dampingFraction: 0.86), value: isExpanded)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(DesignColors.accent.opacity(0.1))
                        )
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.02))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.06), lineWidth: 1)
                    )
            )
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(spacing: 10) {
                        ForEach(features, id: \.self) { feature in
                            Button(action: onUnlockClick) {
                                HStack(spacing: 10) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(DesignColors.accent)
                                    
                                    Text(feature)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Spacer()
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.02))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Button(action: onUnlockClick) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                            
                            Text(unlockButtonText)
                                .font(DesignTypography.subheadFont(weight: .medium))
                        }
                        .foregroundColor(DesignColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(DesignColors.accent.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity
                ))
            }
        }
        .padding(.top, 4)
    }
}

