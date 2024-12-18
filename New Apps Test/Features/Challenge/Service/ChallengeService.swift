//
//  ChallengeService.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

protocol ChallengeService {
    func currentChallenge() async throws -> Challenge
    func submitParticipation(_ image: Data, for challengeId: UUID) async throws
    func userParticipation(for challengeId: UUID) async throws -> Participation?
    
    func previousChallenge() async throws -> Challenge
    func participations(for challengeId: UUID) async throws -> [Participation]
}
