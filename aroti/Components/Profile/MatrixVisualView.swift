//
//  MatrixVisualView.swift
//  Aroti
//
//  Matrix of Fate visual grid component
//

import SwiftUI

struct MatrixVisualView: View {
    let matrix: MatrixVisual
    let coreDestinyNumber: Int
    
    private let cellSpacing: CGFloat = 8
    private let cellSize: CGFloat = 60
    
    var body: some View {
        BaseCard {
            VStack(spacing: 16) {
                // Title
                Text("Your Matrix")
                    .font(DesignTypography.subheadFont(weight: .semibold))
                    .foregroundColor(DesignColors.foreground)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Grid
                let gridSize = matrix.gridSize
                VStack(spacing: cellSpacing) {
                    ForEach(0..<gridSize, id: \.self) { row in
                        HStack(spacing: cellSpacing) {
                            ForEach(0..<gridSize, id: \.self) { col in
                                let cell = matrix.cells.first { $0.x == col && $0.y == row }
                                let value = cell?.value
                                let isCore = value == coreDestinyNumber
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            isCore
                                                ? DesignColors.accent.opacity(0.2)
                                                : Color.white.opacity(0.05)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(
                                                    isCore
                                                        ? DesignColors.accent.opacity(0.5)
                                                        : Color.white.opacity(0.1),
                                                    lineWidth: isCore ? 2 : 1
                                                )
                                        )
                                    
                                    if let value = value {
                                        VStack(spacing: 2) {
                                            Text("\(value)")
                                                .font(DesignTypography.bodyFont(weight: isCore ? .bold : .medium))
                                                .foregroundColor(
                                                    isCore
                                                        ? DesignColors.accent
                                                        : DesignColors.foreground
                                                )
                                            
                                            if isCore {
                                                Text("Core")
                                                    .font(DesignTypography.caption2Font())
                                                    .foregroundColor(DesignColors.accent.opacity(0.7))
                                            }
                                        }
                                    }
                                }
                                .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
