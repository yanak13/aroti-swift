//
//  ProfileView.swift
//  Aroti
//
//  Profile page matching React ProfileOverview
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @Binding var selectedTab: TabItem
    @StateObject private var controller = ProfileController()
    
    // Profile data - use controller if available, fallback to defaults
    private var userName: String {
        controller.profile?.name ?? "Alexandra Moon"
    }
    private var userLocation: String {
        controller.profile?.birthLocation ?? "San Francisco, CA"
    }
    @State private var editingName: String = ""
    @State private var editingLocation: String = ""
    @State private var profileAvatar: String = "specialist-1" // Image name
    @State private var userPoints: Int = 0
    
    // Personalization status - in real app, this would come from user data
    private var personalizationStatus: String {
        if hasBirthDetails {
            return "Your birth details are complete"
        } else {
            return "Add your birth details to unlock insights"
        }
    }
    
    // Tab state for saved content
    @State private var activeSavedTab: SavedContentTab = .readings
    
    // Category selector state
    @State private var selectedCategory: BlueprintCategory = .astrology
    
    // Premium unlock state (for demo/testing - shows premium content when unlocked)
    @State private var unlockedPremiumContent: Set<BlueprintCategory> = []
    
    // Modal states
    @State private var showEditProfile = false
    @State private var showAstrologyModal = false
    @State private var showNumerologyModal = false
    @State private var showPaywall = false
    @State private var paywallContext: String? = nil
    @State private var showPDFModal = false
    @State private var showPartnerModal = false
    @State private var showCompatibilityUnlockSheet = false
    @State private var showCompatibilityResults = false
    @State private var selectedReport: Report?
    @State private var userBlueprint: UserBlueprint?
    @State private var identityProfile: UserIdentityProfile?
    @State private var partnerData: (name: String, birthDate: Date, birthTime: Date?, location: String)?
    
    // Settings sheet states
    @State private var showWalletCreditsSheet = false
    @State private var showSettingsSheet = false
    @State private var showNotificationsSheet = false
    @State private var showLanguageSheet = false
    @State private var showChangeEmailSheet = false
    @State private var showChangePasswordSheet = false
    @State private var showPrivacyTermsSheet = false
    @State private var showPrivacyPolicySheet = false
    @State private var showTermsOfUseSheet = false
    @State private var showCookiePolicySheet = false
    @State private var showDataDeletionPolicySheet = false
    @State private var showDownloadDataSheet = false
    @State private var showDeleteAccountSheet = false
    @State private var showContactSupportSheet = false
    @State private var scrollOffset: CGFloat = 0
    @State private var hasUnreadNotifications: Bool = false
    
    // Premium status
    private var isPremium: Bool {
        UserSubscriptionService.shared.isPremium
    }
    
    // Birth details check
    private var hasBirthDetails: Bool {
        guard let userData = DailyStateManager.shared.loadUserData() else {
            return false
        }
        return userData.birthDate != nil
    }
    
    // Load blueprint from user data
    private func loadBlueprint() {
        guard let userData = DailyStateManager.shared.loadUserData() else {
            return
        }
        userBlueprint = BlueprintService.shared.calculateBlueprint(from: userData)
        
        // Load identity profile (check cache first, then compute)
        let identityService = IdentityProfileService.shared
        if let cached = identityService.getCachedIdentityProfile(),
           !identityService.shouldRecompute(userData: userData) {
            identityProfile = cached
        } else {
            identityProfile = identityService.computeIdentityProfile(from: userData)
            if let profile = identityProfile {
                identityService.saveIdentityProfile(profile)
            }
        }
    }
    
    // Update user points
    private func updatePoints() {
        let balance = PointsService.shared.getBalance()
        userPoints = balance.totalPoints
    }
    
    private func updateNotificationState() {
        hasUnreadNotifications = NotificationService.shared.hasUnread()
    }
    
    var body: some View {
        GeometryReader { geometry in
            let _ = geometry.safeAreaInsets.top
            
            ZStack(alignment: .bottom) {
                CelestialBackground()
                    .ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 0) {
                            // Scroll offset tracker
                            GeometryReader { scrollGeometry in
                                Color.clear
                                    .preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: scrollGeometry.frame(in: .named("scroll")).minY
                                    )
                            }
                            .frame(height: 0)
                            
                            // 1. Modern Profile Header (No Card Background)
                            ScrollReveal {
                                modernProfileHeader
                                    .padding(.top, DesignSpacing.lg + 8)
                                    .padding(.bottom, DesignSpacing.lg)
                            }
                            
                            // 4. Compatibility Card
                            ScrollReveal(delay: 0.15) {
                                compatibilityCard
                                    .padding(.bottom, DesignSpacing.lg)
                            }
                            
                            // 5. Reports
                            ScrollReveal(delay: 0.2) {
                                reportsSection
                                    .padding(.bottom, DesignSpacing.lg)
                            }
                            
                            // 6. Saved Content
                            ScrollReveal(delay: 0.25) {
                                savedContentSection
                                    .padding(.bottom, DesignSpacing.lg)
                            }
                            
                            // 7. Membership
                            ScrollReveal(delay: 0.3) {
                                membershipSection
                                    .padding(.bottom, DesignSpacing.lg)
                            }
                            
                            // 8. Account & Settings
                            ScrollReveal(delay: 0.35) {
                                accountSettingsSection
                            }
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.bottom, 100) // Space for bottom nav
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollOffset = max(0, -value)
                    }
                    .padding(.top, StickyHeaderBar.contentHeight())
                    
                    StickyHeaderBar(
                        title: "Profile",
                        subtitle: "Your cosmic journey",
                        scrollOffset: $scrollOffset
                    ) {
                        HStack(spacing: 8) {
                            // Points Chip - premium styling
                            NavigationLink(destination: JourneyPage()) {
                                HeaderBadge(
                                    iconName: "star.fill",
                                    text: userPoints.formatted()
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Notification Bell - premium styling
                            NavigationLink(destination: NotificationsPage()) {
                                HeaderBadge(
                                    iconName: "bell",
                                    showUnreadDot: hasUnreadNotifications
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Bottom Navigation Bar
                VStack {
                    Spacer()
                    BottomNavigationBar(selectedTab: $selectedTab) { tab in
                        selectedTab = tab
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showEditProfile) {
                EditProfileSheet(
                    userName: $editingName,
                    userLocation: $editingLocation,
                    onSave: { name, location in
                        // Update profile via controller
                        Task {
                            do {
                                _ = try await controller.updateProfile(name: name, location: location)
                            } catch {
                                // Error already handled in controller
                            }
                        }
                        // Clear identity profile cache and reload after birth data changes
                        IdentityProfileService.shared.clearCache()
                        loadBlueprint()
                    }
                )
            }
            .onChange(of: showEditProfile) { _, isShowing in
                if isShowing {
                    // Initialize editing values when sheet appears
                    editingName = userName
                    editingLocation = userLocation
                }
            }
            .sheet(isPresented: $showAstrologyModal) {
                if let blueprint = userBlueprint {
                    AstrologyDetailSheet(blueprint: blueprint.astrology)
                }
            }
            .sheet(isPresented: $showNumerologyModal) {
                if let blueprint = userBlueprint {
                    NumerologyDetailSheet(blueprint: blueprint.numerology)
                } else {
                    NumerologyDetailSheet()
                }
            }
            .task {
                // Fetch profile data on appear
                if controller.profile == nil {
                    await controller.fetchProfile()
                }
            }
            .onAppear {
                loadBlueprint()
                updatePoints()
                updateNotificationState()
            }
            .onReceive(NotificationCenter.default.publisher(for: NotificationService.notificationsUpdated)) { _ in
                updateNotificationState()
            }
            .sheet(isPresented: $showPaywall) {
                if let context = paywallContext {
                    PremiumPaywallSheet(context: context)
                } else {
                    PremiumPaywallSheet()
                }
            }
            .sheet(isPresented: $showPDFModal) {
                if let report = selectedReport {
                    PDFPurchaseSheet(report: report)
                }
            }
            .sheet(isPresented: $showPartnerModal) {
                PartnerInputSheet(
                    onCalculateCompatibility: { name, birthDate, birthTime, location in
                        partnerData = (name: name, birthDate: birthDate, birthTime: birthTime, location: location)
                        showPartnerModal = false
                        
                        // Check access
                        let access = AccessControlService.shared.canAccessCompatibility()
                        if access.allowed {
                            let success = AccessControlService.shared.recordCompatibilityCheck()
                            if success {
                                updatePoints()
                                showCompatibilityResults = true
                            } else {
                                showCompatibilityUnlockSheet = true
                            }
                        } else {
                            showCompatibilityUnlockSheet = true
                        }
                    }
                )
            }
            .sheet(isPresented: $showCompatibilityUnlockSheet) {
                CompatibilityUnlockSheet(
                    isPresented: $showCompatibilityUnlockSheet,
                    onUnlock: {
                        let success = AccessControlService.shared.recordCompatibilityCheck()
                        if success {
                            updatePoints()
                            showCompatibilityUnlockSheet = false
                            if partnerData != nil {
                                showCompatibilityResults = true
                            }
                        }
                    }
                )
            }
            .sheet(isPresented: $showCompatibilityResults) {
                if let partner = partnerData {
                    CompatibilityResultsSheet(
                        partnerName: partner.name,
                        partnerBirthDate: partner.birthDate,
                        partnerBirthTime: partner.birthTime,
                        partnerBirthLocation: partner.location
                    )
                } else {
                    // Fallback empty view
                    Text("")
                        .onAppear {
                            showCompatibilityResults = false
                        }
                }
            }
            .sheet(isPresented: $showWalletCreditsSheet) {
                MembershipBillingSheet(showPaywall: $showPaywall)
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsSheet(
                    showNotificationsSheet: $showNotificationsSheet,
                    showLanguageSheet: $showLanguageSheet,
                    showChangeEmailSheet: $showChangeEmailSheet,
                    showChangePasswordSheet: $showChangePasswordSheet
                )
            }
            .sheet(isPresented: $showNotificationsSheet) {
                NotificationsSheet()
            }
            .sheet(isPresented: $showLanguageSheet) {
                LanguageSheet()
            }
            .sheet(isPresented: $showChangeEmailSheet) {
                ChangeEmailSheet()
            }
            .sheet(isPresented: $showChangePasswordSheet) {
                ChangePasswordSheet()
            }
            .sheet(isPresented: $showPrivacyTermsSheet) {
                PrivacyTermsSheet(
                    showPrivacyPolicySheet: $showPrivacyPolicySheet,
                    showTermsOfUseSheet: $showTermsOfUseSheet,
                    showCookiePolicySheet: $showCookiePolicySheet,
                    showDataDeletionPolicySheet: $showDataDeletionPolicySheet,
                    showDownloadDataSheet: $showDownloadDataSheet,
                    showDeleteAccountSheet: $showDeleteAccountSheet,
                    showContactSupportSheet: $showContactSupportSheet
                )
            }
            .sheet(isPresented: $showPrivacyPolicySheet) {
                PrivacyPolicySheet()
            }
            .sheet(isPresented: $showTermsOfUseSheet) {
                TermsOfUseSheet()
            }
            .sheet(isPresented: $showCookiePolicySheet) {
                CookiePolicySheet()
            }
            .sheet(isPresented: $showDataDeletionPolicySheet) {
                DataDeletionPolicySheet()
            }
            .sheet(isPresented: $showDownloadDataSheet) {
                DownloadDataSheet()
            }
            .sheet(isPresented: $showDeleteAccountSheet) {
                DeleteAccountSheet()
            }
            .sheet(isPresented: $showContactSupportSheet) {
                ContactSupportSheet()
            }
        }
    }
    
    // MARK: - Profile Accessibility Label
    
    private var profileAccessibilityLabel: String {
        var label = "Profile. \(userName). "
        if let astrology = identityProfile?.astrology {
            label += "\(astrology.sunSign) Sun, \(astrology.moonSign) Moon, \(astrology.risingSign) Rising. "
        }
        if let userData = DailyStateManager.shared.loadUserData(),
           let birthLocation = userData.birthLocation,
           !birthLocation.isEmpty {
            label += "Born in \(birthLocation)."
        }
        return label
    }
    
    // MARK: - Account Tool Navigation Handler
    
    private func handleAccountToolTap(path: String) {
        switch path {
        case "/profile/settings/wallet":
            showWalletCreditsSheet = true
        case "/profile/settings":
            showSettingsSheet = true
        case "/profile/notifications":
            showNotificationsSheet = true
        case "/profile/language":
            showLanguageSheet = true
        case "/profile/settings/privacy":
            showPrivacyTermsSheet = true
        default:
            break
        }
    }
    
    // MARK: - Modern Profile Header (Premium Card)
    private var modernProfileHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Identity Block - Premium Card Container
            VStack(alignment: .leading, spacing: 0) {
                // Premium User Card - Tappable
                ZStack(alignment: .topTrailing) {
                    BaseCard(
                        variant: .interactive,
                        action: {
                            showEditProfile = true
                        }
                    ) {
                        HStack(alignment: .top, spacing: 16) {
                            // Premium Avatar with Gradient Ring
                            PremiumAvatarView(
                                imageName: profileAvatar,
                                userName: userName,
                                size: 50
                            )
                            
                            // User Info - Premium Typography Hierarchy
                            VStack(alignment: .leading, spacing: 5) {
                                // Line 1 (Primary): User name - Highest emphasis
                                Text(userName)
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                    .lineLimit(1)
                                
                                // Line 2 (Secondary): Big Three - Medium emphasis with premium icons
                                if let astrology = identityProfile?.astrology {
                                    HStack(alignment: .center, spacing: 8) {
                                        // Sun
                                        HStack(spacing: 4) {
                                            Image(systemName: "sun.max.fill")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(DesignColors.accent)
                                            Text(astrology.sunSign)
                                                .font(DesignTypography.subheadFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                        
                                        // Divider
                                        Text("·")
                                            .font(DesignTypography.subheadFont())
                                            .foregroundColor(DesignColors.mutedForeground.opacity(0.3))
                                        
                                        // Moon
                                        HStack(spacing: 4) {
                                            Image(systemName: "moon.fill")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(DesignColors.accent)
                                            Text(astrology.moonSign)
                                                .font(DesignTypography.subheadFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                        
                                        // Divider
                                        Text("·")
                                            .font(DesignTypography.subheadFont())
                                            .foregroundColor(DesignColors.mutedForeground.opacity(0.3))
                                        
                                        // Rising
                                        HStack(spacing: 4) {
                                            Image(systemName: "sparkles")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(DesignColors.accent)
                                            Text(astrology.risingSign)
                                                .font(DesignTypography.subheadFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                }
                                
                                // Line 3 (Tertiary): Birthplace - Lowest emphasis (lower opacity, non-bold)
                                if let userData = DailyStateManager.shared.loadUserData(),
                                   let birthLocation = userData.birthLocation,
                                   !birthLocation.isEmpty {
                                    Text("Born in \(birthLocation)")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.65))
                                        .lineLimit(1)
                                }
                            }
                            .padding(.top, 2)
                            
                            Spacer(minLength: 0)
                            
                            // Spacer for edit button area
                            Color.clear
                                .frame(width: 44, height: 44)
                        }
                        .padding(.vertical, 8) // Extra vertical padding for taller card
                    }
                    
                    // Subtle Edit Button (overlaid to prevent card tap)
                    Button(action: {
                        showEditProfile = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(DesignColors.mutedForeground.opacity(0.5))
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("Edit profile")
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(profileAccessibilityLabel)
                .padding(.bottom, 16)
                
                // Category Tabs - Integrated with header (horizontally scrollable)
                VStack(spacing: 0) {
                    // Top divider line
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.05))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(BlueprintCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedCategory = category
                                    }
                                }) {
                                    VStack(spacing: 0) {
                                        Text(category.rawValue)
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                            .foregroundColor(selectedCategory == category ? DesignColors.foreground : DesignColors.mutedForeground.opacity(0.5))
                                            .lineLimit(1)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 12)
                                        
                                        // Thicker underline animation
                                        if selectedCategory == category {
                                            Rectangle()
                                                .frame(height: 3)
                                                .foregroundColor(DesignColors.accent)
                                                .shadow(color: DesignColors.accent.opacity(0.4), radius: 4, x: 0, y: 0)
                                        } else {
                                            Rectangle()
                                                .frame(height: 0)
                                                .foregroundColor(.clear)
                                        }
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Bottom divider line
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.05))
                }
            }
            .padding(.bottom, 32)
            
            // Dynamic Category Content (wrapped in BaseCard)
            BaseCard {
                if hasBirthDetails, let profile = identityProfile {
                    switch selectedCategory {
                    case .astrology:
                        astrologyTabContent(identity: profile.astrology)
                    case .numerology:
                        numerologyTabContent(identity: profile.numerology)
                    case .matrix:
                        matrixTabContent(identity: profile.matrix)
                    case .elements:
                        elementalTabContent(identity: profile.elements)
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("Add your birth details to generate your blueprint")
                            .font(DesignTypography.bodyFont())
                            .foregroundColor(DesignColors.foreground)
                            .multilineTextAlignment(.center)
                        
                        Text("Birth details are collected during onboarding. Please complete the onboarding flow to generate your blueprint.")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .multilineTextAlignment(.center)
                    }
                    .padding(20)
                }
            }
        }
    }
    
    // MARK: - Tab Content Functions
    
    // MARK: - Astrology Tab Content
    private func astrologyTabContent(identity: AstrologyIdentity?) -> some View {
        guard let identity = identity else {
            return AnyView(EmptyView())
        }
        
        let contentGenerator = IdentityContentGenerator.shared
        let freeInsight = contentGenerator.generateAstrologyFreeInsight(
            sunSign: identity.sunSign,
            moonSign: identity.moonSign,
            risingSign: identity.risingSign,
            dominantElement: identity.dominantElement
        )
        let coreTheme = contentGenerator.generateAstrologyCoreTheme(
            sunSign: identity.sunSign,
            moonSign: identity.moonSign,
            risingSign: identity.risingSign,
            dominantElement: identity.dominantElement
        )
        
        return AnyView(
            VStack(alignment: .leading, spacing: 20) {
                // A. Identity Header Block (Free)
                BaseCard {
                    IdentityHeaderCard(
                        title: "Astrology",
                        primaryLine: "\(identity.sunSign) Sun · \(identity.moonSign) Moon · \(identity.risingSign) Rising",
                        secondaryLine: "Dominant element: \(identity.dominantElement.rawValue)"
                    )
                }
                
                // B. Free Insight Block (Free)
                TextCard(
                    title: nil,
                    content: freeInsight
                )
                
                // C. Core Theme Block (Free)
                TextCard(
                    title: "Core Theme",
                    content: coreTheme
                )
                
                // D. Premium CTA Block (if !isPremium) OR E. Premium Content (if isPremium)
                if unlockedPremiumContent.contains(.astrology) {
                    // Premium Content (inline, no headers)
                    VStack(alignment: .leading, spacing: 16) {
                        if let lifeFocusAreas = identity.lifeFocusAreas, !lifeFocusAreas.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Life Focus Areas")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(lifeFocusAreas) { area in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .foregroundColor(DesignColors.accent)
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(area.title)
                                                    .font(DesignTypography.bodyFont(weight: .medium))
                                                    .foregroundColor(DesignColors.foreground)
                                                Text(area.shortMeaning)
                                                    .font(DesignTypography.footnoteFont())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                            }
                                        }
                                    }
                                }
                            }
                        } else if !identity.hasAccurateBirthTime || !identity.hasAccurateBirthPlace {
                            BaseCard {
                                Text("Add birth time to refine this insight.")
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        
                        if let familiarPatterns = identity.familiarPatterns {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Familiar Patterns")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(familiarPatterns.shortMeaning)
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                        
                        if let growthDirection = identity.growthDirection {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Growth Direction")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(growthDirection.shortMeaning)
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                        
                        if let strengths = identity.strengths, !strengths.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Strengths")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(strengths, id: \.self) { strength in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .foregroundColor(DesignColors.accent)
                                            Text(strength)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let blindSpots = identity.blindSpots, !blindSpots.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Blind Spots")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(blindSpots, id: \.self) { spot in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .foregroundColor(DesignColors.mutedForeground)
                                            Text(spot)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    // Premium CTA Block (footer-like)
                    PremiumCTACard(
                        title: "Unlock your full Astrology blueprint",
                        subtitle: "Explore life focus areas, patterns, and growth direction.",
                        onUnlockClick: {
                            unlockedPremiumContent.insert(.astrology)
                        }
                    )
                }
            }
        )
    }
    
    // MARK: - Numerology Tab Content
    private func numerologyTabContent(identity: NumerologyIdentity?) -> some View {
        guard let identity = identity else {
            return AnyView(EmptyView())
        }
        
        let contentGenerator = IdentityContentGenerator.shared
        let freeInsight = contentGenerator.generateNumerologyFreeInsight(
            lifePath: identity.lifePath,
            archetype: identity.archetypeLabel
        )
        let coreTheme = contentGenerator.generateNumerologyCoreTheme(
            lifePath: identity.lifePath,
            archetype: identity.archetypeLabel
        )
        
        return AnyView(
            VStack(alignment: .leading, spacing: 20) {
                // A. Identity Header Block (Free)
                BaseCard {
                    IdentityHeaderCard(
                        title: "Numerology",
                        primaryLine: "Life Path \(identity.lifePath)",
                        secondaryLine: "Archetype: \(identity.archetypeLabel)"
                    )
                }
                
                // B. Free Insight Block (Free)
                TextCard(
                    title: nil,
                    content: freeInsight
                )
                
                // C. Core Theme Block (Free)
                TextCard(
                    title: "Core Theme",
                    content: coreTheme
                )
                
                // D. Premium CTA Block (if !isPremium) OR E. Premium Content (if isPremium)
                if unlockedPremiumContent.contains(.numerology) {
                    // Premium Content (inline, no headers)
                    VStack(alignment: .leading, spacing: 16) {
                        if let destiny = identity.destinyExpression,
                           let soulUrge = identity.soulUrge,
                           let personality = identity.personality {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Your Core Numbers")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    HStack {
                                        Text("Destiny/Expression:")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                        Text("\(destiny)")
                                            .font(DesignTypography.bodyFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                    }
                                    
                                    HStack {
                                        Text("Soul Urge:")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                        Text("\(soulUrge)")
                                            .font(DesignTypography.bodyFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                    }
                                    
                                    HStack {
                                        Text("Personality:")
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                        Text("\(personality)")
                                            .font(DesignTypography.bodyFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                    }
                                }
                            }
                        }
                        
                        BaseCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Karmic Themes")
                                    .font(DesignTypography.bodyFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                if let karmicDebt = identity.karmicDebt, !karmicDebt.isEmpty {
                                    Text("Karmic Debt Numbers: \(karmicDebt.map { String($0) }.joined(separator: ", "))")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                } else {
                                    Text("None detected")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                        
                        if let synthesis = identity.premiumSynthesis {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("How Your Numbers Work Together")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(synthesis)
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                    }
                } else {
                    // Premium CTA Block (footer-like)
                    PremiumCTACard(
                        title: "Unlock your full Numerology blueprint",
                        subtitle: "Access all core numbers, karmic themes, and synthesis.",
                        onUnlockClick: {
                            unlockedPremiumContent.insert(.numerology)
                        }
                    )
                }
            }
        )
    }
    
    // MARK: - Matrix Tab Content
    private func matrixTabContent(identity: MatrixIdentity?) -> some View {
        guard let identity = identity else {
            return AnyView(EmptyView())
        }
        
        let contentGenerator = IdentityContentGenerator.shared
        let freeInsight = contentGenerator.generateMatrixFreeInsight(
            coreDestinyNumber: identity.coreDestinyNumber,
            themes: identity.freeThemes
        )
        let coreTheme = contentGenerator.generateMatrixCoreTheme(
            coreDestinyNumber: identity.coreDestinyNumber,
            themes: identity.freeThemes
        )
        
        return AnyView(
            VStack(alignment: .leading, spacing: 20) {
                // A. Identity Header Block (Free)
                BaseCard {
                    IdentityHeaderCard(
                        title: "Matrix of Fate",
                        primaryLine: "Core Destiny \(identity.coreDestinyNumber)",
                        secondaryLine: nil
                    )
                }
                
                // Matrix Visual
                MatrixVisualView(matrix: identity.matrixVisual, coreDestinyNumber: identity.coreDestinyNumber)
                
                // B. Free Insight Block (Free)
                TextCard(
                    title: nil,
                    content: freeInsight
                )
                
                // C. Core Theme Block (Free)
                TextCard(
                    title: "Core Theme",
                    content: coreTheme
                )
                
                // D. Premium CTA Block (if !isPremium) OR E. Premium Content (if isPremium)
                if unlockedPremiumContent.contains(.matrix) {
                    // Premium Content (inline, no headers)
                    VStack(alignment: .leading, spacing: 16) {
                        if let strengthZones = identity.strengthZones, !strengthZones.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Strength Zones")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(strengthZones) { zone in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(zone.title)
                                                .font(DesignTypography.bodyFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            Text(zone.shortMeaning)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let challengeZones = identity.challengeZones, !challengeZones.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Challenge Zones")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(challengeZones) { zone in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(zone.title)
                                                .font(DesignTypography.bodyFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            Text(zone.shortMeaning)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let karmicLessons = identity.karmicLessons, !karmicLessons.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Karmic Lessons")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(karmicLessons, id: \.self) { lesson in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .foregroundColor(DesignColors.mutedForeground)
                                            Text(lesson)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let repeatingPatterns = identity.repeatingPatterns, !repeatingPatterns.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Repeating Patterns")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(repeatingPatterns, id: \.self) { pattern in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .foregroundColor(DesignColors.accent)
                                            Text(pattern)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let interpretation = identity.premiumInterpretation {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Interpretation")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(interpretation)
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                    }
                } else {
                    // Premium CTA Block (footer-like)
                    PremiumCTACard(
                        title: "Unlock your full Matrix of Fate blueprint",
                        subtitle: "Access strength zones, challenge zones, and deeper insights.",
                        onUnlockClick: {
                            unlockedPremiumContent.insert(.matrix)
                        }
                    )
                }
            }
        )
    }
    
    // MARK: - Elemental Tab Content
    private func elementalTabContent(identity: ElementalIdentity?) -> some View {
        guard let identity = identity else {
            return AnyView(EmptyView())
        }
        
        let contentGenerator = IdentityContentGenerator.shared
        let freeInsight = contentGenerator.generateElementalFreeInsight(
            dominant: identity.dominant,
            deficient: identity.deficient
        )
        let coreTheme = contentGenerator.generateElementalCoreTheme(
            dominant: identity.dominant,
            deficient: identity.deficient
        )
        
        return AnyView(
            VStack(alignment: .leading, spacing: 20) {
                // A. Identity Header Block (Free)
                BaseCard {
                    IdentityHeaderCard(
                        title: "Elemental Profile",
                        primaryLine: "Dominant: \(identity.dominant.map { $0.rawValue }.joined(separator: ", "))",
                        secondaryLine: identity.deficient.isEmpty ? nil : "Deficient: \(identity.deficient.map { $0.rawValue }.joined(separator: ", "))"
                    )
                }
                
                // Element Pills
                ElementPillRow(elements: identity.dominant, label: "Your Dominant Elements")
                
                if !identity.deficient.isEmpty {
                    ElementPillRow(elements: identity.deficient, label: "Your Deficient Elements")
                }
                
                // B. Free Insight Block (Free)
                TextCard(
                    title: nil,
                    content: freeInsight
                )
                
                // C. Core Theme Block (Free)
                TextCard(
                    title: "Core Theme",
                    content: coreTheme
                )
                
                // D. Premium CTA Block (if !isPremium) OR E. Premium Content (if isPremium)
                if unlockedPremiumContent.contains(.elements) {
                    // Premium Content (inline, no headers)
                    VStack(alignment: .leading, spacing: 16) {
                        if let imbalanceSignals = identity.imbalanceSignals, !imbalanceSignals.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("How Imbalance Shows Up")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(imbalanceSignals, id: \.self) { signal in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .foregroundColor(DesignColors.mutedForeground)
                                            Text(signal)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let supporting = identity.supportingElements, !supporting.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Supporting Elements")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(supporting) { element in
                                        VStack(alignment: .leading, spacing: 8) {
                                            ElementPill(element: element.element)
                                            
                                            Text(element.meaning)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                                .padding(.top, 4)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let draining = identity.drainingElements, !draining.isEmpty {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Draining Elements")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    ForEach(draining) { element in
                                        VStack(alignment: .leading, spacing: 8) {
                                            ElementPill(element: element.element)
                                            
                                            Text(element.meaning)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                                .padding(.top, 4)
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let crossSystem = identity.crossSystemInfluence {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Cross-System Influence")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(crossSystem)
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                        
                        if let balanceGuidance = identity.balanceGuidance {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Balance Guidance")
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(balanceGuidance)
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                        }
                    }
                } else {
                    // Premium CTA Block (footer-like)
                    PremiumCTACard(
                        title: "Unlock your full Elemental Profile blueprint",
                        subtitle: "Access imbalance insights, element relationships, and balance guidance.",
                        onUnlockClick: {
                            unlockedPremiumContent.insert(.elements)
                        }
                    )
                }
            }
        )
    }
    
    private var compatibilityCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 10) {
                // 1. Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Compatibility")
                        .font(DesignTypography.headlineFont())
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Explore your relationship dynamics and connection patterns.")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                // 2. Free Insight Line (inline, no card)
                if !isPremium {
                    let freeRemaining = AccessControlService.shared.getFreeCompatibilityRemaining()
                    let pointsCost = AccessControlService.shared.getCompatibilityPointsCost()
                    
                    if freeRemaining > 0 {
                        HStack(spacing: 4) {
                            Text("\(freeRemaining) free compatibility insight\(freeRemaining != 1 ? "s" : "") remaining")
                                .font(DesignTypography.footnoteFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("After that: \(pointsCost) points per insight")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    } else {
                        Text("\(pointsCost) points per insight")
                            .font(DesignTypography.footnoteFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                    }
                }
                
                // 3. Main CTA - Add Partner (Hero)
                VStack(spacing: 4) {
                    ArotiButton(
                        kind: .primary,
                        action: {
                            showPartnerModal = true
                        },
                        label: {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 18))
                                Text("Add Partner")
                                    .font(DesignTypography.subheadFont(weight: .semibold))
                            }
                        }
                    )
                    
                    Text("Choose someone to explore your compatibility with.")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 2)
                
                // 4. Baseline Compatibility Preview (Small Card)
                Button(action: {
                    // Handle baseline compatibility tap
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your baseline compatibility")
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("Tap to see your quick overview")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.02))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 2)
                
                // 5. Premium Preview Row (collapsed, tappable, minimal)
                if !isPremium {
                    Button(action: {
                        paywallContext = "compatibility"
                        showPaywall = true
                    }) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 6) {
                                Text("✨")
                                    .font(.system(size: 14))
                                
                                Text("Unlock deeper insights")
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                            }
                            
                            Text("Emotional connection • Communication • Long-term potential")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 2)
                    
                    // 6. Small Premium CTA Card (reduced height by ~40%)
                    Button(action: {
                        paywallContext = "compatibility"
                        showPaywall = true
                    }) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Unlock Unlimited Compatibility + Timing Insights")
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Access every insight and explore deeper patterns.")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(DesignColors.accent.opacity(0.03))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(DesignColors.accent.opacity(0.2), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 2)
                }
            }
        }
    }
    
    
    // MARK: - Saved Content Section
    private var savedContentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            BaseSectionHeader(
                title: "Saved Content",
                subtitle: "Your saved readings and practices"
            )
            
            VStack(spacing: 12) {
                // Category Tabs - Consistent with main category tabs
                VStack(spacing: 0) {
                    // Top divider line
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.05))
                    
                    HStack(spacing: 0) {
                        ForEach(SavedContentTab.allCases, id: \.self) { tab in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    activeSavedTab = tab
                                }
                            }) {
                                VStack(spacing: 0) {
                                    Text(tab.rawValue)
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                        .foregroundColor(activeSavedTab == tab ? DesignColors.foreground : DesignColors.mutedForeground.opacity(0.5))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                    
                                    // Thicker underline animation
                                    if activeSavedTab == tab {
                                        Rectangle()
                                            .frame(height: 3)
                                            .foregroundColor(DesignColors.accent)
                                            .shadow(color: DesignColors.accent.opacity(0.4), radius: 4, x: 0, y: 0)
                                    } else {
                                        Rectangle()
                                            .frame(height: 0)
                                            .foregroundColor(.clear)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // Bottom divider line
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.white.opacity(0.05))
                }
                
                // Saved Items Horizontal Scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array((ProfileData.savedLibrary[activeSavedTab] ?? []).enumerated()), id: \.offset) { index, item in
                            savedContentCard(item: item, isPremium: activeSavedTab == .practices && index == 0)
                        }
                    }
                }
            }
        }
    }
    
    private func savedContentCard(item: ProfileData.SavedContentItem, isPremium: Bool) -> some View {
        BaseCard(
            variant: .interactive,
            action: {
                if isPremium && !UserSubscriptionService.shared.isPremium {
                    paywallContext = nil
                    showPaywall = true
                } else {
                    // Navigate to content
                }
            }
        ) {
            VStack(alignment: .leading, spacing: 12) {
                // Type Tag
                Text(item.type)
                    .font(DesignTypography.caption2Font(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.05))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                    )
                
                Spacer()
                
                Text(item.name)
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                    .lineLimit(2)
                
                Text("Tap to explore")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            .frame(width: 280, height: 160, alignment: .topLeading)
            .padding(16)
        }
    }
    
    // MARK: - Reports Section
    private var reportsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            BaseSectionHeader(
                title: "Reports",
                subtitle: "Purchase detailed PDF reports"
            )
            
            VStack(spacing: 12) {
                // Monthly Horoscope Forecast (moved from Discovery)
                NavigationLink(destination: HoroscopeForecastPage()) {
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Monthly Horoscope Forecast")
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("Your personalized horoscope forecast for the month")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16))
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.02))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // PDF Reports
                ForEach(ProfileData.reports) { report in
                    Button(action: {
                        selectedReport = report
                        showPDFModal = true
                    }) {
                        HStack(alignment: .center, spacing: 12) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(report.name)
                                    .font(DesignTypography.bodyFont(weight: .medium))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text(report.description)
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                if report.isMostPopular {
                                    Text("Most popular")
                                        .font(DesignTypography.caption2Font(weight: .medium))
                                        .foregroundColor(DesignColors.accent)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(DesignColors.accent.opacity(0.2))
                                                .overlay(
                                                    Capsule()
                                                        .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                                )
                                        )
                                }
                                
                                Text("$\(String(format: "%.2f", report.price))")
                                    .font(DesignTypography.bodyFont(weight: .semibold))
                                    .foregroundColor(DesignColors.accent)
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16))
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.02))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // MARK: - Membership Section
    private var membershipSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            BaseSectionHeader(
                title: "Your Membership",
                subtitle: "Unlock your full cosmic potential"
            )
            
            ZStack(alignment: .topTrailing) {
                // Reduced gradient background card
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                DesignColors.accent.opacity(0.15),
                                DesignColors.accent.opacity(0.08),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: DesignColors.accent.opacity(0.15), radius: 6, x: 0, y: 3)
                
                // Star icon in top right
                Image(systemName: "sparkles")
                    .font(.system(size: 20))
                    .foregroundColor(DesignColors.accent)
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Membership")
                            .font(DesignTypography.title3Font())
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("You're on the Free Plan")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    .padding(.trailing, 50) // Space for star icon
                    
                    // 3 main bullet points instead of 5
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text("✦")
                                .font(.system(size: 14))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Access all rituals and readings")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                        }
                        
                        HStack(spacing: 8) {
                            Text("✦")
                                .font(.system(size: 14))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Unlock full astrology & numerology blueprints")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                        }
                        
                        HStack(spacing: 8) {
                            Text("✦")
                                .font(.system(size: 14))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Premium compatibility insights")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.foreground)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Text("Unlock your full cosmic potential.")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 16)
                    
                    ArotiButton(
                        kind: .custom(ArotiButtonStyle(
                            foregroundColor: .white,
                            backgroundGradient: LinearGradient(
                                colors: [DesignColors.accent, DesignColors.accent.opacity(0.9)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            cornerRadius: 10,
                            height: 44
                        )),
                        action: {
                            paywallContext = nil
                            showPaywall = true
                        },
                        label: {
                            Text("Unlock All Access")
                                .font(DesignTypography.subheadFont(weight: .semibold))
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
    }
    
    // MARK: - Account Settings Section
    private var accountSettingsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            BaseSectionHeader(
                title: "Account & Settings",
                subtitle: "Manage your preferences and privacy"
            )
            
            VStack(spacing: 12) {
                ForEach(ProfileData.accountTools, id: \.label) { tool in
                    Button(action: {
                        handleAccountToolTap(path: tool.path)
                    }) {
                        ZStack(alignment: .topTrailing) {
                            // Premium gradient background card
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            DesignColors.accent.opacity(0.08),
                                            DesignColors.accent.opacity(0.03),
                                            Color.clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(DesignColors.accent.opacity(0.15), lineWidth: 1)
                                )
                                .shadow(color: DesignColors.accent.opacity(0.08), radius: 4, x: 0, y: 2)
                            
                            // Decorative icon in top right (subtle)
                            Image(systemName: getDecorativeIcon(for: tool.path))
                                .font(.system(size: 16))
                                .foregroundColor(DesignColors.accent.opacity(0.2))
                                .padding(.top, 14)
                                .padding(.trailing, 14)
                            
                            HStack(spacing: 16) {
                                // Enhanced icon with gradient background
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    DesignColors.accent.opacity(0.2),
                                                    DesignColors.accent.opacity(0.1)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(DesignColors.accent.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    Image(systemName: tool.iconName)
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(DesignColors.accent)
                                }
                                .frame(width: 48, height: 48)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(tool.label)
                                        .font(DesignTypography.bodyFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Text(getSubtitle(for: tool.path))
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(DesignColors.accent.opacity(0.6))
                            }
                            .padding(16)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    // Helper function to get decorative icon for each tool
    private func getDecorativeIcon(for path: String) -> String {
        switch path {
        case "/profile/settings/wallet":
            return "sparkles"
        case "/profile/settings":
            return "gearshape.2"
        case "/profile/settings/privacy":
            return "lock.shield"
        default:
            return "circle"
        }
    }
    
    // Helper function to get subtitle for each tool
    private func getSubtitle(for path: String) -> String {
        switch path {
        case "/profile/settings/wallet":
            return "Manage subscription and credits"
        case "/profile/settings":
            return "Notifications, language, and more"
        case "/profile/settings/privacy":
            return "Privacy policy and terms of use"
        default:
            return ""
        }
    }
}

// MARK: - Blueprint Category Enum
enum BlueprintCategory: String, CaseIterable {
    case astrology = "Astrology"
    case numerology = "Numerology"
    case matrix = "Matrix of Fate"
    case elements = "Elemental Profile"
}

struct ProfileData {
    static let astrologyPlacements: [PlanetaryPlacement] = [
        PlanetaryPlacement(
            planet: "Sun",
            sign: "Virgo",
            description: "Identity • How you move through the world",
            meaning: "Your Sun in Virgo reflects a practical, analytical nature. You move through the world with attention to detail and a desire to be of service.",
            house: nil
        ),
        PlanetaryPlacement(
            planet: "Moon",
            sign: "Pisces",
            description: "Inner world • How you feel and process emotion",
            meaning: "Your Moon in Pisces reveals a deeply intuitive and empathetic emotional nature. You process feelings through imagination and compassion.",
            house: nil
        ),
        PlanetaryPlacement(
            planet: "Rising",
            sign: "Leo",
            description: "First impression • The energy you project to others",
            meaning: "Your Rising in Leo means you present with warmth and confidence. Others see your natural radiance first.",
            house: nil
        )
    ]
    
    static let premiumAstrologyFeatures = [
        "All planets (Venus, Mars, Mercury...)",
        "12 Houses",
        "Aspects"
    ]
    
    static let premiumNumerologyFeatures = [
        "Destiny Number",
        "Expression Number",
        "Soul Urge"
    ]
    
    struct SavedContentItem {
        let name: String
        let type: String
        let timestamp: String
    }
    
    static let savedLibrary: [SavedContentTab: [SavedContentItem]] = [
        .readings: [
            SavedContentItem(name: "Celtic Cross Spread", type: "Tarot", timestamp: "Saved 2 days ago"),
            SavedContentItem(name: "Moonlit Reflection", type: "Tarot", timestamp: "Updated today"),
            SavedContentItem(name: "Solar Alignment", type: "Practice", timestamp: "Saved 1 week ago")
        ],
        .practices: [
            SavedContentItem(name: "Morning Mantra", type: "Daily Ritual", timestamp: "Saved 3 days ago"),
            SavedContentItem(name: "Gratitude Flow", type: "Practice", timestamp: "Updated yesterday"),
            SavedContentItem(name: "Evening Integration", type: "Daily Ritual", timestamp: "Saved 5 days ago")
        ]
    ]
    
    static let reports: [Report] = [
        Report(id: "birth-chart", name: "Birth Chart Report", description: "In-depth analysis of your natal chart", price: 11.99, isMostPopular: true),
        Report(id: "numerology", name: "Numerology Report", description: "Complete numerology breakdown & insights", price: 7.99, isMostPopular: false),
        Report(id: "compatibility", name: "Compatibility Report", description: "Deep dive into relationship dynamics", price: 9.99, isMostPopular: false),
        Report(id: "year-ahead", name: "Year Ahead Report", description: "Astrological forecast for the coming year", price: 12.99, isMostPopular: false)
    ]
    
    static let freeMembershipBenefits = [
        "Access daily guidance & rituals",
        "Preview astrology & numerology",
        "Save readings to your library"
    ]
    
    static let premiumMembershipBenefits = [
        "Full astrology + numerology blueprint",
        "Unlimited compatibility checks",
        "Relationship timing insights",
        "Access every ritual & reading"
    ]
    
    static let membershipBenefits = [
        "Access every ritual and reading",
        "Reveal your full astrological blueprint",
        "Unlock complete numerology insights",
        "Premium compatibility breakdowns",
        "Zero ads, pure focus"
    ]
    
    static let accountTools: [AccountTool] = [
        AccountTool(label: "Membership & Billing", iconName: "creditcard", path: "/profile/settings/wallet"),
        AccountTool(label: "Settings", iconName: "gearshape", path: "/profile/settings"),
        AccountTool(label: "Privacy & Terms", iconName: "shield", path: "/profile/settings/privacy")
    ]
}


