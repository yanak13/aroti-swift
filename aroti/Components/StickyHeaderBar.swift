import SwiftUI

struct StickyHeaderBar: View {
    struct HeaderAction {
        let iconName: String
        let accessibilityLabel: String
        let action: () -> Void
    }
    
    private let title: String
    private let subtitle: String?
    private let leftAction: HeaderAction?
    private let rightContent: AnyView?
    @Binding private var scrollOffset: CGFloat
    
    init<RightContent: View>(
        title: String,
        subtitle: String? = nil,
        scrollOffset: Binding<CGFloat> = .constant(0),
        leftAction: HeaderAction? = nil,
        @ViewBuilder rightContent: () -> RightContent = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self._scrollOffset = scrollOffset
        self.leftAction = leftAction
        
        if RightContent.self == EmptyView.self {
            self.rightContent = nil
        } else {
            self.rightContent = AnyView(rightContent())
        }
    }
    
    private var titleFontSize: CGFloat {
        let minSize: CGFloat = 17  // headlineFont
        let maxSize: CGFloat = 22  // title2Font
        let threshold: CGFloat = 100
        
        let progress = min(max(scrollOffset, 0) / threshold, 1.0)
        return maxSize - (progress * (maxSize - minSize))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header content
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
                    
                    VStack(alignment: .leading, spacing: subtitle == nil ? 0 : 2) {
                        Text(title)
                            .font(.system(size: titleFontSize, weight: .semibold))
                            .foregroundColor(DesignColors.foreground)
                            .lineLimit(1)
                            .animation(.smooth, value: scrollOffset)
                        
                        if let subtitle {
                            Text(subtitle)
                                .font(DesignTypography.footnoteFont())
                                .foregroundColor(DesignColors.mutedForeground)
                                .lineLimit(1)
                                .padding(.bottom, 8)
                        }
                    }
                    
                    Spacer()
                    
                    if let rightContent {
                        rightContent
                    }
                }
                .padding(.horizontal, DesignSpacing.sm)
                .padding(.top, 6)
                .padding(.bottom, 6)
                
                // Thin horizontal line under subtitle
                if subtitle != nil {
                    Divider()
                        .background(Color.white.opacity(0.08))
                        .padding(.horizontal, DesignSpacing.sm)
                        .padding(.top, 4)
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [ArotiColor.bg, Color(hue: 240/360, saturation: 0.30, brightness: 0.09)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .top)
        )
    }
    
    static func totalHeight(for safeAreaTop: CGFloat) -> CGFloat {
        safeAreaTop + 32 // safe area + content height (6 top + ~20 content + 6 bottom = 32)
    }
    
    static func contentHeight() -> CGFloat {
        32 // 6 top + ~20 content + 6 bottom = 32
    }
}

// MARK: - Shared Preference Key
// Public preference key for scroll offset tracking across views
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

