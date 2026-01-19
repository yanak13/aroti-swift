//
//  DailyPickHeroIcons.swift
//  Aroti
//
//  Hero-style icon components matching onboarding design system
//  For Horoscope, Numerology, and Affirmation detail pages
//

import SwiftUI

// MARK: - Horoscope Hero Icon
struct HoroscopeHeroIcon: View {
    let sign: String
    let color: Color
    @State private var glowPulse: Double = 0.5
    @State private var breathingScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow - warm accent color, blurred
                RadialGradient(
                    colors: [
                        color.opacity(0.12 * glowPulse),
                        color.opacity(0.06 * glowPulse),
                        color.opacity(0.02 * glowPulse),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.7
                )
                .blur(radius: 20)
                .blendMode(.plusLighter)
                
                // Zodiac circle - cinematic with inner glow
                ZodiacCircleShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                color.opacity(0.95),
                                color.opacity(0.85),
                                color.opacity(0.75),
                                color.opacity(0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: color.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                    .blur(radius: 0.5)
                
                // Constellation points forming into circle (8 nodes like BirthChartHero)
                ForEach(0..<8, id: \.self) { index in
                    let angle = Double(index) * (2 * .pi / 8)
                    let radius = min(geometry.size.width, geometry.size.height) * 0.25
                    let centerX = geometry.size.width / 2
                    let centerY = geometry.size.height / 2
                    
                    let x = centerX + cos(angle) * radius
                    let y = centerY + sin(angle) * radius
                    
                    ZStack {
                        // Soft outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        color.opacity(0.3 * glowPulse),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 3,
                                    endRadius: 12
                                )
                            )
                            .frame(width: 24, height: 24)
                            .blur(radius: 2)
                        
                        // Main point with inner glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        color.opacity(0.9),
                                        color.opacity(0.7),
                                        color.opacity(0.5),
                                        color.opacity(0.3)
                                    ],
                                    center: .center,
                                    startRadius: 2,
                                    endRadius: 10
                                )
                            )
                            .frame(width: 10, height: 10)
                    }
                    .position(x: x, y: y)
                    .shadow(color: color.opacity(0.8 * glowPulse), radius: 10, x: 0, y: 0)
                }
                
                // Zodiac symbol pattern in center (dots and lines)
                ZodiacSymbolPattern(sign: sign)
                    .stroke(
                        LinearGradient(
                            colors: [
                                color.opacity(0.95),
                                color.opacity(0.85),
                                color.opacity(0.75),
                                color.opacity(0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 40, height: 40)
                
                // Zodiac symbol dots
                ZodiacSymbolDots(sign: sign)
                    .fill(color)
                    .frame(width: 40, height: 40)
            }
        }
        .onAppear {
            // Continuous glow pulse
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
            
            // Very slow breathing animation
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                breathingScale = 1.02
            }
        }
    }
    
    private func getZodiacSymbol(_ sign: String) -> String {
        let symbols: [String: String] = [
            "Aries": "♈",
            "Taurus": "♉",
            "Gemini": "♊",
            "Cancer": "♋",
            "Leo": "♌",
            "Virgo": "♍",
            "Libra": "♎",
            "Scorpio": "♏",
            "Sagittarius": "♐",
            "Capricorn": "♑",
            "Aquarius": "♒",
            "Pisces": "♓"
        ]
        return symbols[sign] ?? "♓"
    }
}

struct ZodiacCircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.25
        
        // Draw circle
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
        )
        
        return path
    }
}

