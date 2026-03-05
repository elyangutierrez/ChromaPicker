//
//  SwiftUIView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/4/26.
//

import SwiftUI

struct GradientStopsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var vm: GradientPickerVM
    
    var body: some View {
//        HStack {
//            Text("Stops")
//                .font(.title2.bold())
//            
//            Spacer()
//            
//            Button(action: {
//                Haptics.tap()
//                
//                withAnimation(.spring(duration: 0.3)) {
//                    vm.addStop()
//                }
//            }) {
//                ZStack {
//                    Image(systemName: "plus")
//                        .pickerButtonStyle(colorScheme: colorScheme, scale: 0.5)
//                }
//            }
//        }
        
        VStack(spacing: 15.0) {
            // Iterate over the bindings of our new editable wrapper array
            ForEach($vm.editableStops) { $item in
                GradientStopRow(
                    stop: $item.stop,
                    onSelect: {
                        
                        withAnimation(.spring(duration: 0.3)) {
                            vm.selectedId = item.id
                        }
                        
                        if let index = vm.editableStops.firstIndex(of: item) {
                            vm.selectedIndex = index
                        }
                    },
                    onRemove: {
                        withAnimation(.spring(duration: 0.3)) {
                            
                            vm.removeStop(id: item.id)
                        }
                    }
                )
                
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(vm.selectedId == item.id ? Color.blue : Color.clear, lineWidth: 2.0)
                )
                .onTapGesture {
                    
                    withAnimation(.spring(duration: 0.3)) {
                        vm.selectedId = item.id
                    }
                }
            }
        }

    }
}

#Preview {
    GradientStopsView(vm: GradientPickerVM())
}
