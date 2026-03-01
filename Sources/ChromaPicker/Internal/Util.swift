//
//  File.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import Foundation

internal struct Util {
    static func clamp<T: Comparable>(_ value: T, min minimum: T, max maximum: T) -> T {
        return max(minimum, min(value, maximum))
    }
}
