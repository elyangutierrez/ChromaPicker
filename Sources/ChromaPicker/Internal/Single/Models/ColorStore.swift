//
//  ColorStore.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/4/26.
//

import Foundation
import SwiftUI

/**
    Saves all the colors that added by the user in the single color picker
    view until the end of the apps lifecycle.
 */

@Observable
@MainActor
final internal class ColorStore {
    static let shared = ColorStore()
    
    var savedColors: [Color] = []
    
    let MAXIMUM_AMOUNT = 15
    
    private init() { }
    
    /**
        Adds a new color to `savedColors`. To prevent ui cluttering,
        the maximum amount of colors that can be added is 15.
     
        - Parameter color: The current color that is being displayed which the user wants to add.
     */
    
    func addColor(color: Color) {
        guard !savedColors.contains(color) else { return }
        guard savedColors.count < MAXIMUM_AMOUNT else { return }
        
        savedColors.append(color)
    }
}
