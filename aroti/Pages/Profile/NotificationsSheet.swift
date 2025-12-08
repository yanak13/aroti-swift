//
//  NotificationsSheet.swift
//  Aroti
//
//  Notifications popup page
//

import SwiftUI

struct NotificationsSheet: View {
    @State private var ritualReminders: Bool = true
    @State private var dailyReading: Bool = true
    @State private var astrologyUpdates: Bool = true
    @State private var bookingUpdates: Bool = true
    @State private var marketingOffers: Bool = false
    
    private let notificationKeyPrefix = "aroti_notification_"
    
    var body: some View {
        GlassSheetContainer(title: "Notifications", subtitle: "Fine-tune reminders and updates") {
            VStack(spacing: 20) {
                BaseCard {
                    VStack(alignment: .leading, spacing: 24) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.accent)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.05))
                                )
                            
                            Text("Notification Preferences")
                                .font(DesignTypography.headlineFont(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                        }
                        
                        VStack(spacing: 16) {
                            notificationToggleRow(title: "Ritual Reminders", binding: $ritualReminders, key: "ritualReminders")
                            notificationToggleRow(title: "Daily Reading", binding: $dailyReading, key: "dailyReading")
                            notificationToggleRow(title: "Astrology Updates", binding: $astrologyUpdates, key: "astrologyUpdates")
                            notificationToggleRow(title: "Booking Updates", binding: $bookingUpdates, key: "bookingUpdates")
                            notificationToggleRow(title: "Marketing/Offers", binding: $marketingOffers, key: "marketingOffers")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text("Your device notification settings can override these preferences.")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
            .onAppear { loadNotificationPreferences() }
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
                .onChange(of: binding.wrappedValue) { newValue in
                    saveNotificationPreference(key: key, value: newValue)
                }
        }
    }
    
    private func loadNotificationPreferences() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: notificationKeyPrefix + "ritualReminders") != nil {
            ritualReminders = defaults.bool(forKey: notificationKeyPrefix + "ritualReminders")
        }
        if defaults.object(forKey: notificationKeyPrefix + "dailyReading") != nil {
            dailyReading = defaults.bool(forKey: notificationKeyPrefix + "dailyReading")
        }
        if defaults.object(forKey: notificationKeyPrefix + "astrologyUpdates") != nil {
            astrologyUpdates = defaults.bool(forKey: notificationKeyPrefix + "astrologyUpdates")
        }
        if defaults.object(forKey: notificationKeyPrefix + "bookingUpdates") != nil {
            bookingUpdates = defaults.bool(forKey: notificationKeyPrefix + "bookingUpdates")
        }
        if defaults.object(forKey: notificationKeyPrefix + "marketingOffers") != nil {
            marketingOffers = defaults.bool(forKey: notificationKeyPrefix + "marketingOffers")
        }
    }
    
    private func saveNotificationPreference(key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: notificationKeyPrefix + key)
    }
}
