//
//  ColorExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import Foundation
import SwiftUI

extension Color: @MainActor ChromaSelection {
    
    /**
        Makes the view for the color picker only when selection is
        a `Color`.
     
        - Parameter binding: A `Binding` to an `Color`.
     
        - Returns: `ColorPickerView`
     */
    
    public func makePickerView(_ binding: Binding<Color>) -> some View {
        ColorPickerView(color: binding)
    }
    
    /**
        A custom initalizer that allows for hex parsing and
        creates a new color from that parsing.
     */
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
