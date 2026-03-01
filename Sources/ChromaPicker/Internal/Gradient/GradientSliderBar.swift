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
                
                let sortedStops = editableStops.map { $0.stop }.sorted { $0.location < $1.location }
                
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(LinearGradient(stops: sortedStops, startPoint: .leading, endPoint: .trailing))
                    .frame(height: 55)
                    .offset(y: 25)
                
                ForEach($editableStops) { $item in
                    StopCursorView(isSelected: selectedId == item.id, color: item.stop.color)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("GradientBarSpace"))
                                .onChanged { value in
                                    if selectedId != item.id {
                                        withAnimation(.spring(duration: 0.3)) {
                                            selectedId = item.id
                                        }
                                    }
                                    
                                    let newLoc = value.location.x / geo.size.width
                                    item.stop.location = Util.clamp(newLoc, min: 0.0, max: 1.0)
                                }
                                .onEnded { _ in
                                    withAnimation(.spring(duration: 0.3)) {
                                        selectedId = nil
                                    }
                                }
                        )
                        .position(
                            x: item.stop.location * geo.size.width,
                            y: 25
                        )
                }
            }
            .coordinateSpace(name: "GradientBarSpace")
        }
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
