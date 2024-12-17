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
    
    private let challengeService: ChallengeService
    private var timer: Timer?
    
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
