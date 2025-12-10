//
//  ArchetypeSelectionView.swift
//  Aroti
//
//  Screen 11: Archetype selection
//

import SwiftUI

struct ArchetypeSelectionView: View {
    @ObservedObject var onboardingManager = OnboardingManager.shared
    @State private var selected: String? = nil
    
    let archetypes = [
        Archetype(id: "thinker", name: "The Thinker", icon: "brain.head.profile", color: Color.blue),
        Archetype(id: "empath", name: "The Empath", icon: "heart.fill", color: Color.pink),
        Archetype(id: "visionary", name: "The Visionary", icon: "lightbulb.fill", color: Color.yellow),
        Archetype(id: "leader", name: "The Leader", icon: "crown.fill", color: Color.purple),
        Archetype(id: "free-spirit", name: "The Free Spirit", icon: "sparkles", color: Color.cyan)
    ]
    
    var body: some View {
        ZStack {
            CelestialBackground()
            
            VStack(spacing: 24) {
                HStack {
                    OnboardingBackButton()
                    Spacer()
                    OnboardingSkipButton()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                VStack(spacing: 8) {
                    Text("Which archetype feels closest to you?")
                        .font(ArotiTextStyle.title1)
                        .foregroundColor(ArotiColor.textPrimary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(archetypes) { archetype in
                        ArchetypeCard(
                            archetype: archetype,
                            isSelected: selected == archetype.id,
                            action: {
                                selected = archetype.id
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                ArotiButton(
                    kind: .primary,
                    title: "Continue",
                    isDisabled: selected == nil,
                    action: {
                        onboardingManager.updateData { data in
                            data.archetype = selected
                        }
                        
                        // Conditional routing
                        let mainIntention = onboardingManager.data.mainIntention
                        if mainIntention == "Love & connection" {
                            onboardingManager.currentScreen = .loveFocus
                        } else if mainIntention == "Career & purpose" {
                            onboardingManager.currentScreen = .careerFocus
                        } else if mainIntention == "A mix of everything" {
                            onboardingManager.currentScreen = .loveFocus
                        } else {
                            onboardingManager.currentScreen = .building
                        }
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            selected = onboardingManager.data.archetype
        }
    }
}

struct Archetype: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
}

struct ArchetypeCard: View {
    let archetype: Archetype
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    archetype.color.opacity(0.2),
                                    archetype.color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: archetype.icon)
                        .font(.system(size: 32))
                        .foregroundColor(isSelected ? ArotiColor.textPrimary : ArotiColor.textSecondary)
                }
                
                Text(archetype.name)
                    .font(ArotiTextStyle.headline)
                    .foregroundColor(ArotiColor.textPrimary)
                    .multilineTextAlignment(.center)
                
                if isSelected {
                    Circle()
                        .fill(ArotiColor.accent)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                        )
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [
                                archetype.color.opacity(0.2),
                                archetype.color.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Color.clear
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: ArotiRadius.md)
                    .stroke(
                        isSelected ? archetype.color.opacity(0.4) : ArotiColor.inputBorder,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .cornerRadius(ArotiRadius.md)
        }
        .buttonStyle(.plain)
    }
}
