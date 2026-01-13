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
    @StateObject private var authController = AuthController.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !authController.isAuthenticated {
                    // Show login if not authenticated
                    LoginView()
                        .transition(.opacity)
                } else if onboardingCoordinator.isOnboardingComplete {
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
            .animation(.easeInOut(duration: 0.3), value: authController.isAuthenticated)
        }
        .environmentObject(onboardingCoordinator)
    }
}

#Preview {
    ContentView()
}
