//
//  FormattedTextView.swift
//  Aroti
//
//  Formatted text view with justified alignment, highlights, and better readability
//

import SwiftUI
import UIKit

// PreferenceKey to communicate text height from UITextView to SwiftUI
struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct FormattedTextView: View {
    let text: String
    let font: Font
    let foregroundColor: Color
    let highlightColor: Color
    @State private var textHeight: CGFloat = 0
    
    init(
        text: String,
        font: Font = DesignTypography.bodyFont(),
        foregroundColor: Color = DesignColors.foreground,
        highlightColor: Color = DesignColors.accent
    ) {
        self.text = text
        self.font = font
        self.foregroundColor = foregroundColor
        self.highlightColor = highlightColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            // Use full available width (parent already handles padding)
            let textWidth = max(geometry.size.width, 0)
            
            // Calculate accurate height using layout manager
            let height = calculateAccurateHeight(for: formattedText, width: textWidth)
            
            JustifiedTextRepresentable(
                text: formattedText,
                font: font,
                foregroundColor: foregroundColor,
                width: textWidth
            )
            .frame(width: min(textWidth, geometry.size.width), height: height)
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func calculateAccurateHeight(for attributedText: NSAttributedString, width: CGFloat) -> CGFloat {
        guard width > 0 else { return 20 }
        
        // Create a temporary text container and layout manager to calculate accurate height
        let textContainer = NSTextContainer(size: CGSize(width: width, height: .greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 0
        textContainer.lineBreakMode = .byWordWrapping
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        // Ensure layout is complete
        layoutManager.ensureLayout(for: textContainer)
        
        // Get the actual used rect which includes all text
        let usedRect = layoutManager.usedRect(for: textContainer)
        
        // Also get the glyph range to ensure we capture all text including first and last lines
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
        // Use the maximum height to ensure we capture all text
        let calculatedHeight = max(usedRect.height, boundingRect.height)
        
        // Add text container insets (4pt top + 4pt bottom = 8pt) plus extra padding
        let textContainerInsets: CGFloat = 8 // Top + bottom insets
        let extraPadding: CGFloat = 32 // Increased padding to prevent cutting at beginning and end
        let height = ceil(calculatedHeight) + textContainerInsets + extraPadding
        
        return height
    }
    
    private var formattedText: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let nsString = text as NSString
        
        // Get font size from DesignTypography (default to body size)
        let fontSize = DesignTypography.body
        let baseFont = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        
        // Set paragraph style first
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.paragraphSpacing = 0
        paragraphStyle.paragraphSpacingBefore = 0
        
        // Set base attributes
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(foregroundColor),
            .font: baseFont,
            .paragraphStyle: paragraphStyle
        ]
        attributedString.addAttributes(baseAttributes, range: NSRange(location: 0, length: text.count))
        
        // Keywords to highlight (tarot, astrology, spiritual terms)
        let keywords = [
            "Celtic Cross", "Major Arcana", "Minor Arcana", "tarot", "spread", "cards",
            "astrology", "birth chart", "planets", "zodiac", "horoscope",
            "meditation", "chakra", "energy", "spiritual", "ritual",
            "numerology", "life path", "moon phase", "full moon", "new moon",
            "manifestation", "intention", "gratitude", "reflection",
            "Position 1", "Position 2", "Position 3", "Position 4", "Position 5",
            "Position 6", "Position 7", "Position 8", "Position 9", "Position 10",
            "10-card layout", "current situation", "future path", "past influences", "future outcome",
            "most popular", "each card position", "represents"
        ]
        
        // Find and highlight keywords
        var rangesToHighlight: [NSRange] = []
        
        for keyword in keywords {
            var searchRange = NSRange(location: 0, length: nsString.length)
            var foundRange = nsString.range(of: keyword, options: [.caseInsensitive, .diacriticInsensitive], range: searchRange)
            
            while foundRange.location != NSNotFound {
                rangesToHighlight.append(foundRange)
                let nextLocation = foundRange.location + foundRange.length
                if nextLocation < nsString.length {
                    searchRange = NSRange(location: nextLocation, length: nsString.length - nextLocation)
                    foundRange = nsString.range(of: keyword, options: [.caseInsensitive, .diacriticInsensitive], range: searchRange)
                } else {
                    break
                }
            }
        }
        
        // Apply highlighting
        let boldFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        for range in rangesToHighlight {
            attributedString.addAttribute(.foregroundColor, value: UIColor(highlightColor), range: range)
            attributedString.addAttribute(.font, value: boldFont, range: range)
        }
        
        // Add underline for quoted phrases
        let quotedPattern = "\"[^\"]+\""
        if let regex = try? NSRegularExpression(pattern: quotedPattern, options: []) {
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for match in matches.reversed() {
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
                attributedString.addAttribute(
                    .underlineColor,
                    value: UIColor(highlightColor).withAlphaComponent(0.6),
                    range: match.range
                )
            }
        }
        
        return attributedString
    }
}

// Coordinator to track UITextView
class TextCoordinator: NSObject {
    var textView: UITextView?
}

// UIViewRepresentable for justified text with attributed string
struct JustifiedTextRepresentable: UIViewRepresentable {
    let text: NSAttributedString
    let font: Font
    let foregroundColor: Color
    let width: CGFloat
    
    func makeCoordinator() -> TextCoordinator {
        TextCoordinator()
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0) // Add small top/bottom insets
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.widthTracksTextView = false
        textView.textContainer.size = CGSize(width: width, height: .greatestFiniteMagnitude)
        textView.clipsToBounds = false // Don't clip to allow text to render fully
        
        // Set paragraph style for left alignment with reduced line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.paragraphSpacing = 0
        paragraphStyle.paragraphSpacingBefore = 0
        
        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: mutableText.length))
        
        textView.attributedText = mutableText
        
        context.coordinator.textView = textView
        
        // Calculate initial height after layout
        DispatchQueue.main.async {
            textView.setNeedsLayout()
            textView.layoutIfNeeded()
            textView.invalidateIntrinsicContentSize()
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Update container width if it changed
        uiView.textContainer.size = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        // Ensure text container insets are set
        uiView.textContainerInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        uiView.clipsToBounds = false
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.paragraphSpacing = 0
        paragraphStyle.paragraphSpacingBefore = 0
        
        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: mutableText.length))
        
        uiView.attributedText = mutableText
        
        // Force layout to ensure accurate height calculation
        DispatchQueue.main.async {
            uiView.setNeedsLayout()
            uiView.layoutIfNeeded()
            uiView.invalidateIntrinsicContentSize()
        }
    }
    
    
    static func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        guard let width = proposal.width, width > 0, width != .infinity else {
            return nil
        }
        
        // Set container width
        uiView.textContainer.size = CGSize(width: width, height: .greatestFiniteMagnitude)
        uiView.layoutIfNeeded()
        
        // Calculate height using layout manager's usedRect for accurate measurement
        let layoutManager = uiView.layoutManager
        let textContainer = uiView.textContainer
        layoutManager.ensureLayout(for: textContainer)
        
        // Get the actual used rect which includes all text
        let usedRect = layoutManager.usedRect(for: textContainer)
        let height = ceil(usedRect.height) + 8 // Add small padding
        
        return CGSize(width: width, height: height)
    }
}

