//
//  EnvironValuesExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/13/26.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var chromaConfig: ChromaConfig {
        get { self[ChromaConfigKey.self] }
        set { self[ChromaConfigKey.self] = newValue }
    }
}
