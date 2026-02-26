//
//  Checkerboard.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation
import SwiftUI

struct Checkerboard: View {
    var color: Color
    var squareSize: CGFloat = 8.0
    
    var body: some View {
        Canvas { context, size in
            
            let columns = Int(size.width / squareSize) + 1
            let rows = Int(size.height / squareSize) + 1
            
            for row in 0..<rows {
                for col in 0..<columns {
                    
                    if (row + col) % 2 == 0 {
                        let rect = CGRect(
                            x: CGFloat(col) * squareSize,
                            y: CGFloat(row) * squareSize,
                            width: squareSize,
                            height: squareSize
                        )
                        
                        context.fill(Path(rect), with: .color(Color.gray.opacity(0.2)))
                    }
                }
            }
        }
        .background(LinearGradient(colors: [.white.opacity(0.1), color], startPoint: .leading, endPoint: .trailing))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
