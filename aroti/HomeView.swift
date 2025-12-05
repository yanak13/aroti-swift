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
    
    // Sheet presentation states
    @State private var showTarotSheet: Bool = false
    @State private var showHoroscopeSheet: Bool = false
    @State private var showNumerologySheet: Bool = false
    @State private var showRitualDetail: Bool = false
    @State private var showReflectionSheet: Bool = false
    @State private var reflectionText: String = ""
    
    private let stateManager = DailyStateManager.shared
    private let contentService = DailyContentService.shared
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let safeAreaTop = geometry.safeAreaInsets.top
            
            ZStack(alignment: .bottom) {
                CelestialBackground()
                    .ignoresSafeArea()
                
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 24) {
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
                        if let insight = dailyInsight, let tarotCard = insight.tarotCard {
                            Button(action: {
                                if tarotCardFlipped {
                                    showTarotSheet = true
                                }
                            }) {
                                TarotCardView(
                                    card: tarotCard,
                                    isFlipped: tarotCardFlipped,
                                    onFlip: {
                                        tarotCardFlipped = true
                                        stateManager.markCardFlipped()
                                        // Show sheet after flip animation
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            showTarotSheet = true
                                        }
                                    },
                                    canFlip: !stateManager.hasFlippedCardToday()
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(!tarotCardFlipped)
                        }
                        
                        // Horoscope Section
                        if let insight = dailyInsight {
                            Button(action: {
                                showHoroscopeSheet = true
                            }) {
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
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                        // Numerology Section
                        if let insight = dailyInsight {
                            Button(action: {
                                showNumerologySheet = true
                            }) {
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
                            .buttonStyle(PlainButtonStyle())
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
                                        action: {
                                            showRitualDetail = true
                                        }
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
                                
                                if reflectionText.isEmpty {
                                    Text("Write something small about your day or energy.")
                                        .font(DesignTypography.footnoteFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                } else {
                                    Text(reflectionText)
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineLimit(3)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                ArotiButton(
                                    kind: .custom(.accentCard(height: 48)),
                                    action: {
                                        showReflectionSheet = true
                                    },
                                    label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: reflectionText.isEmpty ? "plus" : "pencil")
                                                .font(.system(size: 16))
                                            Text(reflectionText.isEmpty ? "Add Reflection" : "Edit Reflection")
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
                    .padding(.top, StickyHeaderBar.totalHeight(for: safeAreaTop))
                    
                    StickyHeaderBar(
                        title: "Today's Insights",
                        safeAreaTop: safeAreaTop
                    ) {
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.system(size: 20))
                                .foregroundColor(DesignColors.accent)
                                .frame(width: 36, height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.06))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                        )
                                )
                        }
                    }
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
                .sheet(isPresented: $showTarotSheet) {
                    if let insight = dailyInsight, let card = insight.tarotCard {
                        TarotDetailSheet(card: card)
                            .presentationDetents([.large]) // full-height popup for Tarot
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showHoroscopeSheet) {
                    if let insight = dailyInsight {
                        HoroscopeDetailSheet(horoscope: insight.horoscope, sign: userData.sunSign)
                            .presentationDetents([.large]) // full-height for Astrology
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showNumerologySheet) {
                    if let insight = dailyInsight {
                        HomeNumerologyDetailSheet(numerology: insight.numerology)
                            .presentationDetents([.large]) // full-height for Numerology
                            .presentationDragIndicator(.visible)
                    }
                }
                .sheet(isPresented: $showReflectionSheet) {
                    ReflectionSheet(reflectionText: $reflectionText)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
                .navigationDestination(isPresented: $showRitualDetail) {
                    if let insight = dailyInsight {
                        RitualDetailPage(ritual: insight.ritual)
                    }
                }
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
