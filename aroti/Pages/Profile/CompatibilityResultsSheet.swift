//
//  CompatibilityResultsSheet.swift
//  Aroti
//
//  Sheet for displaying compatibility analysis results
//

import SwiftUI

struct CompatibilityResultsSheet: View {
    @Environment(\.dismiss) var dismiss
    let partnerName: String
    let partnerBirthDate: Date
    let partnerBirthTime: Date?
    let partnerBirthLocation: String
    
    @State private var saved = false
    
    private var isPremium: Bool {
        UserSubscriptionService.shared.isPremium
    }
    
    // Mock compatibility data - in real app, this would come from API
    private let compatibilityData: (
        overallScore: Int,
        emotionalCompatibility: (score: Int, description: String),
        communicationChemistry: (score: Int, description: String),
        longTermPotential: (score: Int, description: String)
    ) = (
        overallScore: 87,
        emotionalCompatibility: (
            score: 92,
            description: "Your emotional worlds align beautifully. You both value deep connection and understand each other's feelings intuitively."
        ),
        communicationChemistry: (
            score: 85,
            description: "You communicate with ease and mutual respect. Your conversations flow naturally, though you may approach topics from different angles."
        ),
        longTermPotential: (
            score: 88,
            description: "Strong foundation for lasting partnership. Your values align and you both prioritize growth and commitment."
        )
    )
    
    private func getScoreColor(_ score: Int) -> Color {
        if score >= 85 {
            return Color(red: 0.2, green: 0.8, blue: 0.4) // emerald
        } else if score >= 70 {
            return Color(red: 1.0, green: 0.65, blue: 0.0) // amber
        } else {
            return Color(red: 1.0, green: 0.3, blue: 0.3) // rose
        }
    }
    
    private func getScoreBg(_ score: Int) -> Color {
        if score >= 85 {
            return Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.2)
        } else if score >= 70 {
            return Color(red: 1.0, green: 0.65, blue: 0.0).opacity(0.2)
        } else {
            return Color(red: 1.0, green: 0.3, blue: 0.3).opacity(0.2)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CelestialBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Compatibility Analysis")
                                .font(DesignTypography.title2Font(weight: .semibold))
                                .foregroundColor(DesignColors.foreground)
                            
                            Text("\(partnerName) • \(formatDate(partnerBirthDate))")
                                .font(DesignTypography.bodyFont())
                                .foregroundColor(DesignColors.mutedForeground)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, DesignSpacing.md)
                        
                        // Overall Score Card
                        BaseCard {
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(DesignColors.accent)
                                    Text("Overall Compatibility")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    Spacer()
                                }
                                
                                VStack(spacing: 8) {
                                    Text("\(compatibilityData.overallScore)%")
                                        .font(.system(size: 56, weight: .bold))
                                        .foregroundColor(getScoreColor(compatibilityData.overallScore))
                                    
                                    Text("Strong connection with excellent potential")
                                        .font(DesignTypography.bodyFont())
                                        .foregroundColor(DesignColors.mutedForeground)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        
                        // Detailed Metrics
                        VStack(spacing: 16) {
                            // Emotional Compatibility
                            CompatibilityMetricCard(
                                icon: "heart.fill",
                                title: "Emotional Compatibility",
                                score: compatibilityData.emotionalCompatibility.score,
                                description: compatibilityData.emotionalCompatibility.description,
                                scoreColor: getScoreColor(compatibilityData.emotionalCompatibility.score),
                                scoreBg: getScoreBg(compatibilityData.emotionalCompatibility.score)
                            )
                            
                            // Communication Chemistry
                            CompatibilityMetricCard(
                                icon: "message.fill",
                                title: "Communication Chemistry",
                                score: compatibilityData.communicationChemistry.score,
                                description: compatibilityData.communicationChemistry.description,
                                scoreColor: getScoreColor(compatibilityData.communicationChemistry.score),
                                scoreBg: getScoreBg(compatibilityData.communicationChemistry.score)
                            )
                            
                            // Long-term Potential
                            CompatibilityMetricCard(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Long-term Potential",
                                score: compatibilityData.longTermPotential.score,
                                description: compatibilityData.longTermPotential.description,
                                scoreColor: getScoreColor(compatibilityData.longTermPotential.score),
                                scoreBg: getScoreBg(compatibilityData.longTermPotential.score)
                            )
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        
                        // Premium Timing Insights
                        if isPremium {
                            RelationshipTimingInsightsView(partnerName: partnerName)
                                .padding(.horizontal, DesignSpacing.sm)
                        }
                        
                        // Save Button
                        BaseCard {
                            Button(action: {
                                // Haptic feedback
                                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                impactFeedback.impactOccurred()
                                
                                // In real app, save to backend
                                saved = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    saved = false
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: saved ? "checkmark.circle.fill" : "square.and.arrow.down")
                                        .font(.system(size: 18))
                                        .foregroundColor(saved ? DesignColors.accent : DesignColors.foreground)
                                    
                                    Text(saved ? "Saved!" : "Save Compatibility Check")
                                        .font(DesignTypography.subheadFont(weight: .medium))
                                        .foregroundColor(DesignColors.foreground)
                                    
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.bottom, DesignSpacing.lg)
                    }
                }
            }
            .navigationTitle("Compatibility")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(ArotiColor.surface.opacity(0.9), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignColors.foreground)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct CompatibilityMetricCard: View {
    let icon: String
    let title: String
    let score: Int
    let description: String
    let scoreColor: Color
    let scoreBg: Color
    
    var body: some View {
        BaseCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    HStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(DesignColors.accent)
                        Text(title)
                            .font(DesignTypography.bodyFont(weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                    }
                    
                    Spacer()
                    
                    Text("\(score)%")
                        .font(DesignTypography.subheadFont(weight: .semibold))
                        .foregroundColor(scoreColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(scoreBg)
                                .overlay(
                                    Capsule()
                                        .stroke(scoreColor.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                
                Text(description)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

