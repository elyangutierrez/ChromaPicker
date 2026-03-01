//
//  GradientPickerView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import SwiftUI

struct GradientPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var editableStops: [DraggableStop] = []
    @State private var selectedStop: Gradient.Stop?
    @State private var selectedIndex: Int?
    @State private var selectedId: UUID?
    @State private var locationInput: Double?
    @State private var hexInput: String?
    @State private var alphaInput: Double?
    @State private var isShowingSheet: Bool = false
    
    @Binding var stops: [Gradient.Stop]
    
    var buttonBackgroundColor: Color {
        return Color(white: colorScheme == .dark ? 0.19 : 0.93)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15.0) {
                VStack {
                    HStack {
                        Button(action: {
                            Haptics.tap()
                            withAnimation(.spring(duration: 0.3)) {
                                reset()
                            }
                        }) {
                            ZStack {
                                Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                                    .pickerButtonStyle(colorScheme: colorScheme, scale: 0.7)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Haptics.tap()
                            dismiss()
                        }) {
                            ZStack {
                                Image(systemName: "xmark")
                                    .pickerButtonStyle(colorScheme: colorScheme, scale: 0.5)
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 25)
                
                VStack {
                    GradientSliderBar(editableStops: $editableStops, selectedId: $selectedId)
                        .frame(maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                }
                
                Spacer()
                    .frame(height: 25)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Stops")
                            .font(.title2.bold())
                        
                        Spacer()
                        
                        Button(action: {
                            Haptics.tap()
                            
                            withAnimation(.spring(duration: 0.3)) {
                                addStop()
                            }
                        }) {
                            ZStack {
                                Image(systemName: "plus")
                                    .pickerButtonStyle(colorScheme: colorScheme, scale: 0.5)
                            }
                        }
                    }
                    
                    VStack(spacing: 15.0) {
                        // Iterate over the bindings of our new editable wrapper array
                        ForEach($editableStops) { $item in
                            
                            GradientStopRow(
                                stop: $item.stop, // Bind directly to the wrapped Gradient.Stop
                                onSelect: {
                                    // Set the active UUID when they tap the color button
                                    withAnimation(.spring(duration: 0.3)) {
                                        selectedId = item.id
                                    }
                                    
                                    if let index = editableStops.firstIndex(of: item) {
                                        selectedIndex = index
                                    }
                                },
                                onRemove: {
                                    withAnimation(.spring(duration: 0.3)) {
                                        // Find and remove this specific item by its UUID
                                        removeStop(id: item.id)
                                    }
                                }
                            )
                            // Highlight the row if it matches the actively selected pin!
                            .overlay(
                                RoundedRectangle(cornerRadius: 5.0)
                                    .stroke(selectedId == item.id ? Color.blue : Color.clear, lineWidth: 2.0)
                            )
                            .onTapGesture {
                                // Also select the row if they just tap anywhere on it
                                withAnimation(.spring(duration: 0.3)) {
                                    selectedId = item.id
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            setEditableStops()
        }
        .onChange(of: editableStops) { _, newEditableStops in
            stops = newEditableStops.map { $0.stop }.sorted { $0.location < $1.location }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            Spacer()
                .frame(height: 30)
        }
        .sheet(isPresented: Binding(
            get: { selectedIndex != nil },
            set: { if !$0 { selectedIndex = nil } }
        ), onDismiss: {
            selectedIndex = nil
        }) {
            if let index = selectedIndex {
                let colorBinding = Binding<Color>(
                    get: { stops[index].color },
                    set: {
                        stops[index].color = $0
                        editableStops[index].stop.color = $0
                    }
                )
                ColorPickerView(color: colorBinding)
            }
        }
        
    }
    
    func setEditableStops() {
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
        updateStopLocations()
        
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
        editableStops = []
        
        if !editableStops.isEmpty {
            let first = editableStops.first!
            
            selectedId = first.id
        }
        
        updateStopLocations()
    }
}

#Preview {
    
    @Previewable @State var stops: [Gradient.Stop] =
    [
        .init(color: .red, location: 0.2),
        .init(color: .blue, location: 0.5),
        .init(color: .green, location: 0.8)
    ]
    
    GradientPickerView(stops: $stops)
}
