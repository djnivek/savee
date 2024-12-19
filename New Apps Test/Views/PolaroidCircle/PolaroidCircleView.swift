//
//  PolaroidCircleView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import SwiftUI

struct PolaroidCircleView: View {
    let frames: [PolaroidFrame]
    let circleRadius: CGFloat
    let hapticManager: HapticManaging
    let onDispersionStarted: () -> Void
    
    @State private var isAnimating = false
    @State private var shouldDismiss = false
    @State private var backgroundOpacity = 1.0
    
    init(
        numberOfFrames: Int = 10,
        circleRadius: CGFloat = 100,
        hapticManager: HapticManaging = HapticManager.shared,
        onDispersionStarted: @escaping () -> Void
    ) {
        self.frames = PolaroidFrame.createFrames(count: numberOfFrames)
        self.circleRadius = circleRadius
        self.hapticManager = hapticManager
        self.onDispersionStarted = onDispersionStarted
    }
    
    var body: some View {
        ZStack {
            // Polaroid circle content
            GeometryReader { geometry in
                ZStack {
                    ForEach(frames) { frame in
                        SinglePolaroidView(
                            frame: frame,
                            isAnimating: isAnimating,
                            shouldDismiss: shouldDismiss,
                            circleRadius: circleRadius,
                            screenHeight: geometry.size.height
                        )
                        .zIndex(Double(frame.index))
                    }
                }
                .frame(width: 300, height: 300)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.7, green: 0.3, blue: 0.8),
                    Color(red: 0.4, green: 0.2, blue: 0.7)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(backgroundOpacity)
        )
        .onAppear(perform: handleAppear)
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
        onDispersionStarted()
        
        withAnimation(.easeOut(duration: 0.8)) {
            backgroundOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.8)) {
                shouldDismiss = true
                hapticManager.playSequence(count: 3, interval: 0.15)
            }
        }
    }
}

struct SinglePolaroidView: View {
    let frame: PolaroidFrame
    let isAnimating: Bool
    let shouldDismiss: Bool
    let circleRadius: CGFloat
    let screenHeight: CGFloat
    
    private var polaroidState: PolaroidState {
        if shouldDismiss {
            return .dismissing
        } else if isAnimating {
            return .circle
        }
        return .initial
    }
    
    private var targetY: CGFloat {
        switch polaroidState {
        case .dismissing:
            return screenHeight * 0.75 - screenHeight / 2
        case .circle:
            return circleRadius * sin((frame.angle) * .pi / 180)
        case .initial:
            return 0
        }
    }

    private var targetX: CGFloat {
        switch polaroidState {
        case .dismissing:
            return 0
        case .circle:
            return circleRadius * cos((frame.angle) * .pi / 180)
        case .initial:
            return 0
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .frame(width: 70, height: 80)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .overlay(photoArea)
                .rotation3DEffect(
                    polaroidState == .circle ? .degrees(15) : .degrees(0),
                    axis: (
                        x: cos((frame.angle) * .pi / 180),
                        y: sin((frame.angle) * .pi / 180),
                        z: 0.3
                    )
                )
                .rotationEffect(.degrees(frame.angle + frame.rotationOffset))
                .scaleEffect(polaroidState == .initial ? 0.1 : frame.scaleOffset)
                .offset(x: targetX, y: targetY)
                .opacity(polaroidState == .dismissing ? 0 : 1)
        }
        .animation(
            .spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.8)
            .delay(Double(frame.index) * 0.1),
            value: polaroidState
        )
    }
    
    private var photoArea: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color(red: 1.0, green: 0.6, blue: 0.6))
            .frame(width: 60, height: 60)
            .offset(y: -5)
    }
}

private enum PolaroidState {
    case initial
    case circle
    case dismissing
}

// MARK: - Preview
#Preview {
    PolaroidCircleView(onDispersionStarted: {})
}
