//
//  StopCursorShape.swift
//  ChromaPicker
//
//  Created by Assistant on 2/28/26.
//

import SwiftUI

internal struct StopCursorShape: Shape {
    var cornerRadius: CGFloat = 16.0
        var tailWidth: CGFloat = 24.0
        var tailHeight: CGFloat = 16.0
        
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // The bottom of the rounded rectangle (above the tail)
        let rectBottom = rect.maxY - tailHeight
        
        // 1. Start at Top-Left
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        
        // 2. Top Edge & Top-Right Corner
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )
        
        // 3. Right Edge & Bottom-Right Corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rectBottom - cornerRadius))
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rectBottom - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )
        
        // 4. Bottom Edge (Right side) & The Tail
        path.addLine(to: CGPoint(x: rect.midX + (tailWidth / 2.0), y: rectBottom))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY)) // The tip of the tail
        path.addLine(to: CGPoint(x: rect.midX - (tailWidth / 2.0), y: rectBottom))
        
        // 5. Bottom Edge (Left side) & Bottom-Left Corner
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rectBottom))
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rectBottom - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        // 6. Left Edge & Top-Left Corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        path.closeSubpath()
        return path
    }
}
