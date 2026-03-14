//
//  GradientPickerView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import SwiftUI

/**
    Generates the view for the gradient picker view.
 */

internal struct GradientPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var vm: GradientPickerVM = GradientPickerVM()
    
    @Binding var stops: [Gradient.Stop]
    
    var buttonBackgroundColor: Color {
        return Color(white: colorScheme == .dark ? 0.19 : 0.93)
    }
    
    var body: some View {
        AdaptiveLayout(
            portrait: {
                ScrollView(.vertical) {
                    VStack(spacing: 15.0) {
                        VStack {
                            GradientButtonHeaderView(vm: vm)
                        }
                        
                        Spacer()
                            .frame(height: 25)
                        
                        VStack {
                            GradientSliderBar(editableStops: $vm.editableStops, selectedId: $vm.selectedId)
                                .frame(maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                            .frame(height: 25)
                        
                        VStack {
                            HStack {
                                Text("Stops")
                                    .font(.title2.bold())
                                
                                Spacer()
                                
                                Button(action: {
                                    Haptics.tap()
                                    
                                    withAnimation(.spring(duration: 0.3)) {
                                        vm.addStop()
                                    }
                                }) {
                                    Image(systemName: "plus")
                                        .pickerButtonStyle(colorScheme: colorScheme, scale: 0.5)
                                }
                            }
                            
                            VStack(spacing: 20) {
                                GradientStopsView(vm: vm)
                            }
                        }
                    }
                    .padding()
                }
            },
            landscape: {
                VStack(spacing: 25.0) {
                    VStack {
                        GradientButtonHeaderView(vm: vm)
                    }
                    
                    HStack(spacing: 35.0) {
                        VStack {
                            GradientSliderBar(editableStops: $vm.editableStops, selectedId: $vm.selectedId)
                                .frame(maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                                .padding(.horizontal)
                        }
                        
                        VStack {
                            HStack {
                                Text("Stops")
                                    .font(.title2.bold())
                                
                                Spacer()
                                
                                Button(action: {
                                    Haptics.tap()
                                    
                                    withAnimation(.spring(duration: 0.3)) {
                                        vm.addStop()
                                    }
                                }) {
                                    Image(systemName: "plus")
                                        .pickerButtonStyle(colorScheme: colorScheme, scale: 0.5)
                                }
                            }
                            
                            ScrollView {
                                VStack(spacing: 20) {
                                    GradientStopsView(vm: vm)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        )
        .onAppear {
            vm.setEditableStops(stops: stops)
        }
        .onChange(of: vm.editableStops) { _, newEditableStops in
            stops = newEditableStops.map { $0.stop }.sorted { $0.location < $1.location }
            
            // checks if the stop is out of order
            var isOutOfOrder = false
            if newEditableStops.count > 1 {
                for i in 0..<(newEditableStops.count - 1) {
                    if newEditableStops[i].stop.location > newEditableStops[i + 1].stop.location {
                        isOutOfOrder = true
                        break
                    }
                }
            }
            
            // triggers change when a stop is out of order
            if isOutOfOrder {
                withAnimation(.spring(duration: 0.3)) {
                    vm.editableStops.sort { $0.stop.location < $1.stop.location }
                }
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            Spacer()
                .frame(height: 30)
        }
        .sheet(isPresented: Binding(
            get: { vm.selectedIndex != nil },
            set: { if !$0 { vm.selectedIndex = nil } }
        ), onDismiss: {
            vm.selectedIndex = nil
        }) {
            if let index = vm.selectedIndex {
                let colorBinding = Binding<Color>(
                    get: { vm.editableStops[index].stop.color },
                    set: {
                        vm.editableStops[index].stop.color = $0
                    }
                )
                ColorPickerView(color: colorBinding)
                    .presentationDetents([.fraction(0.9)])
            }
        }
    }
}

#Preview("Default") {
    
    @Previewable @State var stops: [Gradient.Stop] =
    [
        .init(color: .red, location: 0.2),
        .init(color: .blue, location: 0.5),
        .init(color: .green, location: 0.8)
    ]
    
    GradientPickerView(stops: $stops)
}
