//
//  SavedColorsView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/5/26.
//

import SwiftUI

/**
    Generates a view that lets users add current colors
    to a store that can then be used for ease of access
    and reusability.
 */

internal struct SavedColorsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let adaptiveColumns: [GridItem] = [GridItem(.adaptive(minimum: 50))]
    
    @Bindable var vm: ColorPickerVM
    @Binding var color: Color
    
    var body: some View {
        LazyVGrid(columns: adaptiveColumns, spacing: 25.0) {
            
            Button(action: {
                Haptics.tap()
                withAnimation(.spring(duration: 0.3)) {
                    vm.colorStore.addColor(color: color)
                }
            }) {
                Image(systemName: "plus")
                    .pickerButtonStyle(colorScheme: colorScheme, scale: 0.5)
            }
            
            ForEach(vm.colorStore.savedColors, id: \.self) { savedColor in
                Circle()
                    .colorCircle(color: savedColor, size1: 30, size2: 18, colorScheme: colorScheme)
                    .onTapGesture {
                        Haptics.tap()
                        withAnimation(.spring(duration: 0.3)) {
                            color = savedColor
                            vm.setInputs(color: &color)
                        }
                    }
            }
        }
    }
}

#Preview {
    SavedColorsView(vm: ColorPickerVM(), color: .constant(.red))
}
