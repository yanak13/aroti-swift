//
//  NotificationsSheet.swift
//  Aroti
//
//  Notifications popup page
//

import SwiftUI
import UserNotifications

struct NotificationsSheet: View {
    @State private var allowPushNotifications: Bool = true
    @State private var dailyHoroscopeNotifications: Bool = true
    @State private var guidanceMessageAlerts: Bool = true
    @State private var ritualReminders: Bool = true
    @State private var systemNotificationsDisabled: Bool = false
    
    private let notificationKeyPrefix = "aroti_notification_"
    
    var body: some View {
        GlassSheetContainer(title: "Notifications", subtitle: "Manage alerts and ritual reminders") {
            VStack(spacing: 20) {
                // System Notification Banner
                if systemNotificationsDisabled {
                    BaseCard {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(DesignColors.warning)
                            Text("Notifications are turned off in iOS Settings → Aroti.")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .stroke(DesignColors.warning.opacity(0.3), lineWidth: 1)
                    )
                }
                
                BaseCard {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(spacing: 12) {
                            notificationToggleRow(title: "Allow Push Notifications", binding: $allowPushNotifications, key: "allowPushNotifications")
                            notificationToggleRow(title: "Daily Horoscope Notifications", binding: $dailyHoroscopeNotifications, key: "dailyHoroscopeNotifications")
                            notificationToggleRow(title: "Guidance Message Alerts", binding: $guidanceMessageAlerts, key: "guidanceMessageAlerts")
                            notificationToggleRow(title: "Ritual Reminders", binding: $ritualReminders, key: "ritualReminders")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear {
                loadNotificationPreferences()
                checkSystemNotificationStatus()
            }
        }
    }
    
    private func notificationToggleRow(title: String, binding: Binding<Bool>, key: String) -> some View {
        HStack {
            Text(title)
                .font(DesignTypography.subheadFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            Spacer()
            Toggle("", isOn: binding)
                .tint(DesignColors.accent)
                .labelsHidden()
                .onChange(of: binding.wrappedValue) { oldValue, newValue in
                    saveNotificationPreference(key: key, value: newValue)
                }
        }
    }
    
    private func loadNotificationPreferences() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: notificationKeyPrefix + "allowPushNotifications") != nil {
            allowPushNotifications = defaults.bool(forKey: notificationKeyPrefix + "allowPushNotifications")
        }
        if defaults.object(forKey: notificationKeyPrefix + "dailyHoroscopeNotifications") != nil {
            dailyHoroscopeNotifications = defaults.bool(forKey: notificationKeyPrefix + "dailyHoroscopeNotifications")
        }
        if defaults.object(forKey: notificationKeyPrefix + "guidanceMessageAlerts") != nil {
            guidanceMessageAlerts = defaults.bool(forKey: notificationKeyPrefix + "guidanceMessageAlerts")
        }
        if defaults.object(forKey: notificationKeyPrefix + "ritualReminders") != nil {
            ritualReminders = defaults.bool(forKey: notificationKeyPrefix + "ritualReminders")
        }
    }
    
    private func checkSystemNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                systemNotificationsDisabled = settings.authorizationStatus != .authorized
            }
        }
    }
    
    private func saveNotificationPreference(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: notificationKeyPrefix + key)
    }
}
