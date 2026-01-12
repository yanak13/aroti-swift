//
//  FilterSheet.swift
//  Aroti
//
//  Filter sheet component matching React implementation
//

import SwiftUI

struct FilterSheet: View {
    @Binding var isPresented: Bool
    @Binding var filters: FilterState
    let specialists: [Specialist]
    
    @State private var localFilters: FilterState
    @State private var priceRange: ClosedRange<Double>
    
    private let priceMinDefault: Int = 20
    private let priceMaxDefault: Int = 80
    private let priceMin: Int = 0
    private let priceMax: Int = 120
    
    init(isPresented: Binding<Bool>, filters: Binding<FilterState>, specialists: [Specialist]) {
        self._isPresented = isPresented
        self._filters = filters
        self.specialists = specialists
        
        let currentMin = filters.wrappedValue.priceMin ?? priceMinDefault
        let currentMax = filters.wrappedValue.priceMax ?? priceMaxDefault
        
        _localFilters = State(initialValue: filters.wrappedValue)
        _priceRange = State(initialValue: Double(currentMin)...Double(currentMax))
    }
    
    var activeFilterCount: Int {
        var count = 0
        if filters.availability != nil { count += 1 }
        if filters.priceMin != nil && filters.priceMin != priceMinDefault { count += 1 }
        if filters.priceMax != nil && filters.priceMax != priceMaxDefault { count += 1 }
        if filters.rating != nil { count += 1 }
        if filters.yearsOfExperience != nil { count += 1 }
        if filters.category != nil && filters.category != "All" { count += 1 }
        count += filters.languages.count
        return count
    }
    
    var availableLanguages: [String] {
        Array(Set(specialists.flatMap { $0.languages })).sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Filter Specialists")
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(DesignColors.foreground)
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .background(
                Rectangle()
                    .fill(DesignColors.glassPrimary)
            )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                        // Category Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Category")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                FilterChip(
                                    label: "All",
                                    isSelected: localFilters.category == nil || localFilters.category == "All",
                                    action: {
                                        localFilters.category = localFilters.category == "All" ? nil : "All"
                                    }
                                )
                                
                                ForEach(["Astrology", "Therapy", "Numerology", "Reiki", "Coaching"], id: \.self) { category in
                                    FilterChip(
                                        label: category,
                                        isSelected: localFilters.category == category,
                                        action: {
                                            localFilters.category = localFilters.category == category ? nil : category
                                        }
                                    )
                                }
                            }
                        }
                        
                        // Availability Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Availability")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8)
                            ], spacing: 8) {
                                FilterChip(
                                    label: "Available today",
                                    isSelected: localFilters.availability == "today",
                                    action: {
                                        localFilters.availability = localFilters.availability == "today" ? nil : "today"
                                    }
                                )
                                
                                FilterChip(
                                    label: "Available this week",
                                    isSelected: localFilters.availability == "week",
                                    action: {
                                        localFilters.availability = localFilters.availability == "week" ? nil : "week"
                                    }
                                )
                            }
                        }
                        
                        // Price Range Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Price Range")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Spacer()
                                
                                Text(getPriceDisplayText())
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.accent)
                            }
                            
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Min: $\(Int(priceRange.lowerBound))")
                                        .font(DesignTypography.caption1Font())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    DesignSlider(
                                        value: Binding(
                                            get: { priceRange.lowerBound },
                                            set: { newValue in
                                                let clamped = min(newValue, priceRange.upperBound)
                                                priceRange = clamped...priceRange.upperBound
                                                localFilters.priceMin = Int(clamped)
                                            }
                                        ),
                                        in: Double(priceMin)...Double(priceMax),
                                        step: 10
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Max: $\(Int(priceRange.upperBound))")
                                        .font(DesignTypography.caption1Font())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    DesignSlider(
                                        value: Binding(
                                            get: { priceRange.upperBound },
                                            set: { newValue in
                                                let clamped = max(newValue, priceRange.lowerBound)
                                                priceRange = priceRange.lowerBound...clamped
                                                localFilters.priceMax = Int(clamped)
                                            }
                                        ),
                                        in: Double(priceMin)...Double(priceMax),
                                        step: 10
                                    )
                                }
                            }
                        }
                        
                        // Rating Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Rating")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8)
                            ], spacing: 8) {
                                FilterChip(
                                    label: "4.0+",
                                    isSelected: localFilters.rating == "4.0",
                                    action: {
                                        localFilters.rating = localFilters.rating == "4.0" ? nil : "4.0"
                                    }
                                )
                                
                                FilterChip(
                                    label: "4.5+",
                                    isSelected: localFilters.rating == "4.5",
                                    action: {
                                        localFilters.rating = localFilters.rating == "4.5" ? nil : "4.5"
                                    }
                                )
                            }
                        }
                        
                        // Years of Experience Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Years of Experience")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8)
                            ], spacing: 8) {
                                ForEach(["1", "3", "5", "10", "15"], id: \.self) { years in
                                    FilterChip(
                                        label: "\(years)+ years",
                                        isSelected: localFilters.yearsOfExperience == years,
                                        action: {
                                            localFilters.yearsOfExperience = localFilters.yearsOfExperience == years ? nil : years
                                        }
                                    )
                                }
                            }
                        }
                        
                        // Language Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Language")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 8),
                                GridItem(.flexible(), spacing: 8)
                            ], spacing: 8) {
                                ForEach(availableLanguages, id: \.self) { language in
                                    FilterChip(
                                        label: language,
                                        isSelected: localFilters.languages.contains(language),
                                        action: {
                                            if localFilters.languages.contains(language) {
                                                localFilters.languages.removeAll { $0 == language }
                                            } else {
                                                localFilters.languages.append(language)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 24)
                }
                
                // Bottom Action Buttons
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Button(action: {
                            localFilters = FilterState()
                            localFilters.priceMin = priceMinDefault
                            localFilters.priceMax = priceMaxDefault
                            priceRange = Double(priceMinDefault)...Double(priceMaxDefault)
                        }) {
                            Text("Clear")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                        .fill(DesignColors.glassPrimary)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                                .stroke(DesignColors.glassBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        Button(action: {
                            filters = localFilters
                            isPresented = false
                        }) {
                            Text("Apply Filters")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                        .fill(DesignColors.accent)
                                )
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(
                    Rectangle()
                        .fill(DesignColors.glassPrimary)
                )
        }
        .background(DesignColors.glassPrimary)
    }
    
    private func getPriceDisplayText() -> String {
        let min = localFilters.priceMin ?? priceMinDefault
        let max = localFilters.priceMax ?? priceMaxDefault
        let maxText = max == priceMax ? "$120+" : "$\(max)"
        return "$\(min) – \(maxText)"
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(label)
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(isSelected ? DesignColors.accent : DesignColors.mutedForeground)
                    .lineLimit(1)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(DesignColors.accent)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(isSelected ? DesignColors.accent.opacity(0.2) : DesignColors.glassPrimary)
                    .overlay(
                        Capsule()
                            .stroke(isSelected ? DesignColors.accent.opacity(0.5) : DesignColors.glassBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


