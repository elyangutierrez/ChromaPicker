//
//  UtilTests.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/17/26.
//

import Testing
@testable import ChromaPicker

@Suite("Util Function Testing")
struct UtilTests {

    @Test
    func testOutOfBoundsClamp() {
        #expect(Util.clamp(-5, min: 0, max: 10) == 0)
    }
    
    @Test
    func testInBoundsClamp() {
        #expect(Util.clamp(3, min: 0, max: 5) == 3)
    }
    
    @Test
    func testOnBoundaryClamp() {
        #expect(Util.clamp(0, min: 0, max: 5) == 0)
    }
}
