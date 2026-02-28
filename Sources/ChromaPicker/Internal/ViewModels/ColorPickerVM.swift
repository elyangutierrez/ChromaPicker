//
//  ColorPickerVM.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation
import SwiftUI

@Observable
@MainActor
class ColorPickerVM {
    var value: Double = 1.0
    var alpha: Double = 1.0;
    var pickerCursor: CGPoint = .zero
    var valueCursor: CGPoint = .zero
    var alphaCursor: CGPoint = .zero
    var pickerSize: CGSize = .zero
    var valueSize: CGSize = .zero
    var alphaSize: CGSize = .zero
    var pickerScale: CGFloat = 1.0
    var valueScale: CGFloat = 1.0
    var alphaScale: CGFloat = 1.0
    
    var pickerScaleTask: Task<Void, Never>?
    var valueScaleTask: Task<Void, Never>?
    var alphaScaleTask: Task<Void, Never>?
    
    var hasTappedCursor: Bool = false
    
    var colorModel: ColorModel = .hsv
    
    var hexValue: String = "#FFFFFF"
    var textboxOne: Double = 0.0
    var textboxTwo: Double = 0.0
    var textboxThree: Double = 0.0
    var alphaTextbox: Double = 100.0
    
    let HORIZONTAL_INSET_VALUE = 0.04
    let PICKER_MAX_SCALE = 1.2
    let SLIDER_MAX_SCALE = 1.4
    let MIN_SCALE = 1.0
    
    func setScaleUp(type: PickerType) {
        switch type {
        case .color:
            pickerScaleTask?.cancel()
            withAnimation(.spring(duration: 0.3)) { pickerScale = PICKER_MAX_SCALE }
        case .value:
            valueScaleTask?.cancel()
            withAnimation(.spring(duration: 0.3)) { valueScale = PICKER_MAX_SCALE }
        case .alpha:
            alphaScaleTask?.cancel()
            withAnimation(.spring(duration: 0.3)) { alphaScale = PICKER_MAX_SCALE }
        }
    }
    
    func setScaleDown(type: PickerType) {
        let task = Task {
            try? await Task.sleep(nanoseconds: 150_000_000) // guarantees cursor will pop to max scale even if user taps fast
            
            guard !Task.isCancelled else { return }
            
            withAnimation(.spring(duration: 0.3)) {
                switch type {
                case .color:
                    self.pickerScale = MIN_SCALE
                case .value:
                    self.valueScale = MIN_SCALE
                case .alpha:
                    self.alphaScale = MIN_SCALE
                }
            }
        }
        
        switch type {
        case .color:
            pickerScaleTask = task
        case .value:
            valueScaleTask = task
        case .alpha:
            alphaScaleTask = task
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
    
    func updateColorFromInputs(color: inout Color) {
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
        
        setInitialPickerCursor(color: &color)
        setInitialSliderCursors(color: &color)
    }
    
    func setInputs(color: inout Color) {
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
    
    func setInitialInputs(color: inout Color) {
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

    func setInitialPickerCursor(color: inout Color) {
        let center = CGPoint(x: pickerSize.width / 2.0, y: pickerSize.height / 2.0)
        let maxRadius = min(pickerSize.width * 0.85, pickerSize.height * 0.85) / 2.0 // 0.85 gives wheel some padding so that it doesn't extend outside rect
        
        let (h,s,v,a) = colorToHsv(color: color)
        
        value = v
        alpha = a
        
        let angle = h * 2.0 * .pi
        let currentRadius = maxRadius * s
        
        let x = center.x + (currentRadius * cos(angle))
        let y = center.y + (currentRadius * sin(angle))
        
        hsvToRgb(h: h, s: s, v: v, a: a, color: &color)
        
        pickerCursor = CGPoint(x: x, y: y)
    }
    
    func setInitialSliderCursors(color: inout Color) {
        
        let (_,_,v,a) = colorToHsv(color: color)
        
        value = v
        alpha = a
        
        let horizontalInset = valueSize.width * HORIZONTAL_INSET_VALUE
        
        let usableWidth = valueSize.width - (horizontalInset * 2.0)
        
        let valueCursorX = horizontalInset + (usableWidth * v)
        let alphaCursorX = horizontalInset + (usableWidth * a)
        let cursorY = valueSize.height / 2.0
        
        valueCursor = CGPoint(x: valueCursorX, y: cursorY)
        alphaCursor = CGPoint(x: alphaCursorX, y: cursorY)
    }
    
    func picker(location: CGPoint, color: inout Color) {

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
        
        hsvToRgb(h: hue, s: saturation, v: value, a: alpha, color: &color)
        setInputs(color: &color)
    }

    func slider(location: CGPoint, type: PickerType, color: inout Color) {
        switch type {
        case .value:
            let normalizedX = location.x / valueSize.width
            let clampedX = clamp(normalizedX, min: 0.0, max: 1.0)
            
            let horizontalInset = valueSize.width * HORIZONTAL_INSET_VALUE
            let usableWidth = valueSize.width - (horizontalInset * 2.0)
            let cursorX = horizontalInset + (usableWidth * clampedX)
            let cursorY = valueSize.height / 2.0
            
            valueCursor = CGPoint(x: cursorX, y: cursorY)
            value = clampedX
            
            let (h,s,_,_) = colorToHsv(color: color)
            hsvToRgb(h: h, s: s, v: value, a: alpha, color: &color)
            setInputs(color: &color)
        case .alpha:
            let normalizedX = location.x / alphaSize.width
            let clampedX = clamp(normalizedX, min: 0.0, max: 1.0)
            
            let horizontalInset = alphaSize.width * HORIZONTAL_INSET_VALUE
            let usableWidth = alphaSize.width - (horizontalInset * 2.0)
            let cursorX = horizontalInset + (usableWidth * clampedX)
            let cursorY = alphaSize.height / 2.0
            
           
            alphaCursor = CGPoint(x: cursorX, y: cursorY)
            alpha = clampedX
            
            let (h,s,_,_) = colorToHsv(color: color)
            hsvToRgb(h: h, s: s, v: value, a: alpha, color: &color)
            setInputs(color: &color)
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
    
    func hsvToRgb(h: CGFloat, s: CGFloat, v: CGFloat, a: CGFloat, color: inout Color) {
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
    
    func shuffle(color: inout Color) {
        let randomRed = Double.random(in: 0.0...1.0)
        let randomGreen = Double.random(in: 0.0...1.0)
        let randomBlue = Double.random(in: 0.0...1.0)
        
        let rgb = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
        color = Color(uiColor: rgb)
        
        setInputs(color: &color)
        setInitialPickerCursor(color: &color)
        setInitialSliderCursors(color: &color)
    }
    
    func reset(color: inout Color) {
        let white = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        color = Color(uiColor: white)
        
        value = 1.0
        alpha = 1.0
        
        setInputs(color: &color)
        setInitialPickerCursor(color: &color)
        setInitialSliderCursors(color: &color)
    }
}
