//
//  UserSubscriptionService.swift
//  Aroti
//
//  Premium subscription status management (mock)
//

import Foundation

class UserSubscriptionService {
    static let shared = UserSubscriptionService()
    
    private let isPremiumKey = "aroti_is_premium"
    
    private init() {}
    
    var isPremium: Bool {
        get {
            UserDefaults.standard.bool(forKey: isPremiumKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isPremiumKey)
        }
    }
    
    func setPremium(_ premium: Bool) {
        isPremium = premium
    }
}

