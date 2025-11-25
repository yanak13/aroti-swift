//
//  DailyPracticeCardView.swift
//  Aroti
//
//  Daily Practice cards matching discovery page design
//

import SwiftUI

struct Practice {
    let id: String
    let title: String
    let duration: String
    let mood: String
    let gradient: [Color]
}

struct DailyPracticeCardView: View {
    private let practices = [
        Practice(
            id: "1",
            title: "Morning Intention",
            duration: "5 min",
            mood: "Light Energy",
            gradient: [
                Color(red: 0xFC/255, green: 0xE3/255, blue: 0x8A/255),
                Color(red: 0xF3/255, green: 0x81/255, blue: 0x81/255),
                Color(red: 0xC9/255, green: 0x4B/255, blue: 0x4B/255)
            ]
        ),
        Practice(
            id: "2",
            title: "Breathing Exercise",
            duration: "10 min",
            mood: "Steady Rhythm",
            gradient: [
                Color(red: 0x89/255, green: 0xF7/255, blue: 0xFE/255),
                Color(red: 0x66/255, green: 0xA6/255, blue: 0xFF/255),
                Color(red: 0x4E/255, green: 0x54/255, blue: 0xC8/255)
            ]
        ),
        Practice(
            id: "3",
            title: "Evening Reflection",
            duration: "8 min",
            mood: "Calm Focus",
            gradient: [
                Color(red: 0xF9/255, green: 0xD2/255, blue: 0x9D/255),
                Color(red: 0xF8/255, green: 0xAF/255, blue: 0xA6/255),
                Color(red: 0xC7/255, green: 0x79/255, blue: 0xD0/255)
            ]
        ),
        Practice(
            id: "4",
            title: "Gratitude Practice",
            duration: "3 min",
            mood: "Warm Flow",
            gradient: [
                Color(red: 0xF6/255, green: 0xFB/255, blue: 0xA2/255),
                Color(red: 0x20/255, green: 0xDE/255, blue: 0xD3/255),
                Color(red: 0x0B/255, green: 0xA2/255, blue: 0x9D/255)
            ]
        )
    ]
    
    var body: some View {
        DesignCard(title: "Card / Daily Practice") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(practices, id: \.id) { practice in
                        PracticeCard(
                            title: practice.title,
                            duration: practice.duration,
                            mood: practice.mood,
                            gradientColors: practice.gradient,
                            action: {}
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}
