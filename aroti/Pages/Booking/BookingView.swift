//
//  BookingView.swift
//  Aroti
//
//  Main booking page - specialist listing
//

import SwiftUI

struct BookingView: View {
    @Binding var selectedTab: TabItem
    @State private var activeCategory: String = "All"
    @State private var searchQuery: String = ""
    @State private var showFilters: Bool = false
    @State private var showSavedOnly: Bool = false
    @State private var selectedSpecialist: Specialist?
    @State private var navigationPath = NavigationPath()
    
    private let categories = ["All", "Astrology", "Therapy", "Numerology", "Reiki", "Coaching"]
    
    private var filteredSpecialists: [Specialist] {
        var result = BookingDataService.shared.specialists
        
        // Category filter
        if activeCategory != "All" {
            result = result.filter { specialist in
                specialist.categories.contains { $0.lowercased().contains(activeCategory.lowercased()) }
            }
        }
        
        // Search filter
        if !searchQuery.isEmpty {
            result = result.filter { specialist in
                specialist.name.lowercased().contains(searchQuery.lowercased()) ||
                specialist.specialty.lowercased().contains(searchQuery.lowercased())
            }
        }
        
        return result
    }
    
    private var upcomingSessions: [Session] {
        BookingDataService.shared.getUpcomingSessions()
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    CelestialBackground()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header - matching Home and Discovery page style
                            BaseHeader(
                                title: "Find Your Specialist",
                                subtitle: "Personal guidance starts with the right connection"
                            )
                            .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                            .padding(.horizontal, DesignSpacing.sm)
                            
                            // Category Filters
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(categories, id: \.self) { category in
                                        CategoryChip(
                                            label: category,
                                            isActive: activeCategory == category,
                                            action: {
                                                activeCategory = category
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                            }
                            .padding(.vertical, DesignSpacing.sm)
                            .padding(.horizontal, -DesignSpacing.sm)
                            
                            // Sort + Filter + Saved Bar
                            HStack(spacing: 12) {
                                // Sort Dropdown
                                Menu {
                                    Button("Price: Low to High", action: {})
                                    Button("Price: High to Low", action: {})
                                    Button("Rating", action: {})
                                    Button("Newest", action: {})
                                } label: {
                                    HStack {
                                        Text("Sort")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12))
                                    }
                                    .foregroundColor(DesignColors.foreground)
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
                                
                                // Filter Button
                                ArotiButton(
                                    kind: .custom(.glassCardButton()),
                                    title: "Filters",
                                    action: { showFilters = true }
                                )
                                
                                // Saved Filter
                                ArotiButton(
                                    kind: .custom(showSavedOnly ?
                                        .pill(background: ArotiColor.accentSoft, textColor: ArotiColor.accent) :
                                        .glassCardButton()
                                    ),
                                    title: "Saved",
                                    icon: Image(systemName: showSavedOnly ? "bookmark.fill" : "bookmark"),
                                    action: { showSavedOnly.toggle() }
                                )
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            
                            // Upcoming Sessions Section
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
                            
                            // Recommended Section
                            VStack(alignment: .leading, spacing: 16) {
                                BaseSectionHeader(
                                    title: "Recommended for You",
                                    subtitle: "Based on your interests and preferences"
                                )
                                
                                ForEach(filteredSpecialists.prefix(2)) { specialist in
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
                            
                            // All Specialists Section
                            VStack(alignment: .leading, spacing: 16) {
                                BaseSectionHeader(
                                    title: "All Specialists",
                                    subtitle: "Browse our complete directory"
                                )
                                
                                ForEach(filteredSpecialists.dropFirst(2)) { specialist in
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
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.bottom, 60) // Space for bottom nav
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
                    Text("Booking History")
                }
            }
            .sheet(isPresented: $showFilters) {
                Text("Filters")
                    .presentationDetents([.medium])
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



