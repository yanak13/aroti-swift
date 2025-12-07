//
//  PointsSpendModal.swift
//  Aroti
//
//  Confirmation modal for spending points
//

import SwiftUI

struct PointsSpendModal: View {
    @Binding var isPresented: Bool
    let cost: Int
    let currentBalance: Int
    let title: String
    let message: String
    let onConfirm: () -> Void
    let onUpgrade: (() -> Void)?
    
    private var hasEnoughPoints: Bool {
        currentBalance >= cost
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: hasEnoughPoints ? "star.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(hasEnoughPoints ? DesignColors.accent : Color.orange)
                    
                    Text(title)
                        .font(DesignTypography.title2Font(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .multilineTextAlignment(.center)
                    
                    Text(message)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .multilineTextAlignment(.center)
                }
                .padding(24)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Points Info
                VStack(spacing: 16) {
                    HStack {
                        Text("Cost:")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        Spacer()
                        Text("\(cost) points")
                            .font(DesignTypography.bodyFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                    }
                    
                    HStack {
                        Text("Your balance:")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        Spacer()
                        Text("\(currentBalance) points")
                            .font(DesignTypography.bodyFont(weight: .semibold))
                            .foregroundColor(hasEnoughPoints ? DesignColors.accent : Color.red)
                    }
                    
                    if !hasEnoughPoints {
                        HStack {
                            Text("You need:")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            Spacer()
                            Text("\(cost - currentBalance) more points")
                                .font(DesignTypography.bodyFont(weight: .semibold))
                                .foregroundColor(Color.orange)
                        }
                    }
                }
                .padding(24)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Actions
                VStack(spacing: 12) {
                    if hasEnoughPoints {
                        Button(action: {
                            onConfirm()
                            isPresented = false
                        }) {
                            Text("Confirm - Spend \(cost) points")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(DesignColors.accent)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Button(action: {
                            onUpgrade?()
                            isPresented = false
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 14))
                                Text("Upgrade to Premium")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 1.0, green: 0.84, blue: 0.0), Color(red: 1.0, green: 0.65, blue: 0.0)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .font(DesignTypography.subheadFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(24)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hue: 240/360, saturation: 0.25, brightness: 0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    ZStack {
        CelestialBackground()
        
        VStack {
            PointsSpendModal(
                isPresented: .constant(true),
                cost: 20,
                currentBalance: 50,
                title: "Unlock Content",
                message: "This will cost 20 points. Continue?",
                onConfirm: {},
                onUpgrade: {}
            )
        }
    }
}

