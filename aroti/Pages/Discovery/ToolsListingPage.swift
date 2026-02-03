//
//  ToolsListingPage.swift
//  Aroti
//
//  Tools listing page
//

import SwiftUI

struct ToolsListingPage: View {
    @Environment(\.dismiss) private var dismiss
    private let accessControl = AccessControlService.shared
    private let userSubscription = UserSubscriptionService.shared
    
    private var isPremium: Bool {
        userSubscription.isPremium
    }
    
    let tools: [ToolItem] = [
        ToolItem(
            id: "compatibility-report",
            title: "Compatibility Report",
            description: "Astrology compatibility analysis between two people based on their birth charts",
            iconName: "person.2.fill",
            timeEstimate: "2-3 min",
            isPremium: false,
            category: "Relationships"
        )
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            CelestialBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 12) {
                    BaseHeader(
                        title: "Tools",
                        subtitle: "Calculators and interactive tools for astrology, numerology, and more",
                        leftAction: BaseHeader.HeaderAction(
                            icon: Image(systemName: "chevron.left"),
                            label: "Back to Discovery",
                            action: { dismiss() }
                        ),
                        alignment: .leading,
                        horizontalPadding: 0
                    )
                    .padding(.top, DesignSpacing.sm)
                    
                    // Tools List
                    if tools.isEmpty {
                        BaseCard {
                            VStack {
                                Text("No tools available at this time.")
                                    .font(DesignTypography.bodyFont())
                                    .foregroundColor(DesignColors.mutedForeground)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }
                    } else {
                        ForEach(tools) { tool in
                            NavigationLink(destination: CompatibilityToolPage()) {
                                BaseCard {
                                    HStack(spacing: 16) {
                                        // Icon
                                        Image(systemName: tool.iconName)
                                            .font(.system(size: 32))
                                            .foregroundColor(DesignColors.accent)
                                            .frame(width: 60, height: 60)
                                            .background(
                                                Circle()
                                                    .fill(DesignColors.accent.opacity(0.15))
                                            )
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text(tool.title)
                                                    .font(DesignTypography.headlineFont(weight: .medium))
                                                    .foregroundColor(DesignColors.foreground)
                                                
                                                Spacer()
                                                
                                                if tool.isPremium && !isPremium {
                                                    Image(systemName: "lock.fill")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(DesignColors.mutedForeground.opacity(0.6))
                                                }
                                            }
                                            
                                            Text(tool.description)
                                                .font(DesignTypography.footnoteFont())
                                                .foregroundColor(DesignColors.mutedForeground)
                                                .lineLimit(2)
                                            
                                            HStack(spacing: 12) {
                                                if !tool.timeEstimate.isEmpty {
                                                    HStack(spacing: 4) {
                                                        Image(systemName: "clock.fill")
                                                            .font(.system(size: 10))
                                                            .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                                        Text(tool.timeEstimate)
                                                            .font(DesignTypography.caption2Font())
                                                            .foregroundColor(DesignColors.mutedForeground.opacity(0.7))
                                                    }
                                                }
                                                
                                                if tool.isPremium {
                                                    Text("Premium")
                                                        .font(DesignTypography.caption2Font(weight: .medium))
                                                        .foregroundColor(DesignColors.accent)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(
                                                            Capsule()
                                                                .fill(DesignColors.accent.opacity(0.2))
                                                        )
                                                }
                                            }
                                        }
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(DesignColors.mutedForeground.opacity(0.5))
                                    }
                                    .padding()
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, DiscoveryLayout.horizontalPadding)
                .padding(.top, DesignSpacing.md)
                .padding(.bottom, 60)
            }
        }
        .navigationBarBackButtonHidden(true) // Hide default back button to avoid duplicate
    }
}
