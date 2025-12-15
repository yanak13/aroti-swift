//
//  OnboardingBirthDateView.swift
//
//  Page 10 - Birth Date
//

import SwiftUI

struct OnboardingBirthDateView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @State private var isPickerOpen = false
    
    private var hasDateSelected: Bool {
        coordinator.birthDate != nil
    }
    
    private var maximumBirthDate: Date {
        let calendar = Calendar.current
        let today = Date()
        // Maximum date is 16 years ago from today
        return calendar.date(byAdding: .year, value: -16, to: today) ?? today
    }
    
    private var dateRange: ClosedRange<Date> {
        // Allow dates from a reasonable past (e.g., 120 years ago) to 16 years ago
        let calendar = Calendar.current
        let today = Date()
        let minDate = calendar.date(byAdding: .year, value: -120, to: today) ?? today
        let maxDate = maximumBirthDate
        return minDate...maxDate
    }
    
    var body: some View {
        OnboardingPageView(
            coordinator: coordinator,
            hero: {
                BirthDateHero()
            },
            title: "What's your birth date?",
            subtitle: "We use this to calculate your chart and tailor the guidance you receive.",
            content: {
                OnboardingInputCard(
                    placeholder: "MM / DD / YYYY",
                    isSelected: hasDateSelected
                ) {
                    OnboardingDatePicker(
                        date: Binding(
                            get: { coordinator.birthDate },
                            set: { newDate in
                                coordinator.birthDate = newDate
                            }
                        ),
                        isPickerOpen: $isPickerOpen,
                        displayedComponents: [.date],
                        placeholder: "MM / DD / YYYY",
                        title: "Select Birth Date",
                        dateRange: dateRange
                    )
                }
            },
            canContinue: hasDateSelected,
            onContinue: {
                coordinator.nextPage()
            }
        )
        .blur(radius: isPickerOpen ? 8 : 0)
        .opacity(isPickerOpen ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: isPickerOpen)
    }
}
