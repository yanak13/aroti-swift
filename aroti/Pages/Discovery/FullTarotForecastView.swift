//
//  FullTarotForecastView.swift
//  Aroti
//
//  Full tarot forecast content view (sections 8.1-8.5)
//

import SwiftUI

struct FullTarotForecastView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showReflectionSheet: Bool = false
    
    private let manager = DailyStateManager.shared
    
    private var hasReflectionToday: Bool {
        manager.hasReflectionToday()
    }
    
    private var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Page Header
                    BaseHeader(
                        title: "\(currentMonthName) Tarot Overview",
                        subtitle: "Themes shaping this month",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, 0)
                    
                    // 8.2 Key Themes (Core Section)
                    keyThemesSection
                    
                    // 8.3 Life Areas Focus
                    lifeAreasFocusSection
                    
                    // 8.4 Guidance & Reflection
                    guidanceSection
                    
                    // 8.5 Optional Reflection Prompt
                    reflectionPromptSection
                    
                    // Add Reflection Button
                    addReflectionButton
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 12)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showReflectionSheet) {
            ReflectionSheet(prompt: "")
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: - 8.2 Key Themes Section
    private var keyThemesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key themes")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.accent)
            
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
    }
    
    // MARK: - 8.3 Life Areas Focus Section
    private var lifeAreasFocusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Areas of focus")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.accent)
            
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
    }
    
    // MARK: - 8.4 Guidance & Reflection Section
    private var guidanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Guidance for the month")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.accent)
            
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
    }
    
    // MARK: - 8.5 Reflection Prompt Section
    private var reflectionPromptSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reflection prompt")
                .font(DesignTypography.title3Font(weight: .medium))
                .foregroundColor(DesignColors.accent)
            
            Text("What small adjustment could bring more balance into your routine this month?")
                .font(DesignTypography.bodyFont())
                .foregroundColor(DesignColors.mutedForeground)
                .italic()
                .lineSpacing(6)
        }
    }
    
    // MARK: - Add Reflection Button
    private var addReflectionButton: some View {
        ArotiButton(
            kind: .primary,
            title: hasReflectionToday ? "Edit Reflection" : "Add Reflection",
            icon: Image(systemName: hasReflectionToday ? "pencil" : "plus"),
            action: {
                showReflectionSheet = true
            }
        )
        .padding(.top, 8)
    }
    
    // MARK: - Helper Views
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
        FullTarotForecastView()
    }
}

