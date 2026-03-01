//
//  StopCursorView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import SwiftUI

struct StopCursorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var isSelected: Bool
    var color: Color
    
    var fillColor: any ShapeStyle {
        if isSelected {
            return .blue
        } else {
            return .regularMaterial
        }
    }
    
    var body: some View {
        StopCursorShape(cornerRadius: 6, tailWidth: 12, tailHeight: 6)
            .fill(AnyShapeStyle(fillColor))
            .frame(width: 30, height: 36)
            .overlay {
                Rectangle()
                    .fill(color)
                    .padding(6)
                    .padding(.bottom, 6)
            }
    }
}

#Preview {
    
    
    
    StopCursorView(isSelected: true, color: .red)
}
