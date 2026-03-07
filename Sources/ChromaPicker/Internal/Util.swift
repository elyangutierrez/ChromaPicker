//
//  Util.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import Foundation
import UIKit

/**
    Contains helper functions that are reusable
    in many different areas of the package.
 */

internal struct Util {
    
    /**
        Clamps the given value in the range of min and max.
     
        - Parameters:
            - value: Given value
            - minimum: The minimum of the value
            - maximum: The maximum of the value
        - Returns: A clamped value
     */
    
    static func clamp<T: Comparable>(_ value: T, min minimum: T, max maximum: T) -> T {
        return max(minimum, min(value, maximum))
    }
}
