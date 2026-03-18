//
//  GradientPickerTests.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/18/26.
//

import Testing
import SwiftUI
@testable import ChromaPicker

@Suite("Gradient Picker Function Testing")
struct GradientPickerTests {

    @Test("Tests the initial setup of stops.")
    func testSetEditableStops() {
        let vm = GradientPickerVM()
        let initialStops: [Gradient.Stop] = [
            .init(color: .red, location: 0.3),
            .init(color: .blue, location: 0.7)
        ]
        
        vm.setEditableStops(stops: initialStops)
        
        #expect(vm.editableStops.count == 2)
        
        try? #require(vm.editableStops.first != nil)
        
        #expect(vm.editableStops.first!.stop.color == .red)
        #expect(vm.selectedId == vm.editableStops.first!.id)
    }
    
    @Test("Tests the addition of a new stop.")
    func testAddStop() async throws {
        let vm = GradientPickerVM()
        let initialCount = vm.editableStops.count
        
        #expect(initialCount == 0)
        
        vm.addStop()
        
        #expect(vm.editableStops.count != initialCount)
    }
    
    @Test("Tests the removal of a stop.")
    func testRemoveStop() async throws {
        let vm = GradientPickerVM()
        let initialStops: [Gradient.Stop] = [
            .init(color: .red, location: 0.3),
            .init(color: .blue, location: 0.7)
        ]
        
        let initialCount = initialStops.count
        
        vm.setEditableStops(stops: initialStops)
        
        try? #require(vm.editableStops.first != nil)
        
        let stopToRemove = vm.editableStops.first!
        
        vm.removeStop(id: stopToRemove.id)
        
        #expect(vm.editableStops.count != initialCount)
    }
    
    @Test("Tests the reset of stops.")
    func testReset() async throws {
        let vm = GradientPickerVM()
        let initialStops: [Gradient.Stop] = [
            .init(color: .red, location: 0.3),
            .init(color: .blue, location: 0.7)
        ]
        
        vm.setEditableStops(stops: initialStops)
        
        vm.reset()
        
        for i in 0..<vm.editableStops.count {
            #expect(initialStops[i] != vm.editableStops[i].stop)
        }
    }
}
