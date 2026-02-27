//
//  ColorModel.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation

internal enum ColorModel: String, CaseIterable, Comparable {
    case hex = "Hex"
    case rgb = "RGB"
    case hsv = "HSV"
    
    var sortOrder: Int {
        switch self {
        case .hex:
            1
        case .rgb:
            3
        case .hsv:
            2
        }
    }
    
    static func <(lhs: ColorModel, rhs: ColorModel) -> Bool {
        return lhs.sortOrder < rhs.sortOrder
    }
}
