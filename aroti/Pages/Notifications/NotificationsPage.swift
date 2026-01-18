//
//  NotificationsPage.swift
//  Aroti
//
//  Full-screen notifications page with Journey styling
//

import SwiftUI

struct NotificationsPage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notifications: [NotificationItem] = []
    @State private var showCoreGuidanceSheet = false
    @State private var selectedCoreGuidanceCard: CoreGuidanceCard?
    @State private var navigateToHome = false
    @State private var navigateToJourney = false
    @State private var selectedPracticeId: String?
    
    private let notificationService = NotificationService.shared
    private let coreGuidanceService = CoreGuidanceService.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                CelestialBackground()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        BaseHeader(
                            title: "Notifications",
                            subtitle: "Moments unfolding",
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            ),
                            alignment: .leading
                        )
                        .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                        
                        // Content
                        VStack(spacing: 20) {
                            if notifications.isEmpty {
                                emptyStateView
                            } else {
                                notificationsList
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 60)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadNotifications()
            
            // For development: Add sample notifications if none exist
            #if DEBUG
            if notifications.isEmpty {
                notificationService.addSampleNotifications()
                loadNotifications()
            }
            #endif
        }
        .onReceive(NotificationCenter.default.publisher(for: NotificationService.notificationsUpdated)) { _ in
            loadNotifications()
        }
        .sheet(isPresented: $showCoreGuidanceSheet) {
            if let card = selectedCoreGuidanceCard {
                CoreGuidanceDetailSheet(card: card)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
        .navigationDestination(isPresented: $navigateToHome) {
            HomeView(selectedTab: .constant(.home))
        }
        .navigationDestination(isPresented: $navigateToJourney) {
            JourneyPage()
        }
        .navigationDestination(item: $selectedPracticeId) { practiceId in
            PracticeDetailPage(practiceId: practiceId)
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        BaseCard {
            VStack(spacing: 12) {
                Image(systemName: "bell.slash")
                    .font(.system(size: 48))
                    .foregroundColor(DesignColors.mutedForeground.opacity(0.5))
                    .padding(.bottom, 8)
                
                Text("All caught up")
                    .font(DesignTypography.headlineFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Text("New moments will appear here as they unfold.")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Notifications List
    
    private var notificationsList: some View {
        VStack(spacing: 0) {
            ForEach(Array(notifications.enumerated()), id: \.element.id) { index, notification in
                let isPremium = notification.type == .monthlyForecast || 
                               notification.type == .newLevelUnlocked ||
                               notification.type == .premiumFeatureUnlocked
                let isFirst = index == 0
                let isLast = index == notifications.count - 1
                
                VStack(spacing: 0) {
                    // Extra spacing above premium moments for subtle elevation
                    if isPremium && !isFirst {
                        Spacer()
                            .frame(height: 8)
                    }
                    
                    NotificationCard(
                        notification: notification,
                        onTap: {
                            handleNotificationTap(notification)
                        },
                        onDismiss: {
                            handleNotificationDismiss(notification)
                        }
                    )
                    
                    // Subtle divider (except after last item)
                    if !isLast {
                        Rectangle()
                            .fill(Color.white.opacity(0.06))
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity,
                    removal: .opacity.combined(with: .move(edge: .trailing))
                ))
            }
        }
    }
    
    // MARK: - Actions
    
    private func loadNotifications() {
        notifications = notificationService.getNotifications()
    }
    
    private func handleNotificationTap(_ notification: NotificationItem) {
        // Remove notification immediately on tap
        withAnimation {
            notificationService.deleteNotification(id: notification.id)
        }
        
        // Navigate to destination
        switch notification.destination {
        case .home:
            navigateToHome = true
        case .tarotDetail, .horoscope, .numerology, .affirmation:
            // These all navigate to home for now
            navigateToHome = true
        case .journey:
            navigateToJourney = true
        case .coreGuidance(let cardId):
            // Fetch the card from the service
            if let card = coreGuidanceService.getCard(id: cardId) {
                selectedCoreGuidanceCard = card
                showCoreGuidanceSheet = true
            }
        case .practiceDetail(let practiceId):
            selectedPracticeId = practiceId
        }
    }
    
    private func handleNotificationDismiss(_ notification: NotificationItem) {
        // Dismiss notification with animation
        withAnimation {
            notificationService.dismissNotification(id: notification.id)
        }
    }
}

#Preview {
    NavigationStack {
        NotificationsPage()
    }
}
