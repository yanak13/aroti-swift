//
//  PaymentMethodSheet.swift
//  Aroti
//
//  Payment method selection page for premium subscription
//

import SwiftUI

struct PaymentMethodSheet: View {
    @Environment(\.dismiss) var dismiss
    let selectedPlan: PremiumPlan
    let onConfirm: () -> Void
    
    @State private var selectedPaymentMethod: PaymentMethodType = .applePay
    @State private var agreedToTerms: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String?
    
    enum PaymentMethodType {
        case applePay
        case appStoreBilling
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background matching paywall style
                deepGradientBackground
                    .ignoresSafeArea()
                vignetteOverlay
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSpacing.md) {
                        // Subscription Summary Card
                        subscriptionSummaryCard
                            .padding(.horizontal, DesignSpacing.md)
                            .padding(.top, DesignSpacing.md)
                        
                        // Payment Method Selection
                        VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                            Text("Payment Method")
                                .font(ArotiTextStyle.subhead)
                                .fontWeight(.semibold)
                                .foregroundColor(ArotiColor.textPrimary)
                                .padding(.horizontal, DesignSpacing.md)
                            
                            VStack(spacing: DesignSpacing.sm) {
                                // Apple Pay
                                PaymentMethodButton(
                                    title: "Apple Pay",
                                    icon: Image(systemName: "applelogo"),
                                    isSelected: selectedPaymentMethod == .applePay
                                ) {
                                    selectedPaymentMethod = .applePay
                                    HapticFeedback.impactOccurred(.light)
                                }
                                
                                // App Store Billing
                                PaymentMethodButton(
                                    title: "App Store Billing",
                                    icon: Image(systemName: "creditcard"),
                                    isSelected: selectedPaymentMethod == .appStoreBilling
                                ) {
                                    selectedPaymentMethod = .appStoreBilling
                                    HapticFeedback.impactOccurred(.light)
                                }
                            }
                            .padding(.horizontal, DesignSpacing.md)
                        }
                        
                        // Terms Agreement
                        termsAgreementView
                            .padding(.horizontal, DesignSpacing.md)
                        
