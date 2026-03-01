//
//  File.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import Foundation
import SwiftUI

extension Gradient.Stop {
    func formattedLocation() -> CGFloat {
        return Util.clamp(self.location * 100.0, min: 0.0, max: 100.0)
    }
}
