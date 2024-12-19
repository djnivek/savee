//
//  MockChallengeService.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

class MockChallengeService: ChallengeService {
    private var userParticipations: [Participation] = []
    private var mockedPreviousChallenge: Challenge = {
        let now = Date().timeIntervalSince1970
        let dayInSeconds: TimeInterval = 24 * 60 * 60
        
        return Challenge(
            id: UUID(),
            title: "Epic Sunset Alert!",
            description: "Snap the wackiest sunset you can find! Get creative with those golden hour vibes",
            startTimestamp: now - dayInSeconds,
            endTimestamp: now - 1
        )
    }()
    
    
    func currentChallenge() async throws -> Challenge {
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
    
    func userParticipation(for challengeId: UUID) async throws -> Participation? {
        try await Task.sleep(for: .seconds(0.5)) // simulate latency :D
        return userParticipations.first(where: { $0.challengeId == challengeId })
    }
    
    func previousChallenge() async throws -> Challenge {
        try await Task.sleep(for: .seconds(0.5))
        return mockedPreviousChallenge
    }
    
    func participations(for challengeId: UUID) async throws -> [Participation] {
        try await Task.sleep(for: .seconds(0.5))
        
        // Generate mocked participations - they won't be used anyway I think...
        return (0..<9).map { _ in
            Participation(
                id: UUID(),
                challengeId: challengeId,
                imageData: Data(),
                userId: UUID(),
                timestamp: Date().addingTimeInterval(-Double.random(in: 0...86400))
            )
        }
    }
}
