//
//  PracticeStartButton.swift
//  Aroti
//
//  Button for starting practice with access control
//

import SwiftUI

struct PracticeStartButtonView: View {
    let practice: PracticeDetail
    @State private var showUnlockModal = false
    @State private var showPracticeView = false
    
    private var accessInfo: (allowed: Bool, cost: Int?, reason: String?) {
        AccessControlService.shared.canAccessDailyPractice(practiceId: practice.id)
    }
    
    private var balance: PointsBalance {
        PointsService.shared.getBalance()
    }
    
    var body: some View {
        Group {
            if accessInfo.allowed {
                Button(action: {
                    handleStartPractice()
                }) {
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
                .sheet(isPresented: $showPracticeView) {
                    NavigationStack {
                        GuidedPracticeView(practice: practice)
                    }
                }
            } else {
                Button(action: {
                    showUnlockModal = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                        Text("Unlock Today - \(accessInfo.cost ?? 10) points")
                            .font(DesignTypography.subheadFont(weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(DesignColors.accent)
                            .shadow(color: DesignColors.accent.opacity(0.35), radius: 10, x: 0, y: 6)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .sheet(isPresented: $showUnlockModal) {
            PointsSpendModal(
                isPresented: $showUnlockModal,
                cost: accessInfo.cost ?? 10,
                currentBalance: balance.totalPoints,
                title: "Unlock Practice",
                message: accessInfo.reason ?? "Unlock this practice for today?",
                onConfirm: {
                    handleUnlockPractice()
                },
                onUpgrade: {
                    // Navigate to premium upgrade
                }
            )
        }
    }
    
    private func handleStartPractice() {
        // Record practice usage
        AccessControlService.shared.recordDailyPractice()
        showPracticeView = true
    }
    
    private func handleUnlockPractice() {
        guard let cost = accessInfo.cost else { return }
        
        let result = PointsService.shared.spendPoints(event: "unlock_practice", cost: cost)
        
        if result.success {
            AccessControlService.shared.recordDailyPractice()
            showPracticeView = true
        }
    }
}

