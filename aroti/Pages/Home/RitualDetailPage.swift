//
//  RitualDetailPage.swift
//  Aroti
//
//  Today's Ritual detail page matching PracticeDetailPage structure
//

import SwiftUI

struct RitualDetailPage: View {
    @Environment(\.dismiss) private var dismiss
    let ritual: Ritual
    
    // Generate ritual-specific hero image
    @ViewBuilder
    private func ritualHeroImage(for ritual: Ritual) -> some View {
        ZStack {
            // Base gradient - varies by ritual type
            Group {
                if ritual.type.lowercased() == "grounding" {
                    LinearGradient(
                        colors: [
                            Color(hue: 220/360, saturation: 0.30, brightness: 0.14),
                            Color(hue: 240/360, saturation: 0.25, brightness: 0.12),
                            Color(hue: 250/360, saturation: 0.20, brightness: 0.10)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else if ritual.type.lowercased() == "intention" || ritual.title.lowercased().contains("morning") {
                    LinearGradient(
                        colors: [
                            Color(hue: 30/360, saturation: 0.35, brightness: 0.18),
                            Color(hue: 25/360, saturation: 0.30, brightness: 0.15),
                            Color(hue: 20/360, saturation: 0.25, brightness: 0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else if ritual.type.lowercased() == "gratitude" || ritual.title.lowercased().contains("gratitude") {
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
            
            // Ritual-specific decorative icon
            Group {
                if ritual.type.lowercased() == "grounding" {
                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.system(size: 64))
                        .foregroundColor(DesignColors.accent.opacity(0.4))
                        .offset(x: 0, y: 0)
                } else if ritual.type.lowercased() == "intention" || ritual.title.lowercased().contains("morning") {
                    Image(systemName: "sunrise.fill")
                        .font(.system(size: 64))
                        .foregroundColor(DesignColors.accent.opacity(0.4))
                        .offset(x: -20, y: 20)
                } else if ritual.type.lowercased() == "gratitude" || ritual.title.lowercased().contains("gratitude") {
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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        BaseHeader(
                            title: ritual.title,
                            subtitle: ritual.type,
                            leftAction: BaseHeader.HeaderAction(
                                icon: Image(systemName: "chevron.left"),
                                label: "Back",
                                action: { dismiss() }
                            ),
                            alignment: .leading
                        )
                        .padding(.top, 0)
                        
                        // Content
                        VStack(spacing: 24) {
                            // Hero Card with Image and Description
                            BaseCard {
                                VStack(alignment: .leading, spacing: 0) {
                                    // Hero Image/Illustration - Inside Card
                                    ritualHeroImage(for: ritual)
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
                                        // Icon, Duration, Type Row
                                        HStack(spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(DesignColors.accent.opacity(0.2))
                                                    .frame(width: 40, height: 40)
                                                
                                                Image(systemName: "clock.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(DesignColors.accent)
                                            }
                                            
                                            Text(ritual.duration)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                            
                                            Text("•")
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                            
                                            Text(ritual.type)
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
                                        Text(ritual.description)
                                            .font(DesignTypography.bodyFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        // Benefits Section (if available)
                                        if let benefits = ritual.benefits, !benefits.isEmpty {
                                            Divider()
                                                .background(Color.white.opacity(0.1))
                                            
                                            VStack(alignment: .leading, spacing: 12) {
                                                Text("Benefits")
                                                    .font(DesignTypography.title3Font(weight: .medium))
                                                    .foregroundColor(DesignColors.foreground)
                                                
                                                VStack(alignment: .leading, spacing: 12) {
                                                    ForEach(benefits, id: \.self) { benefit in
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
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, 16)
                        .padding(.bottom, 120) // Space for fixed button at bottom
                    }
                }
                
                // Fixed button at bottom
                VStack(spacing: 12) {
                    NavigationLink(destination: GuidedPracticeView(practice: convertRitualToPractice(ritual))) {
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
                    
                    // Invisible spacer to match Back button space
                    Spacer()
                        .frame(height: 44)
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.bottom, 48)
            }
            .navigationBarHidden(true)
        }
    }
    
    // Convert Ritual to PracticeDetail for GuidedPracticeView
    private func convertRitualToPractice(_ ritual: Ritual) -> PracticeDetail {
        PracticeDetail(
            id: ritual.id,
            title: ritual.title,
            duration: ritual.duration,
            category: ritual.type,
            description: ritual.description,
            steps: ritual.steps ?? [],
            benefits: ritual.benefits ?? []
        )
    }
}

#Preview {
    NavigationStack {
        RitualDetailPage(
            ritual: Ritual(
                id: "1",
                title: "Grounding Breath",
                description: "A simple breathing practice to center yourself and reconnect with your body.",
                duration: "3 min",
                type: "Grounding",
                intention: "This ritual helps you ground your energy and reconnect with your body after a busy day.",
                steps: ["Find a quiet space and sit comfortably.", "Take three slow, deep breaths.", "Place your hand over your heart and set your intention.", "Repeat the affirmation silently three times."],
                affirmation: "I am grounded, centered, and at peace.",
                benefits: ["Reduces stress and anxiety", "Improves focus", "Regulates nervous system", "Promotes relaxation"]
            )
        )
    }
}

