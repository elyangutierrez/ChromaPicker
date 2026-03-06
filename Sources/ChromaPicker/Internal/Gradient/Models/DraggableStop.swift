//
//  DraggableStop.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import Foundation
import SwiftUI

internal struct DraggableStop: Equatable, Identifiable, Comparable {
    var id = UUID()
    var stop: Gradient.Stop
    
    var loc: CGFloat {
        return stop.location
    }
    
    static func <(lhs: DraggableStop, rhs: DraggableStop) -> Bool {
        return lhs.loc < rhs.loc
    }
}
