//
//  LocationPickerSheet.swift
//  Aroti
//
//  Location picker for birth place selection
//

import SwiftUI
import MapKit

struct LocationPickerSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocation: String
    
    @State private var searchText: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Slightly lighter background for sheet
                Color(hue: 235/360, saturation: 0.30, brightness: 0.13)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search Bar
                    BaseCard {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            TextField("Search for city, country…", text: $searchText)
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                                .onChange(of: searchText) { newValue in
                                    searchLocations(query: newValue)
                                }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    searchResults = []
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                        .padding(12)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Results List or Empty State
                    if !searchText.isEmpty {
                        if isSearching && searchResults.isEmpty {
                            VStack(spacing: 16) {
                                Spacer()
                                Text("No locations found")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground.opacity(0.7))
                                Spacer()
                            }
                        } else if !searchResults.isEmpty {
                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(searchResults, id: \.self) { item in
                                        Button(action: {
                                            let locationString = formatLocationForDisplay(item: item)
                                            selectedLocation = locationString
                                            dismiss()
                                        }) {
                                            BaseCard {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(formatLocationForList(item: item))
                                                        .font(DesignTypography.bodyFont(weight: .medium))
                                                        .foregroundColor(DesignColors.foreground)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                        }
                    } else {
                        // Empty state - text only, no icon
                        VStack(spacing: 12) {
                            Spacer()
                            
                            Text("Search for your place of birth")
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground.opacity(0.9))
                            
                            Text("Enter a city name to find an accurate location")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.foreground.opacity(0.7))
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 40)
                    }
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(Color.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground)
                }
            }
        }
    }
    
    private func searchLocations(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = [.address, .pointOfInterest]
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                isSearching = false
                if let response = response {
                    searchResults = Array(response.mapItems.prefix(10))
                } else {
                    searchResults = []
                }
            }
        }
    }
    
    // Format for list display: City, Region, Country
    private func formatLocationForList(item: MKMapItem) -> String {
        let placemark = item.placemark
        var components: [String] = []
        
        if let city = placemark.locality {
            components.append(city)
        }
        if let state = placemark.administrativeArea {
            components.append(state)
        }
        if let country = placemark.country {
            components.append(country)
        }
        
        return components.joined(separator: ", ")
    }
    
    // Format for field display: City, Country (or City, State if in US)
    private func formatLocationForDisplay(item: MKMapItem) -> String {
        let placemark = item.placemark
        var components: [String] = []
        
        if let city = placemark.locality {
            components.append(city)
        }
        
        // For US, include state; otherwise just country
        if placemark.country == "United States" || placemark.country == "USA" {
            if let state = placemark.administrativeArea {
                components.append(state)
            }
        } else {
            if let country = placemark.country {
                components.append(country)
            }
        }
        
        return components.joined(separator: ", ")
    }
}