// MARK: - Numerology Hero Icon
struct NumerologyHeroIcon: View {
    let number: Int
    let color: Color
    @State private var glowPulse: Double = 0.5
    @State private var breathingScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow - warm accent color, blurred
                RadialGradient(
                    colors: [
                        color.opacity(0.12 * glowPulse),
                        color.opacity(0.06 * glowPulse),
                        color.opacity(0.02 * glowPulse),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.7
                )
                .blur(radius: 20)
                .blendMode(.plusLighter)
                
                // Geometric pattern based on number - polygon shape
                NumerologyPatternShape(number: number)
                    .stroke(
                        LinearGradient(
                            colors: [
                                color.opacity(0.95),
                                color.opacity(0.85),
                                color.opacity(0.75),
                                color.opacity(0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: color.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                    .blur(radius: 0.5)
                
                // Number pattern in center (dots and lines)
                NumberPatternShape(number: number)
                    .stroke(
                        LinearGradient(
                            colors: [
                                color.opacity(0.95),
                                color.opacity(0.85),
                                color.opacity(0.75),
                                color.opacity(0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 50, height: 50)
                
                // Number dots
                NumberDotsShape(number: number)
                    .fill(color)
                    .frame(width: 50, height: 50)
            }
        }
        .onAppear {
            // Continuous glow pulse
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
            
            // Very slow breathing animation
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                breathingScale = 1.02
            }
        }
    }
}

struct NumerologyPatternShape: Shape {
    let number: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.3
        
        // Create polygon based on number (3-9 sides)
        let sides = min(max(number, 3), 9)
        let angleStep = (2 * .pi) / Double(sides)
        
        var points: [CGPoint] = []
        for i in 0..<sides {
            let angle = Double(i) * angleStep - .pi / 2 // Start from top
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            points.append(CGPoint(x: x, y: y))
        }
        
        // Draw polygon
        if let first = points.first {
            path.move(to: first)
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
            path.closeSubpath()
        }
        
        return path
    }
}

// MARK: - Affirmation Hero Icon
struct AffirmationHeroIcon: View {
    let color: Color
    @State private var glowPulse: Double = 0.5
    @State private var breathingScale: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft outer glow - warm accent color, blurred
                RadialGradient(
                    colors: [
                        color.opacity(0.12 * glowPulse),
                        color.opacity(0.06 * glowPulse),
                        color.opacity(0.02 * glowPulse),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: geometry.size.width * 0.2,
                    endRadius: geometry.size.width * 0.7
                )
                .blur(radius: 20)
                .blendMode(.plusLighter)
                
                // Double circle pattern (inner + outer)
                AffirmationPatternShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                color.opacity(0.95),
                                color.opacity(0.85),
                                color.opacity(0.75),
                                color.opacity(0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                    )
                    .scaleEffect(breathingScale)
                    .shadow(color: color.opacity(0.5 * glowPulse), radius: 12, x: 0, y: 0)
                    .blur(radius: 0.5)
                
                // Glowing nodes around outer circle (6 nodes representing affirmations)
                ForEach(0..<6, id: \.self) { index in
                    let angle = Double(index) * (2 * .pi / 6)
                    let radius = min(geometry.size.width, geometry.size.height) * 0.25
                    let centerX = geometry.size.width / 2
                    let centerY = geometry.size.height / 2
                    
                    let x = centerX + cos(angle) * radius
                    let y = centerY + sin(angle) * radius
                    
                    ZStack {
                        // Soft outer glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        color.opacity(0.3 * glowPulse),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 3,
                                    endRadius: 12
                                )
                            )
                            .frame(width: 24, height: 24)
                            .blur(radius: 2)
                        
                        // Main point with inner glow
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        color.opacity(0.9),
                                        color.opacity(0.7),
                                        color.opacity(0.5),
                                        color.opacity(0.3)
                                    ],
                                    center: .center,
                                    startRadius: 2,
                                    endRadius: 10
                                )
                            )
                            .frame(width: 10, height: 10)
                    }
                    .position(x: x, y: y)
                    .shadow(color: color.opacity(0.8 * glowPulse), radius: 10, x: 0, y: 0)
                }
                
                // Quote pattern in center (dots and lines)
                QuotePatternShape()
                    .stroke(
                        LinearGradient(
                            colors: [
                                color.opacity(0.95),
                                color.opacity(0.85),
                                color.opacity(0.75),
                                color.opacity(0.65)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 36, height: 36)
                
                // Quote dots
                QuoteDotsShape()
                    .fill(color)
                    .frame(width: 36, height: 36)
            }
        }
        .onAppear {
            // Continuous glow pulse
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
            
            // Very slow breathing animation
            withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                breathingScale = 1.02
            }
        }
    }
}

struct AffirmationPatternShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * 0.25
        
        // Draw inner circle (60% of outer radius)
        path.addArc(
            center: center,
            radius: radius * 0.6,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
        )
        
        // Draw outer circle
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(0),
            endAngle: .degrees(360),
            clockwise: false
        )
        
        return path
    }
}

