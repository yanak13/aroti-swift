//
//  BaseHeader.swift
//  Aroti
//
//  Page header with back button and title
//

import SwiftUI

struct BaseHeader: View {
    let title: String
    let subtitle: String?
    let leftAction: HeaderAction?
    let rightAction: HeaderAction?
    let rightView: AnyView?
    let alignment: HorizontalAlignment
    let horizontalPadding: CGFloat
    let titleFont: Font?
    
    struct HeaderAction {
        let icon: Image
        let label: String
        let action: () -> Void
    }
    
    init(
        title: String,
        subtitle: String? = nil,
        leftAction: HeaderAction? = nil,
        rightAction: HeaderAction? = nil,
        rightView: AnyView? = nil,
        alignment: HorizontalAlignment = .center,
        horizontalPadding: CGFloat = DesignSpacing.sm,
        titleFont: Font? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leftAction = leftAction
        self.rightAction = rightAction
        self.rightView = rightView
        self.alignment = alignment
        self.horizontalPadding = horizontalPadding
        self.titleFont = titleFont
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 12) {
                if let leftAction = leftAction {
                    Button(action: leftAction.action) {
                        leftAction.icon
                            .foregroundColor(DesignColors.foreground)
                            .frame(width: 24, height: 24)
                    }
                } else if alignment == .center {
                    Spacer()
                        .frame(width: 24, height: 24)
                }
                
                VStack(alignment: alignment == .leading ? .leading : .center, spacing: 2) {
                    Text(title)
                        .font(titleFont ?? DesignTypography.headlineFont())
                        .foregroundColor(DesignColors.foreground)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : .center)
                
                if alignment == .center {
                    Spacer()
                }
                
                if let rightView = rightView {
                    rightView
                } else if let rightAction = rightAction {
                    Button(action: rightAction.action) {
                        rightAction.icon
                            .foregroundColor(DesignColors.foreground)
                            .frame(width: 24, height: 24)
                    }
                } else if alignment == .center {
                    Spacer()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, DesignSpacing.sm)
    }
}

