//
//  UnlockButton.swift
//  Aroti
//
//  Button component showing unlock cost or premium CTA
//

import SwiftUI

struct UnlockButton: View {
    let accessStatus: AccessStatus
    let onUnlock: () -> Void
    let onUpgrade: () -> Void
    
    var body: some View {
        switch accessStatus {
        case .free, .unlocked:
            EmptyView()
            
        case .unlockableWithPoints(let cost):
            Button(action: onUnlock) {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                    Text("Unlock - \(cost) points")
                        .font(DesignTypography.subheadFont(weight: .medium))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(DesignColors.accent)
                        .shadow(color: DesignColors.accent.opacity(0.35), radius: 10, x: 0, y: 6)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
        case .premiumOnly:
            Button(action: onUpgrade) {
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
                        .shadow(color: Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.35), radius: 10, x: 0, y: 6)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        UnlockButton(
            accessStatus: .unlockableWithPoints(cost: 20),
            onUnlock: {},
            onUpgrade: {}
        )
        
        UnlockButton(
            accessStatus: .premiumOnly,
            onUnlock: {},
            onUpgrade: {}
        )
    }
    .padding()
}

