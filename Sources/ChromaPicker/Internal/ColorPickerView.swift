//
//  ColorPickerView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/24/26.
//

import SwiftUI

internal struct ColorPickerView: View {
    
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
    
    @State private var colorModel: ColorModel = .hsv
    
    @State private var hexValue: String = "#FFFFFF"
    @State private var textboxOne: Double = 0.0
    @State private var textboxTwo: Double = 0.0
    @State private var textboxThree: Double = 0.0
    @State private var alphaTextbox: Double = 100.0
    
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
                                        picker(location: location, isTap: false)
                                    }
                                    .onEnded { _ in
                                        setScale(value: MIN_SCALE, type: .color)
                                    }
                            )
                            .onTapGesture { location in
                                picker(location: location, isTap: true)
                            }
                            .geometryReader { g in
                                pickerSize = g?.size ?? .zero
                                let center = CGPoint(x: pickerSize.width / 2.0, y: pickerSize.height / 2.0)
                                pickerCursor = CGPoint(x: center.x, y: center.y)
                            }
                        
                        Circle()
                            .glassEffect(
                                .clear.tint(
                                    color.opacity(0.7).mix(with: colorScheme == .dark ? .white : .black, by: 0.3)
                                )
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
                                                    slider(location: location, type: .value, isTap: false)
                                                }
                                                .onEnded { _ in
                                                    setScale(value: MIN_SCALE, type: .value)
                                                }
                                        )
                                        .onTapGesture { location in
                                            slider(location: location, type: .value, isTap: true)
                                        }
                                        .geometryReader { g in
                                            valueSize = g?.size ?? .zero
                                            
                                            let horizontalInset = valueSize.width * 0.050
                                            
                                            let usableWidth = valueSize.width - (horizontalInset * 2.0)
                                            
                                            let cursorX = horizontalInset + (usableWidth * value)
                                            let cursorY = valueSize.height / 2.0
                                            
                                            valueCursor = CGPoint(x: cursorX, y: cursorY)
                                        }
                                    
                                    Circle()
                                        .glassEffect(
                                            .clear.tint(
                                                color.opacity(0.7).mix(with: colorScheme == .dark ? .white : .black, by: 0.3)
                                            )
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
                                                    
                                                    slider(location: location, type: .alpha, isTap: false)
                                                }
                                                .onEnded { _ in
                                                    setScale(value: MIN_SCALE, type: .alpha)
                                                }
                                        )
                                        .onTapGesture { location in
                                            slider(location: location, type: .alpha, isTap: true)
                                        }
                                        .geometryReader { g in
                                            alphaSize = g?.size ?? .zero
                                            
                                            let horizontalInset = alphaSize.width * 0.050
                                            
                                            let usableWidth = alphaSize.width - (horizontalInset * 2.0)
                                            
                                            let cursorX = horizontalInset + (usableWidth * alpha)
                                            let cursorY = alphaSize.height / 2.0
                                            
                                            alphaCursor = CGPoint(x: cursorX, y: cursorY)
                                        }
                                
                                    Circle()
                                        .glassEffect(
                                            .clear.tint(
                                                color.opacity(0.7).mix(with: colorScheme == .dark ? .white : .black, by: 0.3)
                                            )
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
                                Picker("", selection: $colorModel) {
                                    ForEach(ColorModel.allCases.sorted(), id: \.self) { model in
                                        Text(model.rawValue)
                                    }
                                }
                                .labelsHidden()
                                .tint(colorScheme == .light ? .black : .white)
                                .background(
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 1)
                                        .fill(Color.clear)
                                        .frame(height: 35)
                                )
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 10) {
                                if case .hex = colorModel {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(.regularMaterial)
                                        .frame(width: 100, height: 35)
                                        .overlay {
                                            VStack(alignment: .center) {
                                                TextField("", text: Binding(
                                                    get: { hexValue },
                                                    set: { newValue in
                                                        if !(newValue.count > 0 && newValue.count < 8) {
                                                            hexValue = "#FFFFFF"
                                                        } else if newValue.first != "#" {
                                                            hexValue = "#FFFFFF"
                                                        } else {
                                                            hexValue = newValue
                                                        }
                                                    })
                                                )
                                                .tint(colorScheme == .dark ? .white : .black)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                                .onSubmit {
                                                    updateColorFromInputs()
                                                }
                                            }
                                        }
                                } else {
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(.regularMaterial)
                                        .frame(width: 60, height: 35)
                                        .overlay {
                                            VStack(alignment: .center) {
                                                TextField("", value: Binding(
                                                    get: { textboxOne },
                                                    set: { newValue in
                                                        switch colorModel {
                                                        case .hsv:
                                                            if newValue >= 0.0 && newValue <= 360.0  {
                                                                textboxOne = newValue
                                                            } else {
                                                                textboxOne = 360.0
                                                            }
                                                        case .rgb:
                                                            if newValue >= 0.0 && newValue <= 255.0  {
                                                                textboxOne = newValue
                                                            } else {
                                                                textboxOne = 255.0
                                                            }
                                                        default:
                                                            return
                                                        }
                                                    }),
                                                    format: .number
                                                )
                                                .tint(colorScheme == .dark ? .white : .black)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                                .onSubmit {
                                                    updateColorFromInputs()
                                                }
                                            }
                                        }
                                    
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(.regularMaterial)
                                        .frame(width: 60, height: 35)
                                        .overlay {
                                            VStack(alignment: .center) {
                                                TextField("", value: Binding(
                                                    get: { textboxTwo },
                                                    set: { newValue in
                                                        switch colorModel {
                                                        case .hsv:
                                                            if newValue >= 0.0 && newValue <= 100.0  {
                                                                textboxTwo = newValue
                                                            } else {
                                                                textboxTwo = 100.0
                                                            }
                                                        case .rgb:
                                                            if newValue >= 0.0 && newValue <= 255.0  {
                                                                textboxTwo = newValue
                                                            } else {
                                                                textboxTwo = 255.0
                                                            }
                                                        default:
                                                            return
                                                        }
                                                    }),
                                                    format: .number
                                                )
                                                .tint(colorScheme == .dark ? .white : .black)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                                .onSubmit {
                                                    updateColorFromInputs()
                                                }
                                            }
                                        }
                                    
                                    RoundedRectangle(cornerRadius: 10.0)
                                        .stroke(.gray, lineWidth: 0.5)
                                        .fill(.regularMaterial)
                                        .frame(width: 60, height: 35)
                                        .overlay {
                                            VStack(alignment: .center) {
                                                TextField("", value: Binding(
                                                    get: { textboxThree },
                                                    set: { newValue in
                                                        switch colorModel {
                                                        case .hsv:
                                                            if newValue >= 0.0 && newValue <= 100.0  {
                                                                textboxThree = newValue
                                                            } else {
                                                                textboxThree = 100.0
                                                            }
                                                        case .rgb:
                                                            if newValue >= 0.0 && newValue <= 255.0  {
                                                                textboxThree = newValue
                                                            } else {
                                                                textboxThree = 255.0
                                                            }
                                                        default:
                                                            return
                                                        }
                                                    }),
                                                    format: .number
                                                )
                                                .tint(colorScheme == .dark ? .white : .black)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                                .onSubmit {
                                                    updateColorFromInputs()
                                                }
                                            }
                                        }
                                }
                                
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(.gray, lineWidth: 0.5)
                                    .fill(.regularMaterial)
                                    .frame(width: 60, height: 35)
                                    .overlay {
                                        VStack(alignment: .center) {
                                            TextField("", value: Binding(
                                                get: { alphaTextbox },
                                                set: { newValue in
                                                    if newValue >= 0.0 && newValue <= 100.0 {
                                                        alphaTextbox = newValue
                                                    } else {
                                                        alphaTextbox = 100.0
                                                    }
                                                }),
                                                format: .number
                                            )
                                            .tint(colorScheme == .dark ? .white : .black)
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.center)
                                            .onSubmit {
                                                updateColorFromInputs()
                                            }
                                        }
                                    }
                                    
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            setInitialPickerCursor()
            setInitialSliderCursors()
            setInitialInputs()
        }
        .onChange(of: colorModel) {
            setInputs()
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
    
    func updateColorFromInputs() {
        switch colorModel {
        case .hex:
            color = Color(hex: hexValue)
        case .hsv:
            let safeHue = max(0.0, min(textboxOne, 360.0))
            let safeSat = max(0.0, min(textboxTwo, 100.0))
            let safeVal = max(0.0, min(textboxThree, 100.0))
            let safeAlpha = max(0.0, min(alphaTextbox, 100.0))
            
            let normalizedHue = safeHue / 360.0
            let normalizedSat = safeSat / 100.0
            let normalizedVal = safeVal / 100.0
            let normalizedAlpha = safeAlpha / 100.0
            
            color = Color(
                hue: normalizedHue,
                saturation: normalizedSat,
                brightness: normalizedVal,
                opacity: normalizedAlpha
            )
        case .rgb:
            let safeRed = max(0.0, min(textboxOne, 255.0))
            let safeGreen = max(0.0, min(textboxTwo, 255.0))
            let safeBlue = max(0.0, min(textboxThree, 255.0))
            let safeAlpha = max(0.0, min(alphaTextbox, 100.0))
            
            let normalizedRed = safeRed / 255.0
            let normalizedGreen = safeGreen / 255.0
            let normalizedBlue = safeBlue / 255.0
            let normalizedAlpha = safeAlpha / 100.0
            
            color = Color(
                red: normalizedRed,
                green: normalizedGreen,
                blue: normalizedBlue,
                opacity: normalizedAlpha
            )
        }
        
        setInitialPickerCursor()
        setInitialSliderCursors()
    }
    
    func setInputs() {
        switch colorModel {
        case .hex:
            let hexString = UIColor(color).toHexString()
            hexValue = hexString ?? "#FFFFFF"
        case .hsv:
            let (h, s, v, a) = colorToHsv(color: color)
            
            let hue = Double(h) * 360.0
            let saturation = Double(s) * 100.0
            let value = Double(v) * 100.0
            let alpha = Double(a) * 100.0
            
            textboxOne = (hue * 10).rounded() / 10.0
            textboxTwo = (saturation * 10).rounded() / 10.0
            textboxThree = (value * 10).rounded() / 10.0
            alphaTextbox = (alpha * 10).rounded() / 10.0
            
        case .rgb:
            let uiColor = UIColor(color)
            
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            
            let dRed = Double(red) * 255.0
            let dGre = Double(green) * 255.0
            let dBlu = Double(blue) * 255.0
            let dAlp = Double(alpha) * 100.0
            
            textboxOne = (dRed * 10).rounded() / 10.0
            textboxTwo = (dGre * 10).rounded() / 10.0
            textboxThree = (dBlu * 10).rounded() / 10.0
            alphaTextbox = (dAlp * 10).rounded() / 10.0
        }
    }
    
    func setInitialInputs() {
        switch colorModel {
        case .hex:
            let hexString = UIColor(color).toHexString()
            hexValue = hexString ?? "#FFFFFF"
            
        case .hsv:
            let (h, s, v, a) = colorToHsv(color: color)
            
            let hue = Double(h) * 360.0
            let saturation = Double(s) * 100.0
            let value = Double(v) * 100.0
            let alpha = Double(a) * 100.0
            
            textboxOne = (hue * 10).rounded() / 10.0
            textboxTwo = (saturation * 10).rounded() / 10.0
            textboxThree = (value * 10).rounded() / 10.0
            alphaTextbox = (alpha * 10).rounded() / 10.0
            
        case .rgb:
            let uiColor = UIColor(color)
            
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            var alpha: CGFloat = 0.0
            
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            let dRed = Double(red) * 255.0
            let dGre = Double(green) * 255.0
            let dBlu = Double(blue) * 255.0
            let dAlp = Double(alpha) * 100.0
            
            textboxOne = (dRed * 10).rounded() / 10.0
            textboxTwo = (dGre * 10).rounded() / 10.0
            textboxThree = (dBlu * 10).rounded() / 10.0
            alphaTextbox = (dAlp * 10).rounded() / 10.0
        }
    }

    func setInitialPickerCursor() {
        let center = CGPoint(x: pickerSize.width / 2.0, y: pickerSize.height / 2.0)
        let maxRadius = min(pickerSize.width * 0.85, pickerSize.height * 0.85) / 2.0 // 0.85 gives wheel some padding so that it doesn't extend outside rect
        
        let (h,s,v,a) = colorToHsv(color: color)
        
        let angle = h * 2.0 * .pi
        let currentRadius = maxRadius * s
        
        let x = center.x + (currentRadius * cos(angle))
        let y = center.y + (currentRadius * sin(angle))
        
        hsvToRgb(h: h, s: s, v: v, a: a)
        
        pickerCursor = CGPoint(x: x, y: y)
    }
    
    func setInitialSliderCursors() {
        
        let (_,_,v,a) = colorToHsv(color: color)
        
        let horizontalInset = valueSize.width * 0.050
        
        let usableWidth = valueSize.width - (horizontalInset * 2.0)
        
        let valueCursorX = horizontalInset + (usableWidth * v)
        let alphaCursorX = horizontalInset + (usableWidth * a)
        let cursorY = valueSize.height / 2.0
        
        valueCursor = CGPoint(x: valueCursorX, y: cursorY)
        alphaCursor = CGPoint(x: alphaCursorX, y: cursorY)
    }
    
    func picker(location: CGPoint, isTap: Bool) { // Removed 'async'
        let center = CGPoint(x: pickerSize.width / 2.0, y: pickerSize.height / 2.0)
        let maxRadius = min(pickerSize.width * 0.85, pickerSize.height * 0.85) / 2.0

        let dx = location.x - center.x
        let dy = location.y - center.y

        let distance = hypot(dx, dy)
        let angle = atan2(dy, dx)

        if distance > maxRadius {
            let clampedX = center.x + (maxRadius * cos(angle))
            let clampedY = center.y + (maxRadius * sin(angle))
            pickerCursor = CGPoint(x: clampedX, y: clampedY)
        } else {
            pickerCursor = location
        }

        let clampedDistance = min(distance, maxRadius)
        let saturation = clampedDistance / maxRadius
        var hue = angle / (2 * .pi)
        if hue < 0 { hue += 1.0 }
        
        hsvToRgb(h: hue, s: saturation, v: value, a: alpha)
        setScale(value: PICKER_MAX_SCALE, type: .color)
        setInputs()
        
        if isTap {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.setScale(value: MIN_SCALE, type: .color)
            }
        }
    }

    func slider(location: CGPoint, type: PickerType, isTap: Bool) { // Removed 'async'
        switch type {
        case .value:
            let normalizedX = location.x / valueSize.width
            let clampedX = clamp(normalizedX, min: 0.0, max: 1.0)
            
            let horizontalInset = valueSize.width * 0.050
            let usableWidth = valueSize.width - (horizontalInset * 2.0)
            let cursorX = horizontalInset + (usableWidth * clampedX)
            let cursorY = valueSize.height / 2.0
            
            valueCursor = CGPoint(x: cursorX, y: cursorY)
            value = clampedX
            
            let (h,s,_,_) = colorToHsv(color: color)
            hsvToRgb(h: h, s: s, v: value, a: alpha)
            
            setScale(value: SLIDER_MAX_SCALE, type: .value)
            setInputs()
            
            if isTap {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.setScale(value: MIN_SCALE, type: .value)
                }
            }
        case .alpha:
            let normalizedX = location.x / alphaSize.width
            let clampedX = clamp(normalizedX, min: 0.0, max: 1.0)
            
            let horizontalInset = alphaSize.width * 0.050
            let usableWidth = alphaSize.width - (horizontalInset * 2.0)
            let cursorX = horizontalInset + (usableWidth * clampedX)
            let cursorY = alphaSize.height / 2.0
            
            // 1. Instantly update position and values
            alphaCursor = CGPoint(x: cursorX, y: cursorY)
            alpha = clampedX
            
            let (h,s,_,_) = colorToHsv(color: color)
            hsvToRgb(h: h, s: s, v: value, a: alpha)
            
            setScale(value: SLIDER_MAX_SCALE, type: .alpha)
            setInputs()
            
            // 2. Handle tap delay
            if isTap {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.setScale(value: MIN_SCALE, type: .alpha)
                }
            }
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
    
    @Previewable @State var binding: Color = .red
    
    ColorPickerView(color: $binding)
}
