//
//  ImageExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation
import SwiftUI

extension Image {
    
    /**
        A custom view modifiier that setups the styling for the header buttons.
        
        - Parameters:
            - colorScheme:  The devices current color system that is being used.
            - scale: The scale that wants to be applied to the button.
     
        - Returns: A new button style.
     */
    
    func pickerButtonStyle(colorScheme: ColorScheme, scale: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .font(.headline)
            .frame(width: 35, height: 35)
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
