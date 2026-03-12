//
//  SingleButtonHeaderView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/5/26.
//

import SwiftUI

/**
    Generates a view that offers more discrete functionality.
 */

internal struct SingleButtonHeaderView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @Bindable var vm: ColorPickerVM
    @Binding var color: Color
    
    var body: some View {
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
            .accessibilityLabel("Reset Color")
            .accessibilityHint("Resets the current color being displayed.")
            
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
            .accessibilityLabel("Shuffle Color")
            .accessibilityHint("Randomizes the current color being displayed.")
            
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
            .accessibilityLabel("Exit Picker")
            .accessibilityHint("Exit the color picker.")
        }
    }
}

#Preview {
    SingleButtonHeaderView(vm: ColorPickerVM(), color: .constant(.red))
}
