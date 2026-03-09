//
//  UIColorExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation
import UIKit

extension UIColor {
    
    /**
        Converts the `UIColor` to an `optional` hex string.
     
        - Parameter includeAlpha: A boolean that determines if the alpha wants to be applied.
        
        - Returns: An `optional` hex string.
     */
    
    func toHexString(includeAlpha: Bool = false) -> String? {
            
            guard let components = self.cgColor.components else {
                return nil
            }
            
            
            let red = Int(components[0] * 255.0)
            let green = Int(components[1] * 255.0)
            let blue = Int(components[2] * 255.0)
            
            let hexString: String
            if includeAlpha, let alpha = components.last {
                let alphaValue = Int(alpha * 255.0)
                
                hexString = String(format: "#%02X%02X%02X%02X", red, green, blue, alphaValue)
            } else {
               
                hexString = String(format: "#%02X%02X%02X", red, green, blue)
            }
            
            return hexString
        }
}
