//
//  BookingView.swift
//  Aroti
//
//  Main booking page - specialist listing
//

import SwiftUI

struct BookingView: View {
    @Binding var selectedTab: TabItem
    @State private var searchQuery: String = ""
    @State private var showFilters: Bool = false
    @State private var showSavedOnly: Bool = false
    @State private var selectedSpecialist: Specialist?
    @State private var navigationPath = NavigationPath()
    @State private var sortOption: SortOption? = nil
    @State private var filters: FilterState = FilterState()
    
    private var filteredSpecialists: [Specialist] {
        var result = BookingDataService.shared.specialists
        
        // Category filter
        if let category = filters.category, category != "All" {
            result = result.filter { specialist in
                specialist.categories.contains { $0.lowercased().contains(category.lowercased()) }
            }
        }
        
        // Search filter (fuzzy search by name)
        if !searchQuery.isEmpty {
            let query = searchQuery.lowercased()
            result = result.filter { specialist in
                specialist.name.lowercased().contains(query) ||
                specialist.specialty.lowercased().contains(query) ||
                specialist.categories.contains { $0.lowercased().contains(query) }
            }
        }
        
        // Saved filter
        if showSavedOnly {
            // TODO: Implement favorites integration
            // For now, we'll skip this filter
        }
        
        // Availability filter
        if let availability = filters.availability {
            result = result.filter { specialist in
                if availability == "today" || availability == "week" {
                    return specialist.available
                }
                return true
            }
        }
        
        // Price range filter
        if let priceMin = filters.priceMin, let priceMax = filters.priceMax {
            result = result.filter { specialist in
                specialist.price >= priceMin && specialist.price <= priceMax
            }
        }
        
        // Rating filter
        if let ratingStr = filters.rating, let ratingThreshold = Double(ratingStr) {
            result = result.filter { specialist in
                specialist.rating >= ratingThreshold
            }
        }
        
        // Years of experience filter
        if let yearsStr = filters.yearsOfExperience, let yearsThreshold = Int(yearsStr) {
            result = result.filter { specialist in
                specialist.yearsOfPractice >= yearsThreshold
            }
        }
        
        // Language filter
        if !filters.languages.isEmpty {
            result = result.filter { specialist in
                !Set(specialist.languages).isDisjoint(with: Set(filters.languages))
            }
        }
        
        // Apply sorting
        if let sort = sortOption {
            result = result.sorted { a, b in
                switch sort {
                case .priceLow:
                    return a.price < b.price
                case .priceHigh:
                    return a.price > b.price
                case .rating:
                    return a.rating > b.rating
                case .sessions:
                    return a.sessionCount > b.sessionCount
                case .newest:
                    if let aDate = a.addedDate, let bDate = b.addedDate {
                        return aDate > bDate
                    }
                    return (a.yearsOfPractice) < (b.yearsOfPractice)
                }
            }
        }
        
        return result
    }
    
    private var activeFilterCount: Int {
        var count = 0
        if filters.availability != nil { count += 1 }
        if filters.priceMin != nil && filters.priceMin != 20 { count += 1 }
        if filters.priceMax != nil && filters.priceMax != 80 { count += 1 }
        if filters.rating != nil { count += 1 }
        if filters.yearsOfExperience != nil { count += 1 }
        if filters.category != nil && filters.category != "All" { count += 1 }
        count += filters.languages.count
        return count
    }
    
