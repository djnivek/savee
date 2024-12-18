//
//  Mocks.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

extension Challenge {
    static var mocked: Challenge {
        let now = Date().timeIntervalSince1970
        
        let secondsInDay: TimeInterval = 24 * 60 * 60
        let secondsSinceMidnight = TimeInterval(Int(now) % Int(secondsInDay))
        let tenAMInSeconds: TimeInterval = 10 * 60 * 60
        
        let startTimestamp: TimeInterval
        if secondsSinceMidnight >= tenAMInSeconds {
            startTimestamp = now - secondsSinceMidnight + secondsInDay + tenAMInSeconds
        } else {
            startTimestamp = now - secondsSinceMidnight + tenAMInSeconds
        }
        
        return Challenge(
            id: UUID(),
            title: "Un poirier et un lavabo",
            description: "Réaliser un poirier devant un lavabo",
            startTimestamp: startTimestamp,
            endTimestamp: startTimestamp
        )
    }
}
