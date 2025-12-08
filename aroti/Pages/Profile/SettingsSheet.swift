//
//  SettingsSheet.swift
//  Aroti
//
//  Settings popup page
//

import SwiftUI

struct SettingsSheet: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        GlassSheetContainer(title: "Settings", subtitle: "Manage account, data, and support") {
            VStack(spacing: 12) {
                BaseCard(variant: .interactive, action: {
                    alertMessage = "Change email feature coming soon"
                    showAlert = true
                }) {
                    SheetRow(iconName: "envelope", label: "Change Email")
                }
                
                BaseCard(variant: .interactive, action: {
                    alertMessage = "Change password feature coming soon"
                    showAlert = true
                }) {
                    SheetRow(iconName: "lock", label: "Change Password")
                }
                
                BaseCard(variant: .interactive, action: {
                    alertMessage = "Data export started. You'll receive an email when ready."
                    showAlert = true
                }) {
                    SheetRow(iconName: "arrow.down.circle", label: "Download My Data")
                }
                
                BaseCard(variant: .interactive, action: {
                    if let url = URL(string: "mailto:support@aroti.com?subject=Support Request") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    SheetRow(iconName: "questionmark.circle", label: "Contact Support")
                }
                
                BaseCard {
                    Button(action: { showDeleteConfirmation = true }) {
                        HStack(spacing: 12) {
                            SheetRow(iconName: "trash", label: "Delete Account", iconColor: DesignColors.destructive, showChevron: false, textColor: DesignColors.destructive)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .stroke(DesignColors.destructive.opacity(0.2), lineWidth: 1)
                )
            }
            .alert("Info", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .alert("Delete Account", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    alertMessage = "Account deletion requires additional verification. Please contact support."
                    showAlert = true
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
        }
    }
}
