//
//  SortDropdown.swift
//  Aroti
//
//  Sort dropdown component matching React implementation
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case priceLow = "price-low"
    case priceHigh = "price-high"
    case rating = "rating"
    case sessions = "sessions"
    case newest = "newest"
    
    var label: String {
        switch self {
        case .priceLow: return "Price: Low to High"
        case .priceHigh: return "Price: High to Low"
        case .rating: return "Rating: High to Low"
        case .sessions: return "Most Sessions (Most Booked)"
        case .newest: return "Newest Specialists"
        }
    }
}

struct SortDropdown: View {
    @Binding var selectedOption: SortOption?
    @State private var isMenuPresented = false
    
    var body: some View {
        Menu {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(action: {
                    selectedOption = selectedOption == option ? nil : option
                }) {
                    HStack {
                        if selectedOption == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(DesignColors.accent)
                        }
                        Text(option.label)
                            .foregroundColor(selectedOption == option ? DesignColors.accent : DesignColors.foreground)
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(selectedOption?.label ?? "Sort")
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                
                Image(systemName: "chevron.down")
                    .font(.system(size: 16))
                    .foregroundColor(DesignColors.mutedForeground)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: DesignRadius.secondary)
                    .fill(DesignColors.glassPrimary)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignRadius.secondary)
                            .stroke(DesignColors.glassBorder, lineWidth: 1)
                    )
            )
        }
        .menuStyle(.borderlessButton)
    }
}

#Preview {
    SortDropdown(selectedOption: .constant(nil))
        .padding()
        .background(CelestialBackground())
}

