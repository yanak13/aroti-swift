//
//  GuidedPracticeView.swift
//  Aroti
//
//  Guided step-by-step practice experience
//

import SwiftUI

enum PracticeScreen {
    case transition
    case step(Int)
    case completion
}

struct GuidedPracticeView: View {
    @Environment(\.dismiss) private var dismiss
    let practice: PracticeDetail
    
    @State private var currentScreen: PracticeScreen = .transition
    @State private var transitionOpacity: Double = 0
    
    var body: some View {
        ZStack {
            CelestialBackground()
                .ignoresSafeArea()
            
            Group {
                switch currentScreen {
                case .transition:
                    PracticeTransitionView(
                        practiceTitle: practice.title,
                        onComplete: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentScreen = .step(0)
                            }
                        }
                    )
                    .opacity(transitionOpacity)
                    
                case .step(let index):
                    PracticeStepView(
                        practice: practice,
                        currentStepIndex: index,
                        totalSteps: practice.steps.count,
                        onNext: {
                            if index < practice.steps.count - 1 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentScreen = .step(index + 1)
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentScreen = .completion
                                }
                            }
                        },
                        onBack: {
                            if index > 0 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentScreen = .step(index - 1)
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentScreen = .transition
                                }
                            }
                        }
                    )
                    
                case .completion:
                    PracticeCompletionView(
                        practiceTitle: practice.title,
                        onReturn: {
                            dismiss()
                        }
                    )
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Fade in transition screen
            withAnimation(.easeInOut(duration: 0.5)) {
                transitionOpacity = 1
            }
        }
    }
}

