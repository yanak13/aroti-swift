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
    @State private var userPoints: Int = 0
    
    // Sheet presentation states
    @State private var showTarotSheet: Bool = false
    @State private var showHoroscopeSheet: Bool = false
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
                                    // Energy Description
                                    VStack(alignment: .leading, spacing: 8) {
                                        let energyText = generateEnergyDescription()
                                        Text(energyText)
                                            .font(DesignTypography.subheadFont())
                                            .foregroundColor(DesignColors.accent)
                                            .opacity(0.9)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, DesignSpacing.sm)
                                    .padding(.top, DesignSpacing.lg + 16)
                                    
                                    // Main Content
                                    VStack(spacing: 24) {
                        // Tarot Card Section
                        if let insight = dailyInsight, let tarotCard = insight.tarotCard {
                            Group {
                                if tarotCardFlipped {
                                    Button(action: {
                                        showTarotSheet = true
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
                                } else {
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
                            }
                        }
                        
                        // Daily Insights - Horoscope and Reflection
                        VStack(spacing: 16) {
                            // Horoscope Card
                            if let insight = dailyInsight {
                                Button(action: {
                                    showHoroscopeSheet = true
                                }) {
                                    BaseCard {
                                        VStack(alignment: .leading, spacing: 12) {
                                            // Top row: Icon in top right
                                            HStack {
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
                                            
                                            Spacer()
                                            
                                            // Title and Description
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("Today's Context")
                                                    .font(DesignTypography.headlineFont(weight: .medium))
                                                    .foregroundColor(DesignColors.foreground)
                                                    .lineLimit(2)
                                                
                                                Text(insight.horoscope)
                                                    .font(.system(size: 14))
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                    .lineLimit(2)
                                                    .padding(.top, 4)
                                            }
                                        }
                                        .frame(height: 200, alignment: .topLeading)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .contentShape(Rectangle())
                            }
                            
                            // Reflection Card
                            Button(action: {
                                showReflectionSheet = true
                            }) {
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 8) {
                                        // Title
                                        Text("Your Reflection")
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                            .lineLimit(1)
                                        
                                        // Description
                                        if reflectionText.isEmpty {
                                            Text("Write something small about your day or energy.")
                                                .font(.system(size: 14))
                                                .foregroundColor(DesignColors.mutedForeground)
                                                .lineLimit(1)
                                        } else {
                                            Text(reflectionText)
                                                .font(.system(size: 14))
                                                .foregroundColor(DesignColors.mutedForeground)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                        
                                        // CTA Button - soft, secondary style
                                        ArotiButton(
                                            kind: .custom(.glassCardButton(height: 40)),
                                            action: {
                                                showReflectionSheet = true
                                            },
                                            label: {
                                                Text(reflectionText.isEmpty ? "Add a reflection" : "Edit reflection")
                                                    .font(DesignTypography.footnoteFont(weight: .medium))
                                            }
                                        )
                                    }
                                    .frame(height: 130, alignment: .topLeading)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contentShape(Rectangle())
                        }
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                        }
                        .padding(.bottom, 100) // Padding to prevent content from going behind nav bar
                    }
                    .padding(.top, 32) // Just header content height, safe area already handled
                    
                    StickyHeaderBar(
                        title: "Today's Insights",
                        subtitle: "Your daily cosmic guidance",
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
                .sheet(isPresented: $showReflectionSheet) {
                    ReflectionSheet(reflectionText: $reflectionText)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
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
        
        updatePoints()
    }
    
    private func updatePoints() {
        let balance = PointsService.shared.getBalance()
        userPoints = balance.totalPoints
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
