//
//  NumerologyDetailSheet.swift
//  Aroti
//
//  Numerology detail modal
//

import SwiftUI

struct NumerologyDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let blueprint: NumerologyBlueprint?
    
    init(blueprint: NumerologyBlueprint? = nil) {
        self.blueprint = blueprint
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if let blueprint = blueprint {
                            // Life Path Number
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Life Path \(blueprint.lifePath.number) — \(blueprint.lifePath.name)")
                                    .font(DesignTypography.title2Font())
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(blueprint.lifePath.description)
                                    .font(DesignTypography.subheadFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Meaning")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(blueprint.lifePath.meaning)
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
                                        ForEach(blueprint.lifePath.traits, id: \.self) { trait in
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
                            
                            // Premium Numbers
                            if let destiny = blueprint.destiny {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Destiny Number \(destiny.number)")
                                        .font(DesignTypography.title3Font(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(destiny.description)
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text(destiny.meaning)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineSpacing(4)
                                }
                            }
                            
                            if let expression = blueprint.expression {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Expression Number \(expression.number)")
                                        .font(DesignTypography.title3Font(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(expression.description)
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text(expression.meaning)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineSpacing(4)
                                }
                            }
                            
                            if let soulUrge = blueprint.soulUrge {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Soul Urge \(soulUrge.number)")
                                        .font(DesignTypography.title3Font(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(soulUrge.description)
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text(soulUrge.meaning)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineSpacing(4)
                                }
                            }
                            
                            if let birthday = blueprint.birthday {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Birthday Number \(birthday.number)")
                                        .font(DesignTypography.title3Font(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(birthday.description)
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text(birthday.meaning)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineSpacing(4)
                                }
                            }
                        } else {
                            Text("No numerology data available")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Numerology")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
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

