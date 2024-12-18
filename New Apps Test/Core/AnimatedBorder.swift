//
//  AnimatedBorder.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//


import SwiftUI

struct AnimatedBorder: View {
    let progress: Double
    let shouldShow: Bool
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.addRoundedRect(
                    in: CGRect(
                        x: 0,
                        y: 0,
                        width: geometry.size.width,
                        height: geometry.size.height
                    ),
                    cornerSize: CGSize(width: 16, height: 16)
                )
            }
            .trim(from: 0, to: progress)
            .stroke(
                Color.accentColor,
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            .rotationEffect(.degrees(-180))
            .opacity(shouldShow ? 1 : 0)
            .animation(.easeInOut(duration: 0.3), value: shouldShow)
        }
    }
}
