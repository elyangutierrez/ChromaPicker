//
//  GeometryReaderModifier.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/25/26.
//

/*
MIT License

Copyright (c) [2023] [George Elsham]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation
import SwiftUI


extension View {
    /// Read the geometry of the current view. Save the returned value in
    /// a `@State` variable, to be used anywhere within the view.
    ///
    /// - Parameter geometry: Geometry closure containing this view's geometry.
    /// - Returns: Modified view.
    func geometryReader(_ geometry: @escaping (GeometryProxy?) -> Void) -> some View {
        modifier(GeometryReaderModifier(geometry: geometry))
    }
}


fileprivate struct GeometryReaderModifier: ViewModifier {
    private struct GeometryPreferenceKey: PreferenceKey {
        static func reduce(value: inout GeometryProxy?, nextValue: () -> GeometryProxy?) {
            value = nextValue()
        }
    }
    
    private let geometry: (GeometryProxy?) -> Void
    
    init(geometry: @escaping (GeometryProxy?) -> Void) {
        self.geometry = geometry
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: GeometryPreferenceKey.self, value: geo)
                }
            )
            .onPreferenceChange(GeometryPreferenceKey.self) { geo in
                geometry(geo)
            }
    }
}


extension GeometryProxy: @retroactive Equatable {
    public static func == (lhs: GeometryProxy, rhs: GeometryProxy) -> Bool {
        lhs.frame(in: .global) == rhs.frame(in: .global)
    }
}
