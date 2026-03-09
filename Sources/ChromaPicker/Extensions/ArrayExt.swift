//
//  ArrayExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import Foundation
import SwiftUI

extension Array: @MainActor ChromaSelection where Element == Gradient.Stop {
    
    /**
        Makes the view for the gradient picker only when the `Array`
        is consisted of `[Gradient.Stop]`.
     
        - Parameter binding: A `Binding` to an `[Gradient.Stop]`.
     
        - Returns: `GradientPickerView`
     */
    
    public func makePickerView(_ binding: Binding<Array<Gradient.Stop>>) -> some View {
        GradientPickerView(stops: binding)
    }
}
