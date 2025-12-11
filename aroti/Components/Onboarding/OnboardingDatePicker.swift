//
//  OnboardingDatePicker.swift
//
//  Date picker for onboarding with placeholder and modal presentation
//

import SwiftUI

struct OnboardingDatePicker: View {
    @Binding var date: Date?
    @Binding var isPickerOpen: Bool
    let displayedComponents: DatePickerComponents
    let placeholder: String
    let title: String
    
    @State private var isModalPresented = false
    @State private var tempDate: Date
    
    init(
        date: Binding<Date?>,
        isPickerOpen: Binding<Bool> = .constant(false),
        displayedComponents: DatePickerComponents,
        placeholder: String,
        title: String
    ) {
        self._date = date
        self._isPickerOpen = isPickerOpen
        self.displayedComponents = displayedComponents
        self.placeholder = placeholder
        self.title = title
        self._tempDate = State(initialValue: date.wrappedValue ?? Date())
    }
    
    var body: some View {
        HStack {
            Group {
                if let date = date {
                    // Show formatted date/time in accent color
                    Text(formattedValue(from: date))
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.accent)
                } else {
                    // Show placeholder in muted color
                    Text(placeholder)
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                }
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: date != nil)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            HapticFeedback.impactOccurred(.light)
            tempDate = date ?? Date()
            isModalPresented = true
            isPickerOpen = true
        }
        .sheet(isPresented: $isModalPresented, onDismiss: {
            date = tempDate
            isPickerOpen = false
        }) {
            OnboardingPickerModal(
                date: Binding(
                    get: { tempDate },
                    set: { newDate in
                        tempDate = newDate
                    }
                ),
                displayedComponents: displayedComponents,
                title: title
            )
        }
    }
    
    private func formattedValue(from date: Date) -> String {
        if displayedComponents.contains(.date) && displayedComponents.contains(.hourAndMinute) {
            return date.formattedBirthDate() + " at " + date.formattedTime()
        } else if displayedComponents.contains(.date) {
            return date.formattedBirthDate()
        } else if displayedComponents.contains(.hourAndMinute) {
            return date.formattedTime()
        }
        return date.formattedBirthDate()
    }
}
