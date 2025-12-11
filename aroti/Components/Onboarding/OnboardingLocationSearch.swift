//
//  OnboardingLocationSearch.swift
//
//  Location search input for onboarding
//

import SwiftUI

struct OnboardingLocationSearch: View {
    @Binding var location: String
    @State private var searchText: String = ""
    
    var body: some View {
        HStack(spacing: DesignSpacing.sm) {
            Image(systemName: "location")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(ArotiColor.textSecondary)
            
            TextField("Search for location", text: $searchText)
                .font(ArotiTextStyle.body)
                .foregroundColor(ArotiColor.textPrimary)
                .autocapitalization(.words)
                .onChange(of: searchText) { oldValue, newValue in
                    location = newValue
                }
        }
        .padding(.horizontal, DesignSpacing.lg)
        .padding(.vertical, DesignSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.md)
                .fill(ArotiColor.inputBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .stroke(ArotiColor.inputBorder, lineWidth: 1)
                )
        )
    }
}
