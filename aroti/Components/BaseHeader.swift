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
        alignment: HorizontalAlignment = .center
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leftAction = leftAction
        self.rightAction = rightAction
        self.rightView = rightView
        self.alignment = alignment
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
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
                
                if alignment == .center {
                    Spacer()
                }
                
                VStack(alignment: alignment == .leading ? .leading : .center, spacing: 2) {
                    Text(title)
                        .font(DesignTypography.headlineFont())
                        .foregroundColor(DesignColors.foreground)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                    }
                }
                
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
        .padding(.horizontal, DesignSpacing.sm)
        .padding(.vertical, DesignSpacing.sm)
    }
}

