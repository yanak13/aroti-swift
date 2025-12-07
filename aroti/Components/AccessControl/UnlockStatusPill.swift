//
//  UnlockStatusPill.swift
//  Aroti
//
//  Clean unlock status pill component for feature cards
//

import SwiftUI

enum UnlockStatusPillType {
    case unlocked
    case freeToday
    case pointsCost(Int)
    case premium
}

struct UnlockStatusPill: View {
    let status: UnlockStatusPillType
    
    var body: some View {
        Group {
            switch status {
            case .unlocked:
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                    Text("Unlocked")
                        .font(DesignTypography.caption2Font(weight: .medium))
                }
                .foregroundColor(Color.green)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
                
            case .freeToday:
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                    Text("Free today")
                        .font(DesignTypography.caption2Font(weight: .medium))
                }
                .foregroundColor(Color.green)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                        )
                )
                
            case .pointsCost(let cost):
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                    Text("\(cost) pts to unlock")
                        .font(DesignTypography.caption2Font(weight: .medium))
                }
                .foregroundColor(Color.orange)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.orange.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                )
                
            case .premium:
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 10))
                    Text("Premium")
                        .font(DesignTypography.caption2Font(weight: .medium))
                }
                .foregroundColor(Color(red: 1.0, green: 0.84, blue: 0.0))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color(red: 1.0, green: 0.84, blue: 0.0).opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
}

struct EarnValueBadge: View {
    let points: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 9))
            Text("Earn: +\(points) pts")
                .font(DesignTypography.caption2Font())
        }
        .foregroundColor(DesignColors.accent)
    }
}

#Preview {
    VStack(spacing: 16) {
        UnlockStatusPill(status: .unlocked)
        UnlockStatusPill(status: .freeToday)
        UnlockStatusPill(status: .pointsCost(40))
        UnlockStatusPill(status: .premium)
        EarnValueBadge(points: 10)
        EarnValueBadge(points: 5)
    }
    .padding()
}

