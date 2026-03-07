//
//  ChromaSelection.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import Foundation
import SwiftUI

/**
    Uses the type that conforms to this protocol to
    create one of the picker views as long
    as the type is either a `Color` or `[Gradient.Stop]`.

 */

public protocol ChromaSelection {
    associatedtype V: View
    
    /**
        Makes the view based off of the type given.
     
        - Parameter binding: `Binding` to either `Color` or `[Gradient.Stop]`.
     
        - Returns: A picker view based off of the given type.
     */
    
    @ViewBuilder
    @MainActor
    func makePickerView(_ binding: Binding<Self>) -> V
}
