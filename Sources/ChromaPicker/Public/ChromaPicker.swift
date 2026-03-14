// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// An instance that lets you select either a color or an array of stops.
///
/// - Parameters:
///     - selection: A `binding` to the variable which can either be a `Color`
///       or an `[Gradient.Stop]`.
/// 

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
    
    let meshPoints: [SIMD2<Float>] = [
        [0.0,0.0], [0.5,0.0], [1.0,0.0],
        [0.0,0.5], [0.5,0.8], [1.0,0.5],
        [0.0,1.0], [0.5,1.0], [1.0,1.0]
    ]
    
    let meshColors: [Color] = [
        .blue, .purple, .red,
        .cyan, .green.opacity(0.8), .orange,
        .green, .green, .yellow
    ]
    
    var strokeStyle: any ShapeStyle {
        if let color = selection as? Color {
            return color
        } else if let stops = selection as? [Gradient.Stop] {
            return AngularGradient(stops: stops, center: .center)
        }
        
        return .red
    }
    
    @Binding var selection: S
    var config: ChromaConfig
    
    public init(
        selection: Binding<S>,
        supportsAlpha: Bool = true,
        canSaveColors: Bool = true
    ) {
        self._selection = selection
        self.config = ChromaConfig(
            supportsAlpha: supportsAlpha,
            canSaveColors: canSaveColors
        )
    }
    
    public var body: some View {
        Button(action: {
            isShowingView.toggle()
        }) {
            Circle()
                .fill(
                    MeshGradient(
                        width: 3,
                        height: 3,
                        points: meshPoints,
                        colors: meshColors
                    )
                )
                .frame(width: 15, height: 15)
                .background(
                    Circle()
                        .stroke(AnyShapeStyle(strokeStyle), lineWidth: 3)
                        .fill(.clear)
                        .frame(width: 25, height: 25)
                )
        }
        .environment(\.chromaConfig, config)
        .accessibilityLabel("Color Picker")
        .accessibilityHint("Tap to use the color picker.")
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingView) {
            selection.makePickerView($selection)
                .presentationDetents([.fraction(0.9)])
        }
    }
}

#Preview {
    @Previewable @State var stops: [Gradient.Stop] = [
        .init(color: .blue, location: 0.2),
        .init(color: .red, location: 0.5),
        .init(color: .green, location: 0.7)
    ]
    @Previewable @State var color: Color = Color.red
    
    ChromaPicker(selection: $stops)
}
