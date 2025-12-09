//
//  MembershipBillingSheet.swift
//  Aroti
//
//  Membership & Billing hub
//
//  Refactored from WalletCreditsSheet
//

import SwiftUI

struct MembershipBillingSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showPaywall: Bool
    
    @State private var isLoading: Bool = true
    
    private var isPremium: Bool {
        UserSubscriptionService.shared.isPremium
    }
    
    // Mock subscription data - in production, fetch from StoreKit
    private var subscriptionStatus: String {
        if isPremium {
            return "Active"
        }
        return "Free"
    }
    
    private var planName: String {
        if isPremium {
            return "Premium Cosmic Access"
        }
        return "Free Plan"
    }
    
    private var renewalInfo: String? {
        if isPremium {
            // In production, get actual renewal date from StoreKit
            return "Renews on March 15, 2026"
        }
        return nil
    }
    
    private var priceInfo: String? {
        if isPremium {
            // In production, get actual price from StoreKit
            return "$9.99 / month"
        }
        return nil
    }
    
    // Mock purchase history - in production, fetch from StoreKit receipts
    private var purchaseHistory: [PurchaseItem] {
        if isPremium {
            return [
                PurchaseItem(title: "Premium – Monthly renewal", amount: "$9.99", date: "Jan 12, 2026"),
                PurchaseItem(title: "Premium – First purchase", amount: "$9.99", date: "Dec 12, 2025")
            ]
        }
        return []
    }
    
    var body: some View {
        GlassSheetContainer(title: "Membership & Billing", subtitle: "Your cosmic membership hub") {
            VStack(spacing: 20) {
                // 1. Premium Hero Card
                premiumHeroCard
                
                // 2. Payment Method Card
                paymentMethodCard
                
                // 3. Purchase History Card
                purchaseHistoryCard
                
                // 4. Billing & Support Section
                billingSupportSection
            }
            .onAppear {
                loadData()
            }
        }
    }
    
    // MARK: - Premium Hero Card
    
    private var premiumHeroCard: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [
                    Color(red: 185/255, green: 110/255, blue: 70/255).opacity(0.25),
                    Color(red: 185/255, green: 110/255, blue: 70/255).opacity(0.15),
                    Color(red: 120/255, green: 80/255, blue: 100/255).opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Glassmorphism Overlay
            Color.white.opacity(0.05)
            
            // Content
            VStack(alignment: .leading, spacing: 20) {
                if isLoading {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: DesignColors.accent))
                        Text("Loading membership info...")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    .padding(.vertical, 16)
                } else if isPremium {
                    // Premium Active State
                    VStack(alignment: .leading, spacing: 16) {
                        // Premium Badge
                        HStack(spacing: 8) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 16))
                                .foregroundColor(DesignColors.accent)
                            Text("Aroti Premium")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                                .foregroundColor(DesignColors.accent)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(DesignColors.accent.opacity(0.15))
                        )
                        
                        // Plan Name
                        Text(planName)
                            .font(DesignTypography.title2Font(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        // Status with renewal info
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 8, height: 8)
                                Text("Active")
                                    .font(DesignTypography.subheadFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                            }
                            
                            if let renewalInfo = renewalInfo {
                                Text(renewalInfo)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            
                            if let priceInfo = priceInfo {
                                Text(priceInfo)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        
                        // Manage Subscription Button
                        ArotiButton(
                            kind: .secondary,
                            title: "Manage Subscription",
                            action: {
                                openSubscriptionManagement()
                            }
                        )
                    }
                } else {
                    // Free Plan - Premium Upgrade CTA
                    VStack(alignment: .leading, spacing: 20) {
                        // Premium Badge
                        HStack(spacing: 8) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 16))
                                .foregroundColor(DesignColors.accent)
                            Text("Aroti Premium")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                                .foregroundColor(DesignColors.accent)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(DesignColors.accent.opacity(0.15))
                        )
                        
                        // Status Row
                        Text("You're on the Free Plan")
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        
                        // Premium Pitch
                        Text("Get deeper clarity, daily rituals, and personalized cosmic insights with Premium.")
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                        
                        // Benefits List
                        VStack(alignment: .leading, spacing: 12) {
                            benefitRow(icon: "message.fill", text: "Unlimited AI messages")
                            benefitRow(icon: "sparkles", text: "All advanced rituals included")
                            benefitRow(icon: "star.fill", text: "Deep astrology + numerology profile")
                            benefitRow(icon: "moon.fill", text: "Monthly premium cosmic guidance")
                        }
                        .padding(.top, 4)
                        
                        // Upgrade CTA Button
                        ArotiButton(
                            kind: .custom(ArotiButtonStyle(
                                foregroundColor: .white,
                                backgroundGradient: LinearGradient(
                                    colors: [
                                        DesignColors.accent,
                                        DesignColors.accent.opacity(0.9),
                                        Color(red: 185/255, green: 110/255, blue: 70/255).opacity(0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                cornerRadius: 12,
                                height: 52,
                                shadow: ArotiButtonShadow(
                                    color: DesignColors.accent.opacity(0.4),
                                    radius: 12,
                                    x: 0,
                                    y: 6
                                )
                            )),
                            action: {
                                dismiss()
                                showPaywall = true
                            },
                            label: {
                                Text("Upgrade to Premium")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                            }
                        )
                        .padding(.top, 8)
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: ArotiRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: ArotiRadius.lg)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: DesignColors.accent.opacity(0.2), radius: 16, x: 0, y: 8)
    }
    
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(DesignColors.accent)
            Text(text)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground)
        }
    }
    
    // MARK: - Payment Method Card (Modern Premium Design)
    
    private var paymentMethodCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 0) {
                // Header Row
                HStack(spacing: 12) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 20))
                        .foregroundColor(DesignColors.foreground)
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.08))
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Text("Payment Method")
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                }
                .padding(.bottom, 16)
                
                // Divider
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.bottom, 16)
                
                // Body Content
                if isPremium {
                    // Premium: Show mock payment data
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 18))
                                .foregroundColor(DesignColors.accent)
                            Text("Visa •••• 1234")
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                        }
                        
                        #if os(iOS)
                        Text("Billed through your Apple ID")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        #else
                        Text("Billed through your Google Play account")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                        #endif
                        
                        Text("Your payment details are securely stored and managed by the store provider.")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                } else {
                    // Free: Empty state with modern design
                    VStack(spacing: 12) {
                        Image(systemName: "creditcard.badge.plus")
                            .font(.system(size: 36))
                            .foregroundColor(DesignColors.mutedForeground)
                        
                        Text("No payment method yet")
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("Your payment details will be securely linked to your Apple ID when you upgrade.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .multilineTextAlignment(.center)
                        
                        #if os(iOS)
                        Text("Apple ID manages your billing.")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                            .padding(.top, 4)
                        #else
                        Text("Google Play manages your billing.")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                            .padding(.top, 4)
                        #endif
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Purchase History Card (Modern Premium Design)
    
    private var purchaseHistoryCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 0) {
                // Header Row
                HStack(spacing: 12) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 20))
                        .foregroundColor(DesignColors.foreground)
                        .frame(width: 40, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.08))
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Text("Purchase History")
                        .font(DesignTypography.headlineFont(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                }
                .padding(.bottom, 16)
                
                // Divider
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.bottom, 16)
                
                // Body Content
                if purchaseHistory.isEmpty {
                    // Empty state with modern design
                    VStack(spacing: 12) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 36))
                            .foregroundColor(DesignColors.mutedForeground)
                        
                        Text("No purchases yet")
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("Your subscription renewals will appear here once you subscribe.")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                } else {
                    VStack(spacing: 12) {
                        ForEach(purchaseHistory, id: \.id) { item in
                            purchaseHistoryRow(item: item)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func purchaseHistoryRow(item: PurchaseItem) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                .font(DesignTypography.bodyFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            Text("\(item.amount) · \(item.date)")
                .font(DesignTypography.subheadFont())
                .foregroundColor(DesignColors.mutedForeground)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
    
    // MARK: - Billing & Support Section
    
    private var billingSupportSection: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Billing & support")
                    .font(DesignTypography.subheadFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground.opacity(0.9))
                
                Text("For issues with your membership, charges or refunds, please manage your subscription in the App Store or contact support.")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                VStack(spacing: 12) {
                    #if os(iOS)
                    Button(action: {
                        openSubscriptionManagement()
                    }) {
                        HStack {
                            Text("Manage in App Store")
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 14))
                                .foregroundColor(DesignColors.accent.opacity(0.7))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    #else
                    Button(action: {
                        openSubscriptionManagement()
                    }) {
                        HStack {
                            Text("Manage in Google Play")
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 14))
                                .foregroundColor(DesignColors.accent.opacity(0.7))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    #endif
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    Button(action: {
                        if let url = URL(string: "mailto:support@aroti.com?subject=Billing Inquiry") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text("Contact support")
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 14))
                                .foregroundColor(DesignColors.accent.opacity(0.7))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadData() {
        isLoading = true
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isLoading = false
        }
    }
    
    private func openSubscriptionManagement() {
        #if os(iOS)
        // iOS: Open App Store subscription management
        // Use URL approach as it's more reliable across iOS versions
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url)
        }
        #else
        // Android: Open Google Play subscription management
        if let url = URL(string: "https://play.google.com/store/account/subscriptions") {
            UIApplication.shared.open(url)
        }
        #endif
    }
}

// MARK: - Purchase Item Model

struct PurchaseItem: Identifiable {
    let id = UUID()
    let title: String
    let amount: String
    let date: String
}

