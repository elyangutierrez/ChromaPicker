//
//  ColorExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import Foundation
import SwiftUI

extension Color: ChromaSelection {
    public func makePickerView(binding: Binding<Color>) -> some View {
        Text("Single Color")
    }
}
