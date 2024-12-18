//
//  ChallengeViewModel.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import Foundation
import SwiftUI

@Observable
class TodayChallengeViewModel {
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
    private let calculateProgress: CalculateChallengeProgressUseCase
    private var currentChallenge: Challenge?
    private var timer: Timer?
    var participations: [ParticipationState] = Array(repeating: .blurred, count: 9)
    private var userParticipationIndex: Int?
    
    var state: State = .loading
    var formattedTimeRemaining: String = "--:--:--"
    var progress: Double = 0
    
    init(
        challengeService: ChallengeService,
        formatTime: FormatChallengeTimeUseCase = DefaultFormatChallengeTimeUseCase(),
        calculateProgress: CalculateChallengeProgressUseCase = DefaultCalculateChallengeProgressUseCase()
    ) {
        self.challengeService = challengeService
        self.formatTime = formatTime
        self.calculateProgress = calculateProgress
    }
    
    deinit {
        stopTimer()
    }
    
    @MainActor
    func loadChallenge() async {
        stopTimer()
        state = .loading
        do {
            currentChallenge = try await challengeService.currentChallenge()
            guard let currentChallenge else { return }
            state = .loaded(currentChallenge)
            startTimer()
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
        } catch {
            // TODO: handle error
        }
    }
    
    private func updateTime() {
        guard let challenge = currentChallenge else { return }
        formattedTimeRemaining = formatTime.execute(challenge)
        progress = calculateProgress.execute(challenge)
    }
    
    func startTimer() {
        stopTimer()
        
        guard let challenge = currentChallenge else { return }
        updateTime()
        
        timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateTime()
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
