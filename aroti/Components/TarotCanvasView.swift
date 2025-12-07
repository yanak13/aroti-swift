//
//  TarotCanvasView.swift
//  Aroti
//
//  Zoomable and pannable canvas for tarot spreads
//

import SwiftUI

struct TarotCanvasView<Content: View>: View {
    @GestureState private var magnification: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    
    let content: Content
    let canvasSize: CGSize
    let initialScale: CGFloat
    @Binding var currentScale: CGFloat
    
    init(
        canvasSize: CGSize,
        initialScale: CGFloat = 1.0,
        currentScale: Binding<CGFloat> = .constant(1.0),
        @ViewBuilder content: () -> Content
    ) {
        self.canvasSize = canvasSize
        self.initialScale = initialScale
        self._currentScale = currentScale
        self.content = content()
        _scale = State(initialValue: initialScale)
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            
            content
                .frame(width: canvasSize.width, height: canvasSize.height)
                .scaleEffect(scale * magnification)
                .offset(
                    x: offset.width + dragOffset.width,
                    y: offset.height + dragOffset.height
                )
                .gesture(
                    SimultaneousGesture(
                        // Pinch to zoom gesture
                        MagnificationGesture()
                            .updating($magnification) { value, state, _ in
                                state = value
                            }
                            .onEnded { value in
                                let newScale = (scale * value).clamped(to: 0.5...2.5)
                                scale = newScale
                                currentScale = newScale
                                
                                // Constrain offset to keep content visible
                                constrainOffset(to: screenSize, scale: newScale)
                            },
                        
                        // Pan/drag gesture (with minimum distance to allow card taps)
                        DragGesture(minimumDistance: 10)
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                offset.width += value.translation.width
                                offset.height += value.translation.height
                                
                                // Constrain offset to keep content visible
                                constrainOffset(to: screenSize, scale: scale)
                            }
                    )
                )
                .animation(.easeOut(duration: 0.15), value: scale)
                .animation(.easeOut(duration: 0.15), value: offset)
                .onAppear {
                    // Set initial scale first
                    scale = initialScale
                    currentScale = initialScale
                    // Center the canvas with a slight delay to ensure geometry is ready
                    DispatchQueue.main.async {
                        let scaledWidth = canvasSize.width * initialScale
                        let scaledHeight = canvasSize.height * initialScale
                        offset.width = (screenSize.width - scaledWidth) / 2
                        offset.height = (screenSize.height - scaledHeight) / 2
                    }
                }
                .onChange(of: screenSize) { _, newSize in
                    // Re-center when screen size changes (e.g., rotation)
                    centerCanvas(screenSize: newSize)
                    constrainOffset(to: newSize, scale: scale)
                }
                .onChange(of: initialScale) { _, newScale in
                    // Update if initial scale changes
                    if scale == initialScale || abs(scale - initialScale) < 0.01 {
                        scale = newScale
                        currentScale = newScale
                        centerCanvas(screenSize: screenSize)
                    }
                }
        }
        .clipped()
    }
    
    private func centerCanvas(screenSize: CGSize) {
        // Use current scale
        let currentScaleValue = scale
        let scaledWidth = canvasSize.width * currentScaleValue
        let scaledHeight = canvasSize.height * currentScaleValue
        
        // Center the canvas on screen
        offset.width = (screenSize.width - scaledWidth) / 2
        offset.height = (screenSize.height - scaledHeight) / 2
    }
    
    // Helper to center canvas with a specific scale
    private func centerCanvas(screenSize: CGSize, withScale scaleValue: CGFloat) {
        let scaledWidth = canvasSize.width * scaleValue
        let scaledHeight = canvasSize.height * scaleValue
        
        offset.width = (screenSize.width - scaledWidth) / 2
        offset.height = (screenSize.height - scaledHeight) / 2
    }
    
    private func constrainOffset(to screenSize: CGSize, scale: CGFloat) {
        let scaledWidth = canvasSize.width * scale
        let scaledHeight = canvasSize.height * scale
        
        // Calculate bounds - allow panning within the scaled canvas bounds
        if scaledWidth <= screenSize.width {
            // Canvas fits in screen, center it
            offset.width = (screenSize.width - scaledWidth) / 2
        } else {
            // Canvas is larger, allow panning but constrain
            let minOffsetX = (screenSize.width - scaledWidth) / 2
            let maxOffsetX = (scaledWidth - screenSize.width) / 2
            offset.width = offset.width.clamped(to: minOffsetX...maxOffsetX)
        }
        
        if scaledHeight <= screenSize.height {
            // Canvas fits in screen, center it
            offset.height = (screenSize.height - scaledHeight) / 2
        } else {
            // Canvas is larger, allow panning but constrain
            let minOffsetY = (screenSize.height - scaledHeight) / 2
            let maxOffsetY = (scaledHeight - screenSize.height) / 2
            offset.height = offset.height.clamped(to: minOffsetY...maxOffsetY)
        }
    }
    
    func resetZoom(screenSize: CGSize) {
        withAnimation(.easeOut(duration: 0.3)) {
            scale = initialScale
            currentScale = initialScale
            centerCanvas(screenSize: screenSize)
        }
    }
}
