//
//  ExampleView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import SwiftUI

struct ExampleView: View {
    
    @State private var color: Color = .red
    
    var body: some View {
        NavigationStack {
            GeometryReader { g in
                VStack(spacing: 15) {
                    VStack {
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(color)
                            .frame(width: g.size.width * 0.85, height: g.size.height * 0.4)
                    }
                    
                    VStack {
                        HStack {
                            Text("Color")
                                .font(.headline)
                            
                            Spacer()
                            
                            ChromaPicker(selection: $color)
                        }
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
