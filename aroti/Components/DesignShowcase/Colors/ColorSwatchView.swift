//
//  ColorSwatchView.swift
//  Aroti
//
//  Shared swatch helpers for color showcase sections.
//

import SwiftUI

struct ColorSwatchView: View {
    let name: String
    let token: String
    let color: Color
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                Text(description)
                    .font(DesignTypography.footnoteFont())
                    .foregroundColor(DesignColors.mutedForeground)
                Text(token)
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
            }
        }
    }
}

struct StatusColorSwatchView: View {
    let name: String
    let background: Color
    let border: Color
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(background)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(border, lineWidth: 1)
                )
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                Text(description)
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

struct GradientSwatchView: View {
    let name: String
    let description: String
    let gradient: LinearGradient
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(gradient)
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                Text(description)
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(DesignColors.mutedForeground)
            }
        }
    }
}

struct BorderSwatchView: View {
    let name: String
    let token: String
    let color: Color
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(color, lineWidth: 2)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.clear))
                .frame(width: 64, height: 64)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(DesignTypography.bodyFont(weight: .medium))
                    .foregroundColor(DesignColors.foreground)
                Text(description)
                    .font(DesignTypography.caption1Font())
                    .foregroundColor(DesignColors.mutedForeground)
                Text(token)
                    .font(DesignTypography.caption2Font())
                    .foregroundColor(DesignColors.mutedForeground.opacity(0.8))
            }
        }
    }
}
