//
//  BlueprintModels.swift
//  Aroti
//
//  Data models for user blueprint information
//

import Foundation

// MARK: - Main Blueprint Container
struct UserBlueprint: Codable {
    let astrology: AstrologyBlueprint
    let numerology: NumerologyBlueprint
    let chineseZodiac: ChineseZodiacBlueprint
}

// MARK: - Astrology Blueprint
struct AstrologyBlueprint: Codable {
    let sun: PlanetaryPlacement
    let moon: PlanetaryPlacement
    let rising: PlanetaryPlacement
    let venus: PlanetaryPlacement?
    let mars: PlanetaryPlacement?
    let mercury: PlanetaryPlacement?
    let jupiter: PlanetaryPlacement?
    let saturn: PlanetaryPlacement?
    let uranus: PlanetaryPlacement?
    let neptune: PlanetaryPlacement?
    let pluto: PlanetaryPlacement?
    
    var essentialPlacements: [PlanetaryPlacement] {
        [sun, moon, rising]
    }
    
    var allPlacements: [PlanetaryPlacement] {
        var placements = [sun, moon, rising]
        if let venus = venus { placements.append(venus) }
        if let mars = mars { placements.append(mars) }
        if let mercury = mercury { placements.append(mercury) }
        if let jupiter = jupiter { placements.append(jupiter) }
        if let saturn = saturn { placements.append(saturn) }
        if let uranus = uranus { placements.append(uranus) }
        if let neptune = neptune { placements.append(neptune) }
        if let pluto = pluto { placements.append(pluto) }
        return placements
    }
}

struct PlanetaryPlacement: Codable, Identifiable {
    let planet: String
    let sign: String
    let description: String
    let meaning: String
    let house: Int?
    
    var id: String {
        "\(planet)-\(sign)"
    }
    
    var title: String {
        "\(planet) — \(sign)"
    }
}

// MARK: - Numerology Blueprint
struct NumerologyBlueprint: Codable {
    let lifePath: NumerologyNumber
    let destiny: NumerologyNumber?
    let expression: NumerologyNumber?
    let soulUrge: NumerologyNumber?
    let birthday: NumerologyNumber?
    let karmicLessons: [Int]?
    
    var essentialNumbers: [NumerologyNumber] {
        [lifePath]
    }
    
    var allNumbers: [NumerologyNumber] {
        var numbers = [lifePath]
        if let destiny = destiny { numbers.append(destiny) }
        if let expression = expression { numbers.append(expression) }
        if let soulUrge = soulUrge { numbers.append(soulUrge) }
        if let birthday = birthday { numbers.append(birthday) }
        return numbers
    }
}

struct NumerologyNumber: Codable, Identifiable {
    let number: Int
    let name: String
    let description: String
    let meaning: String
    let traits: [String]
    
    var id: String {
        "\(name)-\(number)"
    }
    
    var title: String {
        "\(name) — \(number)"
    }
}

// MARK: - Chinese Zodiac Blueprint
struct ChineseZodiacBlueprint: Codable {
    let animal: String
    let element: String
    let year: Int
    let description: String
    let traits: [String]
    let compatibility: [String]
    let luckyNumbers: [Int]
    let luckyColors: [String]
    
    var fullSign: String {
        "\(element) \(animal)"
    }
}

