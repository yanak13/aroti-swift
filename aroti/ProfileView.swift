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
    
    // Tab state for saved content
    @State private var activeSavedTab: SavedContentTab = .readings
    
    // Modal states
    @State private var showEditProfile = false
    @State private var showAstrologyModal = false
    @State private var showNumerologyModal = false
    @State private var showPaywall = false
    @State private var paywallContext: String? = nil
    @State private var showPDFModal = false
    @State private var showPartnerModal = false
    @State private var selectedAstrologyPlacement: AstrologyPlacement?
    @State private var selectedReport: Report?
    
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
    
    var body: some View {
        GeometryReader { geometry in
            let safeAreaTop = geometry.safeAreaInsets.top
            
            ZStack(alignment: .bottom) {
                CelestialBackground()
                    .ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 32) {
                            // 1. Profile Header
                            profileHeaderSection
                            
                            // 2. Membership Status (compact)
                            membershipSection
                            
                            // 3. Your Blueprint
                            blueprintSection
                            
                            // 4. Saved Content
                            savedContentSection
                            
                            // 5. Reports
                            reportsSection
                            
                            // 6. Account & Settings
                            accountSettingsSection
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.bottom, 100) // Space for bottom nav
                    }
                    .padding(.top, StickyHeaderBar.totalHeight(for: safeAreaTop))
                    
                    StickyHeaderBar(
                        title: "Profile",
                        safeAreaTop: safeAreaTop
                    )
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
                    }
                )
            }
            .sheet(isPresented: $showAstrologyModal) {
                if let placement = selectedAstrologyPlacement {
                    AstrologyDetailSheet(placement: placement)
                }
            }
            .sheet(isPresented: $showNumerologyModal) {
                NumerologyDetailSheet()
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
    
    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
        BaseCard {
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
                }
                
                Spacer()
                
                // Edit Profile Button
                Button(action: {
                    showEditProfile = true
                }) {
                    Text("Edit Profile")
                        .font(DesignTypography.subheadFont(weight: .medium))
                        .foregroundColor(DesignColors.foreground)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                )
                        )
                }
            }
        }
    }
    
    // MARK: - Blueprint Section
    private var blueprintSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            BaseSectionHeader(
                title: "Your Blueprint",
                subtitle: "Core traits based on your birth details"
            )
            
            if hasBirthDetails {
                VStack(spacing: 16) {
                    // Astrology Card
                    astrologyCard
                    
                    // Numerology Card
                    numerologyCard
                    
                    // Compatibility Card
                    compatibilityCard
                }
            } else {
                // Missing birth details placeholder
                BaseCard {
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
    
    private var astrologyCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Astrology")
                        .font(DesignTypography.title3Font())
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Essential placements derived from your birth date, time, and location")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                VStack(spacing: 12) {
                    ForEach(ProfileData.astrologyPlacements) { placement in
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
                
                // Premium Preview Row (compact)
                if !isPremium {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    Button(action: {
                        paywallContext = "astrology"
                        showPaywall = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Unlock full astrology blueprint: planets, houses, and aspects")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Spacer()
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
                
                // Natal Chart Wheel (integrated)
                Divider()
                    .background(Color.white.opacity(0.1))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Natal Chart Wheel")
                        .font(DesignTypography.title3Font())
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Your visual cosmic blueprint")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                    
                    if isPremium {
                        // Premium: Show wheel preview
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            DesignColors.accent.opacity(0.1),
                                            Color.white.opacity(0.05),
                                            DesignColors.accent.opacity(0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            
                            // Constellation dots effect
                            VStack {
                                Text("Natal Chart")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                            }
                        }
                        .frame(height: 192)
                    } else {
                        // Free: Locked preview
                        Button(action: {
                            paywallContext = "astrology"
                            showPaywall = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                DesignColors.accent.opacity(0.1),
                                                Color.white.opacity(0.05),
                                                DesignColors.accent.opacity(0.05)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                    )
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text("Premium Feature")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    Text("Tap to unlock")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                            }
                            .frame(height: 192)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    private var numerologyCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Numerology")
                        .font(DesignTypography.title3Font())
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("Core numbers that describe your path and personality")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                }
                
                Button(action: {
                    showNumerologyModal = true
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Life Path 3 — The Connector")
                            .font(DesignTypography.title3Font(weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                        
                        Text("Creative energy • Expression • Communication")
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
                
                // Premium Preview Row (compact)
                if !isPremium {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    Button(action: {
                        paywallContext = "numerology"
                        showPaywall = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Unlock Destiny, Expression, and Soul Urge numbers")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Spacer()
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
    
    private var compatibilityCard: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Compatibility")
                        .font(DesignTypography.title3Font())
                        .foregroundColor(DesignColors.foreground)
                    
                    Text("See how your energies interact in love, friendship, and work")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
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
                
                // Premium Preview Row (compact)
                if !isPremium {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    
                    Button(action: {
                        paywallContext = "compatibility"
                        showPaywall = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                                .foregroundColor(DesignColors.accent)
                            
                            Text("Unlock full compatibility insights")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                            
                            Spacer()
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
                        ForEach(ProfileData.savedLibrary[activeSavedTab] ?? [], id: \.self) { item in
                            savedContentCard(item: item, isPremium: activeSavedTab == .practices && item == ProfileData.savedLibrary[.practices]?.first)
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                }
            }
        }
    }
    
    private func savedContentCard(item: String, isPremium: Bool) -> some View {
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
                    Text(activeSavedTab.rawValue)
                        .font(DesignTypography.footnoteFont(weight: .medium))
                        .foregroundColor(DesignColors.mutedForeground)
                        .padding(.horizontal, 12)
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
                
                Text(item)
                    .font(DesignTypography.headlineFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                    .multilineTextAlignment(.leading)
                
                Text(isPremium ? "Unlock to view" : "Tap to view your saved content")
                    .font(.system(size: 15))
                    .foregroundColor(DesignColors.mutedForeground)
                    .multilineTextAlignment(.leading)
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
                subtitle: "Purchase detailed PDF insights"
            )
            
            BaseCard {
                VStack(spacing: 12) {
                    ForEach(ProfileData.reports) { report in
                        Button(action: {
                            selectedReport = report
                            showPDFModal = true
                        }) {
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
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    // MARK: - Membership Section (Compact)
    private var membershipSection: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your Membership")
                            .font(DesignTypography.title3Font())
                            .foregroundColor(DesignColors.foreground)
                        
                        Text(isPremium ? "All Access Member" : "You're on the Free Plan")
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    if isPremium {
                        ForEach(ProfileData.premiumMembershipBenefits, id: \.self) { benefit in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(DesignColors.accent)
                                
                                Text(benefit)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                            }
                        }
                    } else {
                        ForEach(ProfileData.freeMembershipBenefits, id: \.self) { benefit in
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(DesignColors.accent)
                                
                                Text(benefit)
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.foreground)
                            }
                        }
                    }
                }
                
                ArotiButton(
                    kind: isPremium ? .custom(ArotiButtonStyle(
                        foregroundColor: DesignColors.foreground,
                        backgroundColor: Color.white.opacity(0.05),
                        borderColor: Color.white.opacity(0.12),
                        borderWidth: 1,
                        cornerRadius: 10,
                        height: 44
                    )) : .custom(ArotiButtonStyle(
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
                        if isPremium {
                            // Navigate to manage membership
                        } else {
                            paywallContext = nil
                            showPaywall = true
                        }
                    },
                    label: {
                        Text(isPremium ? "Manage Membership" : "Unlock All Access")
                            .font(DesignTypography.subheadFont(weight: .medium))
                    }
                )
            }
            .padding(16)
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

// MARK: - Supporting Data Models
enum SavedContentTab: String, CaseIterable {
    case readings = "Readings"
    case practices = "Practices"
}

struct AstrologyPlacement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let sign: String
    let meaning: String
}

struct Report: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
}

struct AccountTool {
    let label: String
    let iconName: String
    let path: String
}

struct ProfileData {
    static let astrologyPlacements: [AstrologyPlacement] = [
        AstrologyPlacement(
            title: "Sun — Virgo",
            description: "Identity • How you move through the world",
            sign: "Virgo",
            meaning: "Your Sun in Virgo reflects a practical, analytical nature. You move through the world with attention to detail and a desire to be of service."
        ),
        AstrologyPlacement(
            title: "Moon — Pisces",
            description: "Inner world • How you feel and process emotion",
            sign: "Pisces",
            meaning: "Your Moon in Pisces reveals a deeply intuitive and empathetic emotional nature. You process feelings through imagination and compassion."
        ),
        AstrologyPlacement(
            title: "Rising — Leo",
            description: "First impression • The energy you project to others",
            sign: "Leo",
            meaning: "Your Rising in Leo means you present with warmth and confidence. Others see your natural radiance first."
        )
    ]
    
    static let premiumAstrologyFeatures = [
        "All planets (Venus, Mars, Mercury...)",
        "12 Houses",
        "Aspects",
        "Strengths & weaknesses",
        "Full personality, love, career, health interpretation",
        "Full chart overview"
    ]
    
    static let premiumNumerologyFeatures = [
        "Destiny Number",
        "Expression Number",
        "Soul Urge",
        "Birthday Number",
        "Karmic Lessons"
    ]
    
    static let savedLibrary: [SavedContentTab: [String]] = [
        .readings: ["Celtic Cross Spread", "Moonlit Reflection", "Solar Alignment"],
        .practices: ["Morning Mantra", "Gratitude Flow", "Evening Integration"]
    ]
    
    static let reports: [Report] = [
        Report(id: "birth-chart", name: "Birth Chart Report", description: "Comprehensive analysis of your natal chart", price: 11.99),
        Report(id: "numerology", name: "Numerology Report", description: "Complete numerology analysis and insights", price: 7.99),
        Report(id: "compatibility", name: "Compatibility Report", description: "Deep dive into relationship dynamics", price: 9.99),
        Report(id: "year-ahead", name: "Year Ahead Report", description: "Astrological forecast for the coming year", price: 12.99)
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
    
    static let accountTools: [AccountTool] = [
        AccountTool(label: "Wallet & Credits", iconName: "creditcard", path: "/profile/settings/wallet"),
        AccountTool(label: "Settings", iconName: "gearshape", path: "/profile/settings"),
        AccountTool(label: "Notifications", iconName: "bell", path: "/profile/notifications"),
        AccountTool(label: "Language", iconName: "globe", path: "/profile/language"),
        AccountTool(label: "Privacy & Terms", iconName: "shield", path: "/profile/settings/privacy")
    ]
}

#Preview {
    NavigationStack {
        ProfileView(selectedTab: .constant(.profile))
    }
}

