//
//  PracticeDetailPage.swift
//  Aroti
//
//  Practice detail page with steps and benefits
//

import SwiftUI

struct PracticeDetail: Identifiable {
    let id: String
    let title: String
    let duration: String
    let category: String
    let description: String
    let steps: [String]
    let benefits: [String]
}

struct PracticeDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    let practiceId: String
    
    // Generate practice-specific hero image
    @ViewBuilder
    private func practiceHeroImage(for practice: PracticeDetail) -> some View {
        ZStack {
            // Base gradient - varies by practice type
            Group {
                if practice.category.lowercased() == "meditation" {
                    LinearGradient(
                        colors: [
                            Color(hue: 220/360, saturation: 0.30, brightness: 0.14),
                            Color(hue: 240/360, saturation: 0.25, brightness: 0.12),
                            Color(hue: 250/360, saturation: 0.20, brightness: 0.10)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else if practice.category.lowercased() == "reflection" {
                    LinearGradient(
                        colors: [
                            Color(hue: 260/360, saturation: 0.25, brightness: 0.13),
                            Color(hue: 270/360, saturation: 0.20, brightness: 0.11),
                            Color(hue: 280/360, saturation: 0.18, brightness: 0.09)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else if practice.title.lowercased().contains("morning") {
                    LinearGradient(
                        colors: [
                            Color(hue: 30/360, saturation: 0.35, brightness: 0.18),
                            Color(hue: 25/360, saturation: 0.30, brightness: 0.15),
                            Color(hue: 20/360, saturation: 0.25, brightness: 0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else if practice.title.lowercased().contains("gratitude") {
                    LinearGradient(
                        colors: [
                            Color(hue: 45/360, saturation: 0.30, brightness: 0.16),
                            Color(hue: 40/360, saturation: 0.25, brightness: 0.14),
                            Color(hue: 35/360, saturation: 0.20, brightness: 0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    LinearGradient(
                        colors: [
                            Color(hue: 240/360, saturation: 0.25, brightness: 0.15),
                            Color(hue: 235/360, saturation: 0.20, brightness: 0.12),
                            Color(hue: 245/360, saturation: 0.18, brightness: 0.10)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
            
            // Subtle overlay pattern
            RadialGradient(
                colors: [
                    DesignColors.accent.opacity(0.15),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 200
            )
            
            // Practice-specific decorative icon
            Group {
                if practice.category.lowercased() == "meditation" {
                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.system(size: 64))
                        .foregroundColor(DesignColors.accent.opacity(0.4))
                        .offset(x: 0, y: 0)
                } else if practice.category.lowercased() == "reflection" {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 64))
                        .foregroundColor(DesignColors.accent.opacity(0.4))
                        .offset(x: 20, y: -10)
                } else if practice.title.lowercased().contains("morning") {
                    Image(systemName: "sunrise.fill")
                        .font(.system(size: 64))
                        .foregroundColor(DesignColors.accent.opacity(0.4))
                        .offset(x: -20, y: 20)
                } else if practice.title.lowercased().contains("gratitude") {
                    Image(systemName: "sparkles")
                        .font(.system(size: 64))
                        .foregroundColor(DesignColors.accent.opacity(0.4))
                        .offset(x: 15, y: -15)
                } else {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 64))
                        .foregroundColor(DesignColors.accent.opacity(0.4))
                        .offset(x: 0, y: 0)
                }
            }
        }
        .frame(height: 200)
    }
    
    private var practice: PracticeDetail? {
        let practices: [String: PracticeDetail] = [
            "1": PracticeDetail(
                id: "1",
                title: "Morning Intention",
                duration: "5 min",
                category: "Mindfulness",
                description: "Start your day with clarity and purpose by setting meaningful intentions that align with your values and goals.",
                steps: [
                    "Find a quiet space and sit comfortably with your back straight.",
                    "Take three deep breaths, inhaling through your nose and exhaling through your mouth.",
                    "Bring to mind three things you're grateful for today.",
                    "Ask yourself: 'What is one intention I want to set for today?'",
                    "Visualize yourself embodying this intention throughout your day.",
                    "Take a final breath and affirm your intention silently or aloud.",
                    "Carry this intention with you as you begin your day."
                ],
                benefits: [
                    "Increases focus and clarity",
                    "Aligns actions with values",
                    "Reduces morning anxiety",
                    "Creates positive momentum"
                ]
            ),
            "2": PracticeDetail(
                id: "2",
                title: "Breathing Exercise",
                duration: "10 min",
                category: "Meditation",
                description: "A calming breathing practice that helps regulate your nervous system and brings you into the present moment.",
                steps: [
                    "Sit or lie in a comfortable position.",
                    "Place one hand on your chest and one on your belly.",
                    "Inhale slowly through your nose for a count of four.",
                    "Hold your breath for a count of four.",
                    "Exhale slowly through your mouth for a count of six.",
                    "Repeat this cycle 8-10 times.",
                    "Notice how your body feels as you complete each cycle.",
                    "When finished, take a few normal breaths and slowly open your eyes."
                ],
                benefits: [
                    "Reduces stress and anxiety",
                    "Improves focus",
                    "Regulates nervous system",
                    "Promotes relaxation"
                ]
            ),
            "3": PracticeDetail(
                id: "3",
                title: "Evening Reflection",
                duration: "8 min",
                category: "Reflection",
                description: "A thoughtful practice to review your day, acknowledge growth, and prepare for restful sleep.",
                steps: [
                    "Find a comfortable, quiet space where you won't be disturbed.",
                    "Take a few deep breaths to transition from your day.",
                    "Reflect on three moments of growth or learning today.",
                    "Acknowledge one challenge you faced and how you handled it.",
                    "Note one thing you're proud of yourself for today.",
                    "Consider one thing you'd like to do differently tomorrow.",
                    "End by expressing gratitude for the day's experiences.",
                    "Set an intention for peaceful rest."
                ],
                benefits: [
                    "Promotes self-awareness",
                    "Improves sleep quality",
                    "Encourages growth mindset",
                    "Reduces daily stress"
                ]
            ),
            "4": PracticeDetail(
                id: "4",
                title: "Gratitude Practice",
                duration: "3 min",
                category: "Mindfulness",
                description: "A quick but powerful practice to shift your perspective and cultivate appreciation.",
                steps: [
                    "Take a comfortable seated position.",
                    "Close your eyes and take three deep breaths.",
                    "Think of three specific things you're grateful for today.",
                    "For each item, spend a moment truly feeling the gratitude.",
                    "Notice where you feel gratitude in your body.",
                    "Open your eyes with a renewed sense of appreciation.",
                    "Carry this feeling with you as you continue your day."
                ],
                benefits: [
                    "Boosts mood and happiness",
                    "Shifts perspective positively",
                    "Reduces negative thinking",
                    "Strengthens relationships"
                ]
            )
        ]
        return practices[practiceId]
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        BaseHeader(
                            title: practice?.title ?? "Practice",
                            subtitle: practice?.category,
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            ),
                            alignment: .leading
                        )
                        .padding(.top, 0)
                        
                        if let practice = practice {
                            // Content
                            VStack(spacing: 24) {
                                // Hero Card with Image, Description, and Benefits
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 0) {
                                        // Hero Image/Illustration - Inside Card
                                        practiceHeroImage(for: practice)
                                            .clipShape(
                                                .rect(
                                                    topLeadingRadius: ArotiRadius.md,
                                                    topTrailingRadius: ArotiRadius.md
                                                )
                                            )
                                            .padding(.horizontal, -16)
                                            .padding(.top, -16)
                                            .padding(.bottom, 20)
                                        
                                        VStack(alignment: .leading, spacing: 20) {
                                            // Icon, Duration, Category Row
                                            HStack(spacing: 12) {
                                                ZStack {
                                                    Circle()
                                                        .fill(DesignColors.accent.opacity(0.2))
                                                        .frame(width: 40, height: 40)
                                                    
                                                    Image(systemName: "clock.fill")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(DesignColors.accent)
                                                }
                                                
                                                Text(practice.duration)
                                                    .font(DesignTypography.footnoteFont())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                
                                                Text("•")
                                                    .font(DesignTypography.footnoteFont())
                                                    .foregroundColor(DesignColors.mutedForeground)
                                                
                                                Text(practice.category)
                                                    .font(DesignTypography.footnoteFont(weight: .medium))
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
                                                
                                                Spacer()
                                            }
                                            
                                            // Description
                                            Text(practice.description)
                                                .font(DesignTypography.bodyFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            // Divider
                                            Divider()
                                                .background(Color.white.opacity(0.1))
                                            
                                            // Benefits Section
                                            VStack(alignment: .leading, spacing: 12) {
                                                Text("Benefits")
                                                    .font(DesignTypography.title3Font(weight: .medium))
                                                    .foregroundColor(DesignColors.foreground)
                                                
                                                VStack(alignment: .leading, spacing: 12) {
                                                    ForEach(practice.benefits, id: \.self) { benefit in
                                                        HStack(alignment: .top, spacing: 12) {
                                                            Image(systemName: "checkmark.circle.fill")
                                                                .font(.system(size: 20))
                                                                .foregroundColor(DesignColors.accent)
                                                            
                                                            Text(benefit)
                                                                .font(DesignTypography.bodyFont())
                                                                .foregroundColor(DesignColors.foreground)
                                                                .fixedSize(horizontal: false, vertical: true)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            .padding(.top, 16)
                            .padding(.bottom, 120) // Space for fixed button at bottom
                        } else {
                            // Not Found
                            BaseCard {
                                VStack {
                                    Text("This practice could not be found.")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                            }
                            .padding(.horizontal, DesignSpacing.sm)
                            .padding(.top, 16)
                        }
                    }
                }
                
                // Fixed button at bottom (same position as Next button)
                if let practice = practice {
                    VStack(spacing: 12) {
                        NavigationLink(destination: GuidedPracticeView(practice: practice)) {
                            Text("Start Practice")
                                .font(DesignTypography.subheadFont(weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(DesignColors.accent)
                                        .shadow(color: DesignColors.accent.opacity(0.35), radius: 10, x: 0, y: 6)
                                )
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            HapticFeedback.impactOccurred(.medium)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        // Invisible spacer to match Back button space (keeps button at same position as Next)
                        Spacer()
                            .frame(height: 44)
                    }
                    .padding(.horizontal, DesignSpacing.sm)
                    .padding(.bottom, 48)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        PracticeDetailPage(practiceId: "1")
    }
}

