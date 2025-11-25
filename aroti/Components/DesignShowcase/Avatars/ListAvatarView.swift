//
//  ListAvatarView.swift
//  Aroti
//

import SwiftUI

struct ListAvatarView: View {
    var body: some View {
        DesignCard(title: "Avatar / List") {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: DesignRadius.main)
                    .fill(DesignColors.card)
                    .frame(width: 80, height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignRadius.main)
                            .stroke(DesignColors.primary.opacity(0.2), lineWidth: 2)
                    )
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .foregroundColor(DesignColors.mutedForeground)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("List avatar (w-20 h-20)")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.foreground)
                    Text("Used in Booking lists and SpecialistCard")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
            }
        }
    }
}

