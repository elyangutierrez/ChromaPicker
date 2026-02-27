//
//  ExampleView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import SwiftUI

struct ExampleView: View {
    
    @State private var stops: [Gradient.Stop] = [
        .init(color: .blue, location: 0.2),
        .init(color: .red, location: 0.5),
        .init(color: .green, location: 0.7)
    ]
    @State private var color: Color = .blue
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { g in
                VStack(spacing: 15) {
                    VStack {
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(color)
//                            .fill(Gradient(stops: stops))
                            .frame(width: g.size.width * 0.85, height: g.size.height * 0.4)
                    }
                    
                    VStack {
                        HStack {
                            Text("Color")
                                .font(.headline)
                            
                            Spacer()
                            
                            ChromaPicker(selection: $color)
                        }
                        
                        ColorPicker("", selection: $color)
                    }
                    
                    Button("Show sheet") {
                        isShowingSheet.toggle()
                    }
                }
                .padding()
            }
            .navigationTitle("Example View")
        }
    }
}

#Preview {
    ExampleView()
}
