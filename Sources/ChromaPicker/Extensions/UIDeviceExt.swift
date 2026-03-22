//
//  UIDeviceExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/22/26.
//

import Foundation
import UIKit

extension UIDevice {
    static var isIPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
