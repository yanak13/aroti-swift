//
//  OnboardingPickerModal.swift
//
//  Custom bottom sheet for date and time pickers
//  Premium glass blur design matching onboarding theme
//

import SwiftUI

struct OnboardingPickerModal: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var date: Date
    let displayedComponents: DatePickerComponents
    let title: String
    let dateRange: ClosedRange<Date>?
    
    @State private var tempDate: Date
    
    init(
        date: Binding<Date>,
        displayedComponents: DatePickerComponents,
        title: String,
        dateRange: ClosedRange<Date>? = nil
    ) {
        self._date = date
        self.displayedComponents = displayedComponents
        self.title = title
        self.dateRange = dateRange
        self._tempDate = State(initialValue: date.wrappedValue)
    }
    
    var body: some View {
        ZStack {
            // Background with blur and gradient
            OnboardingBackground()
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                // Header - centered title with right-aligned Done button
                HStack {
                    Spacer()
                    
                    Text(title)
                        .font(ArotiTextStyle.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(ArotiColor.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        HapticFeedback.impactOccurred(.medium)
                        date = tempDate
                        dismiss()
                    }) {
                        Text("Done")
                            .font(ArotiTextStyle.subhead)
                            .fontWeight(.semibold)
                            .foregroundColor(ArotiColor.accent)
                    }
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.top, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.md)
                
                // Picker with transparent background
                Group {
                    if let dateRange = dateRange {
                        DatePicker(
                            "",
                            selection: $tempDate,
                            in: dateRange,
                            displayedComponents: displayedComponents
                        )
                        .datePickerStyle(.wheel)
                        .accentColor(ArotiColor.accent)
                        .tint(ArotiColor.accent)
                        .colorScheme(.dark)
                        .labelsHidden()
                        .background(Color.clear)
                    } else {
                        DatePicker(
                            "",
                            selection: $tempDate,
                            displayedComponents: displayedComponents
                        )
                        .datePickerStyle(.wheel)
                        .accentColor(ArotiColor.accent)
                        .tint(ArotiColor.accent)
                        .colorScheme(.dark)
                        .labelsHidden()
                        .background(Color.clear)
                    }
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.lg)
            }
        }
        .presentationBackground {
            // Custom blur background with gradient
            ZStack {
                // Base blur
                ArotiColor.surfaceHi
                    .background(.ultraThinMaterial)
                
                // Subtle gradient overlay
                LinearGradient(
                    colors: [
                        Color.clear,
                        ArotiColor.accent.opacity(0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.visible)
        .onAppear {
            tempDate = date
        }
    }
}
