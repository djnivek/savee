//
//  CalculateChallengeProgressUseCase.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//


import Foundation

protocol CalculateChallengeProgressUseCase {
    func execute(_ challenge: Challenge) -> Double
}

struct DefaultCalculateChallengeProgressUseCase: CalculateChallengeProgressUseCase {
    func execute(_ challenge: Challenge) -> Double {
        let now = Date().timeIntervalSince1970
        
        guard now >= challenge.startTimestamp else { return 0 }
        
        let elapsed = now - challenge.startTimestamp
        let totalDuration = challenge.endTimestamp - challenge.startTimestamp
        
        let progress = elapsed / totalDuration
        let clampedProgress = max(0, min(1, progress))
        
        // Truncate to 2 decimal places to avoid too frequent UI updates
        // Example: 0.87654321 becomes 0.87
        return (round(clampedProgress * 100) / 100)
    }
}
