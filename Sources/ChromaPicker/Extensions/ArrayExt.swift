//
//  ArrayExt.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import Foundation
import SwiftUI

extension Array: ChromaSelection where Element == Gradient.Stop {
    public func makePickerView(_ binding: Binding<Array<Gradient.Stop>>) -> some View {
        Text("Multiple Colors")
    }
}
