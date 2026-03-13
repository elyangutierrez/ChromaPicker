//
//  GradientButtonHeaderView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 3/4/26.
//

import SwiftUI

/**
    Generates a view that offers more discrete functionality.
 */

internal struct GradientButtonHeaderView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var vm: GradientPickerVM
    
    var body: some View {
        HStack(spacing: 10.0) {
            Button(action: {
                Haptics.tap()
                withAnimation(.spring(duration: 0.3)) {
                    vm.reset()
                }
            }) {
                ZStack {
                    Image(systemName: "arrow.trianglehead.2.counterclockwise.rotate.90")
                        .pickerButtonStyle(colorScheme: colorScheme, scale: 0.7)
                }
            }
            .accessibilityLabel("Reset Gradient")
            .accessibilityHint("Resets the gradient to a monochromatic gradient.")
            
            Button(action: {
                Haptics.tap()
                withAnimation(.spring(duration: 0.3)) {
                    vm.isOrientationLocked.toggle()
                }
            }) {
                ZStack {
                    Image(systemName: vm.isOrientationLocked ? "lock.fill" : "lock.open.fill")
                        .pickerButtonStyle(colorScheme: colorScheme, scale: 0.5)
                        .contentTransition(.symbolEffect(.replace))
                }
            }
            .accessibilityLabel("Lock Gradient Orientation")
            .accessibilityHint("Prevents it from changing as you add a new color.")
            
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
            .accessibilityLabel("Close Picker")
            .accessibilityHint("Close the picker window.")
        }
    }
}

#Preview {
    GradientButtonHeaderView(vm: GradientPickerVM())
}
