//
//  ContentView.swift
//  Aroti
//
//  Created by Yana Kuchma on 22.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showDesignComponents = false
    @State private var showHomePage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showHomePage {
                    MainTabView()
                        .transition(.opacity)
                } else {
                    WelcomeView(showHomePage: $showHomePage)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showHomePage)
            .navigationDestination(isPresented: $showDesignComponents) {
                DesignComponentsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
