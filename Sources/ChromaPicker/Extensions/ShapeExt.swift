//
//  ShapeExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/6/26.
//

import Foundation
import SwiftUI

extension Shape {
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
