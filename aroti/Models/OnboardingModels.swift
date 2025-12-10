//
//  OnboardingModels.swift
//  Aroti
//
//  Data models for onboarding flow
//

import Foundation

struct OnboardingData: Codable {
    var birthDateString: String?
    var birthTimeString: String?
    var birthPlace: String?
    var gender: String?
    var relationshipStatus: String?
    var mainIntention: String?
    var emotionalNature: [String]
    var currentFocus: String?
    var challenges: [String]
    var archetype: String?
    var loveFocus: String?
    var careerFocus: String?
    
    init() {
        self.birthDateString = nil
        self.birthTimeString = nil
        self.birthPlace = nil
        self.gender = nil
        self.relationshipStatus = nil
        self.mainIntention = nil
        self.emotionalNature = []
        self.currentFocus = nil
        self.challenges = []
        self.archetype = nil
        self.loveFocus = nil
        self.careerFocus = nil
    }
    
    var birthDate: Date? {
        get {
            guard let dateString = birthDateString else { return nil }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            return formatter.date(from: dateString)
        }
        set {
            if let date = newValue {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate]
                birthDateString = formatter.string(from: date)
            } else {
                birthDateString = nil
            }
        }
    }
    
    var birthTime: Date? {
        get {
            guard let timeString = birthTimeString else { return nil }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withTime]
            return formatter.date(from: timeString)
        }
        set {
            if let date = newValue {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withTime]
                birthTimeString = formatter.string(from: date)
            } else {
                birthTimeString = nil
            }
        }
    }
    
    func getCompiledProfile() -> [String: Any] {
        return [
            "birthDate": birthDateString ?? "",
            "birthTime": birthTimeString ?? "",
            "birthPlace": birthPlace ?? "",
            "gender": gender ?? "",
            "relationshipStatus": relationshipStatus ?? "",
            "mainIntention": mainIntention ?? "",
            "emotionalNature": emotionalNature,
            "currentFocus": currentFocus ?? "",
            "challenges": challenges,
            "archetype": archetype ?? "",
            "loveFocus": loveFocus ?? "",
            "careerFocus": careerFocus ?? "",
            "userProfile": [
                "personal": [
                    "birthDate": birthDateString ?? "",
                    "birthTime": birthTimeString ?? "",
                    "birthPlace": birthPlace ?? "",
                    "gender": gender ?? "",
                    "relationshipStatus": relationshipStatus ?? ""
                ],
                "intentions": [
                    "main": mainIntention ?? "",
                    "emotionalNature": emotionalNature,
                    "currentFocus": currentFocus ?? "",
                    "challenges": challenges,
                    "archetype": archetype ?? "",
                    "loveFocus": loveFocus ?? "",
                    "careerFocus": careerFocus ?? ""
                ]
            ]
        ]
    }
}
