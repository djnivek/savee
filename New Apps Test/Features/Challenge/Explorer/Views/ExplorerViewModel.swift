//
//  ExplorerViewModel.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 19/12/2024.
//

import Foundation

@Observable
final class ExplorerViewModel {
    private let challengeService: ChallengeService
    
    var selectedSection: ExplorerSection = .discover
    var previousChallenge: Challenge?
    var isShowingChallengeDetails = false
    
    init(challengeService: ChallengeService) {
        self.challengeService = challengeService
    }
    
    @MainActor
    func loadPreviousChallenge() async {
        do {
            previousChallenge = try await challengeService.previousChallenge()
        } catch {
            print("Erreur lors du chargement du challenge précédent: \(error)")
        }
    }
}
