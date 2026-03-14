//
//  ChromaConfig.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/13/26.
//

import Foundation
import SwiftUI

public struct ChromaConfig: Sendable {
    public var supportsAlpha: Bool
    public var canSaveColors: Bool
    
    public init(
        supportsAlpha: Bool = true,
        canSaveColors: Bool = true
    ) {
        self.supportsAlpha = supportsAlpha
        self.canSaveColors = canSaveColors
    }
}

internal struct ChromaConfigKey: EnvironmentKey {
    static let defaultValue = ChromaConfig()
}
