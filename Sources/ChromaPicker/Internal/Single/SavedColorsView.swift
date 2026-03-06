//
//  SwiftUIView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/5/26.
//

import SwiftUI

struct SavedColorsView: View {
    
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
                    .fill(savedColor)
                    .frame(width: 35, height: 35)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.3)) {
                            color = savedColor
                            vm.setInputs(color: &color)
                            vm.setInitialPickerCursor(color: &color)
                        }
                    }
            }
        }
    }
}

#Preview {
    SavedColorsView(vm: ColorPickerVM(), color: .constant(.red))
}
