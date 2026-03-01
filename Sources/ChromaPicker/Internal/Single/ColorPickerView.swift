//
//  ColorPickerView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/24/26.
//

import SwiftUI

internal struct ColorPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var vm: ColorPickerVM = ColorPickerVM()
    
    @Binding var color: Color
    
    var buttonBackgroundColor: Color {
        return Color(white: colorScheme == .dark ? 0.19 : 0.93)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            
            VStack(spacing: 15.0) {
                
                HStack {
                    
                    HStack(spacing: 10.0) {
                        Button(action: {
                            Haptics.tap()
                            withAnimation(.spring(duration: 0.3)) {
                                vm.reset(color: &color)
                            }
                        }) {
                            ZStack {
                                Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                                    .pickerButtonStyle(colorScheme: colorScheme, scale: 0.7)
                            }
                        }
                        
                        Button(action: {
                            Haptics.tap()
                            withAnimation(.spring(duration: 0.3)) {
                                vm.shuffle(color: &color)
                            }
                        }) {
                            ZStack {
                                Image(systemName: "shuffle")
                                    .pickerButtonStyle(colorScheme: colorScheme, scale: 0.6)
                            }
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
                
                VStack(spacing: 25) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(.gray, lineWidth: 0.5)
                            .fill(.regularMaterial)
                            .frame(maxWidth: .infinity, minHeight: 375)
                            .gesture(
                                DragGesture(minimumDistance: 0.0)
                                    .onChanged { newValue in
                                        
//                                        vm.setGridIntensity(isMoving: true)
                                        
                                        if !vm.hasTappedCursor {
                                            vm.hasTappedCursor = true
                                            Haptics.tap()
                                        }
                                        
                                        vm.setScaleUp(type: .color)
                                        vm.picker(location: newValue.location, color: &color)
                                    }
                                    .onEnded { _ in
                                        
//                                        vm.setGridIntensity(isMoving: false)
                                        
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
                    
                    VStack {
                        VStack(spacing: 20) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15.0)
                                    .stroke(.gray, lineWidth: 0.5)
                                    .fill(
                                        LinearGradient(colors: [.black, color], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .frame(height: 32)
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
                                        
                                        let horizontalInset = vm.valueSize.width * 0.04
                                        
                                        let usableWidth = vm.valueSize.width - (horizontalInset * 2.0)
                                        
                                        let cursorX = horizontalInset + (usableWidth * vm.value)
                                        let cursorY = vm.valueSize.height / 2.0
                                        
                                        vm.valueCursor = CGPoint(x: cursorX, y: cursorY)
                                    }
                                
                                Circle()
                                    .fill(color.opacity(0.7).mix(with: colorScheme == .dark ? .white : .black, by: 0.3))
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 18, height: 18)
                                    }
                                    .position(vm.valueCursor)
                                    .scaleEffect(vm.valueScale)
                            }
                            
                            ZStack {
                                Checkerboard(color: color)
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    .frame(height: 32)
                                    .background(
                                        LinearGradient(colors: [.white.opacity(0.0), color], startPoint: .leading, endPoint: .trailing)
                                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    )
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
                                        
                                        let horizontalInset = vm.alphaSize.width * 0.04
                                        
                                        let usableWidth = vm.alphaSize.width - (horizontalInset * 2.0)
                                        
                                        let cursorX = horizontalInset + (usableWidth * vm.alpha)
                                        let cursorY = vm.alphaSize.height / 2.0
                                        
                                        vm.alphaCursor = CGPoint(x: cursorX, y: cursorY)
                                    }
                            
                                Circle()
                                    .fill(color.opacity(0.7).mix(with: colorScheme == .dark ? .white : .black, by: 0.3))
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 18, height: 18)
                                    }
                                    .position(vm.alphaCursor)
                                    .scaleEffect(vm.alphaScale)
                            }

                        }
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            VStack {
                                Picker("", selection: $vm.colorModel) {
                                    ForEach(ColorModel.allCases.sorted(), id: \.self) { model in
                                        Text(model.rawValue)
                                    }
                                }
                                .labelsHidden()
                                .tint(colorScheme == .light ? .black : .white)
                                .background(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 1)
                                        .fill(Color.clear)
                                        .frame(height: 35)
                                )
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                if case .hex = vm.colorModel {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(.regularMaterial)
                                        .frame(width: 100, height: 35)
                                        .overlay {
                                            VStack(alignment: .center) {
                                                TextField("", text: Binding(
                                                    get: { vm.hexValue },
                                                    set: { newValue in
                                                        if !(newValue.count > 0 && newValue.count < 8) {
                                                            vm.hexValue = "#FFFFFF"
                                                        } else if newValue.first != "#" {
                                                            vm.hexValue = "#FFFFFF"
                                                        } else {
                                                            vm.hexValue = newValue
                                                        }
                                                    })
                                                )
                                                .tint(colorScheme == .dark ? .white : .black)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                                .onSubmit {
                                                    vm.updateColorFromInputs(color: &color)
                                                }
                                            }
                                        }
                                } else {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(.regularMaterial)
                                        .frame(width: 60, height: 35)
                                        .overlay {
                                            VStack(alignment: .center) {
                                                TextField("", value: Binding(
                                                    get: { vm.textboxOne },
                                                    set: { newValue in
                                                        switch vm.colorModel {
                                                        case .hsv:
                                                            if newValue >= 0.0 && newValue <= 360.0  {
                                                                vm.textboxOne = newValue
                                                            } else {
                                                                vm.textboxOne = 360.0
                                                            }
                                                        case .rgb:
                                                            if newValue >= 0.0 && newValue <= 255.0  {
                                                                vm.textboxOne = newValue
                                                            } else {
                                                                vm.textboxOne = 255.0
                                                            }
                                                        default:
                                                            return
                                                        }
                                                    }),
                                                    format: .number
                                                )
                                                .tint(colorScheme == .dark ? .white : .black)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                                .onSubmit {
                                                    vm.updateColorFromInputs(color: &color)
                                                }
                                            }
                                        }
                                    
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(.regularMaterial)
                                        .frame(width: 60, height: 35)
                                        .overlay {
                                            VStack(alignment: .center) {
                                                TextField("", value: Binding(
                                                    get: { vm.textboxTwo },
                                                    set: { newValue in
                                                        switch vm.colorModel {
                                                        case .hsv:
                                                            if newValue >= 0.0 && newValue <= 100.0  {
                                                                vm.textboxTwo = newValue
                                                            } else {
                                                                vm.textboxTwo = 100.0
                                                            }
                                                        case .rgb:
                                                            if newValue >= 0.0 && newValue <= 255.0  {
                                                                vm.textboxTwo = newValue
                                                            } else {
                                                                vm.textboxTwo = 255.0
                                                            }
                                                        default:
                                                            return
                                                        }
                                                    }),
                                                    format: .number
                                                )
                                                .tint(colorScheme == .dark ? .white : .black)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                                .onSubmit {
                                                    vm.updateColorFromInputs(color: &color)
                                                }
                                            }
                                        }
                                    
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(.regularMaterial)
                                        .frame(width: 60, height: 35)
                                        .overlay {
                                            VStack(alignment: .center) {
                                                TextField("", value: Binding(
                                                    get: { vm.textboxThree },
                                                    set: { newValue in
                                                        switch vm.colorModel {
                                                        case .hsv:
                                                            if newValue >= 0.0 && newValue <= 100.0  {
                                                                vm.textboxThree = newValue
                                                            } else {
                                                                vm.textboxThree = 100.0
                                                            }
                                                        case .rgb:
                                                            if newValue >= 0.0 && newValue <= 255.0  {
                                                                vm.textboxThree = newValue
                                                            } else {
                                                                vm.textboxThree = 255.0
                                                            }
                                                        default:
                                                            return
                                                        }
                                                    }),
                                                    format: .number
                                                )
                                                .tint(colorScheme == .dark ? .white : .black)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                                .onSubmit {
                                                    vm.updateColorFromInputs(color: &color)
                                                }
                                            }
                                        }
                                }
                                
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(.gray, lineWidth: 0.5)
                                    .fill(.regularMaterial)
                                    .frame(width: 60, height: 35)
                                    .overlay {
                                        VStack(alignment: .center) {
                                            TextField("", value: Binding(
                                                get: { vm.alphaTextbox },
                                                set: { newValue in
                                                    if newValue >= 0.0 && newValue <= 100.0 {
                                                        vm.alphaTextbox = newValue
                                                    } else {
                                                        vm.alphaTextbox = 100.0
                                                    }
                                                }),
                                                format: .number
                                            )
                                            .tint(colorScheme == .dark ? .white : .black)
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.center)
                                            .onSubmit {
                                                vm.updateColorFromInputs(color: &color)
                                            }
                                        }
                                    }
                                    
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
        .onAppear {
            vm.setInitialPickerCursor(color: &color)
            vm.setInitialSliderCursors(color: &color)
            vm.setInitialInputs(color: &color)
        }
        .onChange(of: vm.colorModel) {
            vm.setInputs(color: &color)
        }
    }
}

#Preview {
    
    @Previewable @State var binding: Color = .red
    
    ColorPickerView(color: $binding)
}
