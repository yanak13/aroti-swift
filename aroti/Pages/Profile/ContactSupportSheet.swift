//
//  ContactSupportSheet.swift
//  Aroti
//
//  Contact Support page
//

import SwiftUI

struct ContactSupportSheet: View {
    @State private var selectedCategory: SupportCategory = .general
    
    enum SupportCategory: String, CaseIterable {
        case billing = "Billing"
        case account = "Account"
        case technical = "Technical Issue"
        case general = "General"
    }
    
    var body: some View {
        GlassSheetContainer(title: "Contact Support", subtitle: nil) {
            VStack(spacing: 20) {
                BaseCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("If you need help with your account, billing, rituals, or technical issues, our team is here for you.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Category Selector
                BaseCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category")
                            .font(DesignTypography.subheadFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                        
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(SupportCategory.allCases, id: \.self) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(DesignColors.accent)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                ArotiButton(
                    kind: .primary,
                    title: "Email Support"
                ) {
                    openEmailSupport()
                }
            }
        }
    }
    
    private func openEmailSupport() {
        let subject = "Support Request - \(selectedCategory.rawValue)"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "mailto:support@aroti.app?subject=\(encodedSubject)") {
            UIApplication.shared.open(url)
        }
    }
}

