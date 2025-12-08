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
    
    // Profile data
    @State private var userName: String = "Alexandra Moon"
    @State private var userLocation: String = "San Francisco, CA"
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
    
    // Modal states
    @State private var showEditProfile = false
    @State private var showAstrologyModal = false
    @State private var showNumerologyModal = false
    @State private var showChineseZodiacModal = false
    @State private var showPaywall = false
    @State private var paywallContext: String? = nil
    @State private var showPDFModal = false
    @State private var showPartnerModal = false
    @State private var selectedAstrologyPlacement: PlanetaryPlacement?
    @State private var selectedReport: Report?
    @State private var userBlueprint: UserBlueprint?
    
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
    }
    
    // Update user points
    private func updatePoints() {
        let balance = PointsService.shared.getBalance()
        userPoints = balance.totalPoints
    }
    
    var body: some View {
        GeometryReader { geometry in
            let safeAreaTop = geometry.safeAreaInsets.top
            
            ZStack(alignment: .bottom) {
                CelestialBackground()
                    .ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 0) {
                            // 1. Unified User Card with Category Selector and Dynamic Content
                            ScrollReveal {
                                unifiedUserCard
                                    .padding(.top, DesignSpacing.lg + 8)
                                    .padding(.bottom, 32)
                            }
                            
                            // 4. Compatibility Card
                            ScrollReveal(delay: 0.15) {
                                compatibilityCard
                                    .padding(.bottom, 32)
                            }
                            
                            // 5. Reports
                            ScrollReveal(delay: 0.2) {
                                reportsSection
                                    .padding(.bottom, 32)
                            }
                            
                            // 6. Saved Content
                            ScrollReveal(delay: 0.25) {
                                savedContentSection
                                    .padding(.bottom, 32)
                            }
                            
                            // 7. Membership
                            ScrollReveal(delay: 0.3) {
                                membershipSection
                                    .padding(.bottom, 32)
                            }
                            
                            // 8. Account & Settings
                            ScrollReveal(delay: 0.35) {
                                accountSettingsSection
                            }
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.bottom, 100) // Space for bottom nav
                    }
                    .padding(.top, 32) // Just header content height, safe area already handled
                    
                    StickyHeaderBar(
                        title: "Profile",
                        subtitle: "Your cosmic journey",
                        safeAreaTop: safeAreaTop
                    ) {
                        HStack(spacing: 8) {
                            // Points Chip - dynamic width based on content
                            NavigationLink(destination: JourneyPage()) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                                    Text("\(userPoints.formatted())")
                                        .font(DesignTypography.caption1Font(weight: .semibold))
                                }
                                .foregroundColor(DesignColors.accent)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .frame(height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.06))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Notification Bell - matching points style
                            Button(action: {
                                // Handle notification tap
                            }) {
                                Image(systemName: "bell")
                                    .font(.system(size: 16))
                                    .foregroundColor(DesignColors.accent)
                                    .frame(width: 36, height: 36)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.06))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                            )
                                    )
                            }
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
                    userName: $userName,
                    userLocation: $userLocation,
                    onSave: { name, location in
                        userName = name
                        userLocation = location
                        // Reload blueprint after birth data changes
                        loadBlueprint()
                    }
                )
            }
            .sheet(isPresented: $showAstrologyModal) {
                if let placement = selectedAstrologyPlacement {
                    AstrologyDetailSheet(placement: placement)
                }
            }
            .sheet(isPresented: $showNumerologyModal) {
                if let blueprint = userBlueprint {
                    NumerologyDetailSheet(blueprint: blueprint.numerology)
                } else {
                    NumerologyDetailSheet()
                }
            }
            .sheet(isPresented: $showChineseZodiacModal) {
                if let blueprint = userBlueprint {
                    ChineseZodiacDetailSheet(blueprint: blueprint.chineseZodiac)
                }
            }
            .onAppear {
                loadBlueprint()
                updatePoints()
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
                PartnerInputSheet()
            }
        }
    }
    
    // MARK: - Helper Functions
    
    // MARK: - Helper Functions for Sign Symbols
    private func getSignSymbol(for planet: String) -> String {
        switch planet.lowercased() {
        case "sun": return "☉"
        case "moon": return "☽"
        case "rising": return "↑"
        default: return ""
        }
    }
    
    private var signsDisplayText: String {
        guard let blueprint = userBlueprint else {
            return ""
        }
        let placements = blueprint.astrology.essentialPlacements
        var parts: [String] = []
        
        for placement in placements {
            let symbol = getSignSymbol(for: placement.planet)
            if !symbol.isEmpty {
                parts.append("\(symbol) \(placement.sign)")
            }
        }
        
        return parts.joined(separator: " • ")
    }
    
    // MARK: - Unified User Card (Hero + Selector + Dynamic Content)
    private var unifiedUserCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 0) {
                // User Header Section with Edit Button
                ZStack(alignment: .topTrailing) {
                    HStack(spacing: 16) {
                        // Avatar
                        Group {
                            if let image = UIImage(named: profileAvatar) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundColor(DesignColors.accent.opacity(0.5))
                            }
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(DesignColors.accent.opacity(0.2), lineWidth: 2)
                        )
                        
                        // User Info
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userName)
                                .font(DesignTypography.title3Font())
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(userLocation)
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            // Sun/Moon/Rising signs
                            if !signsDisplayText.isEmpty {
                                Text(signsDisplayText)
                                    .font(DesignTypography.subheadFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                    .padding(.top, 4)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // Small Edit Button (Pen Icon) in top right
                    Button(action: {
                        showEditProfile = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                            .foregroundColor(DesignColors.mutedForeground)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.05))
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            )
                    }
                }
                .padding(.bottom, 20)
                
                // Category Selector
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.bottom, 16)
                
                HStack(spacing: 0) {
                    ForEach(BlueprintCategory.allCases, id: \.self) { category in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedCategory = category
                            }
                        }) {
                            Text(category.rawValue)
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(selectedCategory == category ? DesignColors.accent : DesignColors.mutedForeground.opacity(0.6))
                                .scaleEffect(selectedCategory == category ? 1.05 : 1.0)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .overlay(
                                    Rectangle()
                                        .frame(height: selectedCategory == category ? 2 : 0)
                                        .foregroundColor(DesignColors.accent)
                                        .offset(y: selectedCategory == category ? 18 : 0),
                                    alignment: .bottom
                                )
                        }
                    }
                }
                .padding(.bottom, 20)
                
                // Dynamic Category Content
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.bottom, 16)
                
                if hasBirthDetails, let blueprint = userBlueprint {
                    switch selectedCategory {
                    case .astrology:
                        astrologyCategoryContent(blueprint: blueprint.astrology)
                    case .numerology:
                        numerologyCategoryContent(blueprint: blueprint.numerology)
                    case .chineseZodiac:
                        chineseZodiacCategoryContent(blueprint: blueprint.chineseZodiac)
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
    
    // MARK: - Astrology Category Content
    private func astrologyCategoryContent(blueprint: AstrologyBlueprint) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Astrology")
                    .font(DesignTypography.title3Font())
                    .foregroundColor(DesignColors.foreground)
                
                Text("Your essential placements based on your birth date, time, and location.")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            // Sun, Moon, Rising (free)
            VStack(spacing: 12) {
                ForEach(blueprint.essentialPlacements) { placement in
                    Button(action: {
                        selectedAstrologyPlacement = placement
                        showAstrologyModal = true
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(placement.title)
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text(placement.description)
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
                }
            }
            
            // Premium Features Section
            if !isPremium {
                PremiumFeaturesSection(
                    features: ProfileData.premiumAstrologyFeatures,
                    unlockButtonText: "Unlock Full Astrology Report",
                    onUnlockClick: {
                        paywallContext = "astrology"
                        showPaywall = true
                    }
                )
            }
        }
    }
    
    // MARK: - Numerology Category Content
    private func numerologyCategoryContent(blueprint: NumerologyBlueprint) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Numerology")
                    .font(DesignTypography.title3Font())
                    .foregroundColor(DesignColors.foreground)
                
                Text("Your life path number calculated from your birth date.")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            // Life Path
            Button(action: {
                showNumerologyModal = true
            }) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Life Path \(blueprint.lifePath.number) — \(blueprint.lifePath.name)")
                        .font(DesignTypography.title3Font(weight: .semibold))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text(blueprint.lifePath.description)
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
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
            
            // Premium Features Section
            if !isPremium {
                PremiumFeaturesSection(
                    features: ProfileData.premiumNumerologyFeatures,
                    unlockButtonText: "Unlock All Numerology Numbers",
                    onUnlockClick: {
                        paywallContext = "numerology"
                        showPaywall = true
                    }
                )
            }
        }
    }
    
    // MARK: - Chinese Zodiac Category Content
    private func chineseZodiacCategoryContent(blueprint: ChineseZodiacBlueprint) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Chinese Zodiac")
                    .font(DesignTypography.title3Font())
                    .foregroundColor(DesignColors.foreground)
                
                Text("Your animal sign and element based on your birth year")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            // Animal sign
            VStack(alignment: .leading, spacing: 8) {
                Text("\(blueprint.fullSign) — \(blueprint.animal)")
                    .font(DesignTypography.title3Font(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                
                Text(blueprint.description)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.02))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )
            )
            
            // Element
            HStack(spacing: 8) {
                Text("Element:")
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                Text(blueprint.element)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.02))
            )
            
            // Year Pillar
            HStack(spacing: 8) {
                Text("Year Pillar:")
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                Text("\(blueprint.year)")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.02))
            )
            
            // Personality keywords
            if !blueprint.traits.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Personality Keywords")
                        .font(DesignTypography.bodyFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(blueprint.traits, id: \.self) { trait in
                            Text(trait)
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.05))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                        }
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.02))
                )
            }
            
            // Premium Features Section
            if !isPremium {
                PremiumFeaturesSection(
                    features: ProfileData.premiumChineseZodiacFeatures,
                    unlockButtonText: "Unlock Full Chinese Zodiac Insights",
                    onUnlockClick: {
                        paywallContext = "chineseZodiac"
                        showPaywall = true
                    }
                )
            }
        }
    }
    
    private var compatibilityCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Compatibility")
                        .font(DesignTypography.title3Font())
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Explore your relationship dynamics and connection patterns.")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                    
                    Text("Your romantic energy is ruled by Venus — compatibility can reveal deeper patterns.")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                        .italic()
                        .padding(.top, 4)
                }
                
                ArotiButton(
                    kind: .primary,
                    action: {
                        showPartnerModal = true
                    },
                    label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus")
                                .font(.system(size: 16))
                            Text("Add Partner")
                                .font(DesignTypography.subheadFont(weight: .medium))
                        }
                    }
                )
                
                // Free Preview Row
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Sun-sign compatibility preview")
                        .font(DesignTypography.bodyFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Tap for a quick overview")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.02))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.05), lineWidth: 1)
                        )
                )
                
                // Premium Preview Rows (with teaser text)
                if !isPremium {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Premium Features")
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.accent)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        let compatibilityFeatures = [
                            ("Full emotional compatibility", "Deep emotional connection insights and patterns."),
                            ("Communication chemistry", "How you communicate and connect with partners."),
                            ("Long-term potential", "Relationship longevity and growth opportunities.")
                        ]
                        
                        ForEach(Array(compatibilityFeatures.enumerated()), id: \.offset) { index, feature in
                            Button(action: {
                                paywallContext = "compatibility"
                                showPaywall = true
                            }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(DesignColors.accent)
                                        
                                        Text(feature.0)
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                        
                                        Spacer()
                                    }
                                    
                                    Text(feature.1)
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                        .padding(.leading, 20)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.02))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // Unlock button
                    Button(action: {
                        paywallContext = "compatibility"
                        showPaywall = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                            
                            Text("Full Compatibility Insights")
                                .font(DesignTypography.subheadFont(weight: .medium))
                        }
                        .foregroundColor(DesignColors.accent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(DesignColors.accent.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    
    // MARK: - Saved Content Section
    private var savedContentSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            BaseSectionHeader(
                title: "Saved Content",
                subtitle: "Your personal library of readings and tools",
                onViewAll: {
                    // Navigate to saved library
                }
            )
            
            VStack(spacing: 16) {
                // Category Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(SavedContentTab.allCases, id: \.self) { tab in
                            CategoryChip(
                                label: tab.rawValue,
                                isActive: activeSavedTab == tab,
                                action: {
                                    activeSavedTab = tab
                                }
                            )
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                }
                
                // Saved Items Horizontal Scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array((ProfileData.savedLibrary[activeSavedTab] ?? []).enumerated()), id: \.offset) { index, item in
                            savedContentCard(item: item, isPremium: activeSavedTab == .practices && index == 0)
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                }
            }
        }
    }
    
    private func savedContentCard(item: ProfileData.SavedContentItem, isPremium: Bool) -> some View {
        Button(action: {
            if isPremium && !UserSubscriptionService.shared.isPremium {
                paywallContext = nil
                showPaywall = true
            } else {
                // Navigate to content
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Text(item.type)
                        .font(DesignTypography.caption2Font(weight: .medium))
                        .foregroundColor(DesignColors.mutedForeground)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                        )
                    
                    if isPremium {
                        HStack(spacing: 4) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12))
                            Text("Premium")
                                .font(DesignTypography.caption2Font(weight: .medium))
                        }
                        .foregroundColor(DesignColors.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(DesignColors.accent.opacity(0.2))
                        )
                    }
                }
                
                Text(item.name)
                    .font(DesignTypography.headlineFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                    .multilineTextAlignment(.leading)
                
                Text(isPremium ? "Unlock to view" : "Tap to view your saved content")
                    .font(.system(size: 15))
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.leading)
                
                Text(item.timestamp)
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                    .padding(.top, 4)
            }
            .frame(width: 320, height: 200, alignment: .topLeading)
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Reports Section
    private var reportsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            BaseSectionHeader(
                title: "Reports",
                subtitle: "Purchase detailed PDF reports"
            )
            
            BaseCard {
                VStack(spacing: 12) {
                    ForEach(ProfileData.reports) { report in
                        Button(action: {
                            selectedReport = report
                            showPDFModal = true
                        }) {
                            ZStack(alignment: .topTrailing) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(report.name)
                                            .font(DesignTypography.bodyFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Text(report.description)
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("$\(String(format: "%.2f", report.price))")
                                        .font(DesignTypography.title3Font(weight: .semibold))
                                        .foregroundColor(DesignColors.accent)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                )
                                
                                if report.isMostPopular {
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 10))
                                        Text("Most popular")
                                            .font(DesignTypography.caption2Font(weight: .medium))
                                    }
                                    .foregroundColor(DesignColors.accent)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(DesignColors.accent.opacity(0.2))
                                    )
                                    .offset(x: -4, y: 4)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    // MARK: - Membership Section
    private var membershipSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            BaseSectionHeader(
                title: "Your Membership",
                subtitle: "Unlock your full cosmic potential"
            )
            
            ZStack(alignment: .topTrailing) {
                // Gradient background card
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                DesignColors.accent.opacity(0.25),
                                DesignColors.accent.opacity(0.10),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(DesignColors.accent.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: DesignColors.accent.opacity(0.2), radius: 8, x: 0, y: 4)
                
                // Star icon in top right
                Image(systemName: "sparkles")
                    .font(.system(size: 24))
                    .foregroundColor(DesignColors.accent)
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Membership")
                            .font(DesignTypography.title3Font())
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("You're on the Free Plan")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    .padding(.top, 20)
                    .padding(.leading, 20)
                    .padding(.trailing, 60) // Space for star icon
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(ProfileData.membershipBenefits, id: \.self) { benefit in
                            HStack(spacing: 8) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 16))
                                    .foregroundColor(DesignColors.accent)
                                
                                Text(benefit)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Unlock your full cosmic blueprint.")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal, 20)
                    
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    // MARK: - Account Settings Section
    private var accountSettingsSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.top, 32)
            
            BaseSectionHeader(
                title: "Account & Settings",
                subtitle: "Manage your preferences and privacy"
            )
            
            VStack(spacing: 12) {
                ForEach(ProfileData.accountTools, id: \.label) { tool in
                    BaseCard(
                        variant: .interactive,
                        action: {
                            // Handle navigation
                        }
                    ) {
                        HStack(spacing: 12) {
                            Image(systemName: tool.iconName)
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.mutedForeground)
                                .frame(width: 40, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white.opacity(0.05))
                                )
                            
                            Text(tool.label)
                                .font(DesignTypography.bodyFont(weight: .medium))
                                .foregroundColor(DesignColors.foreground)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16))
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Blueprint Category Enum
enum BlueprintCategory: String, CaseIterable {
    case astrology = "Astrology"
    case numerology = "Numerology"
    case chineseZodiac = "Chinese Zodiac"
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
    
    static let premiumChineseZodiacFeatures = [
        "Element compatibility",
        "Yearly forecasts"
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
        Report(id: "birth-chart", name: "Birth Chart Report", description: "Comprehensive analysis of your natal chart", price: 11.99, isMostPopular: true),
        Report(id: "numerology", name: "Numerology Report", description: "Complete numerology analysis and insights", price: 7.99, isMostPopular: false),
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
        "All compatibility insights",
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
        AccountTool(label: "Wallet & Credits", iconName: "creditcard", path: "/profile/settings/wallet"),
        AccountTool(label: "Settings", iconName: "gearshape", path: "/profile/settings"),
        AccountTool(label: "Notifications", iconName: "bell", path: "/profile/notifications"),
        AccountTool(label: "Language", iconName: "globe", path: "/profile/language"),
        AccountTool(label: "Privacy & Terms", iconName: "shield", path: "/profile/settings/privacy")
    ]
}


