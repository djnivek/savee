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
    private let formatTime: FormatChallengeTimeUseCase
    private var timer: Timer?
    var participations: [ParticipationState] = Array(repeating: .blurred, count: 9)
    private var userParticipationIndex: Int?
    
    var state: State = .loading
    var formattedTimeRemaining: String = "--:--:--"
    
    init(
        challengeService: ChallengeService,
        formatTime: FormatChallengeTimeUseCase = DefaultFormatChallengeTimeUseCase()
    ) {
        self.challengeService = challengeService
        self.formatTime = formatTime
    }
    
    @MainActor
    func loadChallenge() async {
        state = .loading
        do {
            let challenge = try await challengeService.getCurrentChallenge()
            state = .loaded(challenge)
            updateTimer(for: challenge)
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
    
    private func updateTimer(for challenge: Challenge) {
        timer?.invalidate()
        updateTime(for: challenge)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.updateTime(for: challenge)
        }
    }
    
    private func updateTime(for challenge: Challenge) {
        formattedTimeRemaining = formatTime.execute(challenge)
    }
    
    deinit {
        timer?.invalidate()
    }
}
