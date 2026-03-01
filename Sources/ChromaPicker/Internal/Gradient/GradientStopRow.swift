//
//  SwiftUIView.swift
//  ChromaPicker
//
//  Created by Elyan Gutierrez on 2/28/26.
//

import SwiftUI

internal struct GradientStopRow: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var locationValue: Double = 0.0
    @State private var hexValue: String = ""
    @State private var alphaValue: Double = 100.0
    
    @Binding var stop: Gradient.Stop
    var onSelect: () -> Void
    var onRemove: () -> Void
    
    var body: some View {
        HStack {
            
            VStack {
                HStack {
                    TextField("", value: Binding(
                        get: { locationValue },
                        set: { newValue in
                            if newValue >= 0.0 && newValue <= 100.0 {
                                locationValue = newValue
                            } else {
                                locationValue = 100.0
                            }
                        }), format: .number)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .tint(colorScheme == .dark ? .white : .black)
                        .onSubmit { updateStop() }
                }
            }
            .frame(width: 50, height: 35)
            .background(
                RoundedRectangle(cornerRadius: 7.0)
                    .fill(Color(white: colorScheme == .dark ? 0.19 : 0.90))
            )
            
            Spacer()
            
            VStack {
                HStack {
                    Button(action: {
                        onSelect()
                    }) {
                        RoundedRectangle(cornerRadius: 3.0)
                            .fill(stop.color)
                            .frame(width: 25, height: 25)
                    }
                    
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
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
                    .tint(colorScheme == .dark ? .white : .black)
                    .onSubmit { updateStop() }
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 1)
                    
                    TextField("", value: Binding(
                        get: { alphaValue },
                        set: { newValue in
                            if newValue >= 0.0 && newValue <= 100.0 {
                                alphaValue = newValue
                            } else {
                                alphaValue = 100.0
                            }
                        }), format: .number)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .onSubmit { updateStop() } // Save on enter!
                        .tint(colorScheme == .dark ? .white : .black)
                        .frame(width: 50)
                }
            }
            .frame(height: 35)
            .padding(.horizontal)
            .background(
                RoundedRectangle(cornerRadius: 7.0)
                    .fill(Color(white: colorScheme == .dark ? 0.19 : 0.90))
            )
            
            Spacer()
            
            
            VStack {
                Button(action: {
                    onRemove()
                }) {
                    Image(systemName: "minus")
                        .font(.title3.bold())
                        .foregroundColor(Color(white: colorScheme == .dark ? 0.62 : 0.51))
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
        .background(
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(.gray, lineWidth: 0.5)
                .fill(.regularMaterial)
        )
        .onAppear {
            updateInputs()
        }
        
        .onChange(of: stop) {
            updateInputs()
        }
    }
    
    
    func updateInputs() {
        locationValue = (Double(stop.location) * 100.0 * 10).rounded() / 10.0
        
        let uiColor = UIColor(stop.color)
        hexValue = uiColor.toHexString() ?? "#FFFFFF"
        
        var a: CGFloat = 0
        uiColor.getWhite(nil, alpha: &a)
        alphaValue = (Double(a) * 100.0 * 10).rounded() / 10.0
    }
    
    
    func updateStop() {
        
        let safeLoc = Util.clamp(locationValue, min: 0.0, max: 100.0)
        let safeAlpha = Util.clamp(alphaValue, min: 0.0, max: 100.0)
        
        let newLocation = CGFloat(safeLoc / 100.0)
        let normalizedAlpha = CGFloat(safeAlpha / 100.0)
        
        var processedHex = hexValue
        if !processedHex.hasPrefix("#") { processedHex = "#" + processedHex }
        
        var newColor = stop.color
        
        if processedHex.count == 7 {
            let uiColor = UIColor(Color(hex: processedHex))
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            newColor = Color(UIColor(red: r, green: g, blue: b, alpha: normalizedAlpha))
        } else {
            let uiColor = UIColor(stop.color)
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            newColor = Color(UIColor(red: r, green: g, blue: b, alpha: normalizedAlpha))
        }
        
        stop.location = newLocation
        stop.color = newColor
        
        updateInputs()
    }
}

#Preview {
    
    @Previewable @State var stop: Gradient.Stop = .init(color: .red, location: 0.5)
    
    GradientStopRow(stop: $stop, onSelect: {}, onRemove: {})
        .padding(.horizontal)
}