// MARK: - Zodiac Symbol Patterns (Dots and Lines)
struct ZodiacSymbolPattern: Shape {
    let sign: String
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height)
        
        // Create simplified constellation patterns for each zodiac sign
        switch sign {
        case "Pisces":
            // Two fish pattern - curved lines
            path.move(to: CGPoint(x: center.x - size * 0.15, y: center.y))
            path.addQuadCurve(to: CGPoint(x: center.x - size * 0.3, y: center.y - size * 0.2), control: CGPoint(x: center.x - size * 0.2, y: center.y - size * 0.1))
            path.move(to: CGPoint(x: center.x + size * 0.15, y: center.y))
            path.addQuadCurve(to: CGPoint(x: center.x + size * 0.3, y: center.y + size * 0.2), control: CGPoint(x: center.x + size * 0.2, y: center.y + size * 0.1))
        case "Libra":
            // Scales pattern - horizontal line with two vertical lines
            path.move(to: CGPoint(x: center.x - size * 0.2, y: center.y))
            path.addLine(to: CGPoint(x: center.x + size * 0.2, y: center.y))
            path.move(to: CGPoint(x: center.x - size * 0.15, y: center.y - size * 0.15))
            path.addLine(to: CGPoint(x: center.x - size * 0.15, y: center.y))
            path.move(to: CGPoint(x: center.x + size * 0.15, y: center.y - size * 0.15))
            path.addLine(to: CGPoint(x: center.x + size * 0.15, y: center.y))
        case "Aries":
            // Ram horns - curved lines
            path.move(to: CGPoint(x: center.x, y: center.y + size * 0.2))
            path.addQuadCurve(to: CGPoint(x: center.x - size * 0.2, y: center.y - size * 0.1), control: CGPoint(x: center.x - size * 0.1, y: center.y))
            path.move(to: CGPoint(x: center.x, y: center.y + size * 0.2))
            path.addQuadCurve(to: CGPoint(x: center.x + size * 0.2, y: center.y - size * 0.1), control: CGPoint(x: center.x + size * 0.1, y: center.y))
        default:
            // Default: simple cross pattern
            path.move(to: CGPoint(x: center.x, y: center.y - size * 0.2))
            path.addLine(to: CGPoint(x: center.x, y: center.y + size * 0.2))
            path.move(to: CGPoint(x: center.x - size * 0.2, y: center.y))
            path.addLine(to: CGPoint(x: center.x + size * 0.2, y: center.y))
        }
        
        return path
    }
}

