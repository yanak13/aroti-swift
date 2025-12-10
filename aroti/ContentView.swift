//
//  ContentView.swift
//  Aroti
//
//  Created by Yana Kuchma on 22.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showDesignComponents = false
    @StateObject private var onboardingCoordinator = OnboardingCoordinator()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if onboardingCoordinator.isOnboardingComplete {
                    MainTabView()
                        .navigationDestination(isPresented: $showDesignComponents) {
                            DesignComponentsView()
                        }
                        .transition(.opacity)
                } else {
                    OnboardingView(coordinator: onboardingCoordinator)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: onboardingCoordinator.isOnboardingComplete)
        }
        .environmentObject(onboardingCoordinator)
    }
}

#Preview {
    ContentView()
}
