//
//  OnboardingLocationPickerModal.swift
//
//  Custom bottom sheet for location picker
//  Premium glass blur design matching onboarding theme
//

import SwiftUI
import MapKit

struct OnboardingLocationPickerModal: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var location: String?
    let title: String
    
    @State private var searchText: String = ""
    @State private var results: [LocationSuggestion] = []
    @State private var isLoading: Bool = false
    @FocusState private var isSearchFocused: Bool
    @State private var searchTask: Task<Void, Never>?
    
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
                
                // Sticky search bar
                HStack(spacing: DesignSpacing.sm) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(ArotiColor.textSecondary)
                    
                    TextField("", text: $searchText, prompt: Text("Search for location").foregroundColor(ArotiColor.textPrimary.opacity(0.6)))
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textPrimary)
                        .autocapitalization(.words)
                        .focused($isSearchFocused)
                        .onChange(of: searchText) { oldValue, newValue in
                            performSearch(query: newValue)
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            results = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(ArotiColor.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.vertical, DesignSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .fill(ArotiColor.surface.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: ArotiRadius.md)
                                .stroke(
                                    isSearchFocused ? ArotiColor.accent.opacity(0.5) : ArotiColor.border,
                                    lineWidth: isSearchFocused ? 1.5 : 1
                                )
                        )
                )
                .padding(.horizontal, DesignSpacing.lg)
                .padding(.bottom, DesignSpacing.md)
                
                // Results list or empty state
                if searchText.isEmpty {
                    // Initial empty state
                    VStack(spacing: DesignSpacing.md) {
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(ArotiColor.textSecondary.opacity(0.4))
                        
                        Text("Search for your place of birth")
                            .font(ArotiTextStyle.body)
                            .fontWeight(.medium)
                            .foregroundColor(ArotiColor.textPrimary)
                        
                        Text("Enter a city name to find an accurate location")
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, DesignSpacing.xl)
                } else if isLoading {
                    // Loading state
                    VStack(spacing: DesignSpacing.md) {
                        Spacer()
                        
                        ProgressView()
                            .scaleEffect(1.2)
                            .progressViewStyle(CircularProgressViewStyle(tint: ArotiColor.accent))
                        
                        Text("Searching...")
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textSecondary)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if results.isEmpty && searchText.count >= 3 {
                    // No results state - compact, doesn't fill entire sheet
                    VStack(spacing: DesignSpacing.sm) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(ArotiColor.textSecondary.opacity(0.4))
                            .padding(.top, DesignSpacing.lg)
                        
                        Text("No results")
                            .font(ArotiTextStyle.body)
                            .fontWeight(.semibold)
                            .foregroundColor(ArotiColor.textPrimary)
                        
                        Text("Try a nearby city or check spelling")
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, DesignSpacing.xl)
                    .padding(.vertical, DesignSpacing.md)
                } else {
                    // Results list
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(results.enumerated()), id: \.offset) { index, suggestion in
                                Button(action: {
                                    HapticFeedback.impactOccurred(.light)
                                    location = suggestion.displayName
                                    dismiss()
                                }) {
                                    HStack(spacing: DesignSpacing.md) {
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.system(size: 17, weight: .medium))
                                            .foregroundColor(ArotiColor.accent.opacity(0.6))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(suggestion.displayName)
                                                .font(ArotiTextStyle.body)
                                                .fontWeight(.medium)
                                                .foregroundColor(ArotiColor.textPrimary)
                                            
                                            if let secondary = suggestion.secondaryText {
                                                Text(secondary)
                                                    .font(ArotiTextStyle.caption1)
                                                    .foregroundColor(ArotiColor.textSecondary.opacity(0.7))
                                            }
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, DesignSpacing.lg)
                                    .padding(.vertical, DesignSpacing.md)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(LocationResultButtonStyle())
                                
                                if index < results.count - 1 {
                                    Divider()
                                        .background(ArotiColor.textPrimary.opacity(0.12))
                                        .padding(.leading, DesignSpacing.lg + 17 + DesignSpacing.md)
                                }
                            }
                        }
                    }
                }
            }
        }
        .presentationBackground {
            // Custom blur background with gradient (same as OnboardingPickerModal)
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
        .presentationDetents([.height(500)])
        .presentationDragIndicator(.visible)
        .onAppear {
            isSearchFocused = true
        }
    }
    
    private func performSearch(query: String) {
        // Cancel previous search
        searchTask?.cancel()
        
        if query.isEmpty || query.count < 3 {
            results = []
            isLoading = false
            return
        }
        
        // Set loading state
        isLoading = true
        
        // Debounce search
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
            
            guard !Task.isCancelled else { return }
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.resultTypes = [.address, .pointOfInterest]
            
            let search = MKLocalSearch(request: request)
            
            do {
                let response = try await search.start()
                
                guard !Task.isCancelled else { return }
                
                let formattedResults = response.mapItems.prefix(8).map { item -> LocationSuggestion in
                    let placemark = item.placemark
                    let city = placemark.locality ?? ""
                    let country = placemark.country ?? ""
                    let region = placemark.administrativeArea
                    
                    var displayName = ""
                    if !city.isEmpty && !country.isEmpty {
                        displayName = "\(city), \(country)"
                    } else if !city.isEmpty {
                        displayName = city
                    } else {
                        displayName = item.name ?? ""
                    }
                    
                    return LocationSuggestion(
                        displayName: displayName,
                        secondaryText: region,
                        mapItem: item
                    )
                }
                
                await MainActor.run {
                    results = formattedResults
                    isLoading = false
                }
            } catch {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    results = []
                    isLoading = false
                }
            }
        }
    }
}

// Button style for location results - provides tap highlight feedback
struct LocationResultButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                configuration.isPressed ? ArotiColor.accent.opacity(0.15) : Color.clear
            )
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// Location suggestion model
struct LocationSuggestion: Identifiable, Equatable {
    let id = UUID()
    let displayName: String // "City, Country"
    let secondaryText: String? // Optional region/state
    let mapItem: MKMapItem
    
    static func == (lhs: LocationSuggestion, rhs: LocationSuggestion) -> Bool {
        lhs.id == rhs.id
    }
}
