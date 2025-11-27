//
//  SpecialistCard.swift
//  Aroti
//
//  Specialist card component for booking listing
//

import SwiftUI

struct SpecialistCard: View {
    let specialist: Specialist
    @State private var isFavorite: Bool = false
    let onTap: () -> Void
    let onBookSession: () -> Void
    let onText: () -> Void
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        BaseCard(variant: .interactive, action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Avatar + Info Row
                HStack(alignment: .top, spacing: 12) {
                    // Avatar
                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                        .fill(ArotiColor.accent.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(specialist.name.prefix(2).uppercased())
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(ArotiColor.accent)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                .stroke(ArotiColor.accent.opacity(0.2), lineWidth: 2)
                        )
                    
                    // Info Column
                    VStack(alignment: .leading, spacing: 4) {
                        // Name + Favorite
                        HStack {
                            Text(specialist.name)
                                .font(DesignTypography.title3Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Spacer()
                            
                            Button(action: {
                                isFavorite.toggle()
                                onFavoriteToggle()
                            }) {
                                Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                                    .foregroundColor(isFavorite ? ArotiColor.accent : ArotiColor.textSecondary)
                                    .font(.system(size: 20))
                            }
                        }
                        
                        // Specialty + Price
                        HStack {
                            Text(specialist.specialty)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Spacer()
                            
                            HStack(spacing: 0) {
                                Text("$\(specialist.price)")
                                    .font(DesignTypography.bodyFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                Text(" / session")
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        
                        // Rating + Reviews + Sessions
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(ArotiColor.accent)
                                .font(.system(size: 12))
                            
                            Text(String(format: "%.1f", specialist.rating))
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Text("(\(specialist.reviewCount))")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Text("•")
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Text("\(specialist.sessionCount)+ sessions")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Text("•")
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Text("\(specialist.yearsOfPractice) years")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    ArotiButton(
                        kind: .custom(.glassCardButton()),
                        title: "Text",
                        action: onText
                    )
                    
                    ArotiButton(
                        kind: .custom(.accentCard()),
                        title: "Book session",
                        action: onBookSession
                    )
                }
            }
        }
    }
}

