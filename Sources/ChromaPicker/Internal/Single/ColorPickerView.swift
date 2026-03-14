//
//  ColorPickerView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/24/26.
//

import SwiftUI

/**
    Generates the view for the single color picker.
 */

internal struct ColorPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var vm: ColorPickerVM = ColorPickerVM()
    
    let adaptiveColumns: [GridItem] = [GridItem(.adaptive(minimum: 50))]
    
    @Binding var color: Color
    
    var buttonBackgroundColor: Color {
        return Color(white: colorScheme == .dark ? 0.19 : 0.93)
    }
    
    var body: some View {
        AdaptiveLayout {
            ScrollView(.vertical) {
                VStack(spacing: 15.0) {
                    HStack {
                        SingleButtonHeaderView(vm: vm, color: $color)
                    }
                    
                    VStack(spacing: 25) {
                        CircularHuePickerView(vm: vm, color: $color, isPortrait: true)
                        
                        VStack {
                            SlidersView(vm: vm, color: $color, isPortrait: true)
                        }
                        .padding(.horizontal)
                        
                        VStack {
                            InputsView(vm: vm, color: $color)
                        }
                        
                        VStack {
                            SavedColorsView(vm: vm, color: $color)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                    }
                }
                .padding()
            }
        } landscape: {
            ScrollView {
                VStack(spacing: 25.0) {
                    
                    HStack {
                        SingleButtonHeaderView(vm: vm, color: $color)
                    }
                    
                    HStack(spacing: 35.0) {  
                        VStack(spacing: 15.0) {
                            CircularHuePickerView(vm: vm, color: $color, isPortrait: false)
                        }
                        
                        VStack(spacing: 35.0) {
                            SlidersView(vm: vm, color: $color, isPortrait: false)
                            
                            InputsView(vm: vm, color: $color)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    
                    SavedColorsView(vm: vm, color: $color)
                }
                .padding()
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            Spacer()
                .frame(height: 30)
        }
        .onAppear {
            vm.setInitialInputs(color: &color)
        }
        .onChange(of: vm.colorModel) {
            vm.setInputs(color: &color)
        }
    }
}

#Preview("Default") {
    
    @Previewable @State var binding: Color = .white
    
    ColorPickerView(color: $binding)
}
