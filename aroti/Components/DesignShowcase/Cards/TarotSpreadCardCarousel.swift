//
//  TarotSpreadCardCarousel.swift
//  Aroti
//
//  Tarot Spread cards matching discovery page design
//

import SwiftUI

struct TarotSpread {
    let id: String
    let name: String
    let cardCount: Int
}

struct TarotSpreadCardCarousel: View {
    private let spreads = [
        TarotSpread(id: "celtic-cross", name: "Celtic Cross", cardCount: 10),
        TarotSpread(id: "three-card", name: "Three Card Spread", cardCount: 3),
        TarotSpread(id: "past-present-future", name: "Past Present Future", cardCount: 3),
        TarotSpread(id: "relationship", name: "Relationship Spread", cardCount: 7),
        TarotSpread(id: "moon-guidance", name: "Moon Guidance", cardCount: 5)
    ]
    
    var body: some View {
        DesignCard(title: "Card / Tarot Spread Card") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(spreads, id: \.id) { spread in
                        TarotSpreadCard(
                            name: spread.name,
                            cardCount: spread.cardCount,
                            action: {}
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}
