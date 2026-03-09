//
//  ShapeExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/6/26.
//

import Foundation
import SwiftUI

extension Shape {
    
    /**
        A custom view modifiier that setups the styling for the draggable cursors.
        
        - Parameters:
            - color:  The color that wants to be applied.
            - size1: The size that wants to be applied to the outer circle.
            - size2: The size that wants to be applied to the inner circle.
            - colorScheme:  The devices current color system that is being used.
     
        - Returns: A new circle style for the draggable cursors.
     */
    
    func colorCircle(color: Color, size1: CGFloat, size2: CGFloat, colorScheme: ColorScheme) -> some View {
        self
            .fill(color.opacity(0.7).mix(with: colorScheme == .dark ? .white : .black, by: 0.3))
            .frame(width: size1, height: size1)
            .overlay {
                Circle()
                    .fill(color)
                    .frame(width: size2, height: size2)
            }
    }
}
