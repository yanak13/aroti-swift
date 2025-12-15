import SwiftUI

struct PremiumPaywallSheet: View {
    @Environment(\.dismiss) var dismiss
    let context: String?
    let title: String?
    let description: String?
    
    // State management
    @State private var selectedPlan: PremiumPlan = .yearly
    @State private var isProcessingPurchase: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String?
    @State private var ctaButtonScale: CGFloat = 1.0
    
    init(context: String? = nil, title: String? = nil, description: String? = nil) {
        self.context = context
        self.title = title
        self.description = description
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    deepGradientBackground
                        .ignoresSafeArea()
                    vignetteOverlay
                        .ignoresSafeArea()
                    
                    VStack(spacing: DesignSpacing.lg) {
                        headerSection
                        
                        carouselSection
                        
                        trustBadge
                        
                        Spacer(minLength: 0)
                        
                        ctaSection
                    }
                    .padding(.horizontal, DesignSpacing.md)
                    .padding(.top, geometry.safeAreaInsets.top + DesignSpacing.lg)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + DesignSpacing.lg)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .preferredColorScheme(.dark)
            .environment(\.colorScheme, .dark)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(ArotiColor.textPrimary)
                }
            }
            .alert("Purchase Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Something went wrong while upgrading. Please try again or check your App Store connection.")
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
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.sm) {
            Text("Your Premium Toolkit Is Ready")
                .font(ArotiTextStyle.title1)
                .foregroundColor(ArotiColor.textPrimary)
                .multilineTextAlignment(.leading)
            
            Text("These tools are locked on the free plan")
                .font(ArotiTextStyle.caption1)
                .foregroundColor(ArotiColor.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Carousel
    
    private var carouselSection: some View {
        PremiumToolkitCarousel()
    }
    
    // MARK: - Trust Badge
    
    private var trustBadge: some View {
        VStack(spacing: 4) {
            Text("Included with Premium")
                .font(ArotiTextStyle.caption1)
                .foregroundColor(ArotiColor.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                )
            
            if let context, !context.isEmpty {
                Text("Based on your profile and activity")
                    .font(ArotiTextStyle.caption2)
                    .foregroundColor(ArotiColor.textSecondary)
            }
        }
    }
    
    // MARK: - CTA Section
    
    private var ctaSection: some View {
        VStack(spacing: DesignSpacing.sm) {
            ArotiButton(
                kind: .custom(ArotiButtonStyle(
                    foregroundColor: ArotiColor.accentText,
                    backgroundGradient: LinearGradient(
                        colors: [
                            Color(red: 255/255, green: 188/255, blue: 120/255),
                            Color(red: 255/255, green: 140/255, blue: 102/255),
                            Color(red: 195/255, green: 98/255, blue: 140/255)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    cornerRadius: ArotiRadius.lg,
                    height: ArotiButtonHeight.large,
                    shadow: ArotiButtonShadow(
                        color: Color(red: 255/255, green: 188/255, blue: 120/255).opacity(0.35),
                        radius: 16,
                        x: 0,
                        y: 10
                    )
                )),
                isDisabled: isProcessingPurchase,
                action: {
                    handlePurchase()
                },
                label: {
                    if isProcessingPurchase {
                        HStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Processing...")
                                .font(ArotiTextStyle.subhead)
                        }
                    } else {
                        Text("Start Free Trial")
                            .font(ArotiTextStyle.subhead)
                            .fontWeight(.semibold)
                    }
                }
            )
            .scaleEffect(isProcessingPurchase ? 1.0 : ctaButtonScale)
            
            Text("Full access · Cancel anytime")
                .font(ArotiTextStyle.caption2)
                .foregroundColor(ArotiColor.textSecondary)
            
            Button(action: {
                dismiss()
            }) {
                Text("Continue with Free Version")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textMuted)
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Purchase Handler
    
    private func handlePurchase() {
        isProcessingPurchase = true
        
        Task {
            do {
                let success = try await StoreKitService.shared.purchase(plan: selectedPlan)
                
                await MainActor.run {
                    isProcessingPurchase = false
                    
                    if success {
                        // Update premium status
                        UserSubscriptionService.shared.setPremium(true)
                        
                        // Dismiss and refresh
                        dismiss()
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
