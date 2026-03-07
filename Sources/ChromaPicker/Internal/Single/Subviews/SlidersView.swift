//
//  SlidersView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/5/26.
//

import SwiftUI

internal struct SlidersView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var vm: ColorPickerVM
    @Binding var color: Color
    var isPortrait: Bool
    
    var spacing: CGFloat {
        return isPortrait ? 20.0 : 35.0
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            ZStack {
                RoundedRectangle(cornerRadius: 15.0)
                    .stroke(.gray, lineWidth: 0.5)
                    .fill(
                        LinearGradient(colors: [.black, color], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(height: 32)
                    .overlay {
                        GeometryReader { geo in
                            let cursorRadius: CGFloat = 15.0
                            let usableWidth = geo.size.width - (cursorRadius * 2)
                            let xPos = cursorRadius + (usableWidth * vm.value)
                            
                            Circle()
                                .colorCircle(color: color, size1: cursorRadius * 2.0, size2: 18, colorScheme: colorScheme)
                                .position(x: xPos, y: geo.size.height / 2.0)
                                .scaleEffect(vm.valueScale)
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged { newValue in
                                
                                if !vm.hasTappedCursor {
                                    vm.hasTappedCursor = true
                                    Haptics.tap()
                                }
                                
                                vm.setScaleUp(type: .value)
                                vm.slider(location: newValue.location, type: .value, color: &color)
                            }
                            .onEnded { _ in
                                vm.hasTappedCursor = false
                                vm.setScaleDown(type: .value)
                            }
                    )
                    .geometryReader { g in
                        vm.valueSize = g?.size ?? .zero
                    }
            }
            
            ZStack {
                Checkerboard(color: color)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    .frame(height: 32)
                    .background(
                        LinearGradient(colors: [.white.opacity(0.0), color], startPoint: .leading, endPoint: .trailing)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    )
                    .overlay {
                        GeometryReader { geo in
                            let cursorRadius: CGFloat = 15.0
                            let usableWidth = geo.size.width - (cursorRadius * 2)
                            let xPos = cursorRadius + (usableWidth * vm.alpha)
                            
                            Circle()
                                .colorCircle(color: color, size1: cursorRadius * 2.0, size2: 18, colorScheme: colorScheme)
                                .position(x: xPos, y: geo.size.height / 2.0)
                                .scaleEffect(vm.alphaScale)
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged { newValue in
                                
                                if !vm.hasTappedCursor {
                                    vm.hasTappedCursor = true
                                    Haptics.tap()
                                }
                                
                                vm.setScaleUp(type: .alpha)
                                vm.slider(location: newValue.location, type: .alpha, color: &color)
                            }
                            .onEnded { _ in
                                vm.hasTappedCursor = false
                                vm.setScaleDown(type: .alpha)
                            }
                    )
                    .geometryReader { g in
                        vm.alphaSize = g?.size ?? .zero
                    }
            }
        }
    }
}

#Preview {
    SlidersView(vm: ColorPickerVM(), color: .constant(.red), isPortrait: false)
}
