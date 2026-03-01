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
    
    @State private var selectedStop: Gradient.Stop?
    @State private var selectedIndex: Int?
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(.gray, lineWidth: 0.5)
                            .fill(LinearGradient(stops: stops, startPoint: .leading, endPoint: .trailing))
                            .frame(maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                        
                        VStack {
                            ForEach(0..<stops.count, id: \.self) { index in
                                
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                    }
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
                        ForEach(0..<stops.count, id: \.self) { index in
                            // Safe binding completely prevents crashes if a stop is deleted while scrolling
                            let safeBinding = Binding<Gradient.Stop>(
                                get: {
                                    guard index < stops.count else { return Gradient.Stop(color: .clear, location: 0) }
                                    return stops[index]
                                },
                                set: { newValue in
                                    guard index < stops.count else { return }
                                    stops[index] = newValue
                                }
                            )
                            
                            GradientStopRow(stop: safeBinding, onSelect: {
                                selectedIndex = index
                            }, onRemove: {
                                withAnimation(.spring(duration: 0.3)) {
                                    removeStop(index: index)
                                }
                            })
                            .onTapGesture {
                                selectedStop = nil
                                if index < stops.count { selectedStop = stops[index] }
                            }
                        }
                    }
                }
            }
            .padding()
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
                    set: { stops[index].color = $0 }
                )
                ColorPickerView(color: colorBinding)
            }
        }
        
    }
    
    func updateStopLocations() {
        
        if stops.isEmpty {
            return
        }
        
        let size = stops.count
        
        if size == 1 {
            stops[0].location = 0.0
            return
        }
        
        let valPerStop = 1.0 / Double(size - 1)
        let stopColors = stops.map { $0.color }
        
        var newStops: [Gradient.Stop] = []
        
        for index in 0..<size {
            newStops.append(
                Gradient.Stop(
                    color: stopColors[index],
                    location: valPerStop * Double(index)
                )
            )
        }
        
        stops = newStops
    }
    
    func addStop() {
        
        let rRed = Double.random(in: 0.0...1.0)
        let rGre = Double.random(in: 0.0...1.0)
        let rBlu = Double.random(in: 0.0...1.0)
        
        let rColor = Color(red: rRed, green: rGre, blue: rBlu)
        
        let newStop = Gradient.Stop(color: rColor, location: 1.0)
        stops.append(newStop)
        updateStopLocations()
    }
    
    func removeStop(index: Int) {
        if stops.isEmpty {
            return
        }
        
        stops.remove(at: index)
        updateStopLocations()
    }
    
    func reset() {
        stops = [.init(color: .white, location: 0.0), .init(color: .black, location: 1.0)]
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
