//
//  HeaderTopBarView.swift
//  Aroti
//

import SwiftUI

struct HeaderTopBarView: View {
    var body: some View {
        DesignCard(title: "Header / Top Bar") {
            BaseHeader(
                title: "Page Title",
                leftAction: BaseHeader.HeaderAction(
                    icon: Image(systemName: "chevron.left"),
                    label: "Back",
                    action: {}
                ),
                rightAction: BaseHeader.HeaderAction(
                    icon: Image(systemName: "calendar"),
                    label: "Calendar",
                    action: {}
                )
            )
        }
    }
}

