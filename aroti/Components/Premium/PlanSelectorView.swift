//
//  PlanSelectorView.swift
//  Aroti
//
//  Plan selector with 3 pricing options
//

import SwiftUI

struct PlanSelectorView: View {
    @Binding var selectedPlan: PremiumPlan
    
    var body: some View {
        VStack(spacing: DesignSpacing.xs) {
            // Plan cards - all same size, HOT DEAL chip inside weekly card
            HStack(spacing: DesignSpacing.sm) {
                PlanCard(
                    plan: .weekly,
                    isSelected: selectedPlan == .weekly,
                    onSelect: {
                        selectedPlan = .weekly
                        HapticFeedback.impactOccurred(.light)
                    }
                )
                
                PlanCard(
                    plan: .quarterly,
                    isSelected: selectedPlan == .quarterly,
                    onSelect: {
                        selectedPlan = .quarterly
                        HapticFeedback.impactOccurred(.light)
                    }
                )
                
                PlanCard(
                    plan: .yearly,
                    isSelected: selectedPlan == .yearly,
                    onSelect: {
                        selectedPlan = .yearly
                        HapticFeedback.impactOccurred(.light)
                    }
                )
            }
            .padding(.horizontal, DesignSpacing.md)
        }
    }
}

// MARK: - Plan Card

private struct PlanCard: View {
    let plan: PremiumPlan
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .top) {
                // Card content - all cards have identical structure for perfect alignment
                VStack(alignment: .center, spacing: 4) {
                    // Plan name - all start at same level, top-aligned
                    // Fixed height container to ensure prices align regardless of title wrapping
                    VStack {
                        Text(planName)
                            .font(ArotiTextStyle.caption1)
                            .fontWeight(.semibold)
                            .foregroundColor(ArotiColor.textPrimary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .accessibility(identifier: "planName_\(plan)")
                    }
                    .frame(height: 36) // Fixed height to accommodate 2 lines, ensures prices align
                    
                    // Price - single line for all plans, all at same level
                    Text(price)
                        .font(ArotiTextStyle.subhead)
                        .fontWeight(.bold)
                        .foregroundColor(ArotiColor.textPrimary)
                        .lineLimit(1)
                    
                    // Billing cadence - allow wrapping, top-aligned
                    // Fixed height container to ensure "(auto-renewable)" aligns
                    ZStack(alignment: .top) {
                        Color.clear
                        Text(billingCadence)
                            .font(ArotiTextStyle.caption2)
                            .foregroundColor(ArotiColor.textSecondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 28) // Fixed height to accommodate 2 lines, ensures "(auto-renewable)" aligns
                    
                    // Auto-renewable note - smaller font to ensure full visibility
                    Text("(auto-renewable)")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(ArotiColor.textMuted)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                }
                .padding(DesignSpacing.sm)
                .frame(maxWidth: .infinity)
                .frame(height: 145)
                .background(
                    ZStack {
                        // Glass card background
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .fill(Color(red: 23/255, green: 20/255, blue: 31/255, opacity: 0.75))
                        
                        // Liquid glass highlight at top
                        VStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.clear, Color.white.opacity(0.12), Color.clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 1)
                                .opacity(0.8)
                            Spacer()
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: ArotiRadius.md)
                            .stroke(
                                isSelected ? ArotiColor.accent.opacity(0.8) : Color.white.opacity(0.12),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                )
                
                // HOT DEAL chip positioned on top of the card, overlapping the border
                if plan == .weekly {
                    Text("HOT DEAL")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(ArotiColor.accentText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(ArotiColor.accent)
                        )
                        .offset(y: -10) // Position on top edge, overlapping the border
                }
            }
            .shadow(
                color: isSelected ? ArotiColor.accent.opacity(0.3) : Color.black.opacity(0.3),
                radius: isSelected ? 12 : 8,
                x: 0,
                y: isSelected ? 6 : 4
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
    
    private var planName: String {
        switch plan {
        case .weekly:
            return "TRY 3 DAYS FOR FREE"
        case .quarterly:
            return "3 MONTHS"
        case .yearly:
            return "YEARLY"
        case .monthly:
            return "Monthly"
        }
    }
    
    private var price: String {
        switch plan {
        case .weekly:
            return "$6.99"
        case .quarterly:
            return "$34.99"
        case .yearly:
            return "$44.99"
        case .monthly:
            return "$9.99 / month"
        }
    }
    
    private var billingCadence: String {
        switch plan {
        case .weekly:
            return "then weekly"
        case .quarterly:
            return "billed every 3 months"
        case .yearly:
            return "billed yearly"
        case .monthly:
            return "billed monthly"
        }
    }
}
