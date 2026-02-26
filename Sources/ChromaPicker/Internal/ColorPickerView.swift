//
//  ColorPickerView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/24/26.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var value: Double = 1.0
    @State private var alpha: Double = 1.0;
    @State private var cursor: CGPoint = .zero
    @State private var size: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    
    @Binding var color: Color
    
    var buttonBackgroundColor: Color {
        return Color(white: colorScheme == .dark ? 0.19 : 0.93)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            
            VStack(spacing: 25.0) {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        ZStack {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .font(.headline)
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
                                .scaleEffect(0.5)
                                .background(
                                    Circle()
                                        .fill(buttonBackgroundColor)
                                )
                        }
                    }
                }
                
                VStack(spacing: 25) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(.gray, lineWidth: 0.5)
                            .fill(.regularMaterial)
                            .frame(maxWidth: .infinity, minHeight: 375)
                            .gesture(
                                DragGesture()
                                    .onChanged { newValue in
                                        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
                                        let maxRadius = min(size.width * 0.85, size.height * 0.85) / 2.0 // 0.85 gives wheel some padding so that it doesn't extend outside rect

                                        let location = newValue.location

                                        let dx = location.x - center.x
                                        let dy = location.y - center.y

                                        let distance = hypot(dx, dy)
                                        let angle = atan2(dy, dx)

                                        if distance > maxRadius {
                                            let clampedX = center.x + (maxRadius * cos(angle))
                                            let clampedY = center.y + (maxRadius * sin(angle))
                                            setCursor(value: CGPoint(x: clampedX, y: clampedY))
                                        } else {
                                            setCursor(value: location)
                                        }

                                        let clampedDistance = min(distance, maxRadius)
                                        let saturation = clampedDistance / maxRadius // normalize saturation
                                        var hue = angle / (2 * .pi)
                                        if hue < 0 { hue += 1.0 } // normalize hue
                                        
                                        hsvToRgb(h: hue, s: saturation, v: value, a: alpha)
                                        setScale(value: 1.2)
                                    }
                                    .onEnded { _ in
                                        setScale(value: 1.0)
                                    }
                            )
                            .geometryReader { g in
                                size = g?.size ?? .zero
                                let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
                                cursor = CGPoint(x: center.x, y: center.y)
                            }
                        
                        Circle()
                            .fill(colorScheme == .light ? .black : .white)
                            .frame(width: 28, height: 28)
                            .overlay {
                                Circle()
                                    .fill(color)
                                    .frame(width: 16, height: 16)
                            }
                            .position(cursor)
                            .scaleEffect(scale)
                    }
                    
                    VStack {
                        HStack(spacing: 5) {
                            VStack {
                                Button(action: {
                                    
                                }) {
                                    Image(systemName: "eyedropper")
                                        .font(.title)
                                        .fontWeight(.medium)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal, 10)
                            
                            Spacer()
                            
                            VStack(spacing: 15) {
                                RoundedRectangle(cornerRadius: 15.0)
                                    .fill(Color.red)
                                    .frame(height: 25)
                                
                                RoundedRectangle(cornerRadius: 15.0)
                                    .fill(Color.red)
                                    .frame(height: 25)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            VStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(.gray, lineWidth: 1)
                                    .fill(Color.clear)
                                    .frame(width: 70, height: 35)
                            }
                            
                            Spacer()
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(.gray, lineWidth: 0.5)
                                    .fill(.regularMaterial)
                                    .frame(width: 60, height: 35)
                                
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(.gray, lineWidth: 0.5)
                                    .fill(.regularMaterial)
                                    .frame(width: 60, height: 35)
                                
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(.gray, lineWidth: 0.5)
                                    .fill(.regularMaterial)
                                    .frame(width: 60, height: 35)
                                
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(.gray, lineWidth: 0.5)
                                    .fill(.regularMaterial)
                                    .frame(width: 60, height: 35)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    func setScale(value: CGFloat) {
        withAnimation(.spring(duration: 0.3)) {
            scale = value
        }
    }
    
    func setCursor(value: CGPoint) {
        withAnimation(.spring(duration: 0.3)) {
            cursor = value
        }
    }
    
    func hsvToRgb(h: CGFloat, s: CGFloat, v: CGFloat, a: CGFloat) {
        let hsvColor = UIColor(hue: h, saturation: s, brightness: v, alpha: a)
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        hsvColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        color = Color(UIColor(red: red, green: green, blue: blue, alpha: alpha))
    }

}

#Preview {
    
    @Previewable @State var binding: Color = .white
    
    ColorPickerView(color: $binding)
}
