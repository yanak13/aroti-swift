//
//  OnboardingLocationPicker.swift
//
//  Location picker for onboarding with placeholder and modal presentation
//  Matches OnboardingDatePicker pattern
//

import SwiftUI

struct OnboardingLocationPicker: View {
    @Binding var location: String?
    @Binding var isPickerOpen: Bool
    let placeholder: String
    let title: String
    
    @State private var isModalPresented = false
    @State private var tempLocation: String?
    
    var body: some View {
        HStack {
            Group {
                if let location = location {
                    // Show selected location in accent color
                    Text(location)
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.accent)
                        .lineLimit(1)
                        .truncationMode(.tail)
                } else {
                    // Show placeholder in muted color
                    Text(placeholder)
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                }
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: location != nil)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            HapticFeedback.impactOccurred(.light)
            tempLocation = location
            isModalPresented = true
            isPickerOpen = true
        }
        .sheet(isPresented: $isModalPresented, onDismiss: {
            location = tempLocation
            isPickerOpen = false
        }) {
            OnboardingLocationPickerModal(
                location: Binding(
                    get: { tempLocation },
                    set: { newLocation in
                        tempLocation = newLocation
                    }
                ),
                title: title
            )
        }
    }
}
