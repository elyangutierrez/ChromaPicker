//
//  File.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/4/26.
//

import Foundation
import SwiftUI

@Observable
final internal class GradientPickerVM {
    var isOrientationLocked: Bool = true
    var editableStops: [DraggableStop] = []
    var selectedStop: Gradient.Stop?
    var selectedIndex: Int?
    var selectedId: UUID?
    var locationInput: Double?
    var hexInput: String?
    var alphaInput: Double?
    var isShowingSheet: Bool = false
    
    func setEditableStops(stops: [Gradient.Stop]) {
        editableStops = stops.map { DraggableStop(stop: $0) }
        if let first = editableStops.first { selectedId = first.id }
    }
    
    func updateStopLocations() {
        if editableStops.isEmpty { return }
        
        let size = editableStops.count
        
        if size == 1 {
            editableStops[0].stop.location = 0.0
            return
        }
        
        let valPerStop = 1.0 / Double(size - 1)
        
        for index in 0..<size {
            let stopLoc = valPerStop * Double(index)
            editableStops[index].stop.location = Util.clamp(stopLoc, min: 0.0, max: 1.0)
        }
    }
    
    func addStop() {
        
        let rRed = Double.random(in: 0.0...1.0)
        let rGre = Double.random(in: 0.0...1.0)
        let rBlu = Double.random(in: 0.0...1.0)
        
        let rColor = Color(red: rRed, green: rGre, blue: rBlu)
        
        let newStop = Gradient.Stop(color: rColor, location: 1.0)
        
        let newDraggableStop = DraggableStop(stop: newStop)
        
        editableStops.append(newDraggableStop)
        
        if !isOrientationLocked {
            updateStopLocations()
        }
        
        selectedId = newDraggableStop.id
    }
    
    func removeStop(id: UUID) {
        guard editableStops.count > 1 else { return }
        
        if let index = editableStops.firstIndex(where: { $0.id == id }) {
            editableStops.remove(at: index)
            updateStopLocations()
            
            if selectedId == id {
                selectedId = nil
            }
        }
    }
    
    func reset() {
        
        guard !editableStops.isEmpty else { return }
        
        editableStops = []
        
        let newStops = [
            DraggableStop(stop: .init(color: .white, location: 0.0)),
            DraggableStop(stop: .init(color: .black, location: 1.0))
        ]
        
        editableStops = newStops
        
        if !editableStops.isEmpty {
            let first = editableStops.first!
            
            selectedId = first.id
        }
        
        updateStopLocations()
    }
}
