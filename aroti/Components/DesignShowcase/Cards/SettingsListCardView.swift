//
//  SettingsListCardView.swift
//  Aroti
//

import SwiftUI

struct SettingsListCardView: View {
    private let items = [
        ("wallet.pass", "Wallet & Credits"),
        ("gearshape", "Settings"),
        ("bell", "Notifications")
    ]
    
    var body: some View {
        DesignCard(title: "Card / Settings List Item") {
            VStack(spacing: 12) {
                ForEach(items, id: \.1) { icon, title in
                    HStack {
                        HStack(spacing: 12) {
                            Image(systemName: icon)
                                .font(.system(size: 18))
                                .foregroundColor(DesignColors.mutedForeground)
                            Text(title)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16))
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: DesignRadius.main)
                            .fill(DesignColors.glassPrimary.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: DesignRadius.main)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                }
            }
        }
    }
}

