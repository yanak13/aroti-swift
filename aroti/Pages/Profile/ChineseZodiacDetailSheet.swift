//
//  ChineseZodiacDetailSheet.swift
//  Aroti
//
//  Chinese Zodiac detail modal
//

import SwiftUI

struct ChineseZodiacDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let blueprint: ChineseZodiacBlueprint
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(blueprint.fullSign) — \(blueprint.animal)")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Born in \(blueprint.year)")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Description")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(blueprint.description)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineSpacing(4)
                        }
                        
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Key Traits")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(blueprint.traits, id: \.self) { trait in
                                        HStack(spacing: 8) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(DesignColors.accent)
                                            Text(trait)
                                                .font(DesignTypography.bodyFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                }
                            }
                        }
                        
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Compatibility")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text("Most compatible with: \(blueprint.compatibility.joined(separator: ", "))")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Lucky Numbers")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                HStack(spacing: 8) {
                                    ForEach(blueprint.luckyNumbers, id: \.self) { number in
                                        Text("\(number)")
                                            .font(DesignTypography.bodyFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(DesignColors.accent.opacity(0.2))
                                            )
                                    }
                                }
                            }
                        }
                        
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Lucky Colors")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                HStack(spacing: 8) {
                                    ForEach(blueprint.luckyColors, id: \.self) { color in
                                        Text(color)
                                            .font(DesignTypography.bodyFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(DesignColors.accent.opacity(0.2))
                                            )
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Chinese Zodiac")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.accent)
                }
            }
        }
    }
}