                        // Confirm Button
                        confirmButton
                            .padding(.horizontal, DesignSpacing.md)
                            .padding(.bottom, DesignSpacing.xl)
                    }
                }
            }
            .navigationTitle("Confirm Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .preferredColorScheme(.dark)
            .environment(\.colorScheme, .dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        HapticFeedback.impactOccurred(.light)
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(ArotiColor.textSecondary)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Something went wrong. Please try again.")
            }
        }
    }
    
    // MARK: - Background
    
    private var deepGradientBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 18/255, green: 12/255, blue: 26/255),
                Color(red: 10/255, green: 8/255, blue: 20/255),
                Color(red: 4/255, green: 4/255, blue: 12/255)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var vignetteOverlay: some View {
        ZStack {
            RadialGradient(
                colors: [
                    Color.white.opacity(0.08),
                    Color.clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 380
            )
            .blendMode(.screen)
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.35),
                    Color.clear,
                    Color.black.opacity(0.35)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.overlay)
        }
    }
    
    // MARK: - Subscription Summary Card
    
    private var subscriptionSummaryCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                // Plan Name
                Text(planName)
                    .font(ArotiTextStyle.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(ArotiColor.textPrimary)
                
                // Trial Information (if applicable)
                if selectedPlan == .weekly {
                    HStack(spacing: DesignSpacing.xs) {
                        Image(systemName: "gift.fill")
                            .foregroundColor(ArotiColor.accent)
                            .font(.system(size: 14))
                        Text("3-day free trial, then")
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textSecondary)
                    }
                    .padding(.top, DesignSpacing.xs)
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.vertical, DesignSpacing.xs)
                
                // Price Breakdown
                VStack(spacing: DesignSpacing.xs) {
                    HStack {
                        Text("Price")
                            .font(ArotiTextStyle.subhead)
                            .foregroundColor(ArotiColor.textSecondary)
                        Spacer()
                        Text(price)
                            .font(ArotiTextStyle.subhead)
                            .fontWeight(.semibold)
                            .foregroundColor(ArotiColor.textPrimary)
                    }
                    
                    HStack {
                        Text("Billing Cycle")
                            .font(ArotiTextStyle.subhead)
                            .foregroundColor(ArotiColor.textSecondary)
                        Spacer()
                        Text(billingCycle)
                            .font(ArotiTextStyle.subhead)
                            .foregroundColor(ArotiColor.textPrimary)
                    }
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.vertical, DesignSpacing.xs)
                
                // Total
                HStack {
                    Text("Total")
                        .font(ArotiTextStyle.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(ArotiColor.textPrimary)
                    Spacer()
                    Text(price)
                        .font(ArotiTextStyle.headline)
                        .fontWeight(.bold)
                        .foregroundColor(ArotiColor.accent)
                }
                
                // Auto-renewable notice
                HStack(spacing: DesignSpacing.xs) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(ArotiColor.textMuted)
                        .font(.system(size: 12))
                    Text("Auto-renewable subscription. Cancel anytime.")
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.textMuted)
                }
                .padding(.top, DesignSpacing.xs)
            }
        }
    }
    
    // MARK: - Terms Agreement
    
    private var termsAgreementView: some View {
        HStack(alignment: .top, spacing: DesignSpacing.sm) {
            Button(action: {
                agreedToTerms.toggle()
                HapticFeedback.impactOccurred(.light)
            }) {
                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                    .foregroundColor(agreedToTerms ? ArotiColor.accent : ArotiColor.textMuted)
                    .font(.system(size: 20))
            }
            
            Text("I agree to the Terms of Service, Privacy Policy, and Subscription Terms")
                .font(ArotiTextStyle.caption1)
                .foregroundColor(ArotiColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Confirm Button
    
    private var confirmButton: some View {
        ArotiButton(
            kind: .custom(ArotiButtonStyle(
                foregroundColor: ArotiColor.accentText,
                backgroundGradient: LinearGradient(
                    colors: [
                        ArotiColor.accent,
                        ArotiColor.accent.opacity(0.85)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                cornerRadius: ArotiRadius.lg,
                height: ArotiButtonHeight.large,
                shadow: ArotiButtonShadow(
                    color: ArotiColor.accent.opacity(0.35),
                    radius: 16,
                    x: 0,
                    y: 10
                )
            )),
            isDisabled: !canConfirm,
            action: {
                HapticFeedback.impactOccurred(.medium)
                handleConfirm()
            },
            label: {
                Text("Confirm Subscription")
                    .font(ArotiTextStyle.subhead)
                    .fontWeight(.semibold)
            }
        )
    }
    
    // MARK: - Computed Properties
    
    private var planName: String {
        switch selectedPlan {
        case .weekly:
            return "Weekly Plan"
        case .quarterly:
            return "Quarterly Plan"
        case .yearly:
            return "Yearly Plan"
        case .monthly:
            return "Monthly Plan"
        }
    }
    
    private var price: String {
        switch selectedPlan {
        case .weekly:
            return "$6.99"
        case .quarterly:
            return "$34.99"
        case .yearly:
            return "$44.99"
        case .monthly:
            return "$9.99"
        }
    }
    
    private var billingCycle: String {
        switch selectedPlan {
        case .weekly:
            return "Weekly"
        case .quarterly:
            return "Every 3 months"
        case .yearly:
            return "Yearly"
        case .monthly:
            return "Monthly"
        }
    }
    
    private var canConfirm: Bool {
        agreedToTerms
    }
    
    // MARK: - Actions
    
    private func handleConfirm() {
        // Dismiss payment method sheet and proceed with purchase
        dismiss()
        onConfirm()
    }
}
