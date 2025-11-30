//
//  HomeView.swift
//  Aroti
//
//  Home page reusing components from the design system
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: TabItem
    @State private var userData: UserData = UserData.default
    @State private var dailyInsight: DailyInsight?
    @State private var tarotCardFlipped: Bool = false
    @State private var currentAffirmation: String = ""
    @State private var canShuffleAffirmation: Bool = true
    
    private let stateManager = DailyStateManager.shared
    private let contentService = DailyContentService.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header - positioned right after safe area, left-aligned page title
                        HStack {
                            Text("Today's Insights")
                                .font(DesignTypography.title2Font(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "bell")
                                    .font(.system(size: 20))
                                    .foregroundColor(DesignColors.accent)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                    
                    // Greeting Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hi \(userData.name),")
                            .font(DesignTypography.title3Font())
                            .foregroundColor(DesignColors.foreground)
                        
                        let energyText = generateEnergyDescription()
                        Text(energyText)
                            .font(DesignTypography.subheadFont())
                            .foregroundColor(DesignColors.accent)
                            .opacity(0.9)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, DesignSpacing.sm)
                    
                    // Main Content
                    VStack(spacing: 24) {
                        // Tarot Card Section
                        if let insight = dailyInsight {
                            TarotCardView(
                                card: insight.tarotCard,
                                isFlipped: tarotCardFlipped,
                                onFlip: {
                                    tarotCardFlipped = true
                                    stateManager.markCardFlipped()
                                },
                                canFlip: !stateManager.hasFlippedCardToday()
                            )
                        }
                        
                        // Horoscope Section
                        if let insight = dailyInsight {
                            BaseCard {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Daily Horoscope")
                                            .font(DesignTypography.headlineFont(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                        Text(insight.horoscope)
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    
                                    Spacer()
                                    
                                    // Zodiac symbol in square with glow
                                    Text(getZodiacSymbol(userData.sunSign))
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                        .frame(width: 48, height: 48)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(getZodiacColor(userData.sunSign).opacity(0.3))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(getZodiacColor(userData.sunSign).opacity(0.5), lineWidth: 1)
                                                )
                                        )
                                }
                                .frame(minHeight: 80)
                            }
                        }
                        
                        // Numerology Section
                        if let insight = dailyInsight {
                            BaseCard {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Numerology")
                                            .font(DesignTypography.headlineFont(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                        Text(insight.numerology.preview)
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    
                                    Spacer()
                                    
                                    // Number badge with orange glow
                                    Text("\(insight.numerology.number)")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 48, height: 48)
                                        .background(
                                            Circle()
                                                .fill(DesignColors.accent.opacity(0.3))
                                                .overlay(
                                                    Circle()
                                                        .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                                )
                                        )
                                }
                                .frame(minHeight: 80)
                            }
                        }
                        
                        // Today's Ritual
                        if let insight = dailyInsight {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Today's Ritual")
                                                .font(DesignTypography.headlineFont(weight: .semibold))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            Text(insight.ritual.description)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                        }
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 8) {
                                            CategoryChip(label: insight.ritual.duration, isActive: true, action: {})
                                            CategoryChip(label: insight.ritual.type, isActive: true, action: {})
                                        }
                                    }
                                    
                                    ArotiButton(
                                        kind: .custom(.accentCard(height: 48)),
                                        title: "Begin Practice",
                                        action: {}
                                    )
                                }
                            }
                        }
                        
                        // Your Reflection Section
                        BaseCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your Reflection")
                                    .font(DesignTypography.headlineFont(weight: .semibold))
                                    .foregroundColor(DesignColors.foreground)
                                
                                Text("Write something small about your day or energy.")
                                    .font(DesignTypography.footnoteFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                                
                                ArotiButton(
                                    kind: .custom(.accentCard(height: 48)),
                                    action: {},
                                    label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "plus")
                                                .font(.system(size: 16))
                                            Text("Add Reflection")
                                                .font(DesignTypography.subheadFont(weight: .medium))
                                        }
                                    }
                                )
                            }
                        }
                        
                        // Daily Affirmation
                        if let insight = dailyInsight {
                            BaseCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Daily Affirmation")
                                            .font(DesignTypography.headlineFont(weight: .semibold))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Spacer()
                                        
                                        // Bookmark icon should be white
                                        Image(systemName: "bookmark.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(DesignColors.foreground)
                                    }
                                    
                                    // Quote should be centered
                                    Text("\"\(currentAffirmation.isEmpty ? insight.affirmation : currentAffirmation)\"")
                                        .font(DesignTypography.headlineFont(weight: .semibold))
                                        .foregroundColor(DesignColors.foreground)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                    
                                    ArotiButton(
                                        kind: .custom(ArotiButtonStyle(
                                            foregroundColor: ArotiColor.accent,
                                            backgroundColor: .clear,
                                            borderColor: ArotiColor.accent,
                                            borderWidth: 1,
                                            cornerRadius: DesignRadius.secondary,
                                            height: 48
                                        )),
                                        action: {
                                            if canShuffleAffirmation {
                                                let newAffirmation = contentService.generateAffirmation(dayOfYear: contentService.getDayOfYear() + 1)
                                                currentAffirmation = newAffirmation
                                                stateManager.markAffirmationShuffled()
                                                canShuffleAffirmation = stateManager.canShuffleAffirmation()
                                            }
                                        },
                                        label: {
                                            HStack(spacing: 8) {
                                                Image(systemName: "shuffle")
                                                    .font(.system(size: 16))
                                                Text("New one")
                                                    .font(DesignTypography.subheadFont(weight: .medium))
                                            }
                                        }
                                    )
                                    .disabled(!canShuffleAffirmation)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    
                    // Footer Message
                    Text("Aroti is guiding you today.")
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .opacity(0.6)
                        .padding(.top, DesignSpacing.md)
                        .padding(.bottom, 60) // Reasonable padding to ensure visibility above nav bar
                    }
                    .padding(.bottom, 60) // Reasonable padding to prevent content from going behind nav bar
                }
                
                // Bottom Navigation Bar - fixed at bottom
                VStack {
                    Spacer()
                    BottomNavigationBar(selectedTab: $selectedTab) { tab in
                        // Handle tab selection
                        selectedTab = tab
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarHidden(true)
            .onAppear {
                loadData()
            }
        }
    }
    
    private func loadData() {
        // Load user data
        if let loadedUserData = stateManager.loadUserData() {
            userData = loadedUserData
        }
        
        // Check if we need to reset daily state
        if stateManager.shouldResetDailyState() {
            _ = stateManager.resetDailyState()
            tarotCardFlipped = false
        } else {
            tarotCardFlipped = stateManager.hasFlippedCardToday()
        }
        
        // Generate daily insight
        dailyInsight = contentService.generateDailyInsight(userData: userData)
        currentAffirmation = dailyInsight?.affirmation ?? ""
        canShuffleAffirmation = stateManager.canShuffleAffirmation()
    }
    
    private func generateEnergyDescription() -> String {
        let traits = userData.traits ?? ["intuitive", "spiritual"]
        let firstTrait = traits.first?.lowercased() ?? "intuitive"
        let secondTrait = traits.count > 1 ? traits[1].lowercased() : "grounded"
        return "Today your energy feels \(firstTrait) and \(secondTrait) under \(userData.sunSign) skies."
    }
    
    private func getZodiacSymbol(_ sign: String) -> String {
        let symbols: [String: String] = [
            "Aries": "♈",
            "Taurus": "♉",
            "Gemini": "♊",
            "Cancer": "♋",
            "Leo": "♌",
            "Virgo": "♍",
            "Libra": "♎",
            "Scorpio": "♏",
            "Sagittarius": "♐",
            "Capricorn": "♑",
            "Aquarius": "♒",
            "Pisces": "♓"
        ]
        return symbols[sign] ?? "♓"
    }
    
    private func getZodiacColor(_ sign: String) -> Color {
        // Return purple for Pisces with proper glow, accent for others
        if sign == "Pisces" {
            return Color(hue: 270/360, saturation: 0.7, brightness: 0.8)
        }
        return DesignColors.accent
    }
}

#Preview {
    NavigationStack {
        HomeView(selectedTab: .constant(.home))
    }
}
