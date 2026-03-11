//
//  ColorPickerVM.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/26/26.
//

import Foundation
import SwiftUI

/**
    Contains and manages all the logic used in the single color picker.
 */

@Observable
@MainActor
final internal class ColorPickerVM {
    var value: Double = 1.0
    var alpha: Double = 1.0;
    var valueSize: CGSize = .zero
    var alphaSize: CGSize = .zero
    var pickerScale: CGFloat = 1.0
    var valueScale: CGFloat = 1.0
    var alphaScale: CGFloat = 1.0
    
    var pickerScaleTask: Task<Void, Never>?
    var valueScaleTask: Task<Void, Never>?
    var alphaScaleTask: Task<Void, Never>?
    
    var hasTappedCursor: Bool = false
    var gridIntensity: CGFloat = 0.0
    
    var isAtLeftmostValBoundary: Bool = false
    var isAtRightmostValBoundary: Bool = false
    var isAtLeftmostAlpBoundary: Bool = false
    var isAtRightmostAlpBoundary: Bool = false
    
    var colorModel: ColorModel = .hsv
    
    var hexValue: String = "#FFFFFF"
    var textboxOne: Double = 0.0
    var textboxTwo: Double = 0.0
    var textboxThree: Double = 0.0
    var alphaTextbox: Double = 100.0
    
    var colorStore: ColorStore = ColorStore.shared
    
    let HORIZONTAL_INSET_VALUE = 0.04
    let PICKER_MAX_SCALE = 1.2
    let SLIDER_MAX_SCALE = 1.4
    let MIN_SCALE = 1.0
    
    /**
        Increases the scale effect of the given type.
     
        - Parameter type: Represents the `PickerType` that wants to be scaled up.
     */
    
    func setScaleUp(type: PickerType) {
        switch type {
        case .color:
            pickerScaleTask?.cancel()
            withAnimation(.spring(duration: 0.3)) {
                pickerScale = PICKER_MAX_SCALE
                gridIntensity = 1.0
            }
        case .value:
            valueScaleTask?.cancel()
            withAnimation(.spring(duration: 0.3)) { valueScale = PICKER_MAX_SCALE }
        case .alpha:
            alphaScaleTask?.cancel()
            withAnimation(.spring(duration: 0.3)) { alphaScale = PICKER_MAX_SCALE }
        }
    }
    
    /**
        Decreases the scale effect of the given type.
     
        - Parameter type: Represents the `PickerType` that wants to be scaled down.
     */
    
