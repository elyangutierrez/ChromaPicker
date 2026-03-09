//
//  PickerType.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/25/26.
//

import Foundation

/**
    Represents the picker types that the user can select from
    when interacting with ui.
 */

internal enum PickerType: CaseIterable {
    case color
    case value
    case alpha
}
