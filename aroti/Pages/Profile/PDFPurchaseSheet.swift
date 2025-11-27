//
//  PDFPurchaseSheet.swift
//  Aroti
//
//  PDF report purchase modal
//

import SwiftUI

struct PDFPurchaseSheet: View {
    @Environment(\.dismiss) var dismiss
    let report: Report
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 48))
                                .foregroundColor(DesignColors.accent)
                            
                            Text(report.name)
                                .font(DesignTypography.title2Font())
                                .foregroundColor(DesignColors.foreground)
                                .multilineTextAlignment(.center)
                            
                            Text(report.description)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        
                        BaseCard {
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Price")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Spacer()
                                    
                                    Text("$\(String(format: "%.2f", report.price))")
                                        .font(DesignTypography.title2Font(weight: .semibold))
                                        .foregroundColor(DesignColors.accent)
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("What's included:")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(["Detailed analysis", "PDF download", "Lifetime access"], id: \.self) { item in
                                            HStack(spacing: 12) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(DesignColors.accent)
                                                
                                                Text(item)
                                                    .font(DesignTypography.bodyFont())
                                                    .foregroundColor(DesignColors.foreground)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        ArotiButton(
                            kind: .primary,
                            action: {
                                // Handle purchase
                                dismiss()
                            },
                            label: {
                                Text("Purchase Report")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                            }
                        )
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Purchase Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground)
                }
            }
        }
    }
}

