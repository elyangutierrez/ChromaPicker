//
//  Accessibility.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/12/26.
//

import Foundation

internal struct Accessibility {
    static func getAccessibleColorName(h: Double, s: Double, v: Double) -> String {
        // 1. Handle Grays/Black/White (Low Saturation)
        if s < 0.1 {
            if v > 0.9 { return "White" }
            if v < 0.15 { return "Black" }
            return "Gray"
        }
        
        // 2. Determine base color by Hue (0.0 to 1.0)
        let hueDegrees = h * 360.0
        var colorName = ""
        
        switch hueDegrees {
        case 0...15, 345...360: colorName = "Red"
        case 15..<45: colorName = "Orange"
        case 45..<75: colorName = "Yellow"
        case 75..<165: colorName = "Green"
        case 165..<255: colorName = "Blue"
        case 255..<315: colorName = "Purple"
        case 315..<345: colorName = "Pink"
        default: colorName = "Color"
        }
        
        // 3. Add adjectives based on Saturation and Value
        var adjective = ""
        if s < 0.4 { adjective = "Pale " }
        else if s > 0.8 && v > 0.8 { adjective = "Vivid " }
        else if v < 0.5 { adjective = "Dark " }
        
        return "\(adjective)\(colorName)"
    }
}
