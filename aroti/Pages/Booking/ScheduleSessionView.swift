//
//  ScheduleSessionView.swift
//  Aroti
//
//  Date and time selection for booking
//

import SwiftUI

struct ScheduleSessionView: View {
    let specialist: Specialist
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: Date?
    @State private var selectedTime: String?
    @State private var navigationPath = NavigationPath()
    
    private let timeSlots: [String: [String]] = [
        "morning": ["09:00", "09:30", "10:00", "10:30", "11:00", "11:30"],
        "afternoon": ["12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30"],
        "evening": ["16:00", "16:30", "17:00", "17:30", "18:00", "18:30"]
    ]
    
    private var availableDates: [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<14 {
            if let date = calendar.date(byAdding: .day, value: i, to: today) {
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Specialist Summary
                        BaseCard {
                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                    .fill(ArotiColor.accent.opacity(0.2))
                                    .frame(width: 64, height: 64)
                                    .overlay(
                                        Text(specialist.name.prefix(2).uppercased())
                                            .font(DesignTypography.headlineFont(weight: .semibold))
                                            .foregroundColor(ArotiColor.accent)
                                    )
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(specialist.name)
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(specialist.specialty)
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text("$\(specialist.price) • 60 min")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        .padding(.top, 24)
                        
                        // Date Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Select Date")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                                .padding(.horizontal, DesignSpacing.md)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 28) {
                                    ForEach(availableDates, id: \.self) { date in
                                        DatePillButton(
                                            date: date,
                                            isSelected: selectedDate?.isSameDay(as: date) ?? false
                                        ) {
                                            selectedDate = date
                                            selectedTime = nil // Reset time when date changes
                                        }
                                    }
                                }
                                .padding(.horizontal, DesignSpacing.md)
                            }
                        }
                        
                        // Time Selection
                        if selectedDate != nil {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Select Time")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                    .padding(.horizontal, DesignSpacing.md)
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    ForEach(Array(timeSlots.keys.sorted()), id: \.self) { period in
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(period.capitalized)
                                                .font(DesignTypography.bodyFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                                .padding(.horizontal, DesignSpacing.md)
                                            
                                            LazyVGrid(columns: [
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8)
                                            ], spacing: 8) {
                                                ForEach(timeSlots[period] ?? [], id: \.self) { time in
                                                    TimeSlotButton(
                                                        time: time,
                                                        isSelected: selectedTime == time
                                                    ) {
                                                        selectedTime = time
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, DesignSpacing.md)
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Booking Summary (when both date and time are selected)
                        if let date = selectedDate, let time = selectedTime {
                            BookingSummaryCard(
                                specialist: specialist,
                                date: date,
                                time: time
                            )
                            .padding(.horizontal, DesignSpacing.md)
                            .padding(.top, 8)
                        }
                        
                        // Continue Button
                        if selectedDate != nil && selectedTime != nil {
                            VStack(spacing: 12) {
                                ArotiButton(
                                    kind: .custom(.accentCard()),
                                    title: "Continue",
                                    action: {
                                        if let date = selectedDate, let time = selectedTime {
                                            navigationPath.append(BookingDestination.payment(specialist, date, time))
                                        }
                                    }
                                )
                                .padding(.horizontal, DesignSpacing.md)
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(DesignColors.foreground.opacity(0.6))
                            .font(.system(size: 20))
                            .frame(width: 40, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                    }
                }
            }
            .navigationTitle("Pick Your Time")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: BookingDestination.self) { destination in
                switch destination {
                case .payment(let specialist, let date, let time):
                    PaymentSummaryView(specialist: specialist, selectedDate: date, selectedTime: time)
                default:
                    EmptyView()
                }
            }
        }
    }
}

// Date Pill Button Component
struct DatePillButton: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void
    
    private var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ArotiButton(
            kind: .custom(.datePill(isActive: isSelected)),
            action: action,
            label: {
                VStack(spacing: 4) {
                    Text(dayName)
                        .font(DesignTypography.footnoteFont(weight: .medium))
                    Text(dayNumber)
                        .font(DesignTypography.title2Font(weight: .bold))
                    ZStack(alignment: .bottom) {
                        Text(month)
                            .font(DesignTypography.footnoteFont())
                        if isSelected {
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

// Time Slot Button Component
struct TimeSlotButton: View {
    let time: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        ArotiButton(
            kind: .custom(.timeSlot(isSelected: isSelected)),
            title: formatTime(time),
            action: action
        )
    }
    
    private func formatTime(_ timeString: String) -> String {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return timeString
        }
        
        let period = hour >= 12 ? "PM" : "AM"
        let hour12 = hour % 12 == 0 ? 12 : hour % 12
        return String(format: "%d:%02d %@", hour12, minute, period)
    }
}

// Booking Summary Card
struct BookingSummaryCard: View {
    let specialist: Specialist
    let date: Date
    let time: String
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Booking Summary")
                    .font(DesignTypography.subheadFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                SummaryRow(label: "Date", value: formatDate(date))
                SummaryRow(label: "Time", value: formatTime(time))
                SummaryRow(label: "Duration", value: "60 min")
                SummaryRow(label: "Price", value: "$\(specialist.price)")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
    
    private func formatTime(_ timeString: String) -> String {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return timeString
        }
        
        let period = hour >= 12 ? "PM" : "AM"
        let hour12 = hour % 12 == 0 ? 12 : hour % 12
        return String(format: "%d:%02d %@", hour12, minute, period)
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(DesignTypography.subheadFont())
                .foregroundColor(DesignColors.mutedForeground)
            
            Spacer()
            
            Text(value)
                .font(DesignTypography.subheadFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
        }
    }
}

// Date Extension
extension Date {
    func isSameDay(as other: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: other)
    }
}

