//
//  ColorPickerTests.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/17/26.
//

import Testing
import SwiftUI
@testable import ChromaPicker

@Suite("Color Picker Function Testing")
struct ColorPickerTests {

    @MainActor @Test("Tests a conversion of color to hsv.")
    func testColorToHsv() {
        let vm = ColorPickerVM()
        let sampleColor: Color = .white
        
        let (h,s,v,a) = vm.colorToHsv(color: sampleColor)
        
        #expect(h == 0.0)
        #expect(s == 0.0)
        #expect(v == 1.0)
        #expect(a == 1.0)
    }
    
    @MainActor @Test("Tests a conversion of hsv to color.")
    func testHsvToColor() {
        let vm = ColorPickerVM()
        var sampleColor: Color = .white
        
        let h: CGFloat = 0.79, s: CGFloat = 0.8, v: CGFloat = 1.0, a: CGFloat = 1.0
        
        vm.hsvToRgb(h: h, s: s, v: v, a: a, color: &sampleColor)
        
        let (nH, nS, nV, nA) =  vm.colorToHsv(color: sampleColor)
        
        #expect(nH == h)
        #expect(nS == s)
        #expect(nV == v)
        #expect(nA == a)
    }
}
