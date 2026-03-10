//
//  CircularHuePickerView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/5/26.
//

import SwiftUI

/**
    Generates a view that utilizes circular hue logic
    which can interacted with via a draggable
    cursor.
 */

internal struct CircularHuePickerView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var vm: ColorPickerVM
    @Binding var color: Color
    var isPortrait: Bool
    
    var height: CGFloat {
        return isPortrait ? 375.0 : 215.0
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15.0)
            .stroke(.gray, lineWidth: 0.5)
            .fill(.regularMaterial)
            .frame(maxWidth: .infinity, minHeight: 375)
            .overlay {
                GeometryReader { geo in
                    let cursorPosition = getGridCursorPosition(size: geo.size, for: color)
                    
                    ZStack(alignment: .topLeading) {
                        GridPad(
                            cursor: cursorPosition,
                            dragIntensity: vm.gridIntensity,
                            currentColor: color
                        )
                        
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
                            .scaleEffect(vm.pickerScale)
                            .position(cursorPosition)
                    }
                    .contentShape(Rectangle()) // Ensures the whole ZStack catches the drag
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged { newValue in
                                if !vm.hasTappedCursor {
                                    vm.hasTappedCursor = true
                                    Haptics.tap()
                                }
                                vm.setScaleUp(type: .color)
                                // Pass geo.size directly to the gesture math!
                                vm.picker(location: newValue.location, size: geo.size, color: &color)
                            }
                            .onEnded { _ in
                                vm.hasTappedCursor = false
                                vm.setScaleDown(type: .color)
                            }
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
            }
    }
    
    func getGridCursorPosition(size: CGSize, for color: Color) -> CGPoint {
        // Prevent math errors if the view hasn't sized itself yet
        guard size != .zero else { return .zero }
        
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let maxRadius = min(size.width * 0.85, size.height * 0.85) / 2.0
        
        // Extract HSV from the current color
        let (h, s, _, _) = vm.colorToHsv(color: color)
        
        let angle = h * 2.0 * .pi
        let currentRadius = maxRadius * s
        
        let x = center.x + (currentRadius * cos(angle))
        let y = center.y + (currentRadius * sin(angle))
        
        return CGPoint(x: x, y: y)
    }
}

#Preview {
    CircularHuePickerView(vm: ColorPickerVM(), color: .constant(.red), isPortrait: true)
}
