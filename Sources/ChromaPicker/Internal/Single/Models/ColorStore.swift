//
//  ColorStore.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/4/26.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final internal class ColorStore {
    static let shared = ColorStore()
    
    var savedColors: [Color] = []
    
    private init() { }
    
    func addColor(color: Color) {
        guard !savedColors.contains(color) else { return }
        guard savedColors.count < 15 else { return }
        
        savedColors.append(color)
    }
}
