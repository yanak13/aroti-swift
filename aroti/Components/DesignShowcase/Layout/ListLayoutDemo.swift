//
//  ListLayoutDemo.swift
//  Aroti
//

import SwiftUI

struct ListLayoutDemo: View {
    private let items = [
        ("creditcard", "Wallet & Credits"),
        ("gearshape", "Settings"),
        ("bell", "Notifications")
    ]
    
    var body: some View {
        DesignCard(title: "List Layout") {
            VStack(alignment: .leading, spacing: 12) {
                VStack(spacing: 8) {
                    ForEach(items, id: \.1) { icon, title in
                        listItem(icon: icon, title: title)
                    }
                }
                
                Text("Single list row layout used for Account & Settings")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
    
    private func listItem(icon: String, title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(DesignColors.mutedForeground)
                .frame(width: 20, height: 20)
            
            Text(title)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 20))
                .foregroundColor(DesignColors.mutedForeground)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: DesignRadius.main)
                .fill(DesignColors.card.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignRadius.main)
                        .stroke(DesignColors.border.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

