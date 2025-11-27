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
                            )
                        )
                        .padding(.top, max(0, geometry.safeAreaInsets.top - 45))
                        
                        if let practice = practice {
                            // Content
                            VStack(spacing: 16) {
                                // Hero Section
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        HStack(spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(DesignColors.accent.opacity(0.2))
                                                    .frame(width: 48, height: 48)
                                                
                                                Image(systemName: "clock.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(DesignColors.accent)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack(spacing: 8) {
                                                    Text(practice.duration)
                                                        .font(DesignTypography.footnoteFont())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                    
                                                    Text("•")
                                                        .font(DesignTypography.footnoteFont())
                                                        .foregroundColor(DesignColors.mutedForeground)
                                                    
                                                    Text(practice.category)
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
                                            }
                                        }
                                        
                                        Text(practice.title)
                                            .font(DesignTypography.title1Font(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        Text(practice.description)
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Benefits Section
                                BaseCard {
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "sparkles")
                                            .font(.system(size: 20))
                                            .foregroundColor(DesignColors.accent)
                                        
                                        VStack(alignment: .leading, spacing: 12) {
                                            Text("Benefits")
                                                .font(DesignTypography.headlineFont(weight: .medium))
                                                .foregroundColor(DesignColors.foreground)
                                            
                                            VStack(alignment: .leading, spacing: 8) {
                                                ForEach(practice.benefits, id: \.self) { benefit in
                                                    HStack(alignment: .top, spacing: 8) {
                                                        Text("•")
                                                            .font(DesignTypography.bodyFont())
                                                            .foregroundColor(DesignColors.accent)
                                                        
                                                        Text(benefit)
                                                            .font(DesignTypography.bodyFont())
                                                            .foregroundColor(DesignColors.foreground)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Steps Section
                                BaseCard {
                                    VStack(alignment: .leading, spacing: 16) {
                                        Text("Step-by-Step Guide")
                                            .font(DesignTypography.title3Font(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        VStack(spacing: 16) {
                                            ForEach(Array(practice.steps.enumerated()), id: \.offset) { index, step in
                                                HStack(alignment: .top, spacing: 16) {
                                                    ZStack {
                                                        Circle()
                                                            .fill(DesignColors.accent.opacity(0.2))
                                                            .frame(width: 32, height: 32)
                                                        
                                                        Text("\(index + 1)")
                                                            .font(DesignTypography.footnoteFont(weight: .medium))
                                                            .foregroundColor(DesignColors.accent)
                                                    }
                                                    
                                                    Text(step)
                                                        .font(DesignTypography.bodyFont())
                                                        .foregroundColor(DesignColors.foreground)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                                
                                // Start Practice Button
                                Button(action: {
                                    // TODO: Navigate to guided practice interface
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(DesignColors.accent)
                                        
                                        Text("Start Practice")
                                            .font(DesignTypography.subheadFont(weight: .medium))
                                            .foregroundColor(DesignColors.accent)
                                        
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 16))
                                            .foregroundColor(DesignColors.accent)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(DesignColors.accent.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(DesignColors.accent.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                                }
                                .padding(.horizontal, DesignSpacing.sm)
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 60)
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

