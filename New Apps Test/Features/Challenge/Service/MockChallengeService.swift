//
//  MockChallengeService.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

class MockChallengeService: ChallengeService {
    func getCurrentChallenge() async throws -> Challenge {
        .mocked
    }
}
