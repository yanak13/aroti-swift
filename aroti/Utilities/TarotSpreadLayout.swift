//
//  TarotSpreadLayout.swift
//  Aroti
//
//  Utility to calculate card positions for different tarot spread layouts
//

import SwiftUI
import Foundation

struct CardPosition {
    let point: CGPoint
    let rotation: Angle
}

enum TarotSpreadLayout {
    static let cardWidth: CGFloat = 180
    static let cardHeight: CGFloat = 300
    static let cardSpacing: CGFloat = 40
    
    // MARK: - Celtic Cross Layout
    // Card 1: Center (horizontal)
    // Card 2: Crossed over Card 1 (vertical, rotated 90°)
    // Cards 3-6: Around the cross (below, left, above, right)
    // Cards 7-10: Staff formation (vertical line to the right)
    static func calculateCelticCrossLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        var positions: [CardPosition] = []
        
        // Card 1: Center (horizontal)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 2: Crossed over Card 1 (vertical, rotated 90°)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(90)
        ))
        
        // Card 3: Below the cross (Distant Past)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY + cardHeight + cardSpacing),
            rotation: .degrees(0)
        ))
        
        // Card 4: Left of the cross (Recent Past)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - cardWidth - cardSpacing, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 5: Above the cross (Possible Future)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY - cardHeight - cardSpacing),
            rotation: .degrees(0)
        ))
        
        // Card 6: Right of the cross (Near Future)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + cardWidth + cardSpacing, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Staff formation (Cards 7-10): Vertical line to the right
        let staffX = centerX + (cardWidth + cardSpacing) * 2.5
        let staffStartY = centerY - (cardHeight * 1.5 + cardSpacing * 1.5)
        
        // Card 7: Your Approach (bottom of staff)
        positions.append(CardPosition(
            point: CGPoint(x: staffX, y: staffStartY + (cardHeight + cardSpacing) * 3),
            rotation: .degrees(0)
        ))
        
        // Card 8: External Influences
        positions.append(CardPosition(
            point: CGPoint(x: staffX, y: staffStartY + (cardHeight + cardSpacing) * 2),
            rotation: .degrees(0)
        ))
        
        // Card 9: Hopes and Fears
        positions.append(CardPosition(
            point: CGPoint(x: staffX, y: staffStartY + (cardHeight + cardSpacing)),
            rotation: .degrees(0)
        ))
        
        // Card 10: Outcome (top of staff)
        positions.append(CardPosition(
            point: CGPoint(x: staffX, y: staffStartY),
            rotation: .degrees(0)
        ))
        
        return positions
    }
    
    // MARK: - Three Card Layout
    // Horizontal line: Past (left), Present (center), Future (right)
    static func calculateThreeCardLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        var positions: [CardPosition] = []
        
        // Card 1: Past (left)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - cardWidth - cardSpacing, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 2: Present (center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 3: Future (right)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + cardWidth + cardSpacing, y: centerY),
            rotation: .degrees(0)
        ))
        
        return positions
    }
    
    // MARK: - Past Present Future Layout
    // Similar to three card, but can have slight variations
    static func calculatePastPresentFutureLayout(canvasSize: CGSize) -> [CardPosition] {
        // For now, same as three card layout
        return calculateThreeCardLayout(canvasSize: canvasSize)
    }
    
    // MARK: - Moon Guidance Layout
    // Circular or vertical arrangement representing moon phases
    static func calculateMoonGuidanceLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        var positions: [CardPosition] = []
        
        // Vertical arrangement with slight arc
        let verticalSpacing = cardHeight + cardSpacing
        let arcOffset = cardWidth * 0.3
        
        // Card 1: Waning Moon (bottom left)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - arcOffset, y: centerY + verticalSpacing * 1.5),
            rotation: .degrees(0)
        ))
        
        // Card 2: New Moon (left)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - arcOffset * 1.5, y: centerY + verticalSpacing * 0.5),
            rotation: .degrees(0)
        ))
        
        // Card 3: Waxing Moon (center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 4: Full Moon (right)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + arcOffset * 1.5, y: centerY - verticalSpacing * 0.5),
            rotation: .degrees(0)
        ))
        
        // Card 5: Overall Guidance (top center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY - verticalSpacing * 1.5),
            rotation: .degrees(0)
        ))
        
        return positions
    }
    
    // MARK: - Relationship Layout (7 cards)
    // You, Them, Connection in center, with Past, Present, Challenges, Future around
    static func calculateRelationshipLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        var positions: [CardPosition] = []
        
        // Card 1: You (left)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - cardWidth - cardSpacing, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 2: Them (right)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + cardWidth + cardSpacing, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 3: Connection (center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 4: Past (below)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY + cardHeight + cardSpacing),
            rotation: .degrees(0)
        ))
        
        // Card 5: Present (above)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY - cardHeight - cardSpacing),
            rotation: .degrees(0)
        ))
        
        // Card 6: Challenges (left of center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - (cardWidth + cardSpacing) * 0.7, y: centerY + (cardHeight + cardSpacing) * 0.7),
            rotation: .degrees(0)
        ))
        
        // Card 7: Future (right of center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + (cardWidth + cardSpacing) * 0.7, y: centerY - (cardHeight + cardSpacing) * 0.7),
            rotation: .degrees(0)
        ))
        
        return positions
    }
    
    // MARK: - Career Path Layout (6 cards)
    // Center card with surrounding cards
    static func calculateCareerPathLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        var positions: [CardPosition] = []
        
        // Card 1: Current Role (center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 2: Skills & Strengths (left)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - cardWidth - cardSpacing, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 3: Opportunities (right)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + cardWidth + cardSpacing, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 4: Challenges (below)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY + cardHeight + cardSpacing),
            rotation: .degrees(0)
        ))
        
        // Card 5: Advice (above)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY - cardHeight - cardSpacing),
            rotation: .degrees(0)
        ))
        
        // Card 6: Outcome (top)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY - (cardHeight + cardSpacing) * 2),
            rotation: .degrees(0)
        ))
        
        return positions
    }
    
    // MARK: - Wheel of Fortune Layout (8 cards)
    // Circular pattern representing the wheel
    static func calculateWheelOfFortuneLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        let radius = cardWidth * 1.5
        
        var positions: [CardPosition] = []
        
        // Card 1: Center
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Cards 2-8 arranged in a circle
        let angles: [Double] = [90, 45, 0, -45, -90, -135, -180] // Starting from top, going clockwise
        
        for (_, angle) in angles.enumerated() {
            let radians = angle * .pi / 180
            let x = centerX + radius * cos(radians)
            let y = centerY - radius * sin(radians) // Negative because y increases downward
            positions.append(CardPosition(
                point: CGPoint(x: x, y: y),
                rotation: .degrees(0)
            ))
        }
        
        return positions
    }
    
    // MARK: - Horseshoe Layout (7 cards)
    // Arc pattern like a horseshoe
    static func calculateHorseshoeLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        var positions: [CardPosition] = []
        
        // Card 1: Past (far left)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - (cardWidth + cardSpacing) * 1.5, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 2: Present (left of center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX - (cardWidth + cardSpacing) * 0.5, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 3: Near Future (center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 4: Distant Future (right of center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + (cardWidth + cardSpacing) * 0.5, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Card 5: Your Approach (above center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY - cardHeight - cardSpacing),
            rotation: .degrees(0)
        ))
        
        // Card 6: External Influences (below center)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY + cardHeight + cardSpacing),
            rotation: .degrees(0)
        ))
        
        // Card 7: Outcome (far right)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + (cardWidth + cardSpacing) * 1.5, y: centerY),
            rotation: .degrees(0)
        ))
        
        return positions
    }
    
    // MARK: - One Card Layout (1 card)
    // Simple center placement
    static func calculateOneCardLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        return [
            CardPosition(
                point: CGPoint(x: centerX, y: centerY),
                rotation: .degrees(0)
            )
        ]
    }
    
    // MARK: - Pentagram Layout (5 cards)
    // Star pattern with five points
    static func calculatePentagramLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        let radius = cardWidth * 1.2
        
        var positions: [CardPosition] = []
        
        // Pentagram points: top, top-right, bottom-right, bottom-left, top-left
        let angles: [Double] = [90, 18, -54, -126, 162] // Top, then going clockwise
        
        for angle in angles {
            let radians = angle * .pi / 180
            let x = centerX + radius * cos(radians)
            let y = centerY - radius * sin(radians) // Negative because y increases downward
            positions.append(CardPosition(
                point: CGPoint(x: x, y: y),
                rotation: .degrees(0)
            ))
        }
        
        return positions
    }
    
    // MARK: - Tree of Life Layout (10 cards)
    // Tree-like structure with sephiroth positions
    static func calculateTreeOfLifeLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        var positions: [CardPosition] = []
        
        let verticalSpacing = cardHeight + cardSpacing
        let horizontalSpacing = cardWidth + cardSpacing
        
        // Top row: Kether (1)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY - verticalSpacing * 2.5),
            rotation: .degrees(0)
        ))
        
        // Second row: Chokmah (2), Binah (3)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + horizontalSpacing * 0.8, y: centerY - verticalSpacing * 1.8),
            rotation: .degrees(0)
        ))
        positions.append(CardPosition(
            point: CGPoint(x: centerX - horizontalSpacing * 0.8, y: centerY - verticalSpacing * 1.8),
            rotation: .degrees(0)
        ))
        
        // Third row: Chesed (4), Geburah (5)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + horizontalSpacing * 0.8, y: centerY - verticalSpacing * 0.9),
            rotation: .degrees(0)
        ))
        positions.append(CardPosition(
            point: CGPoint(x: centerX - horizontalSpacing * 0.8, y: centerY - verticalSpacing * 0.9),
            rotation: .degrees(0)
        ))
        
        // Center: Tiphareth (6)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Fourth row: Netzach (7), Hod (8)
        positions.append(CardPosition(
            point: CGPoint(x: centerX + horizontalSpacing * 0.8, y: centerY + verticalSpacing * 0.9),
            rotation: .degrees(0)
        ))
        positions.append(CardPosition(
            point: CGPoint(x: centerX - horizontalSpacing * 0.8, y: centerY + verticalSpacing * 0.9),
            rotation: .degrees(0)
        ))
        
        // Fifth row: Yesod (9)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY + verticalSpacing * 1.8),
            rotation: .degrees(0)
        ))
        
        // Bottom: Malkuth (10)
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY + verticalSpacing * 2.5),
            rotation: .degrees(0)
        ))
        
        return positions
    }
    
    // MARK: - Celtic Knot Layout (9 cards)
    // Interconnected pattern with center and paths
    static func calculateCelticKnotLayout(canvasSize: CGSize) -> [CardPosition] {
        let centerX = canvasSize.width / 2
        let centerY = canvasSize.height / 2
        
        var positions: [CardPosition] = []
        
        let radius = cardWidth * 1.3
        
        // Card 1: Center
        positions.append(CardPosition(
            point: CGPoint(x: centerX, y: centerY),
            rotation: .degrees(0)
        ))
        
        // Cards 2-5: Four paths (top-left, top-right, bottom-right, bottom-left)
        let pathAngles: [Double] = [135, 45, -45, -135] // Top-left, top-right, bottom-right, bottom-left
        
        for angle in pathAngles {
            let radians = angle * .pi / 180
            let x = centerX + radius * cos(radians)
            let y = centerY - radius * sin(radians)
            positions.append(CardPosition(
                point: CGPoint(x: x, y: y),
                rotation: .degrees(0)
            ))
        }
        
        // Cards 6-9: Connections between paths (midpoints)
        let connectionAngles: [Double] = [90, 0, -90, 180] // Top, right, bottom, left
        
        for angle in connectionAngles {
            let radians = angle * .pi / 180
            let x = centerX + radius * 0.7 * cos(radians)
            let y = centerY - radius * 0.7 * sin(radians)
            positions.append(CardPosition(
                point: CGPoint(x: x, y: y),
                rotation: .degrees(0)
            ))
        }
        
        return positions
    }
    
    // MARK: - Calculate Initial Zoom
    // Calculate the initial zoom level to show the entire spread
    static func calculateInitialZoom(
        for spreadId: String,
        canvasSize: CGSize,
        screenSize: CGSize
    ) -> CGFloat {
        let positions: [CardPosition]
        
        switch spreadId {
        case "celtic-cross":
            positions = calculateCelticCrossLayout(canvasSize: canvasSize)
        case "three-card", "past-present-future":
            positions = calculateThreeCardLayout(canvasSize: canvasSize)
        case "moon-guidance":
            positions = calculateMoonGuidanceLayout(canvasSize: canvasSize)
        case "relationship":
            positions = calculateRelationshipLayout(canvasSize: canvasSize)
        case "career-path":
            positions = calculateCareerPathLayout(canvasSize: canvasSize)
        case "wheel-of-fortune":
            positions = calculateWheelOfFortuneLayout(canvasSize: canvasSize)
        case "horseshoe":
            positions = calculateHorseshoeLayout(canvasSize: canvasSize)
        case "one-card":
            positions = calculateOneCardLayout(canvasSize: canvasSize)
        case "pentagram":
            positions = calculatePentagramLayout(canvasSize: canvasSize)
        case "tree-of-life":
            positions = calculateTreeOfLifeLayout(canvasSize: canvasSize)
        case "celtic-knot":
            positions = calculateCelticKnotLayout(canvasSize: canvasSize)
        default:
            positions = calculateThreeCardLayout(canvasSize: canvasSize)
        }
        
        // Find the bounding box of all cards
        var minX = CGFloat.greatestFiniteMagnitude
        var maxX = -CGFloat.greatestFiniteMagnitude
        var minY = CGFloat.greatestFiniteMagnitude
        var maxY = -CGFloat.greatestFiniteMagnitude
        
        for position in positions {
            let cardHalfWidth = cardWidth / 2
            let cardHalfHeight = cardHeight / 2
            
            minX = Swift.min(minX, position.point.x - cardHalfWidth)
            maxX = Swift.max(maxX, position.point.x + cardHalfWidth)
            minY = Swift.min(minY, position.point.y - cardHalfHeight)
            maxY = Swift.max(maxY, position.point.y + cardHalfHeight)
        }
        
        let spreadWidth = maxX - minX
        let spreadHeight = maxY - minY
        
        // Add padding
        let padding: CGFloat = 80
        let totalWidth = spreadWidth + padding * 2
        let totalHeight = spreadHeight + padding * 2
        
        // Calculate zoom to fit in screen
        let zoomX = screenSize.width / totalWidth
        let zoomY = screenSize.height / totalHeight
        
        // Use the smaller zoom to ensure everything fits, but clamp between 0.3 and 1.0
        let zoom = Swift.min(zoomX, zoomY).clamped(to: 0.3...1.0)
        
        return zoom
    }
    
    // MARK: - Get Layout for Spread
    static func getLayout(for spreadId: String, canvasSize: CGSize) -> [CardPosition] {
        switch spreadId {
        case "celtic-cross":
            return calculateCelticCrossLayout(canvasSize: canvasSize)
        case "three-card":
            return calculateThreeCardLayout(canvasSize: canvasSize)
        case "past-present-future":
            return calculatePastPresentFutureLayout(canvasSize: canvasSize)
        case "moon-guidance":
            return calculateMoonGuidanceLayout(canvasSize: canvasSize)
        case "relationship":
            return calculateRelationshipLayout(canvasSize: canvasSize)
        case "career-path":
            return calculateCareerPathLayout(canvasSize: canvasSize)
        case "wheel-of-fortune":
            return calculateWheelOfFortuneLayout(canvasSize: canvasSize)
        case "horseshoe":
            return calculateHorseshoeLayout(canvasSize: canvasSize)
        case "one-card":
            return calculateOneCardLayout(canvasSize: canvasSize)
        case "pentagram":
            return calculatePentagramLayout(canvasSize: canvasSize)
        case "tree-of-life":
            return calculateTreeOfLifeLayout(canvasSize: canvasSize)
        case "celtic-knot":
            return calculateCelticKnotLayout(canvasSize: canvasSize)
        default:
            return calculateThreeCardLayout(canvasSize: canvasSize)
        }
    }
}

extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        return Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

