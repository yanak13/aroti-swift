//
//  AccessBadge.swift
//  Aroti
//
//  Badge component showing "Free", "Premium", "Unlocked" status
//

import SwiftUI

struct AccessBadge: View {
    let accessStatus: AccessStatus
    
    var body: some View {
        Group {
            switch accessStatus {
            case .free:
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                    Text("Free")
                        .font(DesignTypography.caption2Font(weight: .medium))
                }
                .foregroundColor(DesignColors.accent)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(DesignColors.accent.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                        )
                )
                
            case .unlockableWithPoints(let cost):
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                    Text("\(cost) pts")
                        .font(DesignTypography.caption2Font(weight: .medium))
                }
                .foregroundColor(DesignColors.accent)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(DesignColors.accent.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                        )
                )
                
            case .premiumOnly:
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 10))
                    Text("Premium")
                        .font(DesignTypography.caption2Font(weight: .medium))
                }
                .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.3), lineWidth: 1)
                        )
                )
                
            case .unlocked:
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                    Text("Unlocked")
                        .font(DesignTypography.caption2Font(weight: .medium))
                }
                .foregroundColor(Color.green)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        AccessBadge(accessStatus: .free)
        AccessBadge(accessStatus: .unlockableWithPoints(cost: 20))
        AccessBadge(accessStatus: .premiumOnly)
        AccessBadge(accessStatus: .unlocked)
    }
    .padding()
}

