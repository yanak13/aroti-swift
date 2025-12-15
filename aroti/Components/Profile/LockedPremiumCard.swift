//
//  LockedPremiumCard.swift
//  Aroti
//
//  Locked premium content card component
//

import SwiftUI

struct LockedPremiumCard: View {
    let title: String
    let teaserLine: String
    let previewText: String?
    let onUnlockClick: () -> Void
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    // Lock icon
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(DesignColors.accent)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(DesignColors.accent.opacity(0.1))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(DesignTypography.subheadFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text(teaserLine)
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                }
                
                // Preview text (optional)
                if let previewText = previewText {
                    Text(previewText)
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                        .italic()
                        .padding(.top, 4)
                }
                
                // Unlock button
                Button(action: onUnlockClick) {
                    HStack {
                        Spacer()
                        Text("Unlock Premium")
                            .font(DesignTypography.subheadFont(weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(DesignColors.accent)
                    )
                }
                .padding(.top, 8)
            }
        }
    }
}
