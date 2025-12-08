//
//  WalletCreditsSheet.swift
//  Aroti
//
//  Wallet & Credits popup page
//

import SwiftUI

struct WalletCreditsSheet: View {
    @State private var credits: Int = 0
    
    var body: some View {
        GlassSheetContainer(title: "Wallet & Credits", subtitle: "Check balance and history") {
            VStack(spacing: 20) {
                // Balance Card
                BaseCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "creditcard")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.accent)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.05))
                                )
                            
                            Text("Current credits")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                        }
                        
                        Text("\(credits)")
                            .font(DesignTypography.title1Font(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("Use credits to unlock readings, rituals, and personalized insights.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // History Section
                BaseCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 12) {
                            Image(systemName: "clock")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.accent)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.05))
                                )
                            
                            Text("History")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                        }
                        
                        Text("No transactions yet.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear {
                let balance = PointsService.shared.getBalance()
                credits = balance.totalPoints
            }
        }
    }
}
