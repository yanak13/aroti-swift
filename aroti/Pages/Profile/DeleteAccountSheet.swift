//
//  DeleteAccountSheet.swift
//  Aroti
//
//  Delete Account page
//

import SwiftUI

struct DeleteAccountSheet: View {
    @State private var showDeleteConfirmation: Bool = false
    @State private var isDeleting: Bool = false
    
    var body: some View {
        GlassSheetContainer(title: "Delete Account", subtitle: "Permanently delete your Aroti account and all associated data") {
            VStack(spacing: 20) {
                BaseCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.destructive)
                            Text("Warning")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                                .foregroundColor(DesignColors.destructive)
                        }
                        
                        Text("This action is irreversible. Your readings, rituals, history, and personal data will be permanently removed.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                ArotiButton(
                    kind: .custom(ArotiButtonStyle(
                        foregroundColor: .white,
                        backgroundColor: DesignColors.destructive,
                        cornerRadius: DesignRadius.secondary,
                        height: ArotiButtonHeight.standard
                    )),
                    title: "Delete my account",
                    isDisabled: isDeleting
                ) {
                    showDeleteConfirmation = true
                }
            }
            .alert("Are you sure?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteAccount()
                }
            } message: {
                Text("This will permanently delete your account and all data. This cannot be undone.")
            }
        }
    }
    
    private func deleteAccount() {
        isDeleting = true
        
        // TODO: Implement actual API call to delete account
        // After successful deletion:
        // 1. Log out user
        // 2. Clear all local data
        // 3. Redirect to onboarding
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // In production, this would:
            // - Call authentication service to delete account
            // - Clear UserDefaults
            // - Navigate to onboarding/welcome screen
            isDeleting = false
            // For now, just show that deletion was initiated
        }
    }
}