    func setScaleDown(type: PickerType) {
        let task = Task {
            try? await Task.sleep(nanoseconds: 150_000_000) // guarantees cursor will pop to max scale even if user taps fast
            
            guard !Task.isCancelled else { return }
            
            withAnimation(.spring(duration: 0.3)) {
                switch type {
                case .color:
                    gridIntensity = 0.0
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
    
    /**
        Creates a new `Color` from the inputs and sets the current to the new.
        That color is then used to update the cursor of the color picker.
    
        - Parameter color: The current `Color` being displayed.
     */
    
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
    }
    
    /**
        Sets the inputs based off of the given color using the selected color model.
     
        - Parameter color: The current `Color` that is being displayed.
     */
    
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
    
    /**
        Sets the initial inputs based off of the given color using the selected color model.
     
        - Parameter color: The current `Color` that is being displayed.
     */
    
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
    
    /**
        Utilizes circular hue logic to update both the cursor of the picker and
        the current color to the new color that is created. The inputs are then updated
        to match the new color.
     
        - Parameters:
            - location: The current location of where the user finger is at on the picker.
            - color: The current color that is being displayed.
     */
    
    func picker(location: CGPoint, size: CGSize, color: inout Color) {

        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let maxRadius = min(size.width * 0.85, size.height * 0.85) / 2.0
        
        guard maxRadius > 0 else { return }

        let dx = location.x - center.x
        let dy = location.y - center.y

        let distance = hypot(dx, dy)
        let angle = atan2(dy, dx)

        let clampedDistance = min(distance, maxRadius)
        let saturation = clampedDistance / maxRadius
        var hue = angle / (2 * .pi)
        if hue < 0 { hue += 1.0 }
        
        hsvToRgb(h: hue, s: saturation, v: value, a: alpha, color: &color)
        setInputs(color: &color)
    }
    
    /**
        Updates the current slider cursor to the new location based off of the selected type. Using the updated logic,
        the current color gets set to the new one.
     
        - Parameters:
            - location: The current location of where the user finger is at on the sliider.
            - type: The type of the slider that is being adjusted.
            - color: The current color that is being displayed.
     */

    func slider(location: CGPoint, type: PickerType, color: inout Color) {
        let cursorRadius: CGFloat = 15.0
        
        switch type {
        case .value:
            
            let usableWidth = valueSize.width - (cursorRadius * 2)
            
            let adjustedX = location.x - cursorRadius
            
            let normalizedX = adjustedX / usableWidth
            let clampedX = Util.clamp(normalizedX, min: 0.0, max: 1.0)
            value = clampedX
            
            if !isAtLeftmostValBoundary && value == 0.0 {
                isAtLeftmostValBoundary = true
                Haptics.boundary()
            } else if isAtLeftmostValBoundary && value != 0.0 {
                isAtLeftmostValBoundary = false
            }
            
            if !isAtRightmostValBoundary && value == 1.0 {
                isAtRightmostValBoundary = true
                Haptics.boundary()
            } else if isAtRightmostValBoundary && value != 1.0 {
                isAtRightmostValBoundary = false
            }
            
            let (h,s,_,_) = colorToHsv(color: color)
            hsvToRgb(h: h, s: s, v: value, a: alpha, color: &color)
            setInputs(color: &color)
        case .alpha:
            let usableWidth = alphaSize.width - (cursorRadius * 2)
            
            let adjustedX = location.x - cursorRadius
            
            let normalizedX = adjustedX / usableWidth
            let clampedX = Util.clamp(normalizedX, min: 0.0, max: 1.0)
            alpha = clampedX
            
            if !isAtLeftmostAlpBoundary && alpha == 0.0 {
                isAtLeftmostAlpBoundary = true
                Haptics.boundary()
            } else if isAtLeftmostAlpBoundary && alpha != 0.0 {
                isAtLeftmostAlpBoundary = false
            }
            
            if !isAtRightmostAlpBoundary && alpha == 1.0 {
                isAtRightmostAlpBoundary = true
                Haptics.boundary()
            } else if isAtRightmostAlpBoundary && alpha != 1.0 {
                isAtRightmostAlpBoundary = false
            }
            
            let (h,s,_,_) = colorToHsv(color: color)
            hsvToRgb(h: h, s: s, v: value, a: alpha, color: &color)
            setInputs(color: &color)
        default:
            return
        }
    }
    
    /**
        Updates the existing variables to match the values from the
        current color.
     
        - Parameter color: The current color that is being displayed.
     */
    
    func updateVariables(color: Color) {
        let (_, _, v, a) = colorToHsv(color: color)
        
        value = v
        alpha = a
    }
    
    /**
        Returns the HSV representation of the current color given.
     
        - Parameter color: The current color that is being displayed.
     
        - Returns: The HSV representation of the given color.
     */
    
    func colorToHsv(color: Color) -> (h: CGFloat, s: CGFloat, v: CGFloat, a: CGFloat) {
        let uiColor = UIColor(color)
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var value: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &value, alpha: &alpha)
        
        return (hue, saturation, value, alpha)
    }
    
    /**
        Sets the current color given to the RGB representation of it.
     
        - Parameter color: The current color that is being displayed
     */
    
    func hsvToRgb(h: CGFloat, s: CGFloat, v: CGFloat, a: CGFloat, color: inout Color) {
        let hsvColor = UIColor(hue: h, saturation: s, brightness: v, alpha: a)
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        hsvColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        color = Color(UIColor(red: red, green: green, blue: blue, alpha: alpha))
    }
    
    /**
        Shuffles the current color given to a new one via randomization.
        The inputs and picker cursor are updated to the new color.
     
        - Parameter color: The current color that is being displayed
     */
    
    func shuffle(color: inout Color) {
        let randomRed = Double.random(in: 0.0...1.0)
        let randomGreen = Double.random(in: 0.0...1.0)
        let randomBlue = Double.random(in: 0.0...1.0)
        
        let rgb = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
        color = Color(uiColor: rgb)
        
        updateVariables(color: color)
        
        setInputs(color: &color)
    }
    
    /**
        Resets the current color given to white.
        The inputs and picker cursor are updated to the new color.
     
        - Parameter color: The current color that is being displayed
     */
    
    func reset(color: inout Color) {
        let white = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        color = Color(uiColor: white)
        
        value = 1.0
        alpha = 1.0
        
        setInputs(color: &color)
    }
}
