//
//  HapticManaging.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import Foundation

protocol HapticManaging {
    func playSequence(count: Int, interval: TimeInterval)
    func playImpact(intensity: CGFloat)
    func playLandingSequence()
}
