//
//  EmotionalNatureView.swift
//  Aroti
//
//  Screen 8: Emotional nature (multi-select)
//

import SwiftUI

struct EmotionalNatureView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selected: Set<String> = []
    
    let options = [
        "Sensitive & intuitive",
        "Calm & steady",
        "Passionate & expressive",
        "Overthinking at times",
        "Emotionally private"
    ]
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 24) {
                HStack {
                    OnboardingBackButton()
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("How would you describe your emotional nature?")
                        .font(ArotiTextStyle.title1)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 12) {
                    ForEach(options, id: \.self) { option in
                        MultiSelectOptionCard(
                            title: option,
                            isSelected: selected.contains(option),
                            action: {
                                if selected.contains(option) {
                                    selected.remove(option)
                                } else {
                                    selected.insert(option)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                ArotiButton(
                    kind: .primary,
                    title: "Continue",
                    isDisabled: selected.isEmpty,
                    action: {
                        onboardingManager.updateData { data in
                            data.emotionalNature = Array(selected)
                        }
                        onboardingManager.currentScreen = .currentFocus
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selected = Set(onboardingManager.data.emotionalNature)
        }
    }
}

struct MultiSelectOptionCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(ArotiTextStyle.subhead)
                    .foregroundColor(isSelected ? .white : ArotiColor.textPrimary)
                
                Spacer()
                
                if isSelected {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                        )
                }
            }
            .padding(24)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [ArotiColor.accent, ArotiColor.accent.opacity(0.9)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.clear
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: ArotiRadius.md)
                    .stroke(
                        isSelected ? ArotiColor.accent : ArotiColor.inputBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .cornerRadius(ArotiRadius.md)
        }
        .buttonStyle(.plain)
    }
}
