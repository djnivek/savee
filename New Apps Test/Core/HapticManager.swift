//
//  HapticManager.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import UIKit

class HapticManager: HapticManaging {
    static let shared = HapticManager()
    private var lastHapticTime: TimeInterval = 0
    private let minimumInterval: TimeInterval = 0.1
    
    private init() {}
    
    func playSequence(count: Int, interval: TimeInterval = 0.15) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        
        for i in 0..<count {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                let currentTime = CACurrentMediaTime()
                if currentTime - self.lastHapticTime >= self.minimumInterval {
                    generator.impactOccurred(intensity: 0.7)
                    self.lastHapticTime = currentTime
                }
            }
        }
    }
    
    func playLandingSequence() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred(intensity: 0.4)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            generator.notificationOccurred(.success)
        }
    }
}
