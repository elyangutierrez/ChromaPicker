//
//  SwiftUIView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import SwiftUI

struct GradientSliderBar: View {
    @Binding var editableStops: [DraggableStop]
    @Binding var selectedId: UUID?
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                
                // 1. The Live Gradient Background
                let sortedStops = editableStops.map { $0.stop }.sorted { $0.location < $1.location }
                
                RoundedRectangle(cornerRadius: 10.0)
                    .stroke(.gray, lineWidth: 0.5)
                    .fill(LinearGradient(stops: sortedStops, startPoint: .leading, endPoint: .trailing))
                    .frame(height: 55)
                    // Push the bar down by 25 points so there is room for the pins inside the frame!
                    .offset(y: 25)
                
                // 2. The Interactive Pins
                ForEach($editableStops) { $item in
                    StopCursorView(isSelected: selectedId == item.id, color: item.stop.color)
                        // Guarantee the exact 32x40 frame of the pin catches touches
                        .contentShape(Rectangle())
                        // Attach the gesture BEFORE positioning!
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("GradientBarSpace"))
                                .onChanged { value in
                                    if selectedId != item.id {
                                        selectedId = item.id
                                        // Haptics.selection() // Add your tick here if you want!
                                    }
                                    
                                    let newLoc = value.location.x / geo.size.width
                                    item.stop.location = Util.clamp(newLoc, min: 0.0, max: 1.0)
                                }
                        )
                        // Position the pin exactly in the available 25-point space above the bar
                        .position(
                            x: item.stop.location * geo.size.width,
                            y: 25 // The bottom of the pin will touch the top of the bar
                        )
                }
            }
            .coordinateSpace(name: "GradientBarSpace")
        }
        // Total height: 25 for pins + 55 for bar. Nothing is out of bounds now!
        .frame(height: 80)
    }
}

#Preview {
    GradientSliderBar(
        editableStops: .constant(
            [
                DraggableStop(stop: Gradient.Stop(color: .red, location: 0.3)),
                DraggableStop(stop: Gradient.Stop(color: .blue, location: 0.8))
            ]),
        selectedId: .constant(UUID()))
    .padding(.horizontal)
}
