//
//  SortDropdownShowcase.swift
//  Aroti
//

import SwiftUI

struct SortDropdownShowcase: View {
    var body: some View {
        DesignCard(title: "SortDropdown") {
            Menu {
                Button("Newest", action: {})
                Button("Oldest", action: {})
                Button("A-Z", action: {})
                Button("Z-A", action: {})
            } label: {
                HStack {
                    Text("Sort")
                        .font(DesignTypography.subheadFont(weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                }
                .foregroundColor(DesignColors.foreground)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: DesignRadius.secondary)
                        .fill(DesignColors.glassPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignRadius.secondary)
                                .stroke(DesignColors.glassBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
}

