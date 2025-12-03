import SwiftUI

struct StickyHeaderBar: View {
    struct HeaderAction {
        let iconName: String
        let accessibilityLabel: String
        let action: () -> Void
    }
    
    private let title: String
    private let subtitle: String?
    private let safeAreaTop: CGFloat
    private let leftAction: HeaderAction?
    private let rightContent: AnyView?
    
    init<RightContent: View>(
        title: String,
        subtitle: String? = nil,
        safeAreaTop: CGFloat,
        leftAction: HeaderAction? = nil,
        @ViewBuilder rightContent: () -> RightContent = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.safeAreaTop = safeAreaTop
        self.leftAction = leftAction
        
        if RightContent.self == EmptyView.self {
            self.rightContent = nil
        } else {
            self.rightContent = AnyView(rightContent())
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                if let leftAction {
                    Button(action: leftAction.action) {
                        Image(systemName: leftAction.iconName)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(DesignColors.foreground)
                            .frame(width: 24, height: 24)
                    }
                    .accessibilityLabel(leftAction.accessibilityLabel)
                }
                
                VStack(alignment: .leading, spacing: subtitle == nil ? 0 : 4) {
                    Text(title)
                        .font(DesignTypography.headlineFont())
                        .foregroundColor(DesignColors.foreground)
                        .lineLimit(1)
                    
                    if let subtitle {
                        Text(subtitle)
                            .font(DesignTypography.footnoteFont())
                            .foregroundColor(DesignColors.mutedForeground)
                            .opacity(0.9)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                if let rightContent {
                    rightContent
                }
            }
            .padding(.horizontal, DesignSpacing.sm)
            .padding(.vertical, DesignSpacing.sm)
            
            Divider()
                .overlay(Color.white.opacity(0.08))
                .padding(.horizontal, -DesignSpacing.sm)
        }
        .background(Color.clear)
    }
    
    static func totalHeight(for safeAreaTop: CGFloat) -> CGFloat {
        safeAreaTop + 44
    }
}

