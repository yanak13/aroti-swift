//
//  BirthDataPromptCard.swift
//  Aroti
//
//  Prompt card for missing birth data
//

import SwiftUI

struct BirthDataPromptCard: View {
    let onEditProfile: () -> Void
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(DesignColors.accent)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(DesignColors.accent.opacity(0.1))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Complete your birth details")
                            .font(DesignTypography.subheadFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("Add birth time and place to unlock deeper identity insights.")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                Button(action: onEditProfile) {
                    HStack {
                        Spacer()
                        Text("Edit Profile")
                            .font(DesignTypography.subheadFont(weight: .semibold))
                            .foregroundColor(DesignColors.accent)
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(DesignColors.accent.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.top, 8)
            }
        }
    }
}
