//
//  GridPad.swift
//  ChromaPicker
//
//  Created by Assistant on 2/27/26.

import SwiftUI

/**
    Generates a grid-like circular pad that dynamically changes based off
    of where the cursor is currently at.
 */

internal struct GridPad: View {
    
    @Environment(\.colorScheme) var colorScheme
    // 1. Pass the cursor in so the Canvas can read it!
    var cursor: CGPoint
    var dragIntensity: CGFloat
    var currentColor: Color
    
    var spacing: CGFloat = 13.0
    var dotSize: CGFloat = 4.0
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            let maxRadius = min(size.width * 0.85, size.height * 0.85) / 2.0
            
            // Pre-calculate squared values to avoid doing square roots in the loop!
            let maxRadiusSq = maxRadius * maxRadius
            let influenceRadius: CGFloat = 65.0
            let influenceRadiusSq = influenceRadius * influenceRadius
            
            // 1. Find the largest multiple of `spacing` that fits inside `maxRadius`
            let dotCount = floor(maxRadius / spacing)
            let bound = dotCount * spacing
            context.blendMode = .plusLighter
            
            // Cache the base color outside the loop
            let baseColor = colorScheme == .light ? Color.gray : Color.white
            
            // 2. Stride from `-bound` to `bound`. Because bound is a perfect multiple
            // of spacing, this mathematically GUARANTEES it will hit exactly 0.0 in the center!
            for xOffset in stride(from: -bound, through: bound, by: spacing) {
                let xOffsetSq = xOffset * xOffset // Math optimization
                
                for yOffset in stride(from: -bound, through: bound, by: spacing) {
                    let distCenterSq = xOffsetSq + (yOffset * yOffset)
                    
                    // 1. FAST CHECK: Only process dots that are physically inside the main circle
                    if distCenterSq <= maxRadiusSq {
                        
                        let dotCenter = CGPoint(x: center.x + xOffset, y: center.y + yOffset)
                        
                        let dx = dotCenter.x - cursor.x
                        let dy = dotCenter.y - cursor.y
                        let distCursorSq = (dx * dx) + (dy * dy)
                        
                        var activeInfluence: CGFloat = 0.0
                        
                        // 2. FAST CHECK: Only do heavy math if the cursor is actually near this dot!
                        if distCursorSq < influenceRadiusSq {
                            // Only do the expensive square root if we absolutely have to
                            let distanceToCursor = sqrt(distCursorSq)
                            let rawInfluence = max(0.0, 1.0 - (distanceToCursor / influenceRadius))
                            // x * x is significantly faster than pow(x, 2)
                            activeInfluence = (rawInfluence * rawInfluence) * dragIntensity
                        }
                        
                        // 3. Apply the dynamic math
                        let currentSize = dotSize + (activeInfluence * dotSize * 3.1)
                        
                        // Calculate edge vignette (requires actual distance)
                        let distanceToCenter = sqrt(distCenterSq)
                        let edgeDistance = maxRadius - distanceToCenter
                        let edgeVignette = min(1.0, max(0.0, edgeDistance / 15.0))
                        
                        var alpha = 0.15
                        alpha = max(alpha, activeInfluence)
                        alpha *= edgeVignette
                        
                        // Draw using highly optimized CoreGraphics primitives
                        let finalColor = baseColor.mix(with: currentColor, by: activeInfluence)
                        let halfSize = currentSize / 2.0
                        
                        // Path(ellipseIn:) is slightly faster natively than building an .addArc closure
                        let rect = CGRect(
                            x: dotCenter.x - halfSize,
                            y: dotCenter.y - halfSize,
                            width: currentSize,
                            height: currentSize
                        )
                        
                        context.fill(Path(ellipseIn: rect), with: .color(finalColor.opacity(alpha)))
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    GridPad(cursor: .zero, dragIntensity: 1.0, currentColor: .red)
}
