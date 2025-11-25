//
//  TimeSlotButtonsView.swift
//  Aroti
//

import SwiftUI

struct TimeSlotButtonsView: View {
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        DesignCard(title: "Button / Time Slot") {
            VStack(alignment: .leading, spacing: 16) {
                // Morning section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Morning")
                        .font(DesignTypography.bodyFont(weight: .medium))
                        .foregroundColor(ArotiColor.textPrimary)
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        timeSlot("09:00", isActive: false)
                        timeSlot("09:30", isActive: false)
                        timeSlot("10:00", isActive: false)
                        timeSlot("10:30", isActive: false)
                        timeSlot("11:00", isActive: true)
                        timeSlot("11:30", isActive: false)
                    }
                }
                
                // Afternoon section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Afternoon")
                        .font(DesignTypography.bodyFont(weight: .medium))
                        .foregroundColor(ArotiColor.textPrimary)
                    
                    LazyVGrid(columns: columns, spacing: 8) {
                        timeSlot("12:00", isActive: false)
                        timeSlot("12:30", isActive: false)
                        timeSlot("13:00", isActive: false)
                        timeSlot("13:30", isActive: false)
                        timeSlot("14:00", isActive: false)
                        timeSlot("14:30", isActive: false)
                        timeSlot("15:00", isActive: false)
                        timeSlot("15:30", isActive: false)
                    }
                }
                
                Text("Time slot button (inactive / selected)")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(ArotiColor.textSecondary)
                    .padding(.top, 4)
            }
        }
    }
    
    private func timeSlot(_ value: String, isActive: Bool) -> some View {
        ArotiButton(
            kind: .custom(.timeSlot(isSelected: isActive)),
            title: value,
            action: {}
        )
    }
}