struct ZodiacSymbolDots: Shape {
    let sign: String
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height)
        let dotRadius: CGFloat = 2
        
        // Create dots for zodiac symbol pattern
        switch sign {
        case "Pisces":
            // Dots along fish curves
            path.addEllipse(in: CGRect(x: center.x - size * 0.15 - dotRadius, y: center.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
            path.addEllipse(in: CGRect(x: center.x - size * 0.3 - dotRadius, y: center.y - size * 0.2 - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
            path.addEllipse(in: CGRect(x: center.x + size * 0.15 - dotRadius, y: center.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
            path.addEllipse(in: CGRect(x: center.x + size * 0.3 - dotRadius, y: center.y + size * 0.2 - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
        case "Libra":
            // Dots at scale points
            path.addEllipse(in: CGRect(x: center.x - size * 0.2 - dotRadius, y: center.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
            path.addEllipse(in: CGRect(x: center.x + size * 0.2 - dotRadius, y: center.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
            path.addEllipse(in: CGRect(x: center.x - size * 0.15 - dotRadius, y: center.y - size * 0.15 - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
            path.addEllipse(in: CGRect(x: center.x + size * 0.15 - dotRadius, y: center.y - size * 0.15 - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
        default:
            // Default: center dot
            path.addEllipse(in: CGRect(x: center.x - dotRadius, y: center.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
        }
        
        return path
    }
}

// MARK: - Number Patterns (Dots and Lines)
struct NumberPatternShape: Shape {
    let number: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height)
        let segmentWidth = size * 0.15
        
        // Create 7-segment display pattern for numbers
        let segments: [(start: CGPoint, end: CGPoint)] = [
            // Top
            (CGPoint(x: center.x - segmentWidth, y: center.y - size * 0.25), CGPoint(x: center.x + segmentWidth, y: center.y - size * 0.25)),
            // Top-left
            (CGPoint(x: center.x - segmentWidth, y: center.y - size * 0.25), CGPoint(x: center.x - segmentWidth, y: center.y)),
            // Top-right
            (CGPoint(x: center.x + segmentWidth, y: center.y - size * 0.25), CGPoint(x: center.x + segmentWidth, y: center.y)),
            // Middle
            (CGPoint(x: center.x - segmentWidth, y: center.y), CGPoint(x: center.x + segmentWidth, y: center.y)),
            // Bottom-left
            (CGPoint(x: center.x - segmentWidth, y: center.y), CGPoint(x: center.x - segmentWidth, y: center.y + size * 0.25)),
            // Bottom-right
            (CGPoint(x: center.x + segmentWidth, y: center.y), CGPoint(x: center.x + segmentWidth, y: center.y + size * 0.25)),
            // Bottom
            (CGPoint(x: center.x - segmentWidth, y: center.y + size * 0.25), CGPoint(x: center.x + segmentWidth, y: center.y + size * 0.25))
        ]
        
        // Define which segments are active for each number (7-segment display)
        let activeSegments: [Int: [Int]] = [
            1: [2, 5],
            2: [0, 2, 3, 4, 6],
            3: [0, 2, 3, 5, 6],
            4: [1, 2, 3, 5],
            5: [0, 1, 3, 5, 6],
            6: [0, 1, 3, 4, 5, 6],
            7: [0, 2, 5],
            8: [0, 1, 2, 3, 4, 5, 6],
            9: [0, 1, 2, 3, 5, 6]
        ]
        
        let segmentsToDraw = activeSegments[number] ?? [0, 1, 2, 3, 4, 5, 6]
        
        for index in segmentsToDraw {
            let segment = segments[index]
            path.move(to: segment.start)
            path.addLine(to: segment.end)
        }
        
        return path
    }
}

struct NumberDotsShape: Shape {
    let number: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height)
        let dotRadius: CGFloat = 2.5
        
        // Create dots at segment endpoints for the number
        let dotPositions: [CGPoint] = [
            CGPoint(x: center.x - size * 0.15, y: center.y - size * 0.25), // Top-left
            CGPoint(x: center.x + size * 0.15, y: center.y - size * 0.25), // Top-right
            CGPoint(x: center.x - size * 0.15, y: center.y), // Middle-left
            CGPoint(x: center.x + size * 0.15, y: center.y), // Middle-right
            CGPoint(x: center.x - size * 0.15, y: center.y + size * 0.25), // Bottom-left
            CGPoint(x: center.x + size * 0.15, y: center.y + size * 0.25) // Bottom-right
        ]
        
        // Add dots at key positions
        for position in dotPositions {
            path.addEllipse(in: CGRect(x: position.x - dotRadius, y: position.y - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
        }
        
        return path
    }
}

// MARK: - Quote Pattern (Dots and Lines)
struct QuotePatternShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height)
        
        // Create quote bubble shape with lines
        // Left quote mark
        path.move(to: CGPoint(x: center.x - size * 0.2, y: center.y - size * 0.1))
        path.addQuadCurve(to: CGPoint(x: center.x - size * 0.15, y: center.y - size * 0.2), control: CGPoint(x: center.x - size * 0.18, y: center.y - size * 0.15))
        path.addQuadCurve(to: CGPoint(x: center.x - size * 0.1, y: center.y - size * 0.15), control: CGPoint(x: center.x - size * 0.12, y: center.y - size * 0.18))
        
        // Right quote mark
        path.move(to: CGPoint(x: center.x + size * 0.1, y: center.y - size * 0.1))
        path.addQuadCurve(to: CGPoint(x: center.x + size * 0.15, y: center.y - size * 0.2), control: CGPoint(x: center.x + size * 0.12, y: center.y - size * 0.15))
        path.addQuadCurve(to: CGPoint(x: center.x + size * 0.2, y: center.y - size * 0.15), control: CGPoint(x: center.x + size * 0.18, y: center.y - size * 0.18))
        
        // Bubble outline (simplified)
        path.addArc(center: center, radius: size * 0.25, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
        
        return path
    }
}

struct QuoteDotsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let size = min(rect.width, rect.height)
        let dotRadius: CGFloat = 2
        
        // Dots at quote marks
        path.addEllipse(in: CGRect(x: center.x - size * 0.2 - dotRadius, y: center.y - size * 0.2 - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
        path.addEllipse(in: CGRect(x: center.x + size * 0.2 - dotRadius, y: center.y - size * 0.2 - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
        
        // Dots around bubble
        for angle in stride(from: 0, through: 360, by: 45) {
            let rad = Double(angle) * .pi / 180
            let x = center.x + cos(rad) * size * 0.25
            let y = center.y + sin(rad) * size * 0.25
            path.addEllipse(in: CGRect(x: x - dotRadius, y: y - dotRadius, width: dotRadius * 2, height: dotRadius * 2))
        }
        
        return path
    }
}

#Preview("Horoscope") {
    ZStack {
        CelestialBackground()
        HoroscopeHeroIcon(sign: "Libra", color: DesignColors.accent)
            .frame(width: 100, height: 100)
    }
}

#Preview("Numerology") {
    ZStack {
        CelestialBackground()
        NumerologyHeroIcon(number: 7, color: DesignColors.accent)
            .frame(width: 100, height: 100)
    }
}

#Preview("Affirmation") {
    ZStack {
        CelestialBackground()
        AffirmationHeroIcon(color: DesignColors.accent)
            .frame(width: 100, height: 100)
    }
}
