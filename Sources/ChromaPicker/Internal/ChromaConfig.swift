//
//  ChromaConfig.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/13/26.
//

import Foundation
import SwiftUI

internal struct ChromaConfig: Sendable {
    public var supportsAlpha: Bool
    public var canSaveColors: Bool
    public var maxStopCount: Int
    
    init(
        supportsAlpha: Bool = true,
        canSaveColors: Bool = true,
        maxStopCount: Int = 10
    ) {
        self.supportsAlpha = supportsAlpha
        self.canSaveColors = canSaveColors
        self.maxStopCount = maxStopCount
    }
}

internal struct ChromaConfigKey: EnvironmentKey {
    static let defaultValue = ChromaConfig()
}
