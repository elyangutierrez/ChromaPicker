// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct ChromaPicker<S: ChromaSelection>: View {
    
    @State private var isShowingView: Bool = false
    
    let angularColors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .mint,
        .teal,
        .cyan,
        .blue,
        .indigo,
        .purple,
        .pink
    ]
    
    @Binding var selection: S
    
    public init(selection: Binding<S>) {
        self._selection = selection
    }
    
    public var body: some View {
        Button(action: {
            isShowingView.toggle()
        }) {
            Circle()
                .stroke(
                    AngularGradient(colors: angularColors, center: .center)
                        .opacity(0.5)
                    ,
                    lineWidth: 5
                )
                .fill(AngularGradient(colors: angularColors, center: .center))
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingView) {
            selection.makePickerView(binding: $selection)
        }
    }
}

#Preview {
    @Previewable @State var color: Color = Color.red
    
    ChromaPicker(selection: $color)
}
