//
//  SwiftUIView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/5/26.
//

import SwiftUI

internal struct CircularHuePickerView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var vm: ColorPickerVM
    @Binding var color: Color
    var isPortrait: Bool
    
    var height: CGFloat {
        return isPortrait ? 375.0 : 215.0
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15.0)
                .stroke(.gray, lineWidth: 0.5)
                .fill(.regularMaterial)
                .frame(maxWidth: .infinity, minHeight: height)
                .gesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged { newValue in
                            if !vm.hasTappedCursor {
                                vm.hasTappedCursor = true
                                Haptics.tap()
                            }
                            
                            vm.setScaleUp(type: .color)
                            vm.picker(location: newValue.location, color: &color)
                        }
                        .onEnded { _ in
                            vm.hasTappedCursor = false
                            vm.setScaleDown(type: .color)
                        }
                )
                .geometryReader { g in
                    vm.pickerSize = g?.size ?? .zero
                }
                .onChange(of: vm.pickerSize) {
                    vm.setInitialPickerCursor(color: &color)
                }
            
            GridPad(cursor: vm.pickerCursor, dragIntensity: vm.gridIntesity, currentColor: color)
            
            Circle()
                .colorCircle(color: color, size1: 28, size2: 16, colorScheme: colorScheme)
                .shadow(color: color.opacity(0.3), radius: 10.0)
                .shadow(color: color.opacity(0.3), radius: 10.0)
                .scaleEffect(vm.pickerScale)
                .position(vm.pickerCursor)
        }
    }
}

#Preview {
    CircularHuePickerView(vm: ColorPickerVM(), color: .constant(.red), isPortrait: true)
}
