//
//  InputsView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/5/26.
//

import SwiftUI

/**
    Generates a view that lets users select/input different
    values which is then reflected back into the ui.
 */

internal struct InputsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var vm: ColorPickerVM
    @Binding var color: Color
    
    var body: some View {
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
                .accessibilityLabel("Color Model Selector")
                .accessibilityHint("Select from HSV, RGB, and Hex.")
                .accessibilityValue("Current Model: \(vm.colorModel.rawValue)")
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
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Enter Hex Value")
                        .accessibilityValue(vm.hexValue)
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
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(vm.colorModel == ColorModel.hsv ? "Enter Hue Value" : "Enter Red Value")
                        .accessibilityValue(vm.textboxOne.formatted())
                    
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
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(vm.colorModel == ColorModel.hsv ? "Enter Saturation Value" : "Enter Green Value")
                        .accessibilityValue(vm.textboxTwo.formatted())
                    
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
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(vm.colorModel == ColorModel.hsv ? "Enter Value" : "Enter Blue Value")
                        .accessibilityValue(vm.textboxThree.formatted())
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
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Enter Alpha Value")
                    .accessibilityValue(vm.alphaTextbox.formatted())
            }
        }
    }
}

#Preview {
    InputsView(vm: ColorPickerVM(), color: .constant(.red))
}
