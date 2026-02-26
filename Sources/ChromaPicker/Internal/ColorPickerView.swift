//
//  ColorPickerView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/24/26.
//

import Metal
import SwiftUI

struct ColorPickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var value: Double = 1.0
    @State private var alpha: Double = 1.0;
    @State private var pickerCursor: CGPoint = .zero
    @State private var valueCursor: CGPoint = .zero
    @State private var alphaCursor: CGPoint = .zero
    @State private var pickerSize: CGSize = .zero
    @State private var valueSize: CGSize = .zero
    @State private var alphaSize: CGSize = .zero
    @State private var pickerScale: CGFloat = 1.0
    @State private var valueScale: CGFloat = 1.0
    @State private var alphaScale: CGFloat = 1.0
    
    let PICKER_MAX_SCALE = 1.2
    let SLIDER_MAX_SCALE = 1.4
    let MIN_SCALE = 1.0
    
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
                                        let location = newValue.location
                                        picker(location: location)
                                    }
                                    .onEnded { _ in
                                        setScale(value: MIN_SCALE, type: .color)
                                    }
                            )
                            .geometryReader { g in
                                pickerSize = g?.size ?? .zero
                                let center = CGPoint(x: pickerSize.width / 2.0, y: pickerSize.height / 2.0)
                                pickerCursor = CGPoint(x: center.x, y: center.y)
                            }
                        
                        Circle()
                            .fill(
                                colorScheme == .light ?
                                Color.black.mix(with: color, by: 0.5) :
                                Color.white.mix(with: color, by: 0.3)
                            )
                            .frame(width: 28, height: 28)
                            .overlay {
                                Circle()
                                    .fill(color)
                                    .frame(width: 16, height: 16)
                            }
                            .position(pickerCursor)
                            .scaleEffect(pickerScale)
                    }
                    
                    VStack {
                        HStack(spacing: 15) {
                            VStack {
                                Button(action: {
                                    // MARK: Do this later...
                                }) {
                                    Image(systemName: "eyedropper")
                                        .font(.title)
                                        .fontWeight(.medium)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 15) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(
                                            LinearGradient(colors: [.black, color], startPoint: .leading, endPoint: .trailing)
                                        )
                                        .frame(height: 25)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { newValue in
                                                    let location = newValue.location
                                                    slider(location: location, type: .value)
                                                }
                                                .onEnded { _ in
                                                    setScale(value: MIN_SCALE, type: .value)
                                                }
                                        )
                                        .geometryReader { g in
                                            valueSize = g?.size ?? .zero
                                            
                                            let horizontalInset = valueSize.width * 0.050
                                            
                                            let usableWidth = valueSize.width - (horizontalInset * 2.0)
                                            
                                            let cursorX = horizontalInset + (usableWidth * value)
                                            let cursorY = valueSize.height / 2.0
                                            
                                            valueCursor = CGPoint(x: cursorX, y: cursorY)
                                        }
                                    
                                    Circle()
                                        .fill(
                                            colorScheme == .light ?
                                            Color.black.mix(with: color, by: 0.5) :
                                            Color.white.mix(with: color, by: 0.3)
                                        )
                                        .frame(width: 25, height: 25)
                                        .overlay {
                                            Circle()
                                                .fill(color)
                                                .frame(width: 15, height: 15)
                                        }
                                        .position(valueCursor)
                                        .scaleEffect(valueScale)
                                }
                                
                                ZStack {
                                    Checkerboard(color: color)
                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                        .frame(height: 25)
                                        .background(
                                            LinearGradient(colors: [.white.opacity(0.0), color], startPoint: .leading, endPoint: .trailing)
                                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                        )
                                        .gesture(
                                            DragGesture()
                                                .onChanged { newValue in
                                                    let location = newValue.location
                                                    slider(location: location, type: .alpha)
                                                }
                                                .onEnded { _ in
                                                    setScale(value: MIN_SCALE, type: .alpha)
                                                }
                                        )
                                        .geometryReader { g in
                                            alphaSize = g?.size ?? .zero
                                            
                                            let horizontalInset = alphaSize.width * 0.050
                                            
                                            let usableWidth = alphaSize.width - (horizontalInset * 2.0)
                                            
                                            let cursorX = horizontalInset + (usableWidth * alpha)
                                            let cursorY = alphaSize.height / 2.0
                                            
                                            alphaCursor = CGPoint(x: cursorX, y: cursorY)
                                        }
                                
                                    Circle()
                                        .fill(
                                            colorScheme == .light ?
                                            Color.black.mix(with: color, by: 0.5) :
                                            Color.white.mix(with: color, by: 0.3)
                                        )
                                        .frame(width: 25, height: 25)
                                        .overlay {
                                            Circle()
                                                .fill(color)
                                                .frame(width: 15, height: 15)
                                        }
                                        .position(alphaCursor)
                                        .scaleEffect(alphaScale)
                                }

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
    
    func setScale(value: CGFloat, type: PickerType) {
        switch type {
        case .alpha:
            withAnimation(.spring(duration: 0.3)) {
                alphaScale = value
            }
        case .color:
            withAnimation(.spring(duration: 0.3)) {
                pickerScale = value
            }
        case .value:
            withAnimation(.spring(duration: 0.3)) {
                valueScale = value
            }
        }
    }
    
    func setCursor(value: CGPoint) {
        withAnimation(.spring(duration: 0.3)) {
            pickerCursor = value
        }
    }
    
    func picker(location: CGPoint) {
        let center = CGPoint(x: pickerSize.width / 2.0, y: pickerSize.height / 2.0)
        let maxRadius = min(pickerSize.width * 0.85, pickerSize.height * 0.85) / 2.0 // 0.85 gives wheel some padding so that it doesn't extend outside rect

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
        setScale(value: PICKER_MAX_SCALE, type: .color)
    }
    
    func slider(location: CGPoint, type: PickerType) {
        switch type {
        case .value:
            let normalizedX = location.x / valueSize.width
            let clampedX = clamp(normalizedX, min: 0.0, max: 1.0)
            
            let horizontalInset = valueSize.width * 0.050
            
            let usableWidth = valueSize.width - (horizontalInset * 2.0)
            
            let cursorX = horizontalInset + (usableWidth * clampedX)
            let cursorY = valueSize.height / 2.0
            
            withAnimation(.spring(duration: 0.3)) {
                valueCursor = CGPoint(x: cursorX, y: cursorY)
                
                value = clampedX
                
                let (h,s,_,_) = colorToHsv(color: color)
                hsvToRgb(h: h, s: s, v: value, a: alpha)
            }
            setScale(value: SLIDER_MAX_SCALE, type: .value)
        case .alpha:
            let normalizedX = location.x / alphaSize.width
            let clampedX = clamp(normalizedX, min: 0.0, max: 1.0)
            
            let horizontalInset = alphaSize.width * 0.050
            
            let usableWidth = alphaSize.width - (horizontalInset * 2.0)
            
            let cursorX = horizontalInset + (usableWidth * clampedX)
            let cursorY = alphaSize.height / 2.0
            
            withAnimation(.spring(duration: 0.3)) {
                alphaCursor = CGPoint(x: cursorX, y: cursorY)
                
                alpha = clampedX
                
                let (h,s,_,_) = colorToHsv(color: color)
                hsvToRgb(h: h, s: s, v: value, a: alpha)
            }
            setScale(value: SLIDER_MAX_SCALE, type: .alpha)
        default:
            return
        }
    }
    
    func colorToHsv(color: Color) -> (h: CGFloat, s: CGFloat, v: CGFloat, a: CGFloat) {
        let uiColor = UIColor(color)
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var value: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &value, alpha: &alpha)
        
        return (hue, saturation, value, alpha)
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
    
    func clamp<T: Comparable>(_ value: T, min minimum: T, max maximum: T) -> T {
        return max(minimum, min(value, maximum))
    }
}

#Preview {
    
    @Previewable @State var binding: Color = .white
    
    ColorPickerView(color: $binding)
}
