//
//  StopCursorView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import SwiftUI

internal struct StopCursorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var isSelected: Bool
    var color: Color
    
    var body: some View {
        StopCursorShape(cornerRadius: 6, tailWidth: 12, tailHeight: 6)
            .fill(color.opacity(0.7).mix(with: colorScheme == .dark ? .white : .black, by: 0.3))
            .frame(width: 30, height: 36)
            .overlay {
                Rectangle()
                    .fill(color)
                    .padding(6)
                    .padding(.bottom, 6)
            }
            .scaleEffect(isSelected ? 1.3 : 1.0)
    }
}

#Preview {
    StopCursorView(isSelected: true, color: .red)
}
