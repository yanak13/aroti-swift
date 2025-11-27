//
//  NumerologyDetailSheet.swift
//  Aroti
//
//  Numerology detail modal
//

import SwiftUI

struct NumerologyDetailSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Life Path 3 — The Connector")
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Creative energy • Expression • Communication")
                                .font(DesignTypography.subheadFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Meaning")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("You're here to express, inspire, and bring people together through creativity and communication. Joy is your natural state. Your life path encourages you to share your gifts with the world and connect with others through your unique voice.")
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
                                    ForEach(["Creative energy", "Expression", "Communication"], id: \.self) { trait in
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
                    }
                    .padding()
                }
            }
            .navigationTitle("Numerology")
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

