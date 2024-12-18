//
//  LockedMosaicOverlay.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct LockedMosaicOverlay: View {
    let hasParticipated: Bool
    let hapticManager: HapticManaging
    var onParticipate: (() -> Void)?
    var onPremiumAccess: (() -> Void)?
    
    @State private var shouldAnimate = false
    @State private var hapticIntensity: CGFloat = 0.5
    @State private var animationTimer: Timer?
    
    private let minHapticIntensity: CGFloat = 0.1
    private let hapticDecrement: CGFloat = 0.1
    
    var body: some View {
        VStack(spacing: 16) {
            mainContent
            
            if hasParticipated {
                Button {
                    onPremiumAccess?()
                } label: {
                    VStack(spacing: 4) {
                        Text("Deviens VIP, vois tout maintenant ! ✨")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("4,99€/mois")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .padding(32)
        .onAppear(perform: setupTimer)
        .onDisappear(perform: invalidateTimer)
    }
    
    private var mainContent: some View {
        Group {
            if hasParticipated {
                participatedContent
            } else {
                Button {
                    onParticipate?()
                } label: {
                    nonParticipatedContent
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var participatedContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "flame.circle")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
                .symbolEffect(.bounce.up.byLayer, options: .nonRepeating, value: shouldAnimate)
            
            Text("Ta photo est au chaud ! Reviens demain pour la surprise")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }
    
    private var nonParticipatedContent: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.circle")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
                .symbolEffect(.bounce.up.byLayer, options: .nonRepeating, value: shouldAnimate)
            
            Text("Hé ! Montre-nous ta créativité pour voir ce que les autres préparent 😎")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }
    
    private func setupTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            shouldAnimate.toggle()
            if !hasParticipated {
                hapticManager.playImpact(intensity: hapticIntensity)
            }
        }
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 12, repeats: true) { _ in
            shouldAnimate.toggle()
            if !hasParticipated {
                hapticIntensity = max(hapticIntensity - hapticDecrement, minHapticIntensity)
                hapticManager.playImpact(intensity: hapticIntensity)
            }
        }
        
        if let animationTimer {
            RunLoop.main.add(animationTimer, forMode: .common)
        }
    }
    
    private func invalidateTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

#Preview {
    VStack {
        LockedMosaicOverlay(
            hasParticipated: false,
            hapticManager: DumbHapticManager(),
            onParticipate: {},
            onPremiumAccess: {}
        )
        LockedMosaicOverlay(
            hasParticipated: true,
            hapticManager: DumbHapticManager(),
            onParticipate: {},
            onPremiumAccess: {}
        )
    }
}
