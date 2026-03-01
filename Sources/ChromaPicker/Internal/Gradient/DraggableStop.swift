//
//  DraggableStop.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import Foundation
import SwiftUI

internal struct DraggableStop: Identifiable, Equatable {
    var id = UUID()
    var stop: Gradient.Stop
    
    var location: CGFloat {
        stop.location
    }
    
//    static func <(lhs: DraggableStop, rhs: DraggableStop) -> Bool {
//        return lhs.location < rhs.location
//    }
}
