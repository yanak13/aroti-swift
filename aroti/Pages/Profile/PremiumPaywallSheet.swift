//
//  PremiumPaywallSheet.swift
//  Aroti
//
//  Premium paywall with Nebula-style structure
//

import SwiftUI

struct PremiumPaywallSheet: View {
    @Environment(\.dismiss) var dismiss
    let context: String?
    let title: String?
    let description: String?
    let onDismiss: (() -> Void)? // Optional callback for onboarding flow
    
    // State management
    @State private var selectedPlan: PremiumPlan = .weekly
    @State private var selectedSlideIndex: Int = 0
    @State private var isProcessingPurchase: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String?
    @State private var ctaButtonScale: CGFloat = 1.0
    
    // Footer sheet states
    @State private var showTermsOfService = false
    @State private var showPrivacyPolicy = false
    @State private var showSubscriptionTerms = false
    @State private var isRestoring = false
    
    // Payment method sheet state
    @State private var showPaymentMethod = false
    
    init(context: String? = nil, title: String? = nil, description: String? = nil, onDismiss: (() -> Void)? = nil) {
        self.context = context
        self.title = title
        self.description = description
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Background
                    deepGradientBackground
                        .ignoresSafeArea()
                    vignetteOverlay
                        .ignoresSafeArea()
                    
                    // Fixed layout - no scrolling with proper spacing
                    VStack(spacing: 0) {
                        // Carousel section (48% of height) - reduced further to move content up
                        PaywallCarouselView(selectedSlideIndex: $selectedSlideIndex)
                            .frame(height: geometry.size.height * 0.48)
                        
                        // Plan selector (26% of height) - increased to accommodate taller cards
                        PlanSelectorView(selectedPlan: $selectedPlan)
                            .frame(height: geometry.size.height * 0.26)
                        
                        // CTA + Footer (26% of height) - increased to prevent overlap
                        VStack(spacing: DesignSpacing.xs) {
                            // Primary CTA
                            ctaButton
                            
                            // Trust row
                            trustRow
                            
                            // Footer
                            footerView
                        }
                        .padding(.horizontal, DesignSpacing.md)
                        .padding(.top, DesignSpacing.xs) // Add gap from plan selector
                        .padding(.bottom, geometry.safeAreaInsets.bottom + DesignSpacing.xs)
                        .frame(height: geometry.size.height * 0.26)
                    }
                    .padding(.top, geometry.safeAreaInsets.top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .preferredColorScheme(.dark)
            .environment(\.colorScheme, .dark)
            .toolbar {
                // Close button removed
            }
            .alert("Purchase Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Something went wrong while upgrading. Please try again or check your App Store connection.")
            }
            .sheet(isPresented: $showTermsOfService) {
                TermsOfUseSheet()
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicySheet()
            }
            .sheet(isPresented: $showSubscriptionTerms) {
                SubscriptionTermsSheet()
            }
            .sheet(isPresented: $showPaymentMethod) {
                PaymentMethodSheet(
                    selectedPlan: selectedPlan,
                    onConfirm: {
                        handlePaymentMethodConfirm()
                    }
                )
            }
            .onAppear {
                startCTAAnimation()
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
    
    // MARK: - CTA Button
    
    private var ctaButton: some View {
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
            isDisabled: isProcessingPurchase || isRestoring,
            action: {
                HapticFeedback.impactOccurred(.medium)
                handlePurchase()
            },
            label: {
                if isProcessingPurchase {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        Text("Processing...")
                            .font(ArotiTextStyle.subhead)
                            .fontWeight(.semibold)
                    }
                } else {
                    Text(ctaButtonText)
                        .font(ArotiTextStyle.subhead)
                        .fontWeight(.semibold)
                }
            }
        )
        .scaleEffect(isProcessingPurchase ? 1.0 : ctaButtonScale)
    }
    
    private var ctaButtonText: String {
        if selectedPlan == .weekly {
            return "Start Free Trial"
        }
        return "Continue"
    }
    
