//
//  Haptics.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation
import UIKit

/**
    Handles any logic regarding haptics.
 */

final internal class Haptics {
    
    @MainActor
    static func tap(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.impactOccurred()
    }
    
    @MainActor
    static func boundary(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
        let impact = UIImpactFeedbackGenerator(style: style)
        impact.impactOccurred()
    }
}
