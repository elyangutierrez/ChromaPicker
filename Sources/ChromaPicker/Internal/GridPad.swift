//
//  GridPad.swift
//  ChromaPicker
//
//  Created by Assistant on 2/27/26.
//

import SwiftUI

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
            
            // Calculate the nearest grid intersection to the cursor for the "Crosshair"
            let nearestX = round((cursor.x - center.x) / spacing) * spacing
            let nearestY = round((cursor.y - center.y) / spacing) * spacing
            
            context.blendMode = .plusLighter
            
            for xOffset in stride(from: -maxRadius, through: maxRadius, by: spacing) {
                for yOffset in stride(from: -maxRadius, through: maxRadius, by: spacing) {
                    
                    let distanceToCenter = hypot(xOffset, yOffset)
                    
                    if distanceToCenter <= maxRadius {
                        let dotCenter = CGPoint(x: center.x + xOffset, y: center.y + yOffset)
                        let distanceToCursor = hypot(dotCenter.x - cursor.x, dotCenter.y - cursor.y)
                        
                        // 1. Calculate raw influence
                        let influenceRadius: CGFloat = 80.0
                        let rawInfluence = max(0.0, 1.0 - (distanceToCursor / influenceRadius))
                        let smoothInfluence = pow(rawInfluence, 2)
                        
                        // 2. Multiply influence by our dragging intensity
                        let activeInfluence = smoothInfluence * dragIntensity
                        let isOnAxis = abs(xOffset - nearestX) < 1.0 || abs(yOffset - nearestY) < 1.0
                        
                        // 3. Apply the dynamic math
                        let currentSize = dotSize + (activeInfluence * dotSize * 2.7)
                        
                        let edgeDistance = maxRadius - distanceToCenter
                        let edgeVignette = min(1.0, max(0.0, edgeDistance / 15.0))
                        
                        var alpha = 0.15
                        if isOnAxis { alpha = 0.15 + (0.35 * dragIntensity) }
                        alpha = max(alpha, activeInfluence)
                        
                        alpha *= edgeVignette
                        
                        let baseColor = colorScheme == .light ? Color.gray : Color.white
                        let finalColor = baseColor.mix(with: currentColor, by: activeInfluence)
                        
                        let rect = CGRect(
                            x: dotCenter.x - (currentSize / 2.0),
                            y: dotCenter.y - (currentSize / 2.0),
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
