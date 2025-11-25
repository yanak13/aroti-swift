//
//  CalendarShowcase.swift
//  Aroti
//

import SwiftUI

struct CalendarShowcase: View {
    @State private var selectedDate = 23
    
    var body: some View {
        DesignCard(title: "Calendar / DatePicker") {
            VStack(spacing: 16) {
                HStack {
                    Text("November 2025")
                        .font(DesignTypography.title3Font(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(DesignTypography.caption1Font(weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                let firstDayOfMonth = 6
                let daysInMonth = 30
                let totalCells = firstDayOfMonth + daysInMonth
                let weeks = (totalCells + 6) / 7
                
                VStack(spacing: 8) {
                    ForEach(0..<weeks, id: \.self) { week in
                        HStack(spacing: 0) {
                            ForEach(0..<7, id: \.self) { day in
                                let cellIndex = week * 7 + day
                                let dayNumber = cellIndex - firstDayOfMonth + 1
                                
                                if cellIndex >= firstDayOfMonth && dayNumber <= daysInMonth {
                                    Button(action: {
                                        selectedDate = dayNumber
                                    }) {
                                        Text("\(dayNumber)")
                                            .font(DesignTypography.bodyFont(weight: selectedDate == dayNumber ? .semibold : .regular))
                                            .foregroundColor(selectedDate == dayNumber ? ArotiColor.accentText : ArotiColor.textPrimary)
                                            .frame(width: 40, height: 40)
                                            .background(
                                                Circle()
                                                    .fill(selectedDate == dayNumber ? ArotiColor.accent : Color.clear)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    Color.clear
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

