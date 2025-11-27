//
//  AstrologyDetailSheet.swift
//  Aroti
//
//  Astrology placement detail modal
//

import SwiftUI

struct AstrologyDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    let placement: AstrologyPlacement
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(placement.title)
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(placement.description)
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Meaning")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(placement.meaning)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineSpacing(4)
                        }
                        
                        BaseCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Sign: \(placement.sign)")
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Astrology Details")
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

