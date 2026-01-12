//
//  ShareCardImageGenerator.swift
//  Aroti
//
//  Utility to generate 9:16 shareable images for Core Guidance cards
//

import SwiftUI
import UIKit

struct ShareCardImageGenerator {
    static func generateShareImage(
        headline: String,
        bodyLines: [String],
        cardType: CoreGuidanceCardType,
        symbolName: String
    ) -> UIImage? {
        // 9:16 aspect ratio for Stories (1080x1920)
        let width: CGFloat = 1080
        let height: CGFloat = 1920
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // Draw background gradient (matching Discovery page)
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [
                    UIColor(red: 23/255, green: 20/255, blue: 31/255, alpha: 1).cgColor,
                    UIColor(red: 18/255, green: 15/255, blue: 25/255, alpha: 1).cgColor
                ] as CFArray,
                locations: [0.0, 1.0]
            )!
            
            cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: 0, y: height),
                options: []
            )
            
            // Add very light grain texture
            addGrainTexture(to: cgContext, size: CGSize(width: width, height: height))
            
            // Add subtle vignette
            addVignette(to: cgContext, size: CGSize(width: width, height: height))
            
            // Draw content
            let padding: CGFloat = 80
            let contentWidth = width - (padding * 2)
            
            // Top: Small symbol
            let symbolSize: CGFloat = 60
            let symbolY: CGFloat = 200
            if let symbolImage = UIImage(systemName: symbolName) {
                let config = UIImage.SymbolConfiguration(pointSize: symbolSize, weight: .semibold)
                let configuredImage = symbolImage.withConfiguration(config)
                let tintedImage = configuredImage.withTintColor(
                    UIColor(red: 185/255, green: 110/255, blue: 70/255, alpha: 1),
                    renderingMode: .alwaysOriginal
                )
                let symbolRect = CGRect(
                    x: (width - symbolSize) / 2,
                    y: symbolY,
                    width: symbolSize,
                    height: symbolSize
                )
                tintedImage.draw(in: symbolRect)
            }
            
            // Center: Title + Body text
            let titleFont = UIFont.systemFont(ofSize: 56, weight: .medium)
            let bodyFont = UIFont.systemFont(ofSize: 36, weight: .regular)
            let textColor = UIColor.white
            
            var currentY: CGFloat = symbolY + symbolSize + 120
            
            // Draw headline
            let headlineAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: textColor
            ]
            let headlineSize = headline.boundingRect(
                with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: headlineAttributes,
                context: nil
            ).size
            
            let headlineRect = CGRect(
                x: padding,
                y: currentY,
                width: contentWidth,
                height: headlineSize.height
            )
            headline.draw(in: headlineRect, withAttributes: headlineAttributes)
            
            currentY += headlineSize.height + 60
            
            // Draw body lines
            let lineSpacing: CGFloat = 40
            for line in bodyLines {
                let lineAttributes: [NSAttributedString.Key: Any] = [
                    .font: bodyFont,
                    .foregroundColor: textColor.withAlphaComponent(0.85)
                ]
                let lineSize = line.boundingRect(
                    with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    attributes: lineAttributes,
                    context: nil
                ).size
                
                let lineRect = CGRect(
                    x: padding,
                    y: currentY,
                    width: contentWidth,
                    height: lineSize.height
                )
                line.draw(in: lineRect, withAttributes: lineAttributes)
                
                currentY += lineSize.height + lineSpacing
            }
            
            // Bottom: "From Aroti" (small, subtle)
            let footerFont = UIFont.systemFont(ofSize: 24, weight: .regular)
            let footerText = "From Aroti"
            let footerAttributes: [NSAttributedString.Key: Any] = [
                .font: footerFont,
                .foregroundColor: textColor.withAlphaComponent(0.4)
            ]
            let footerSize = footerText.boundingRect(
                with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: footerAttributes,
                context: nil
            ).size
            
            let footerRect = CGRect(
                x: padding,
                y: height - 150,
                width: contentWidth,
                height: footerSize.height
            )
            footerText.draw(in: footerRect, withAttributes: footerAttributes)
        }
    }
    
    private static func addGrainTexture(to context: CGContext, size: CGSize) {
        // Very light grain texture
        context.setFillColor(UIColor.white.withAlphaComponent(0.02).cgColor)
        for _ in 0..<1000 {
            let x = CGFloat.random(in: 0..<size.width)
            let y = CGFloat.random(in: 0..<size.height)
            context.fillEllipse(in: CGRect(x: x, y: y, width: 1, height: 1))
        }
    }
    
    private static func addVignette(to context: CGContext, size: CGSize) {
        // Subtle vignette effect
        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.1).cgColor
            ] as CFArray,
            locations: [0.0, 1.0]
        )!
        
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = max(size.width, size.height) * 0.7
        
        context.drawRadialGradient(
            gradient,
            startCenter: center,
            startRadius: 0,
            endCenter: center,
            endRadius: radius,
            options: []
        )
    }
}

