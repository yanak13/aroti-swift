//
//  HoroscopeForecastPage.swift
//  Aroti
//
//  Horoscope Forecast detail page
//

import SwiftUI

struct HoroscopeForecastPage: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    BaseHeader(
                        title: "Horoscope Forecast",
                        subtitle: "Guidance for what's coming next",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, 0)
                    
                    BaseCard {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Monthly Forecast")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Your personalized horoscope forecast for the month ahead will appear here.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 12)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        HoroscopeForecastPage()
    }
}

