//
//  MockChallengeService.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

class MockChallengeService: ChallengeService {
    private var userParticipations: [Participation] = []
    
    func getCurrentChallenge() async throws -> Challenge {
        .mocked
    }
    
    func submitParticipation(_ image: Data, for challengeId: UUID) async throws {
        let participation = Participation(
            id: UUID(),
            challengeId: challengeId,
            imageData: image,
            userId: UUID(),
            timestamp: Date()
        )
        userParticipations.append(participation)
        try await Task.sleep(for: .seconds(1))  // Simulation de latence réseau
    }
    
    func getUserParticipation(for challengeId: UUID) async throws -> Participation? {
        try await Task.sleep(for: .seconds(0.5)) // simulate latency :D
        return userParticipations.first(where: { $0.challengeId == challengeId })
    }
}
