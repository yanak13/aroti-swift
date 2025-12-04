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
            ),
            "5": PracticeDetail(
                id: "5",
                title: "Body Scan Meditation",
                duration: "15 min",
                category: "Meditation",
                description: "Progressive relaxation technique to release tension and increase awareness.",
                steps: [
                    "Lie down or sit comfortably with your eyes closed.",
                    "Take a few deep breaths to center yourself.",
                    "Bring your attention to your toes and notice any sensations.",
                    "Slowly move your awareness up through your feet, ankles, and calves.",
                    "Continue scanning up through your knees, thighs, and hips.",
                    "Notice your abdomen, chest, and back with gentle awareness.",
                    "Move through your shoulders, arms, hands, and fingers.",
                    "Finally, bring attention to your neck, face, and the crown of your head.",
                    "Take a moment to feel your whole body as one complete unit.",
                    "When ready, slowly open your eyes and return to the present moment."
                ],
                benefits: [
                    "Reduces physical tension",
                    "Increases body awareness",
                    "Promotes deep relaxation",
                    "Improves sleep quality"
                ]
            ),
            "6": PracticeDetail(
                id: "6",
                title: "Loving Kindness",
                duration: "12 min",
                category: "Meditation",
                description: "Cultivate compassion for yourself and others through guided meditation.",
                steps: [
                    "Find a comfortable seated position and close your eyes.",
                    "Take three deep, calming breaths.",
                    "Begin by directing loving kindness toward yourself: 'May I be happy, may I be healthy, may I be safe, may I live with ease.'",
                    "Visualize someone you love and send them the same wishes: 'May you be happy, may you be healthy, may you be safe, may you live with ease.'",
                    "Think of a neutral person and extend the same compassion to them.",
                    "If you're ready, bring to mind someone you have difficulty with and wish them well.",
                    "Finally, extend these wishes to all beings everywhere.",
                    "Take a moment to feel the warmth and compassion in your heart.",
                    "Slowly open your eyes and carry this feeling with you."
                ],
                benefits: [
                    "Increases compassion",
                    "Reduces negative emotions",
                    "Improves relationships",
                    "Enhances emotional well-being"
                ]
            ),
            "7": PracticeDetail(
                id: "7",
                title: "Journaling Session",
                duration: "10 min",
                category: "Reflection",
                description: "Express your thoughts and emotions through guided writing prompts.",
                steps: [
                    "Find a quiet space with a journal and pen.",
                    "Take three deep breaths to center yourself.",
                    "Begin with a gratitude entry: write three things you're grateful for today.",
                    "Reflect on your day: what went well? What challenged you?",
                    "Explore your emotions: how are you feeling right now?",
                    "Write about one thing you learned or discovered about yourself today.",
                    "Set an intention or goal for tomorrow.",
                    "Close by writing one affirmation or positive statement about yourself.",
                    "Take a moment to read back what you've written.",
                    "Close your journal with a sense of completion and clarity."
                ],
                benefits: [
                    "Enhances self-awareness",
                    "Reduces stress and anxiety",
                    "Improves emotional processing",
                    "Tracks personal growth"
                ]
            ),
            "8": PracticeDetail(
                id: "8",
                title: "Energy Clearing",
                duration: "7 min",
                category: "Energy Work",
                description: "Release negative energy and restore your natural energetic balance.",
                steps: [
                    "Stand or sit comfortably with your feet flat on the ground.",
                    "Close your eyes and take three deep, cleansing breaths.",
                    "Visualize a bright white light entering through the crown of your head.",
                    "Feel this light flowing down through your body, clearing any stagnant energy.",
                    "Imagine any negative or heavy energy being released through your feet into the earth.",
                    "Continue breathing and visualizing the light cleansing your entire energy field.",
                    "Focus on areas that feel tense or blocked, allowing the light to flow there.",
                    "When you feel clear, visualize a protective bubble of light surrounding you.",
                    "Take a final deep breath and feel your renewed energy.",
                    "Slowly open your eyes and notice how you feel."
                ],
                benefits: [
                    "Releases energetic blocks",
                    "Restores natural balance",
                    "Increases vitality",
                    "Promotes emotional clarity"
                ]
            ),
            "9": PracticeDetail(
                id: "9",
                title: "Chakra Alignment",
                duration: "20 min",
                category: "Energy Work",
                description: "Balance and align your seven chakras through visualization and breathwork.",
                steps: [
                    "Sit comfortably with your spine straight and eyes closed.",
                    "Take several deep breaths to center yourself.",
                    "Begin at the root chakra: visualize a red spinning wheel at the base of your spine.",
                    "Move to the sacral chakra: see an orange light in your lower abdomen.",
                    "Focus on the solar plexus: visualize a bright yellow light in your stomach area.",
                    "Bring attention to your heart chakra: feel a green light radiating from your chest.",
                    "Move to the throat chakra: see a blue light at your throat.",
                    "Focus on the third eye: visualize an indigo light between your eyebrows.",
                    "Finally, connect with the crown chakra: see a violet or white light above your head.",
                    "Take a moment to feel all seven chakras aligned and balanced.",
                    "Slowly return your awareness to the present moment."
                ],
                benefits: [
                    "Balances energy centers",
                    "Enhances spiritual connection",
                    "Promotes overall well-being",
                    "Increases inner harmony"
                ]
            ),
            "10": PracticeDetail(
                id: "10",
                title: "Mindful Walking",
                duration: "15 min",
                category: "Mindfulness",
                description: "Practice presence and awareness through intentional movement.",
                steps: [
                    "Find a quiet path or space where you can walk slowly.",
                    "Stand still for a moment and take three deep breaths.",
                    "Begin walking at a slower pace than usual.",
                    "Notice the sensation of your feet touching the ground with each step.",
                    "Pay attention to the movement of your legs and the rhythm of your walk.",
                    "Observe your surroundings: what do you see, hear, and feel?",
                    "If your mind wanders, gently bring it back to the sensation of walking.",
                    "Continue walking mindfully, staying present with each step.",
                    "After your walk, pause and take three deep breaths.",
                    "Notice how you feel after this mindful movement practice."
                ],
                benefits: [
                    "Increases present-moment awareness",
                    "Reduces mental chatter",
                    "Improves focus and concentration",
                    "Connects body and mind"
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

