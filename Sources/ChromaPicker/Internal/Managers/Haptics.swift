//
//  Haptics.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation
import UIKit

internal final class Haptics {
    @MainActor
    static func button() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}
