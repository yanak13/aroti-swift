//
//  TypographySizesView.swift
//  Aroti
//
//  Shows large title through caption sizes.
//

import SwiftUI

struct TypographySizesView: View {
    var body: some View {
        DesignCard(title: "Text Sizes") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Large Title (text-large-title)")
                    .font(ArotiTextStyle.largeTitle)
                    .foregroundColor(ArotiColor.textPrimary)
                Text("Title 1 (text-title-1)")
                    .font(ArotiTextStyle.title1)
                    .foregroundColor(ArotiColor.textPrimary)
                Text("Title 2 (text-title-2)")
                    .font(ArotiTextStyle.title2)
                    .foregroundColor(ArotiColor.textPrimary)
                Text("Title 3 (text-title-3)")
                    .font(ArotiTextStyle.title3)
                    .foregroundColor(ArotiColor.textPrimary)
                Text("Headline (text-headline)")
                    .font(ArotiTextStyle.headline)
                    .foregroundColor(ArotiColor.textPrimary)
                Text("Body (text-body)")
                    .font(ArotiTextStyle.body)
                    .foregroundColor(ArotiColor.textPrimary)
                Text("Callout (text-callout)")
                    .font(ArotiTextStyle.callout)
                    .foregroundColor(ArotiColor.textPrimary)
                Text("Subhead (text-subhead)")
                    .font(ArotiTextStyle.subhead)
                    .foregroundColor(ArotiColor.textPrimary)
                Text("Footnote (text-footnote)")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(ArotiColor.textMuted)
                Text("Caption 1 (text-caption-1)")
                    .font(ArotiTextStyle.caption1)
                    .foregroundColor(DesignColors.mutedForeground)
                Text("Caption 2 (text-caption-2)")
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}
