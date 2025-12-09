//
//  PremiumPaywallSheet.swift
//  Aroti
//
//  Premium upgrade paywall screen - high-conversion design
//

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
    @State private var expandedFAQItems: Set<String> = []
    @State private var ctaButtonScale: CGFloat = 1.0
    
    // Pricing
    private let monthlyPrice = "$9.99"
    private let yearlyPrice = "$59.99"
    private let yearlyMonthlyEquivalent = "$4.99"
    
    init(context: String? = nil, title: String? = nil, description: String? = nil) {
        self.context = context
        self.title = title
        self.description = description
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: DesignSpacing.lg) {
                        // Hero Section
                        heroSection
                        
                        // Emotional Benefits
                        emotionalBenefitsSection
                        
                        // Feature Preview Cards
                        featurePreviewCards
                        
                        // Free vs Premium Comparison
                        comparisonTable
                        
                        // Social Proof / Testimonials
                        testimonialsSection
                        
                        // Pricing Selector
                        pricingSelector
                        
                        // Primary CTA
                        primaryCTA
                        
                        // Trust & Safety
                        trustSection
                        
                        // FAQ
                        faqSection
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .padding(.vertical, DesignSpacing.md)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
    
    // MARK: - Hero Section
    
    private var heroSection: some View {
        ZStack {
            // Cosmic gradient background
            LinearGradient(
                colors: [
                    Color(red: 185/255, green: 110/255, blue: 70/255).opacity(0.25),
                    Color(red: 185/255, green: 110/255, blue: 70/255).opacity(0.15),
                    Color(red: 120/255, green: 80/255, blue: 100/255).opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Glassmorphism overlay
            Color.white.opacity(0.05)
            
            // Content
            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                // Icon
                HStack {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 32))
                        .foregroundColor(ArotiColor.accent)
                    Spacer()
                }
                
                // Title
                Text("Unlock your higher clarity")
                    .font(ArotiTextStyle.largeTitle)
                    .foregroundColor(ArotiColor.textPrimary)
                    .multilineTextAlignment(.leading)
                
                // Subtitle
                VStack(alignment: .leading, spacing: 8) {
                    Text("Premium rituals, deep insights, and cosmic guidance — fully unlimited.")
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                    
                    Text("Feel aligned, grounded, and guided every day.")
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                }
            }
            .padding(DesignSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: ArotiRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: ArotiRadius.lg)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: ArotiColor.accent.opacity(0.2), radius: 16, x: 0, y: 8)
    }
    
    // MARK: - Emotional Benefits Section
    
    private var emotionalBenefitsSection: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                Text("With Aroti Premium, you will…")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                
                VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                    benefitRow(icon: "leaf.fill", text: "Feel grounded with rituals made for your exact cosmic blueprint")
                    benefitRow(icon: "chart.bar.fill", text: "Go deeper into your advanced astrology + numerology")
                    benefitRow(icon: "brain.head.profile", text: "Access powerful interpretations for clarity and decision-making")
                    benefitRow(icon: "moon.stars.fill", text: "Stay aligned with your monthly cosmic guidance")
                    benefitRow(icon: "sparkles", text: "Experience a sense of purpose, structure, and inner peace")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Premium icon badge
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.3),
                                ArotiColor.accent.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .blur(radius: 4)
                
                // Icon container
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                ArotiColor.accent.opacity(0.25),
                                ArotiColor.accent.opacity(0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        ArotiColor.accent.opacity(0.4),
                                        ArotiColor.accent.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(ArotiColor.accent)
            }
            
            Text(text)
                .font(ArotiTextStyle.body)
                .foregroundColor(ArotiColor.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Feature Preview Cards
    
    private var featurePreviewCards: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.sm) {
            Text("Premium Features")
                .font(ArotiTextStyle.title3)
                .foregroundColor(ArotiColor.textPrimary)
                .padding(.horizontal, DesignSpacing.sm)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignSpacing.sm) {
                    featureCard(
                        icon: "moon.stars.fill",
                        title: "Deep Rituals",
                        description: "Access advanced step-by-step rituals tailored to your energy."
                    )
                    
                    featureCard(
                        icon: "chart.bar.fill",
                        title: "Astrology Profile",
                        description: "See your full cosmic chart with detailed explanations."
                    )
                    
                    featureCard(
                        icon: "sparkles",
                        title: "Premium Guidance",
                        description: "Chat with Aroti for unlimited, personalized insights."
                    )
                }
                .padding(.horizontal, DesignSpacing.sm)
            }
            .padding(.horizontal, -DesignSpacing.sm)
        }
    }
    
    private func featureCard(icon: String, title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(ArotiColor.accent)
            
            Text(title)
                .font(ArotiTextStyle.headline)
                .foregroundColor(ArotiColor.textPrimary)
            
            Text(description)
                .font(ArotiTextStyle.caption1)
                .foregroundColor(ArotiColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignSpacing.md)
        .frame(width: 240)
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.md)
                .fill(ArotiColor.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .stroke(ArotiColor.border, lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Comparison Table
    
    private var comparisonTable: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                Text("Free vs Premium")
                    .font(ArotiTextStyle.title3)
                    .foregroundColor(ArotiColor.textPrimary)
                
                VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 0) {
                        Text("Feature")
                            .font(ArotiTextStyle.subhead)
                            .foregroundColor(ArotiColor.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Free")
                            .font(ArotiTextStyle.subhead)
                            .foregroundColor(ArotiColor.textSecondary)
                            .frame(width: 80, alignment: .center)
                        
                        Text("Premium")
                            .font(ArotiTextStyle.subhead)
                            .foregroundColor(ArotiColor.accent)
                            .frame(width: 80, alignment: .center)
                    }
                    .padding(.bottom, DesignSpacing.sm)
                    
                    Divider()
                        .background(Color.white.opacity(0.1))
                        .padding(.bottom, DesignSpacing.sm)
                    
                    // Rows
                    comparisonRow(feature: "Daily rituals", free: true, premium: true, premiumNote: "Deep version")
                    comparisonRow(feature: "Advanced rituals", free: false, premium: true)
                    comparisonRow(feature: "Full astrology profile", free: false, premium: true)
                    comparisonRow(feature: "Full numerology blueprint", free: false, premium: true)
                    comparisonRow(feature: "Unlimited AI guidance", free: false, premium: true)
                    comparisonRow(feature: "Monthly cosmic forecast", free: false, premium: true)
                    comparisonRow(feature: "Priority support", free: false, premium: true)
                    comparisonRow(feature: "No ads", free: false, premium: true)
                }
                
                Text("Premium removes limits and unlocks your full cosmic journey.")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                    .padding(.top, DesignSpacing.xs)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func comparisonRow(feature: String, free: Bool, premium: Bool, premiumNote: String? = nil) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(feature)
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    if free {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ArotiColor.textSecondary)
                    } else {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ArotiColor.textMuted)
                    }
                }
                .frame(width: 80, alignment: .center)
                
                HStack {
                    if premium {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ArotiColor.accent)
                    } else {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ArotiColor.textMuted)
                    }
                }
                .frame(width: 80, alignment: .center)
            }
            .padding(.vertical, 10)
            
            if let note = premiumNote {
                Text(note)
                    .font(ArotiTextStyle.caption2)
                    .foregroundColor(ArotiColor.textMuted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 0)
                    .padding(.bottom, 4)
            }
            
            Divider()
                .background(Color.white.opacity(0.05))
        }
    }
    
    // MARK: - Testimonials Section
    
    private var testimonialsSection: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: DesignSpacing.md) {
                Text("What our members say")
                    .font(ArotiTextStyle.title3)
                    .foregroundColor(ArotiColor.textPrimary)
                
                // Star rating
                HStack(spacing: 4) {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                            .foregroundColor(ArotiColor.accent)
                    }
                    Text("4.8 average rating")
                        .font(ArotiTextStyle.caption1)
                        .foregroundColor(ArotiColor.textSecondary)
                }
                .padding(.bottom, DesignSpacing.xs)
                
                // Testimonials
                VStack(spacing: DesignSpacing.md) {
                    testimonialQuote(
                        text: "Premium feels like having a personal spiritual guide with me every day.",
                        author: "Anna"
                    )
                    
                    testimonialQuote(
                        text: "My rituals finally make sense. The clarity is unreal.",
                        author: "Maria"
                    )
                    
                    testimonialQuote(
                        text: "Life-changing depth. It's worth every cent.",
                        author: "Sophia"
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func testimonialQuote(text: String, author: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\"\(text)\"")
                .font(ArotiTextStyle.body)
                .foregroundColor(ArotiColor.textPrimary)
                .italic()
            
            Text("— \(author)")
                .font(ArotiTextStyle.caption1)
                .foregroundColor(ArotiColor.textSecondary)
        }
        .padding(DesignSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.sm)
                .fill(Color.white.opacity(0.03))
        )
    }
    
    // MARK: - Pricing Selector
    
    private var pricingSelector: some View {
        VStack(spacing: DesignSpacing.md) {
            // Toggle
            HStack(spacing: 0) {
                pricingToggleOption(plan: .monthly, label: "Monthly")
                pricingToggleOption(plan: .yearly, label: "Yearly", badge: "Save 20%")
            }
            .background(
                RoundedRectangle(cornerRadius: ArotiRadius.pill)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: ArotiRadius.pill)
                    .stroke(ArotiColor.border, lineWidth: 1)
            )
            
            // Pricing Cards
            HStack(spacing: DesignSpacing.sm) {
                pricingCard(
                    plan: .monthly,
                    label: "Monthly",
                    price: monthlyPrice,
                    period: "/ month",
                    subtext: "Flexible monthly billing",
                    isPopular: false
                )
                
                pricingCard(
                    plan: .yearly,
                    label: "Yearly · Save 20%",
                    price: yearlyPrice,
                    period: "/ year",
                    subtext: "Only \(yearlyMonthlyEquivalent) per month, billed annually",
                    isPopular: true
                )
            }
        }
    }
    
    private func pricingToggleOption(plan: PremiumPlan, label: String, badge: String? = nil) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedPlan = plan
            }
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Text(label)
                        .font(ArotiTextStyle.subhead)
                        .foregroundColor(selectedPlan == plan ? ArotiColor.textPrimary : ArotiColor.textSecondary)
                    
                    if let badge = badge {
                        Text(badge)
                            .font(ArotiTextStyle.caption2)
                            .foregroundColor(ArotiColor.accent)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(ArotiColor.accent.opacity(0.15))
                            )
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                Group {
                    if selectedPlan == plan {
                        RoundedRectangle(cornerRadius: ArotiRadius.pill)
                            .fill(ArotiColor.accent.opacity(0.2))
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func pricingCard(plan: PremiumPlan, label: String, price: String, period: String, subtext: String, isPopular: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if isPopular {
                    Text("Most popular")
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(ArotiColor.accent.opacity(0.15))
                        )
                }
                Spacer()
            }
            
            Text(label)
                .font(ArotiTextStyle.subhead)
                .foregroundColor(ArotiColor.textSecondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(price)
                    .font(ArotiTextStyle.title1)
                    .foregroundColor(ArotiColor.textPrimary)
                
                Text(period)
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.textSecondary)
            }
            
            Text(subtext)
                .font(ArotiTextStyle.caption1)
                .foregroundColor(ArotiColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(DesignSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.md)
                .fill(selectedPlan == plan ? ArotiColor.accent.opacity(0.1) : ArotiColor.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.md)
                        .stroke(selectedPlan == plan ? ArotiColor.accent.opacity(0.5) : ArotiColor.border, lineWidth: selectedPlan == plan ? 2 : 1)
                )
        )
        .scaleEffect(selectedPlan == plan ? 1.02 : 1.0)
        .opacity(selectedPlan == plan ? 1.0 : 0.7)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedPlan)
    }
    
    // MARK: - Primary CTA
    
    private var primaryCTA: some View {
        VStack(spacing: DesignSpacing.sm) {
            ArotiButton(
                kind: .custom(ArotiButtonStyle(
                    foregroundColor: ArotiColor.accentText,
                    backgroundGradient: LinearGradient(
                        colors: [
                            ArotiColor.accent,
                            ArotiColor.accent.opacity(0.9),
                            Color(red: 185/255, green: 110/255, blue: 70/255).opacity(0.8)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    cornerRadius: ArotiRadius.md,
                    height: ArotiButtonHeight.large,
                    shadow: ArotiButtonShadow(
                        color: ArotiColor.accent.opacity(0.4),
                        radius: 12,
                        x: 0,
                        y: 6
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
                        Text("Unlock Premium")
                            .font(ArotiTextStyle.subhead)
                            .fontWeight(.semibold)
                    }
                }
            )
            .scaleEffect(isProcessingPurchase ? 1.0 : ctaButtonScale)
            
            Text("No commitment. Cancel anytime in your App Store settings.")
                .font(ArotiTextStyle.caption2)
                .foregroundColor(ArotiColor.textMuted)
                .multilineTextAlignment(.center)
            
            Text("Subscriptions are managed by Apple.")
                .font(ArotiTextStyle.caption2)
                .foregroundColor(ArotiColor.textMuted.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Trust Section
    
    private var trustSection: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: DesignSpacing.sm) {
                Text("Your journey is safe")
                    .font(ArotiTextStyle.headline)
                    .foregroundColor(ArotiColor.textPrimary)
                
                Text("Payments are handled securely by Apple. You can manage or cancel your subscription at any time in your App Store settings. No hidden fees.")
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - FAQ Section
    
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: DesignSpacing.sm) {
            Text("Frequently Asked Questions")
                .font(ArotiTextStyle.title3)
                .foregroundColor(ArotiColor.textPrimary)
                .padding(.horizontal, DesignSpacing.sm)
            
            VStack(spacing: DesignSpacing.xs) {
                faqItem(
                    question: "What happens after upgrading?",
                    answer: "You immediately unlock all Premium rituals, full astrology + numerology profiles, and unlimited AI guidance, using the same account you have now."
                )
                
                faqItem(
                    question: "Can I cancel anytime?",
                    answer: "Yes. You can manage or cancel your subscription directly through the App Store, without contacting support."
                )
                
                faqItem(
                    question: "Will I lose my data if I cancel?",
                    answer: "Your rituals, readings, and history remain in your account. You simply lose access to Premium-only features."
                )
                
                faqItem(
                    question: "Is Premium personalized to me?",
                    answer: "Yes. Aroti uses your birth details and personal inputs to tailor rituals and insights to your unique cosmic blueprint."
                )
            }
        }
    }
    
    private func faqItem(question: String, answer: String) -> some View {
        let itemId = question
        let isExpanded = expandedFAQItems.contains(itemId)
        
        return VStack(spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                    if isExpanded {
                        expandedFAQItems.remove(itemId)
                    } else {
                        expandedFAQItems.insert(itemId)
                    }
                }
            }) {
                HStack(spacing: 12) {
                    Text(question)
                        .font(ArotiTextStyle.subhead)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(ArotiColor.accent)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.32, dampingFraction: 0.86), value: isExpanded)
                }
                .padding(DesignSpacing.sm)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    Text(answer)
                        .font(ArotiTextStyle.body)
                        .foregroundColor(ArotiColor.textSecondary)
                        .padding(DesignSpacing.sm)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity
                ))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: ArotiRadius.sm)
                .fill(Color.white.opacity(0.02))
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.sm)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
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
