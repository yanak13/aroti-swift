//
//  BookingHistoryView.swift
//  Aroti
//
//  Booking history page with upcoming and past sessions
//

import SwiftUI
import UIKit

struct BookingHistoryView: View {
    @Binding var selectedTab: TabItem
    @StateObject private var controller = BookingController()
    @State private var activeTab: HistoryTab = .upcoming
    @State private var showRatingModal = false
    @State private var ratingSessionId: String? = nil
    @State private var currentRating: Int = 0
    @State private var navigationPath = NavigationPath()
    
    private var upcomingSessions: [Session] {
        controller.getUpcomingSessions()
    }
    
    private var pastSessions: [Session] {
        controller.getPastSessions()
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    CelestialBackground()
                    
                    ScrollView {
                        VStack(spacing: 32) {
                            // Header
                            BaseHeader(
                                title: "My Sessions",
                                leftAction: BaseHeader.HeaderAction(
                                    icon: Image(systemName: "chevron.left"),
                                    label: "Back to booking",
                                    action: {
                                        selectedTab = .booking
                                    }
                                )
                            )
                            .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                            
                            // Main Content
                            VStack(spacing: 32) {
                                // Tabs
                                tabsSection
                                
                                // Sessions List
                                if activeTab == .upcoming {
                                    upcomingSessionsSection
                                } else {
                                    pastSessionsSection
                                }
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            .padding(.bottom, 100) // Space for bottom nav
                        }
                    }
                    
                    // Bottom Navigation Bar
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
            .sheet(isPresented: $showRatingModal) {
                RatingModalView(
                    sessionId: ratingSessionId ?? "",
                    rating: $currentRating,
                    onSubmit: {
                        // Handle rating submission
                        showRatingModal = false
                        ratingSessionId = nil
                        currentRating = 0
                    }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    // MARK: - Tabs Section
    private var tabsSection: some View {
        HStack(spacing: 4) {
            ForEach(HistoryTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        activeTab = tab
                    }
                }) {
                    Text(tab.rawValue)
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(activeTab == tab ? .white : DesignColors.mutedForeground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Group {
                                if activeTab == tab {
                                    LinearGradient(
                                        colors: [DesignColors.accent, DesignColors.accent.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .clipShape(Capsule())
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: DesignRadius.card)
                .fill(DesignColors.glassPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignRadius.card)
                        .stroke(DesignColors.glassBorder, lineWidth: 1)
                )
        )
    }
    
    // MARK: - Upcoming Sessions Section
    private var upcomingSessionsSection: some View {
        VStack(spacing: 16) {
            if upcomingSessions.isEmpty {
                emptyStateView(
                    icon: "calendar",
                    message: "No sessions yet — find your next guide.",
                    buttonTitle: "Browse Specialists",
                    buttonAction: {
                        selectedTab = .booking
                    }
                )
            } else {
                ForEach(upcomingSessions) { session in
                    sessionCard(session: session, isUpcoming: true)
                }
            }
        }
    }
    
    // MARK: - Past Sessions Section
    private var pastSessionsSection: some View {
        VStack(spacing: 16) {
            if pastSessions.isEmpty {
                emptyStateView(
                    icon: "calendar",
                    message: "No past sessions yet.",
                    buttonTitle: nil,
                    buttonAction: nil
                )
            } else {
                ForEach(pastSessions) { session in
                    sessionCard(session: session, isUpcoming: false)
                }
            }
        }
    }
    
    // MARK: - Session Card
    private func sessionCard(session: Session, isUpcoming: Bool) -> some View {
        BaseCard {
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    // Avatar
                    Group {
                        if let image = UIImage(named: session.specialistPhoto) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                .fill(DesignColors.accent.opacity(0.2))
                                .overlay(
                                    Text(String(session.specialistName.prefix(2)).uppercased())
                                        .font(DesignTypography.title3Font(weight: .semibold))
                                        .foregroundColor(DesignColors.accent)
                                )
                        }
                    }
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignColors.accent.opacity(0.2), lineWidth: 2)
                    )
                    
                    // Session Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(session.specialistName)
                            .font(DesignTypography.headlineFont(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text(session.specialty)
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        
                        Text("\(formatDate(session.date)) at \(session.time)")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.foreground)
                        
                        // Status Badge
                        HStack {
                            Text(isUpcoming ? "Confirmed" : "Completed")
                                .font(DesignTypography.footnoteFont(weight: .medium))
                                .foregroundColor(isUpcoming ? .white : DesignColors.mutedForeground)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(isUpcoming ? AnyShapeStyle(LinearGradient(
                                            colors: [DesignColors.accent, DesignColors.accent.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )) : AnyShapeStyle(Color.white.opacity(0.1)))
                                )
                        }
                    }
                    
                    Spacer()
                }
                
                // Action Buttons
                HStack(spacing: 12) {
                    if isUpcoming {
                        ArotiButton(
                            kind: .primary,
                            title: "Join Session",
                            action: {
                                if let link = session.meetingLink, let url = URL(string: link) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        
                        ArotiButton(
                            kind: .custom(.glassCardButton()),
                            title: "View Profile",
                            action: {
                                if let specialist = controller.specialists.first(where: { $0.id == session.specialistId }) {
                                    navigationPath.append(BookingDestination.specialist(specialist))
                                }
                            }
                        )
                    } else {
                        ArotiButton(
                            kind: .primary,
                            action: {
                                ratingSessionId = session.id
                                currentRating = 0
                                showRatingModal = true
                            },
                            label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 16))
                                    Text("Rate Session")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                }
                            }
                        )
                        
                        ArotiButton(
                            kind: .custom(.glassCardButton()),
                            title: "Rebook",
                            action: {
                                if let specialist = controller.specialists.first(where: { $0.id == session.specialistId }) {
                                    navigationPath.append(BookingDestination.schedule(specialist))
                                }
                            }
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Empty State
    private func emptyStateView(icon: String, message: String, buttonTitle: String?, buttonAction: (() -> Void)?) -> some View {
        BaseCard {
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundColor(DesignColors.mutedForeground)
                
                Text(message)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.center)
                
                if let title = buttonTitle, let action = buttonAction {
                    ArotiButton(
                        kind: .primary,
                        title: title,
                        action: action
                    )
                    .padding(.top, 8)
                }
            }
            .padding(.vertical, 48)
        }
    }
    
    // MARK: - Helpers
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    .task {
        // Fetch data on appear
        if controller.sessions.isEmpty {
            await controller.fetchSessions()
        }
        if controller.specialists.isEmpty {
            await controller.fetchSpecialists()
        }
    }
}

// MARK: - Supporting Types
enum HistoryTab: String, CaseIterable {
    case upcoming = "Upcoming"
    case past = "Past"
}

// MARK: - Rating Modal
struct RatingModalView: View {
    let sessionId: String
    @Binding var rating: Int
    let onSubmit: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("How was your session?")
                    .font(DesignTypography.title2Font(weight: .bold))
                    .foregroundColor(DesignColors.foreground)
            }
            .padding(.top, 24)
            
            // Star Rating
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            rating = star
                        }
                    }) {
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.system(size: 40))
                            .foregroundColor(star <= rating ? DesignColors.accent : DesignColors.mutedForeground)
                    }
                    .scaleEffect(star == rating ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rating)
                }
            }
            .padding(.vertical, 24)
            
            // Submit Button
            ArotiButton(
                kind: .primary,
                title: "Submit Rating",
                action: {
                    onSubmit()
                    dismiss()
                }
            )
            .disabled(rating == 0)
            .opacity(rating == 0 ? 0.5 : 1.0)
            
            Spacer()
        }
        .padding(.horizontal, DesignSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignRadius.card)
                .fill(DesignColors.glassPrimary)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignRadius.card)
                        .stroke(DesignColors.glassBorder, lineWidth: 1)
                )
        )
    }
}

#Preview {
    BookingHistoryView(selectedTab: .constant(.booking))
}

