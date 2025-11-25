//
//  SearchInputShowcase.swift
//  Aroti
//

import SwiftUI

struct SearchInputShowcase: View {
    @State private var searchText = ""
    
    var body: some View {
        DesignCard(title: "Search Input") {
            DesignInput(
                text: $searchText,
                placeholder: "Search specialists...",
                leadingIcon: Image(systemName: "magnifyingglass")
            )
        }
    }
}

