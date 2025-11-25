//
//  DatePillButtonsView.swift
//  Aroti
//

import SwiftUI

struct DatePillButtonsView: View {
    var body: some View {
        DesignCard(title: "Button / Date Pill") {
            VStack(alignment: .leading, spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 28) {
                        datePill(day: "Mon", date: "24", month: "Nov", isActive: false)
                        datePill(day: "Tue", date: "25", month: "Nov", isActive: false)
                        datePill(day: "Wed", date: "26", month: "Nov", isActive: true)
                        datePill(day: "Thu", date: "27", month: "Nov", isActive: false)
                        datePill(day: "Fri", date: "28", month: "Nov", isActive: false)
                        datePill(day: "Sat", date: "29", month: "Nov", isActive: false)
                        datePill(day: "Sun", date: "30", month: "Nov", isActive: false)
                    }
                }
                
                Text("Date pill button (inactive / active selected)")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
    
    private func datePill(day: String, date: String, month: String, isActive: Bool) -> some View {
        ArotiButton(
            kind: .custom(.datePill(isActive: isActive)),
            isDisabled: false,
            action: {},
            label: {
                VStack(spacing: 4) {
                    Text(day)
                        .font(DesignTypography.footnoteFont(weight: .medium))
                    Text(date)
                        .font(DesignTypography.title2Font(weight: .bold))
                    ZStack(alignment: .bottom) {
                        Text(month)
                            .font(DesignTypography.footnoteFont())
                        if isActive {
                            Rectangle()
                                .fill(ArotiColor.accent)
                                .frame(height: 2)
                                .offset(y: 2)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        )
        .frame(width: 46)
    }
}

