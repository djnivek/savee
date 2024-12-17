//
//  ChallengeViewModel.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation
import SwiftUI

@Observable
class ChallengeViewModel {
    enum State {
        case loading
        case loaded(Challenge)
        case error(Error)
    }
    
    var hasParticipated: Bool {
        userParticipationIndex != nil
    }
    
    private let challengeService: ChallengeService
    private var timer: Timer?
    var participations: [ParticipationState] = Array(repeating: .blurred, count: 9)
    private var userParticipationIndex: Int?
    
    var state: State = .loading
    var timeRemaining: TimeInterval = 0
    
    init(challengeService: ChallengeService) {
        self.challengeService = challengeService
    }
    
    @MainActor
    func loadChallenge() async {
        state = .loading
        do {
            let challenge = try await challengeService.getCurrentChallenge()
            state = .loaded(challenge)
            startTimer(endTimestamp: challenge.endTimestamp)
        } catch {
            state = .error(error)
        }
    }
    
    @MainActor
    func submitParticipation(image: Data) async {
        do {
            try await challengeService.submitParticipation(image, for: Challenge.mocked.id)
            
            if let existingIndex = userParticipationIndex {
                participations[existingIndex] = .visible(image)
            } else {
                if let emptyIndex = participations.firstIndex(where: {
                    if case .blurred = $0 { return true } else { return false }
                }) {
                    participations[emptyIndex] = .visible(image)
                    userParticipationIndex = emptyIndex
                }
            }
            // TODO: handle success with a haptic feedback
        } catch {
            // TODO: handle error
        }
    }
    
    private func startTimer(endTimestamp: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimeRemaining(endTimestamp: endTimestamp)
        }
    }
    
    private func updateTimeRemaining(endTimestamp: TimeInterval) {
        let now = Date().timeIntervalSince1970
        timeRemaining = max(0, endTimestamp - now)
    }
    
    func formattedTimeRemaining() -> String {
        let hours = Int(timeRemaining) / 3600
        let minutes = Int(timeRemaining) / 60 % 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    deinit {
        timer?.invalidate()
    }
}
