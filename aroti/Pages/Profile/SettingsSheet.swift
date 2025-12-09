//
//  SettingsSheet.swift
//  Aroti
//
//  Settings popup page
//

import SwiftUI

struct SettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showNotificationsSheet: Bool
    @Binding var showLanguageSheet: Bool
    @Binding var showChangeEmailSheet: Bool
    @Binding var showChangePasswordSheet: Bool
    
    var body: some View {
        GlassSheetContainer(title: "Settings", subtitle: "Manage preferences and account") {
            VStack(spacing: 12) {
                BaseCard(variant: .interactive, action: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showLanguageSheet = true
                    }
                }) {
                    SheetRow(iconName: "globe", label: "Languages")
                }
                
                BaseCard(variant: .interactive, action: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showNotificationsSheet = true
                    }
                }) {
                    SheetRow(iconName: "bell", label: "Notifications")
                }
                
                BaseCard(variant: .interactive, action: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showChangeEmailSheet = true
                    }
                }) {
                    SheetRow(iconName: "envelope", label: "Change Email")
                }
                
                BaseCard(variant: .interactive, action: {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showChangePasswordSheet = true
                    }
                }) {
                    SheetRow(iconName: "lock", label: "Change Password")
                }
            }
        }
    }
}
