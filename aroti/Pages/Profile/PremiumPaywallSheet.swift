import SwiftUI
import Combine

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
    @State private var currentSlide: Int = 0
    @State private var autoRotateCancellable: AnyCancellable?
    
    private let autoRotateInterval: TimeInterval = 3.5
    
    init(context: String? = nil, title: String? = nil, description: String? = nil) {
        self.context = context
        self.title = title
        self.description = description
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                deepGradientBackground
                    .ignoresSafeArea()
                vignetteOverlay
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSpacing.lg) {
                    headerSection
                    
                    carouselSection
                    
                    trustBadge
                    
                    ctaSection
                }
                .padding(.horizontal, DesignSpacing.md)
                .padding(.vertical, DesignSpacing.lg)
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
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
                startAutoRotate()
                startCTAAnimation()
            }
            .onDisappear {
                stopAutoRotate()
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
        let slides = Slide.allCases
        
        return ZStack {
            RoundedRectangle(cornerRadius: ArotiRadius.lg)
                .fill(Color.white.opacity(0.04))
                .background(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: ArotiRadius.lg)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.25), radius: 18, x: 0, y: 12)
            
            TabView(selection: $currentSlide) {
                ForEach(slides.indices, id: \.self) { index in
                    let slide = slides[index]
                    carouselCard(for: slide)
                        .padding(DesignSpacing.md)
                        .tag(index)
                        .onChange(of: currentSlide) { _ in
                            triggerSlideHaptic()
                        }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 280)
            .onChange(of: currentSlide) { _ in
                // keeps animation smooth on manual swipe
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func carouselCard(for slide: Slide) -> some View {
        VStack(alignment: .leading, spacing: DesignSpacing.md) {
            slide.visual
            
            VStack(alignment: .leading, spacing: DesignSpacing.xs) {
                HStack(spacing: DesignSpacing.xs) {
                    Text(slide.label)
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(ArotiColor.accent.opacity(0.12))
                        )
                    
                    Spacer()
                }
                
                Text(slide.title)
                    .font(ArotiTextStyle.title3)
                    .foregroundColor(ArotiColor.textPrimary)
                
                Text(slide.description)
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    // MARK: - Slide Model
    
    private enum Slide: CaseIterable {
        case guidance
        case cycles
        case reports
        case unlimited
        
        var title: String {
            switch self {
            case .guidance:
                return "Daily Personalized Guidance"
            case .cycles:
                return "Emotional Cycles Analysis"
            case .reports:
                return "Monthly Personalized Reports"
            case .unlimited:
                return "Unlimited Access Mode"
            }
        }
        
        var description: String {
            switch self {
            case .guidance:
                return "Unlimited AI guidance tailored to your profile, mood, and daily context."
            case .cycles:
                return "Understand emotional patterns across days, weeks, and months — not just today."
            case .reports:
                return "In-depth summaries combining guidance, emotions, and behavioral patterns."
            case .unlimited:
                return "No daily limits. No blocked messages. Full access to all tools."
            }
        }
        
        var label: String {
            switch self {
            case .guidance:
                return "Unlimited"
            case .cycles:
                return "Analysis"
            case .reports:
                return "Reports"
            case .unlimited:
                return "Access"
            }
        }
        
        @ViewBuilder
        var visual: some View {
            switch self {
            case .guidance:
                GuidanceVisual()
            case .cycles:
                CyclesVisual()
            case .reports:
                ReportsVisual()
            case .unlimited:
                UnlockVisual()
            }
        }
    }
    
    // MARK: - Visual Components
    
    private struct GuidanceVisual: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Unlimited")
                        .font(ArotiTextStyle.caption2)
                        .foregroundColor(ArotiColor.accent)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(ArotiColor.accent.opacity(0.16))
                        )
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    messageBubble("Morning check-in · tailored to your mood", alignment: .leading, opacity: 1.0)
                    messageBubble("Action steps · clarity for decisions", alignment: .trailing, opacity: 0.9)
                    messageBubble("Evening reset · calm guidance", alignment: .leading, opacity: 0.8)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        private func messageBubble(_ text: String, alignment: HorizontalAlignment, opacity: Double) -> some View {
            HStack {
                if alignment == .trailing { Spacer(minLength: 24) }
                Text(text)
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textPrimary)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 8)
                    .opacity(opacity)
                if alignment == .leading { Spacer(minLength: 24) }
            }
        }
    }
    
    private struct CyclesVisual: View {
        var body: some View {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.06), lineWidth: 10)
                    Circle()
                        .trim(from: 0.08, to: 0.62)
                        .stroke(
                            LinearGradient(
                                colors: [ArotiColor.accent, Color.purple.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    Circle()
                        .trim(from: 0.65, to: 0.92)
                        .stroke(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.8), Color.cyan.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Text("Cycles")
                            .font(ArotiTextStyle.caption2)
                            .foregroundColor(ArotiColor.textSecondary)
                        Text("Weekly focus")
                            .font(ArotiTextStyle.caption1)
                            .foregroundColor(ArotiColor.textPrimary)
                    }
                }
                .frame(width: 140, height: 140)
                
                VStack(alignment: .leading, spacing: 10) {
                    phaseRow("Stability phase", color: ArotiColor.accent)
                    phaseRow("Adjustment window", color: Color.blue.opacity(0.8))
                    phaseRow("Recharge days", color: Color.cyan.opacity(0.75))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        private func phaseRow(_ title: String, color: Color) -> some View {
            HStack(spacing: 8) {
                Circle()
                    .fill(color.opacity(0.7))
                    .frame(width: 10, height: 10)
                Text(title)
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textPrimary)
            }
        }
    }
    
    private struct ReportsVisual: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.22), radius: 12, x: 0, y: 10)
                    .frame(height: 120)
                    .overlay {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Monthly Report")
                                .font(ArotiTextStyle.caption1)
                                .foregroundColor(ArotiColor.textPrimary)
                            
                            blurredLine(width: 0.82)
                            blurredLine(width: 0.6)
                            blurredLine(width: 0.9)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Capsule().fill(Color.white.opacity(0.12)).frame(width: 90, height: 10)
                                Capsule().fill(Color.white.opacity(0.08)).frame(width: 50, height: 10)
                                Spacer()
                            }
                        }
                        .padding(16)
                    }
                
                Text("Blurred preview. Full report included in Premium.")
                    .font(ArotiTextStyle.caption2)
                    .foregroundColor(ArotiColor.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        private func blurredLine(width: CGFloat) -> some View {
            Capsule()
                .fill(Color.white.opacity(0.12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: UIScreen.main.bounds.width * width * 0.4, height: 12)
                .overlay(
                    Capsule()
                        .fill(Color.white.opacity(0.04))
                        .blur(radius: 2)
                )
        }
    }
    
    private struct UnlockVisual: View {
        @State private var animate = false
        
        var body: some View {
            ZStack {
                Circle()
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.12),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 140, height: 140)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 255/255, green: 180/255, blue: 120/255).opacity(0.25),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 120
                        )
                    )
                    .scaleEffect(animate ? 1.08 : 0.96)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animate)
                
                Image(systemName: "lock.open.display")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundColor(ArotiColor.accent)
                    .shadow(color: ArotiColor.accent.opacity(0.4), radius: 16, x: 0, y: 10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .onAppear {
                animate = true
            }
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
    
    // MARK: - Carousel Rotation & Haptics
    
    private func startAutoRotate() {
        stopAutoRotate()
        
        autoRotateCancellable = Timer.publish(every: autoRotateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                    advanceSlide()
                }
            }
    }
    
    private func stopAutoRotate() {
        autoRotateCancellable?.cancel()
        autoRotateCancellable = nil
    }
    
    private func advanceSlide() {
        let next = (currentSlide + 1) % Slide.allCases.count
        currentSlide = next
        triggerSlideHaptic()
    }
    
    private func triggerSlideHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
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