// Simple justified text view for cases where we don't need highlighting
struct JustifiedTextView: View {
    let text: String
    let font: Font
    let foregroundColor: Color
    
    init(
        text: String,
        font: Font = DesignTypography.bodyFont(),
        foregroundColor: Color = DesignColors.foreground
    ) {
        self.text = text
        self.font = font
        self.foregroundColor = foregroundColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            textView(for: geometry.size.width)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func textView(for width: CGFloat) -> some View {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 2
        paragraphStyle.lineHeightMultiple = 1.0
        paragraphStyle.paragraphSpacing = 0
        paragraphStyle.paragraphSpacingBefore = 0
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor(foregroundColor),
                .font: UIFont.systemFont(ofSize: DesignTypography.body, weight: .regular),
                .paragraphStyle: paragraphStyle
            ]
        )
        
        // Calculate accurate height using layout manager
        let height = calculateAccurateHeight(for: attributedText, width: width)
        
        return JustifiedTextRepresentable(
            text: attributedText,
            font: font,
            foregroundColor: foregroundColor,
            width: width
        )
        .frame(width: width, height: height)
        .padding(.horizontal, 4) // Padding to prevent clipping at rounded corners
    }
    
    private func calculateAccurateHeight(for attributedText: NSAttributedString, width: CGFloat) -> CGFloat {
        guard width > 0 else { return 20 }
        
        // Create a temporary text container and layout manager to calculate accurate height
        let textContainer = NSTextContainer(size: CGSize(width: width, height: .greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = 0
        textContainer.lineBreakMode = .byWordWrapping
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)
        
        // Ensure layout is complete
        layoutManager.ensureLayout(for: textContainer)
        
        // Get the actual used rect which includes all text
        let usedRect = layoutManager.usedRect(for: textContainer)
        
        // Also get the glyph range to ensure we capture all text including first and last lines
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
        // Use the maximum height to ensure we capture all text
        let calculatedHeight = max(usedRect.height, boundingRect.height)
        
        // Add text container insets (4pt top + 4pt bottom = 8pt) plus extra padding
        let textContainerInsets: CGFloat = 8 // Top + bottom insets
        let extraPadding: CGFloat = 32 // Increased padding to prevent cutting at beginning and end
        let height = ceil(calculatedHeight) + textContainerInsets + extraPadding
        
        return height
    }
}
