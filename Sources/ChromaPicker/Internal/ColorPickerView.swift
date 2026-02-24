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
                
                VStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .stroke(.gray, lineWidth: 0.5)
                        .fill(.regularMaterial)
                        .frame(maxWidth: .infinity, minHeight: 375)
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
            .padding()
        }
    }
}

#Preview {
    ColorPickerView(color: .constant(.red))
}
