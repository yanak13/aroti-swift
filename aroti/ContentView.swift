//
//  ContentView.swift
//  Aroti
//
//  Created by Yana Kuchma on 22.11.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var onboardingManager = OnboardingManager.shared
    @State private var showDesignComponents = false
    @State private var showHomePage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showHomePage {
                    MainTabView()
                        .transition(.opacity)
                } else {
                    onboardingView
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showHomePage)
            .animation(.easeInOut(duration: 0.3), value: onboardingManager.currentScreen)
            .navigationDestination(isPresented: $showDesignComponents) {
                DesignComponentsView()
            }
        }
    }
    
    @ViewBuilder
    private var onboardingView: some View {
        switch onboardingManager.currentScreen {
        case .welcome:
            WelcomeView()
        case .valueCarousel:
            ValueCarouselView()
        case .createAccount:
            CreateAccountView()
        case .birthDate:
            BirthDateView()
        case .birthTime:
            BirthTimeView()
        case .birthPlace:
            BirthPlaceView()
        case .gender:
            GenderView()
        case .relationship:
            RelationshipStatusView()
        case .intention:
            MainIntentionView()
        case .emotionalNature:
            EmotionalNatureView()
        case .currentFocus:
            CurrentFocusView()
        case .challenges:
            CurrentChallengesView()
        case .archetype:
            ArchetypeSelectionView()
        case .loveFocus:
            LoveFocusView()
        case .careerFocus:
            CareerFocusView()
        case .building:
            BuildingProfileView()
        case .ready:
            ProfileReadyView(showHomePage: $showHomePage)
        }
    }
}

#Preview {
    ContentView()
}
