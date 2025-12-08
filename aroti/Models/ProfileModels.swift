//
//  ProfileModels.swift
//  Aroti
//
//  Profile-related data models
//

import Foundation

struct Report: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let isMostPopular: Bool
}

enum SavedContentTab: String, CaseIterable {
    case readings = "Readings"
    case practices = "Practices"
}

struct AccountTool {
    let label: String
    let iconName: String
    let path: String
}

