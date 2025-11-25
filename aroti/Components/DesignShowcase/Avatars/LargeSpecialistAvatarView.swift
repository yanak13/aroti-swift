//
//  LargeSpecialistAvatarView.swift
//  Aroti
//

import SwiftUI

struct LargeSpecialistAvatarView: View {
    var body: some View {
        DesignCard(title: "Avatar / Large Specialist") {
            HStack(spacing: 16) {
                Circle()
                    .fill(DesignColors.card)
                    .frame(width: 96, height: 96)
                    .overlay(
                        Circle()
                            .stroke(DesignColors.primary.opacity(0.2), lineWidth: 2)
                    )
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(DesignColors.mutedForeground)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Large specialist avatar (w-24 h-24)")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                    Text("Used in Specialist Profile header")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
            }
        }
    }
}

