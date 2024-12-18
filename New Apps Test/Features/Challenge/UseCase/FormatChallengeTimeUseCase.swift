//
//  FormatChallengeTimeUseCase.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import Foundation

protocol FormatChallengeTimeUseCase {
    func execute(_ challenge: Challenge) -> String
}

struct DefaultFormatChallengeTimeUseCase: FormatChallengeTimeUseCase {
    func execute(_ challenge: Challenge) -> String {
        let now = Date().timeIntervalSince1970
        let remaining = challenge.endTimestamp - now
        
        let hours = Int(remaining) / 3600
        let minutes = Int(remaining) / 60 % 60
        let seconds = Int(remaining) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