    private var upcomingSessions: [Session] {
        BookingDataService.shared.getUpcomingSessions()
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                let safeAreaTop = geometry.safeAreaInsets.top
                
                ZStack(alignment: .bottom) {
                    CelestialBackground()
                        .ignoresSafeArea()
                    
                    ZStack(alignment: .top) {
                        ScrollView {
                            VStack(spacing: 24) {
                                // Upcoming Sessions Section - moved to top
                                if !upcomingSessions.isEmpty {
                                    VStack(alignment: .leading, spacing: 16) {
                                        BaseSectionHeader(
                                            title: "Upcoming Sessions",
                                            subtitle: "Your scheduled appointments"
                                        )
                                        
                                        ForEach(upcomingSessions) { session in
                                            UpcomingSessionCard(session: session) {
                                                navigationPath.append(BookingDestination.sessionDetail(session.id))
                                            }
                                        }
                                    }
                                }
                                
                                // Hero Text
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Let's book your session today")
                                        .font(DesignTypography.title2Font(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Search Bar
                                HStack(spacing: 12) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 16))
                                            .foregroundColor(DesignColors.mutedForeground)
                                        
                                        TextField("Search by name or specialty...", text: $searchQuery)
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        if !searchQuery.isEmpty {
                                            Button(action: { searchQuery = "" }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.system(size: 16))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
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
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Sort + Filter + Saved Bar
                                HStack(spacing: 12) {
                                    // Sort Dropdown
                                    SortDropdown(selectedOption: $sortOption)
                                    
                                    // Filter Button
                                    Button(action: { showFilters = true }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "line.3.horizontal.decrease")
                                                .font(.system(size: 16))
                                            Text("Filter")
                                                .font(DesignTypography.footnoteFont(weight: .medium))
                                            
                                            if activeFilterCount > 0 {
                                                Text("\(activeFilterCount)")
                                                    .font(.system(size: 10, weight: .semibold))
                                                    .foregroundColor(DesignColors.accent)
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 2)
                                                    .background(
                                                        Capsule()
                                                            .fill(DesignColors.accent.opacity(0.2))
                                                    )
                                            }
                                        }
                                        .foregroundColor(DesignColors.mutedForeground)
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
                                    
                                    // Saved Filter
                                    Button(action: { showSavedOnly.toggle() }) {
                                        HStack(spacing: 8) {
                                            Image(systemName: showSavedOnly ? "bookmark.fill" : "bookmark")
                                                .font(.system(size: 16))
                                            Text("Saved")
                                                .font(DesignTypography.footnoteFont(weight: .medium))
                                        }
                                        .foregroundColor(showSavedOnly ? DesignColors.accent : DesignColors.mutedForeground)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                                .fill(showSavedOnly ? DesignColors.accent.opacity(0.2) : DesignColors.glassPrimary)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                                        .stroke(showSavedOnly ? DesignColors.accent.opacity(0.5) : DesignColors.glassBorder, lineWidth: 1)
                                                )
                                        )
                                    }
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Recommended Section
                                if !filteredSpecialists.isEmpty {
                                    let recommended = Array(filteredSpecialists.prefix(2))
                                    let recommendedIds = Set(recommended.map { $0.id })
                                    let allSpecialists = filteredSpecialists.filter { !recommendedIds.contains($0.id) }
                                    
                                    if !recommended.isEmpty {
                                        VStack(alignment: .leading, spacing: 16) {
                                            BaseSectionHeader(
                                                title: "Recommended for You",
                                                subtitle: "Based on your interests and preferences"
                                            )
                                            
                                            ForEach(recommended) { specialist in
                                                SpecialistCard(
                                                    specialist: specialist,
                                                    onTap: {
                                                        selectedSpecialist = specialist
                                                        navigationPath.append(BookingDestination.specialist(specialist))
                                                    },
                                                    onBookSession: {
                                                        selectedSpecialist = specialist
                                                        navigationPath.append(BookingDestination.schedule(specialist))
                                                    },
                                                    onText: {
                                                        // Navigate to messages
                                                    },
                                                    onFavoriteToggle: {
                                                        // Handle favorite toggle
                                                    }
                                                )
                                            }
                                        }
                                    }
                                    
                                    // All Specialists Section
                                    if !allSpecialists.isEmpty {
                                        VStack(alignment: .leading, spacing: 16) {
                                            BaseSectionHeader(
                                                title: "All Specialists",
                                                subtitle: "Browse our complete directory"
                                            )
                                            
                                            ForEach(allSpecialists) { specialist in
                                                SpecialistCard(
                                                    specialist: specialist,
                                                    onTap: {
                                                        selectedSpecialist = specialist
                                                        navigationPath.append(BookingDestination.specialist(specialist))
                                                    },
                                                    onBookSession: {
                                                        selectedSpecialist = specialist
                                                        navigationPath.append(BookingDestination.schedule(specialist))
                                                    },
                                                    onText: {},
                                                    onFavoriteToggle: {}
                                                )
                                            }
                                        }
                                    }
                                } else {
                                    VStack(spacing: 16) {
                                        Text("No specialists found")
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .padding(.vertical, 32)
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                        }
                        .padding(.top, StickyHeaderBar.totalHeight(for: safeAreaTop))
                        .padding(.bottom, 60) // Space for bottom nav
                        
                    StickyHeaderBar(
                        title: "Find Your Specialist",
                        subtitle: "Personal guidance starts with the right connection",
                        safeAreaTop: safeAreaTop
                    )
                    }
                    
                    // Bottom Navigation Bar - fixed at bottom
                    VStack {
                        Spacer()
                        BottomNavigationBar(selectedTab: $selectedTab) { tab in
                            selectedTab = tab
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: BookingDestination.self) { destination in
                switch destination {
                case .specialist(let specialist):
                    SpecialistProfileView(specialist: specialist)
                case .schedule(let specialist):
                    ScheduleSessionView(specialist: specialist)
                case .payment(let specialist, let date, let time):
                    PaymentSummaryView(specialist: specialist, selectedDate: date, selectedTime: time)
                case .confirmation(let specialist, let date, let time):
                    BookingConfirmationView(specialist: specialist, selectedDate: date, selectedTime: time)
                case .sessionDetail(let sessionId):
                    Text("Session Detail: \(sessionId)")
                case .history:
                    BookingHistoryView(selectedTab: $selectedTab)
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterSheet(
                    isPresented: $showFilters,
                    filters: $filters,
                    specialists: BookingDataService.shared.specialists
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

// Upcoming Session Card Component
struct UpcomingSessionCard: View {
    let session: Session
    let onTap: () -> Void
    
    var body: some View {
        BaseCard(variant: .interactive, action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                        .fill(ArotiColor.accent.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Text(session.specialistName.prefix(2).uppercased())
                                .font(DesignTypography.title2Font(weight: .semibold))
                                .foregroundColor(ArotiColor.accent)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.specialistName)
                            .font(DesignTypography.headlineFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text(session.specialty)
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        
                        HStack(spacing: 4) {
                            Text(formatDate(session.date))
                                .font(DesignTypography.subheadFont(weight: .medium))
                            Text("at")
                                .font(DesignTypography.subheadFont())
                            Text(formatTime(session.time))
                                .font(DesignTypography.subheadFont(weight: .medium))
                            Text("•")
                                .font(DesignTypography.subheadFont())
                            Text("\(session.duration) min")
                                .font(DesignTypography.subheadFont())
                        }
                        .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                
                HStack(spacing: 12) {
                    ArotiButton(
                        kind: .custom(.glassCardButton()),
                        title: "Reschedule",
                        action: {}
                    )
                    
                    ArotiButton(
                        kind: .custom(.accentCard()),
                        title: "Join",
                        action: {
                            if let link = session.meetingLink, let url = URL(string: link) {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                }
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else {
            formatter.dateFormat = "EEE, MMM d"
            return formatter.string(from: date)
        }
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



