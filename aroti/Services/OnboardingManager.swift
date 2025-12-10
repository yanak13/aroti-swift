//
//  OnboardingManager.swift
//  Aroti
//
//  State management for onboarding flow
//

import Foundation
import SwiftUI

class OnboardingManager: ObservableObject {
    static let shared = OnboardingManager()
    
    @Published var data = OnboardingData()
    @Published var currentScreen: OnboardingScreen = .welcome
    
    private let storageKey = "aroti_onboarding_data"
    
    private init() {
        loadData()
    }
    
    func updateData(_ updates: (inout OnboardingData) -> Void) {
        updates(&data)
        saveData()
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(OnboardingData.self, from: data) {
            self.data = decoded
        }
    }
    
    func resetData() {
        data = OnboardingData()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
    
    func getCompiledProfile() -> [String: Any] {
        return data.getCompiledProfile()
    }
}

enum OnboardingScreen: String, CaseIterable {
    case welcome
    case valueCarousel
    case createAccount
    case birthDate
    case birthTime
    case birthPlace
    case gender
    case relationship
    case intention
    case emotionalNature
    case currentFocus
    case challenges
    case archetype
    case loveFocus
    case careerFocus
    case building
    case ready
}
