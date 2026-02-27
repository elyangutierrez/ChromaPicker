//
//  ImageExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation
import SwiftUI

internal extension Image {
    func pickerButtonStyle(colorScheme: ColorScheme, scale: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .font(.headline)
            .frame(width: 30, height: 30)
            .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
            .scaleEffect(scale)
            .background(
                Circle()
                    .fill(.clear)
                    .glassEffect(
                        .regular.tint(
                            Color(white: colorScheme == .dark ? 0.19 : 0.93)
                        )
                    )
            )
    }
}
