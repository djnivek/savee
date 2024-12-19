//
//  ConfettiFallView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//

import SwiftUI
import UIKit

struct ConfettiFallView: View {
    @Binding var isActive: Bool
    private let hapticManager = HapticManager.shared
    
    var body: some View {
        ZStack {
            ForEach(0..<30, id: \.self) { i in
                ConfettiView(
                    color: Color.random,
                    size: CGFloat.random(in: 8...16),
                    xOffset: CGFloat.random(in: -UIScreen.main.bounds.width/2...UIScreen.main.bounds.width/2),
                    duration: Double.random(in: 3...5)
                )
                .opacity(isActive ? 1 : 0)
                .onAppear {
                    if i % 3 == 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                            hapticManager.playImpact(intensity: CGFloat.random(in: 0.3...0.7))
                        }
                    }
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            if isActive {
                hapticManager.playSequence(count: 5, interval: 0.15)
            }
        }
    }
}

