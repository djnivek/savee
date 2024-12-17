//
//  PolaroidCircleView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import SwiftUI

struct PolaroidCircleView: View {
    private let frames: [PolaroidFrame]
    private let circleRadius: CGFloat
    private let hapticManager: HapticManaging
    
    @State private var isAnimating = false
    @State private var shouldDismiss = false
    
    init(
        numberOfFrames: Int = 10,
        circleRadius: CGFloat = 100,
        hapticManager: HapticManaging = HapticManager.shared
    ) {
        self.frames = PolaroidFrame.createFrames(count: numberOfFrames)
        self.circleRadius = circleRadius
        self.hapticManager = hapticManager
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                
                polaroidCircle
                    .frame(width: 300, height: 300)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .onAppear(perform: handleAppear)
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.7, green: 0.3, blue: 0.8),
                Color(red: 0.4, green: 0.2, blue: 0.7)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var polaroidCircle: some View {
        ZStack {
            ForEach(frames) { frame in
                SinglePolaroidView(
                    frame: frame,
                    isAnimating: isAnimating,
                    shouldDismiss: shouldDismiss,
                    circleRadius: circleRadius
                )
                .zIndex(Double(frame.index))
            }
        }
    }
    
    private func handleAppear() {
        animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            animateOut()
        }
    }
    
    private func animateIn() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.8)) {
            isAnimating = true
            hapticManager.playLandingSequence()
        }
    }
    
    private func animateOut() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.8)) {
            shouldDismiss = true
            hapticManager.playSequence(count: 3, interval: 0.15)
        }
    }
}

// MARK: - Single Polaroid View
struct SinglePolaroidView: View {
    let frame: PolaroidFrame
    let isAnimating: Bool
    let shouldDismiss: Bool
    let circleRadius: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .frame(width: 70, height: 80)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .overlay(photoArea)
                .rotation3DEffect(rotationAngle, axis: rotationAxis)
                .rotationEffect(.degrees(frame.angle + frame.rotationOffset))
                .scaleEffect(isAnimating && !shouldDismiss ? frame.scaleOffset : 0.1)
                .offset(x: xOffset, y: yOffset)
                .opacity(shouldDismiss ? 0 : 1)
        }
        .animation(
            .spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.8)
            .delay(shouldDismiss ? Double(frame.index) * 0.05 : Double(frame.index) * 0.1),
            value: isAnimating || shouldDismiss
        )
    }
    
    private var photoArea: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color(red: 1.0, green: 0.6, blue: 0.6))
            .frame(width: 60, height: 60)
            .offset(y: -5)
    }
    
    private var rotationAngle: Angle {
        .degrees(isAnimating ? 15 : 0)
    }
    
    private var rotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) {
        (
            x: cos((frame.angle) * .pi / 180),
            y: sin((frame.angle) * .pi / 180),
            z: 0.3
        )
    }
    
    private var xOffset: CGFloat {
        isAnimating && !shouldDismiss ? circleRadius * cos((frame.angle) * .pi / 180) : 0
    }
    
    private var yOffset: CGFloat {
        isAnimating && !shouldDismiss ? circleRadius * sin((frame.angle) * .pi / 180) : 0
    }
}

// MARK: - Preview
#Preview {
    PolaroidCircleView()
}
