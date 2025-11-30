//
//  DailyPracticesListingPage.swift
//  Aroti
//
//  Daily practices listing page
//

import SwiftUI

struct PracticeListItem: Identifiable {
    let id: String
    let title: String
    let duration: String
    let category: String
    let description: String
}

struct DailyPracticesListingPage: View {
    @Environment(\.dismiss) private var dismiss
    
    let practices: [PracticeListItem] = [
        PracticeListItem(id: "1", title: "Morning Intention", duration: "5 min", category: "Mindfulness", description: "Start your day with clarity and purpose by setting meaningful intentions"),
        PracticeListItem(id: "2", title: "Breathing Exercise", duration: "10 min", category: "Meditation", description: "A calming breathing practice that helps regulate your nervous system"),
        PracticeListItem(id: "3", title: "Evening Reflection", duration: "8 min", category: "Reflection", description: "A thoughtful practice to review your day and prepare for restful sleep"),
        PracticeListItem(id: "4", title: "Gratitude Practice", duration: "3 min", category: "Mindfulness", description: "A quick but powerful practice to shift your perspective and cultivate appreciation"),
        PracticeListItem(id: "5", title: "Body Scan Meditation", duration: "15 min", category: "Meditation", description: "Progressive relaxation technique to release tension and increase awareness"),
        PracticeListItem(id: "6", title: "Loving Kindness", duration: "12 min", category: "Meditation", description: "Cultivate compassion for yourself and others through guided meditation"),
        PracticeListItem(id: "7", title: "Journaling Session", duration: "10 min", category: "Reflection", description: "Express your thoughts and emotions through guided writing prompts"),
        PracticeListItem(id: "8", title: "Energy Clearing", duration: "7 min", category: "Energy Work", description: "Release negative energy and restore your natural energetic balance"),
        PracticeListItem(id: "9", title: "Chakra Alignment", duration: "20 min", category: "Energy Work", description: "Balance and align your seven chakras through visualization and breathwork"),
        PracticeListItem(id: "10", title: "Mindful Walking", duration: "15 min", category: "Mindfulness", description: "Practice presence and awareness through intentional movement")
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    BaseHeader(
                        title: "Daily Practices",
                        subtitle: "Morning routines & evening rituals",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back to Discovery",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, 0)
                    
                    ForEach(practices) { practice in
                        NavigationLink(destination: PracticeDetailPage(practiceId: practice.id)) {
                            BaseCard(variant: .interactive, action: {}) {
                                HStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(DesignColors.accent.opacity(0.2))
                                            .frame(width: 48, height: 48)
                                        
                                        Image(systemName: "clock.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(DesignColors.accent)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(practice.title)
                                            .font(DesignTypography.headlineFont(weight: .medium))
                                            .foregroundColor(DesignColors.foreground)
                                        
                                        HStack(spacing: 8) {
                                            Text(practice.duration)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                            
                                            Text("•")
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                            
                                            Text(practice.category)
                                                .font(DesignTypography.caption2Font(weight: .medium))
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
                                        
                                        Text(practice.description)
                                            .font(DesignTypography.footnoteFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                            .lineLimit(2)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16))
                                        .foregroundColor(DesignColors.mutedForeground)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(CardTapButtonStyle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 12)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        DailyPracticesListingPage()
    }
}

