//
//  ForYouListingPage.swift
//  Aroti
//
//  For You listing page with personalized recommendations
//

import SwiftUI

struct ForYouListingItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let tag: String
    let category: String
}

struct ForYouListingPage: View {
    @Environment(\.dismiss) private var dismiss
    
    let forYouItems: [ForYouListingItem] = [
        ForYouListingItem(id: "1", title: "Celtic Cross Reading", subtitle: "A comprehensive 10-card spread for deep insights", tag: "Daily Pick", category: "Tarot"),
        ForYouListingItem(id: "2", title: "Love & Relationships", subtitle: "Explore connections and understand dynamics", tag: "Recommended", category: "Astrology"),
        ForYouListingItem(id: "3", title: "Moon Phase Meditation", subtitle: "Align with lunar cycles for inner peace", tag: "Trending", category: "Moon Phases"),
        ForYouListingItem(id: "4", title: "Birth Chart Basics", subtitle: "Discover your cosmic blueprint", tag: "For You", category: "Astrology"),
        ForYouListingItem(id: "5", title: "Three Card Spread", subtitle: "Quick insights for daily guidance", tag: "Recommended", category: "Tarot"),
        ForYouListingItem(id: "6", title: "Chakra Balancing Guide", subtitle: "Align your energy centers for harmony", tag: "Trending", category: "Energy Work"),
        ForYouListingItem(id: "7", title: "Numerology Life Path", subtitle: "Discover your life path number and its meaning", tag: "For You", category: "Numerology"),
        ForYouListingItem(id: "8", title: "Crystal Healing Basics", subtitle: "Learn to use crystals for energy healing", tag: "Recommended", category: "Crystals"),
        ForYouListingItem(id: "9", title: "Morning Intention Setting", subtitle: "Start your day with purpose and clarity", tag: "Daily Pick", category: "Meditation"),
        ForYouListingItem(id: "10", title: "Past Life Regression", subtitle: "Explore your soul's journey through time", tag: "Trending", category: "Spiritual Guides"),
        ForYouListingItem(id: "11", title: "Angel Number Meanings", subtitle: "Decode messages from the divine realm", tag: "For You", category: "Angel Numbers"),
        ForYouListingItem(id: "12", title: "Manifestation Rituals", subtitle: "Powerful practices to manifest your desires", tag: "Recommended", category: "Manifestation")
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    BaseHeader(
                        title: "For You",
                        subtitle: "Personalized recommendations",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back to Discovery",
                            action: { dismiss() }
                        ),
                        alignment: .leading
                    )
                    .padding(.top, 12)
                    
                    ForEach(forYouItems) { item in
                        NavigationLink(
                            destination: ForYouDetailPage(
                                title: item.title,
                                subtitle: item.subtitle,
                                tag: item.tag,
                                category: item.category
                            )
                        ) {
                            BaseCard(variant: .interactive, action: {}) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(item.tag)
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
                                    
                                    Text(item.title)
                                        .font(DesignTypography.headlineFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                        .lineLimit(2)
                                    
                                    Text(item.subtitle)
                                        .font(DesignTypography.subheadFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .lineLimit(2)
                                    
                                    Text(item.category)
                                        .font(DesignTypography.caption2Font())
                                        .foregroundColor(DesignColors.mutedForeground)
                                    
                                    HStack {
                                        Text("Tap to explore")
                                            .font(DesignTypography.subheadFont())
                                            .foregroundColor(DesignColors.mutedForeground)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 16))
                                            .foregroundColor(DesignColors.mutedForeground)
                                    }
                                    .padding(.top, 8)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(CardTapButtonStyle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 16)
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ForYouListingPage()
    }
}

