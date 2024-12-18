//
//  Challenge.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

struct Challenge: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let startTimestamp: TimeInterval
    let endTimestamp: TimeInterval
    
    var isActive: Bool {
        let now = Date().timeIntervalSince1970
        return now >= startTimestamp && now <= endTimestamp
    }
}
