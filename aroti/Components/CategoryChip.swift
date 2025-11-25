//
//  CategoryChip.swift
//  Aroti
//
//  Category filter chip component (uses ArotiChip)
//

import SwiftUI

struct CategoryChip: View {
    let label: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        ArotiChip(
            text: label,
            variant: isActive ? .selected : .neutral,
            action: action
        )
    }
}

