//
//  ChallengeService.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation

protocol ChallengeService {
    func getCurrentChallenge() async throws -> Challenge
    func submitParticipation(_ image: Data, for challengeId: UUID) async throws
    func getUserParticipation(for challengeId: UUID) async throws -> Participation?
}
