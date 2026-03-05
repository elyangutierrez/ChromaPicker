//
//  ChromaSelection.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import Foundation
import SwiftUI

public protocol ChromaSelection {
    associatedtype V: View
    
    @ViewBuilder
    @MainActor
    func makePickerView(_ binding: Binding<Self>) -> V // make the view based on the type given
}
