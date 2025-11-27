//
//  ForYouDetailPage.swift
//  Aroti
//
//  Simple detail view for For You recommendations
//

import SwiftUI

struct ForYouDetailPage: View {
    let title: String
    let subtitle: String
    let tag: String
    let category: String
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(tag.uppercased())
                        .font(DesignTypography.caption1Font(weight: .medium))
                        .foregroundColor(DesignColors.mutedForeground)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    
                    Text(title)
                        .font(DesignTypography.title2Font(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(subtitle)
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Category • \(category)")
                        .font(DesignTypography.footnoteFont(weight: .medium))
                        .foregroundColor(DesignColors.mutedForeground)
                        .padding(.top, 12)
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("For You")
        .navigationBarTitleDisplayMode(.inline)
    }
}


