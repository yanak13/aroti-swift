//
//  PrivacyTermsSheet.swift
//  Aroti
//
//  Privacy & Terms popup page
//

import SwiftUI

struct PrivacyTermsSheet: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GlassSheetContainer(title: "Privacy & Terms", subtitle: "Review policies and contact support") {
            VStack(spacing: 12) {
                interactiveRow(icon: "shield", label: "Privacy Policy", message: "Privacy Policy page coming soon")
                interactiveRow(icon: "doc.text", label: "Terms of Use", message: "Terms of Use page coming soon")
                interactiveRow(icon: "doc.text.fill", label: "Cookie Policy", message: "Cookie Policy page coming soon")
                interactiveRow(icon: "trash", label: "Data Deletion Policy", message: "Data Deletion Policy page coming soon")
                BaseCard(variant: .interactive, action: {
                    if let url = URL(string: "mailto:support@aroti.com?subject=Privacy & Terms Inquiry") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    SheetRow(iconName: "questionmark.circle", label: "Contact Support")
                }
            }
            .alert("Info", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func interactiveRow(icon: String, label: String, message: String) -> some View {
        BaseCard(variant: .interactive, action: {
            alertMessage = message
            showAlert = true
        }) {
            SheetRow(iconName: icon, label: label)
        }
    }
}