    // MARK: - Trust Row
    
    private var trustRow: some View {
        Text("No ads • Secured with App Store • Cancel anytime.")
            .font(ArotiTextStyle.caption2)
            .foregroundColor(ArotiColor.textSecondary)
            .multilineTextAlignment(.center)
            .lineLimit(2)
    }
    
    // MARK: - Footer
    
    private var footerView: some View {
        VStack(spacing: DesignSpacing.xs) {
            // "Continue with Free Version" button (shown in onboarding)
            if onDismiss != nil {
                Button(action: {
                    HapticFeedback.impactOccurred(.light)
                    onDismiss?()
                }) {
                    Text("Continue with Free Version")
                        .font(ArotiTextStyle.caption1)
                        .foregroundColor(ArotiColor.textMuted)
                }
                .buttonStyle(.plain)
                .padding(.bottom, DesignSpacing.xs)
            }
            
            // Restore button
            Button(action: {
                HapticFeedback.impactOccurred(.light)
                handleRestore()
            }) {
                Text("Restore Purchases")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
            }
            .buttonStyle(.plain)
            .disabled(isRestoring || isProcessingPurchase)
            
            // Legal links
            HStack(spacing: DesignSpacing.xs) {
                Button(action: {
                    showTermsOfService = true
                }) {
                    Text("Terms of Service")
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.textMuted)
                }
                .buttonStyle(.plain)
                
                Text("•")
                    .font(ArotiTextStyle.caption2)
                    .foregroundColor(ArotiColor.textMuted)
                
                Button(action: {
                    showPrivacyPolicy = true
                }) {
                    Text("Privacy Policy")
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.textMuted)
                }
                .buttonStyle(.plain)
                
                Text("•")
                    .font(ArotiTextStyle.caption2)
                    .foregroundColor(ArotiColor.textMuted)
                
                Button(action: {
                    showSubscriptionTerms = true
                }) {
                    Text("Subscription Terms")
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.textMuted)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Purchase Handler
    
    private func handlePurchase() {
        // Show payment method sheet instead of directly calling StoreKit
        showPaymentMethod = true
    }
    
    // MARK: - Payment Method Confirm Handler
    
    private func handlePaymentMethodConfirm() {
        isProcessingPurchase = true
        
        Task {
            do {
                let success = try await StoreKitService.shared.purchase(plan: selectedPlan)
                
                await MainActor.run {
                    isProcessingPurchase = false
                    
                    if success {
                        // Update premium status
                        UserSubscriptionService.shared.setPremium(true)
                        
                        // Call onDismiss callback if provided (for onboarding), otherwise dismiss
                        if let onDismiss = onDismiss {
                            onDismiss()
                        } else {
                            dismiss()
                        }
                    } else {
                        showError = true
                        errorMessage = "Purchase was not completed. Please try again."
                    }
                }
            } catch {
                await MainActor.run {
                    isProcessingPurchase = false
                    showError = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Restore Handler
    
    private func handleRestore() {
        isRestoring = true
        
        Task {
            do {
                let success = try await StoreKitService.shared.restorePurchases()
                
                await MainActor.run {
                    isRestoring = false
                    
                    if success {
                        // Check if user has premium now
                        if UserSubscriptionService.shared.isPremium {
                            // Call onDismiss callback if provided (for onboarding), otherwise dismiss
                            if let onDismiss = onDismiss {
                                onDismiss()
                            } else {
                                dismiss()
                            }
                        } else {
                            showError = true
                            errorMessage = "No previous purchases found to restore."
                        }
                    } else {
                        showError = true
                        errorMessage = "Failed to restore purchases. Please try again."
                    }
                }
            } catch {
                await MainActor.run {
                    isRestoring = false
                    showError = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - CTA Animation
    
    private func startCTAAnimation() {
        // Subtle breathing animation - only when not processing
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            ctaButtonScale = 1.02
        }
    }
}
