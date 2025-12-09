//
//  PrivacyTermsSheet.swift
//  Aroti
//
//  Privacy & Terms popup page
//

import SwiftUI

struct PrivacyTermsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showPrivacyPolicySheet: Bool
    @Binding var showTermsOfUseSheet: Bool
    @Binding var showCookiePolicySheet: Bool
    @Binding var showDataDeletionPolicySheet: Bool
    @Binding var showDownloadDataSheet: Bool
    @Binding var showDeleteAccountSheet: Bool
    @Binding var showContactSupportSheet: Bool
    
    var body: some View {
        GlassSheetContainer(title: "Privacy & Terms", subtitle: "Legal documents, data management, and support") {
            VStack(alignment: .leading, spacing: 20) {
                // Legal Documents Section
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(title: "Legal Documents")
                    BaseCard(variant: .interactive, action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showPrivacyPolicySheet = true
                        }
                    }) {
                        SheetRow(iconName: "shield", label: "Privacy Policy")
                    }
                    BaseCard(variant: .interactive, action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showTermsOfUseSheet = true
                        }
                    }) {
                        SheetRow(iconName: "doc.text", label: "Terms of Use")
                    }
                    BaseCard(variant: .interactive, action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showCookiePolicySheet = true
                        }
                    }) {
                        SheetRow(iconName: "doc.text.fill", label: "Cookie Policy")
                    }
                }
                
                // Your Data Section
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(title: "Your Data")
                    BaseCard(variant: .interactive, action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showDownloadDataSheet = true
                        }
                    }) {
                        SheetRow(iconName: "arrow.down.circle", label: "Download My Data")
                    }
                    BaseCard(variant: .interactive, action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showDataDeletionPolicySheet = true
                        }
                    }) {
                        SheetRow(iconName: "doc.text.fill", label: "Data Deletion Policy")
                    }
                }
                
                // Account & Support Section
                VStack(alignment: .leading, spacing: 12) {
                    sectionHeader(title: "Account & Support")
                    BaseCard(variant: .interactive, action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showDeleteAccountSheet = true
                        }
                    }) {
                        SheetRow(iconName: "trash", label: "Delete Account", iconColor: DesignColors.destructive, textColor: DesignColors.destructive)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .stroke(DesignColors.destructive.opacity(0.2), lineWidth: 1)
                    )
                    BaseCard(variant: .interactive, action: {
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showContactSupportSheet = true
                        }
                    }) {
                        SheetRow(iconName: "questionmark.circle", label: "Contact Support")
                    }
                }
            }
        }
    }
    
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(DesignTypography.subheadFont(weight: .semibold))
            .foregroundColor(DesignColors.mutedForeground)
            .padding(.horizontal, 4)
    }
}
