//
//  NotificationService.swift
//  Aroti
//
//  Service for managing in-app notifications
//

import Foundation

class NotificationService {
    static let shared = NotificationService()
    
    private let userDefaultsKey = "aroti_notifications"
    private let notificationCenter = NotificationCenter.default
    
    // Notification name for when notifications are updated
    static let notificationsUpdated = Notification.Name("NotificationServiceUpdated")
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Get all notifications, ordered by unread first, then by date (newest first)
    func getNotifications() -> [NotificationItem] {
        let notifications = loadNotifications()
        return notifications.sorted { first, second in
            // Unread first
            if first.isRead != second.isRead {
                return !first.isRead
            }
            // Then by date (newest first)
            return first.createdAt > second.createdAt
        }
    }
    
    /// Check if there are any unread notifications
    func hasUnread() -> Bool {
        let notifications = loadNotifications()
        return notifications.contains { !$0.isRead }
    }
    
    /// Mark a notification as read
    func markAsRead(id: String) {
        var notifications = loadNotifications()
        if let index = notifications.firstIndex(where: { $0.id == id }) {
            notifications[index].isRead = true
            saveNotifications(notifications)
            postUpdateNotification()
        }
    }
    
    /// Add a new notification
    func addNotification(_ notification: NotificationItem) {
        var notifications = loadNotifications()
        notifications.append(notification)
        saveNotifications(notifications)
        postUpdateNotification()
    }
    
    /// Delete a notification (used for dismissal)
    func deleteNotification(id: String) {
        var notifications = loadNotifications()
        notifications.removeAll { $0.id == id }
        saveNotifications(notifications)
        postUpdateNotification()
    }
    
    /// Dismiss (delete) a notification - same as delete but semantically clearer
    func dismissNotification(id: String) {
        deleteNotification(id: id)
    }
    
    /// Clear all notifications
    func clearAll() {
        saveNotifications([])
        postUpdateNotification()
    }
    
    // MARK: - Private Methods
    
    private func loadNotifications() -> [NotificationItem] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let notifications = try? JSONDecoder().decode([NotificationItem].self, from: data) else {
            return []
        }
        return notifications
    }
    
    private func saveNotifications(_ notifications: [NotificationItem]) {
        if let data = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func postUpdateNotification() {
        notificationCenter.post(name: NotificationService.notificationsUpdated, object: nil)
    }
    
    // MARK: - Development Helpers
    
    /// Add sample notifications for testing (development only)
    func addSampleNotifications() {
        #if DEBUG
        let samples: [NotificationItem] = [
            NotificationItem(
                type: .dailyTarotCard,
                title: "A card meant for today is waiting",
                body: "Your daily draw has arrived",
                destination: .tarotDetail
            ),
            NotificationItem(
                type: .dailyHoroscope,
                title: "Today's cosmic insight appeared",
                body: "A reading shaped for this moment",
                destination: .horoscope
            ),
            NotificationItem(
                type: .monthlyForecast,
                title: "Insights shaped for the month ahead",
                body: "Your monthly reading has unfolded",
                isRead: true,
                createdAt: Date().addingTimeInterval(-86400), // 1 day ago
                destination: .coreGuidance(cardId: "monthly-forecast")
            ),
            NotificationItem(
                type: .newLevelUnlocked,
                title: "Level 3 unlocked — new paths open",
                body: "Seeker level reached",
                isRead: true,
                createdAt: Date().addingTimeInterval(-172800), // 2 days ago
                destination: .journey
            ),
            NotificationItem(
                type: .dailyAffirmation,
                title: "A reflection arrived for you",
                body: "Today's thought is here",
                createdAt: Date().addingTimeInterval(-3600), // 1 hour ago
                destination: .affirmation
            ),
            NotificationItem(
                type: .rightNowGuidance,
                title: "Guidance appeared for this moment",
                body: "Something shifted — a reading is ready",
                destination: .coreGuidance(cardId: "right-now")
            )
        ]
        
        for sample in samples {
            addNotification(sample)
        }
        #endif
    }
}
