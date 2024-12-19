//
//  Mocks.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

extension Challenge {
    /// Mock challenge that simulates a daily challenge starting at the last 10:00 GMT
    /// and ending at the next 10:00 GMT. For testing and preview purposes only.
    static var mocked: Challenge {
        let now = Date().timeIntervalSince1970
        let secondsInDay: TimeInterval = 24 * 60 * 60
        let tenAMInSeconds: TimeInterval = 10 * 60 * 60
        
        // Calculate seconds since midnight GMT
        let secondsSinceMidnight = TimeInterval(Int(now) % Int(secondsInDay))
        
        // Determine start timestamp (last 10:00 GMT)
        let startTimestamp: TimeInterval
        if secondsSinceMidnight >= tenAMInSeconds {
            // If after 10:00, start is today at 10:00
            startTimestamp = now - secondsSinceMidnight + tenAMInSeconds
        } else {
            // If before 10:00, start was yesterday at 10:00
            startTimestamp = now - secondsSinceMidnight + tenAMInSeconds - secondsInDay
        }
        
        // End timestamp is always the next 10:00 GMT
        let endTimestamp = startTimestamp + secondsInDay
        
        return Challenge(
            id: UUID(),
            title: "Sink-side Handstand! 🤸‍♂️",
            description: "Strike a handstand pose by your bathroom sink! Safety first, epic pics second!",
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp
        )
    }
}
