//
//  TarotForecastPage.swift
//  Aroti
//
//  Tarot Forecast detail page (Premium users only)
//

import SwiftUI

struct TarotForecastPage: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showFullForecast = false
    
    private var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
    }
    
    // TODO: Replace with actual forecast data when available
    private var hasForecastContent: Bool {
        false // Set to true when forecast is generated
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Page Header
                    BaseHeader(
                        title: "Tarot Forecast",
                        subtitle: "Guidance for what's coming next",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, 0)
                    
                    // 1. Hero Card (Anchor) - Premium size
                    heroCard
                    
                    // 2. What This Month Holds (Premium Forecast Overview)
                    whatThisMonthHoldsSection
                    
                    // 3. How This Forecast Is Created
                    howItsCreatedSection
                    
                    // 4. Forecast Preview (This Month's Focus)
                    forecastPreviewSection
                    
                    // 5. Premium Navigation CTA
                    if !hasForecastContent {
                        premiumNavigationCTA
                    }
                    
                    // 6. Actual Forecast Content (when available)
                    if hasForecastContent {
                        forecastContentSection
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 12)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showFullForecast) {
            FullTarotForecastView()
        }
    }
    
    // MARK: - Hero Card (Premium Size)
    private var heroCard: some View {
        Button(action: {
            if hasForecastContent {
                showFullForecast = true
            }
        }) {
            BaseCard {
                heroCardContent
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!hasForecastContent)
    }
    
    private var heroCardContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Month label chip (top right)
            HStack {
                Spacer()
                Text("\(currentMonthName) Forecast")
                    .font(DesignTypography.footnoteFont(weight: .medium))
                    .foregroundColor(DesignColors.mutedForeground)
                    .padding(.horizontal, 12)
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
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Monthly Tarot Forecast")
                    .font(DesignTypography.headlineFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                    .lineLimit(2)
                
                Text("Your personalized tarot forecast for \(currentMonthName) will appear here.")
                    .font(.system(size: 14))
                    .foregroundColor(DesignColors.mutedForeground)
                    .lineLimit(3)
                    .lineSpacing(4)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: 200) // Shorter height, full width
    }
    
    // MARK: - What This Month Holds Section
    private var whatThisMonthHoldsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What this month holds")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            VStack(alignment: .leading, spacing: 12) {
                listItem(
                    title: "Key themes influencing the month",
                    description: nil
                )
                
                listItem(
                    title: "Areas of focus and transition",
                    description: nil
                )
                
                listItem(
                    title: "Guidance to help you navigate decisions",
                    description: nil
                )
            }
        }
    }
    
    // MARK: - How It's Created Section
    private var howItsCreatedSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How this forecast is created")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            VStack(alignment: .leading, spacing: 12) {
                numberedListItem(
                    number: 1,
                    title: "Cards drawn for the upcoming month"
                )
                
                numberedListItem(
                    number: 2,
                    title: "Interpretation of card meanings and patterns"
                )
                
                numberedListItem(
                    number: 3,
                    title: "Synthesized into clear, human guidance"
                )
            }
        }
    }
    
    // MARK: - Forecast Preview Section
    private var forecastPreviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This month's focus")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            Text("This month highlights a shift in how you approach responsibility and long-term goals. Small adjustments in routine may create more stability than forceful action.")
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.mutedForeground)
                .lineSpacing(6) // Increased line-height for readability
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Premium Navigation CTA
    private var premiumNavigationCTA: some View {
        ArotiButton(
            kind: .primary,
            title: "View full \(currentMonthName) forecast",
            action: {
                showFullForecast = true
            }
        )
    }
    
    // MARK: - Forecast Content Section (when available)
    private var forecastContentSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            // 8.1 Forecast Header
            VStack(alignment: .leading, spacing: 4) {
                Text("\(currentMonthName) Tarot Overview")
                    .font(DesignTypography.title2Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                Text("Themes shaping this month")
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
            }
            
            // 8.2 Key Themes
            VStack(alignment: .leading, spacing: 16) {
                Text("Key themes")
                    .font(DesignTypography.title3Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                VStack(alignment: .leading, spacing: 12) {
                    themeItem(
                        title: "Rebalancing priorities",
                        description: "A focus on restructuring daily habits to support long-term stability."
                    )
                    
                    themeItem(
                        title: "Emotional clarity",
                        description: "Moments of insight help clarify where energy should be conserved."
                    )
                    
                    themeItem(
                        title: "Intentional transitions",
                        description: "This period supports thoughtful movement between phases rather than abrupt changes."
                    )
                }
            }
            
            // 8.3 Life Areas Focus
            VStack(alignment: .leading, spacing: 16) {
                Text("Areas of focus")
                    .font(DesignTypography.title3Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                VStack(alignment: .leading, spacing: 16) {
                    lifeAreaItem(
                        area: "Career",
                        description: "This month brings opportunities to reassess your professional direction. Consider what adjustments might create more alignment with your values."
                    )
                    
                    lifeAreaItem(
                        area: "Relationships",
                        description: "Communication patterns may shift, offering chances to deepen connections through honest dialogue."
                    )
                    
                    lifeAreaItem(
                        area: "Personal growth",
                        description: "A period of reflection supports personal development. Trust your intuition as you navigate new insights."
                    )
                    
                    lifeAreaItem(
                        area: "Energy & wellbeing",
                        description: "Pay attention to your natural rhythms and energy cycles. Rest when needed, and honor the pace that feels sustainable for you."
                    )
                    
                    lifeAreaItem(
                        area: "Finances",
                        description: "A time to review your relationship with resources and abundance. Consider how your financial choices align with your deeper values."
                    )
                }
            }
            
            // 8.4 Guidance & Reflection
            VStack(alignment: .leading, spacing: 16) {
                Text("Guidance for the month")
                    .font(DesignTypography.title3Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("This month invites you to find balance between action and reflection. Rather than forcing outcomes, consider how small, intentional shifts might create the stability you're seeking.")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("Trust the process of gradual change. The themes emerging now are part of a longer journey, and your awareness of them is already a meaningful step forward.")
                        .font(DesignTypography.bodyFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // 8.5 Optional Reflection Prompt
            VStack(alignment: .leading, spacing: 16) {
                Text("Reflection prompt")
                    .font(DesignTypography.title3Font(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                
                Text("What small adjustment could bring more balance into your routine this month?")
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .italic()
                    .lineSpacing(6)
            }
        }
    }
    
    // MARK: - Helper Views
    private func listItem(title: String, description: String?) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(DesignColors.accent.opacity(0.3))
                .frame(width: 6, height: 6)
                .padding(.top, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(DesignTypography.bodyFont())
                    .foregroundColor(DesignColors.foreground)
                    .lineSpacing(4)
                
                if let description = description {
                    Text(description)
                        .font(DesignTypography.footnoteFont())
                        .foregroundColor(DesignColors.mutedForeground)
                        .lineSpacing(4)
                }
            }
        }
    }
    
    private func numberedListItem(number: Int, title: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number).")
                .font(DesignTypography.bodyFont(weight: .medium))
                .foregroundColor(DesignColors.accent)
                .frame(width: 24, alignment: .leading)
            
            Text(title)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.foreground)
                .lineSpacing(4)
        }
    }
    
    private func themeItem(title: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(DesignTypography.headlineFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            Text(description)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.mutedForeground)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func lifeAreaItem(area: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(area)
                .font(DesignTypography.headlineFont(weight: .medium))
                .foregroundColor(DesignColors.foreground)
            
            Text(description)
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.mutedForeground)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    NavigationStack {
        TarotForecastPage()
    }
}
