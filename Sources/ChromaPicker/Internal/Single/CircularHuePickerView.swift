//
//  SwiftUIView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/5/26.
//

import SwiftUI

struct CircularHuePickerView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var vm: ColorPickerVM
    @Binding var color: Color
    var isPortrait: Bool
    
    var height: CGFloat {
        return isPortrait ? 375.0 : 175.0
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
                    let center = CGPoint(x: vm.pickerSize.width / 2.0, y: vm.pickerSize.height / 2.0)
                    vm.pickerCursor = CGPoint(x: center.x, y: center.y)
                }
            
            GridPad(cursor: vm.pickerCursor, dragIntensity: vm.gridIntesity, currentColor: color)
            
            Circle()
                .fill(color.opacity(0.7).mix(with: colorScheme == .dark ? .white : .black, by: 0.3))
                .frame(width: 28, height: 28)
                .overlay {
                    Circle()
                        .fill(color)
                        .frame(width: 16, height: 16)
                }
                .shadow(color: color.opacity(0.3), radius: 10.0)
                .shadow(color: color.opacity(0.3), radius: 10.0)
                .position(vm.pickerCursor)
                .scaleEffect(vm.pickerScale)
        }
    }
}

#Preview {
    CircularHuePickerView(vm: ColorPickerVM(), color: .constant(.red), isPortrait: true)
}
