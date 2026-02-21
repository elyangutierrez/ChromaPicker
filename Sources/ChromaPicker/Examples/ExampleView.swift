//
//  SwiftUIView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/21/26.
//

import SwiftUI

struct ExampleView: View {
    
    @State private var color: Color = .red
    
    var body: some View {
        ChromaPicker(selection: $color)
            .foregroundStyle(color)
    }
}

#Preview {
    ExampleView()
}
