//
//  AdaptiveLayout.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/4/26.
//

import SwiftUI

/**
    Generates an adaptive layout with the types provided.
 */

internal struct AdaptiveLayout<Portrait: View, Landscape: View>: View {
    @ViewBuilder
    var portrait: () -> Portrait
    
    @ViewBuilder
    var landscape: () -> Landscape
    
    var body: some View {
        GeometryReader { g in
            if g.size.width > g.size.height {
                landscape()
            } else {
                portrait()
            }
        }
    }
}
