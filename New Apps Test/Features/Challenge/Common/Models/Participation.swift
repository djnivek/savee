//
//  Participation.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

struct Participation: Identifiable, Equatable {
    let id: UUID
    let challengeId: UUID
    let imageData: Data
    let userId: UUID
    let timestamp: Date
}
