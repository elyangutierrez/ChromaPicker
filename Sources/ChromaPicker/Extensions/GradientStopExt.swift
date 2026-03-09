//
//  GradientStopExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import Foundation
import SwiftUI

extension Gradient.Stop {
    
    /**
        Formats the location in a way that is displayed on a scale from 0.0 to 100.0.
     
        - Returns: A new value over  clamped in the range of 0.0 to 100.0.
     */
    
    func formattedLocation() -> CGFloat {
        return Util.clamp(self.location * 100.0, min: 0.0, max: 100.0)
    }
}
