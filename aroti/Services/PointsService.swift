//
//  PointsService.swift
//  Aroti
//
//  Mock API service for points earning/spending
//

import Foundation

class PointsService {
    static let shared = PointsService()
    
    private let balanceKey = "aroti_points_balance"
    private let lifetimeKey = "aroti_lifetime_points"
    private let transactionsKey = "aroti_points_transactions"
    
    private init() {
        // Initialize with default values if not set
        if UserDefaults.standard.object(forKey: balanceKey) == nil {
            UserDefaults.standard.set(0, forKey: balanceKey)
        }
        if UserDefaults.standard.object(forKey: lifetimeKey) == nil {
            UserDefaults.standard.set(0, forKey: lifetimeKey)
        }
    }
    
    var balance: PointsBalance {
        PointsBalance(
            totalPoints: UserDefaults.standard.integer(forKey: balanceKey),
            lifetimePoints: UserDefaults.standard.integer(forKey: lifetimeKey)
        )
    }
    
    func earnPoints(event: String, points: Int) -> PointsEarnResult {
        let currentBalance = UserDefaults.standard.integer(forKey: balanceKey)
        let currentLifetime = UserDefaults.standard.integer(forKey: lifetimeKey)
        
        let newBalance = currentBalance + points
        let newLifetime = currentLifetime + points
        
        UserDefaults.standard.set(newBalance, forKey: balanceKey)
        UserDefaults.standard.set(newLifetime, forKey: lifetimeKey)
        
        // Save transaction
        var transactions = loadTransactions()
        transactions.append(PointsTransaction(event: event, points: points, timestamp: Date()))
        saveTransactions(transactions)
        
        return PointsEarnResult(
            success: true,
            newBalance: newBalance,
            newLifetimePoints: newLifetime,
            message: "Earned \(points) points!"
        )
    }
    
    func spendPoints(event: String, cost: Int) -> PointsSpendResult {
        let currentBalance = UserDefaults.standard.integer(forKey: balanceKey)
        
        guard currentBalance >= cost else {
            return PointsSpendResult(
                success: false,
                newBalance: currentBalance,
                message: "Not enough points. You need \(cost - currentBalance) more points."
            )
        }
        
        let newBalance = currentBalance - cost
        
        UserDefaults.standard.set(newBalance, forKey: balanceKey)
        
        // Save transaction
        var transactions = loadTransactions()
        transactions.append(PointsTransaction(event: event, points: -cost, timestamp: Date()))
        saveTransactions(transactions)
        
        return PointsSpendResult(
            success: true,
            newBalance: newBalance,
            message: "Spent \(cost) points"
        )
    }
    
    func getBalance() -> PointsBalance {
        balance
    }
    
    // MARK: - Testing Helpers
    
    /// Add points for testing
    func addPointsForTesting(_ points: Int) {
        let currentBalance = UserDefaults.standard.integer(forKey: balanceKey)
        let currentLifetime = UserDefaults.standard.integer(forKey: lifetimeKey)
        
        UserDefaults.standard.set(currentBalance + points, forKey: balanceKey)
        UserDefaults.standard.set(currentLifetime + points, forKey: lifetimeKey)
    }
    
    /// Set points balance directly for testing
    func setPointsForTesting(_ points: Int) {
        let currentLifetime = UserDefaults.standard.integer(forKey: lifetimeKey)
        let difference = points - UserDefaults.standard.integer(forKey: balanceKey)
        
        UserDefaults.standard.set(points, forKey: balanceKey)
        if difference > 0 {
            UserDefaults.standard.set(currentLifetime + difference, forKey: lifetimeKey)
        }
    }
    
    /// Set both balance and lifetime points for testing (useful for level testing)
    func setBalanceAndLifetimeForTesting(balance: Int, lifetime: Int) {
        UserDefaults.standard.set(balance, forKey: balanceKey)
        UserDefaults.standard.set(lifetime, forKey: lifetimeKey)
    }
    
    /// Reset to Level 5 for development testing
    func resetToLevel5ForTesting() {
        // Level 5 starts at 3,750, set to 5,000 for mid-level progress
        UserDefaults.standard.set(5000, forKey: balanceKey)
        UserDefaults.standard.set(5000, forKey: lifetimeKey)
    }
    
    private func loadTransactions() -> [PointsTransaction] {
        guard let data = UserDefaults.standard.data(forKey: transactionsKey),
              let transactions = try? JSONDecoder().decode([PointsTransaction].self, from: data) else {
            return []
        }
        return transactions
    }
    
    private func saveTransactions(_ transactions: [PointsTransaction]) {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
}

