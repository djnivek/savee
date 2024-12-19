//
//  ConfettiView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//

import SwiftUI

struct ConfettiView: View {
    let color: Color
    let size: CGFloat
    let xOffset: CGFloat
    let duration: Double
    
    @State private var yOffset: CGFloat = -500
    @State private var rotation: Double = 0
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .rotationEffect(.degrees(rotation))
            .offset(x: xOffset, y: yOffset)
            .onAppear {
                withAnimation(.easeInOut(duration: duration)) {
                    yOffset = UIScreen.main.bounds.height + 100
                }
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}
