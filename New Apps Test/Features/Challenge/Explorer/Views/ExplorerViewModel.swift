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
    
    let discoverViewModel: DiscoverGalleryViewModel
    let circleViewModel: CircleGalleryViewModel
    
    var selectedSection: ExplorerSection = .discover
    var previousChallenge: Challenge?
    var isShowingChallengeDetails = false
    
    init(
        discoverViewModel: DiscoverGalleryViewModel,
        circleViewModel: CircleGalleryViewModel,
        challengeService: ChallengeService
    ) {
        self.discoverViewModel = discoverViewModel
        self.circleViewModel = circleViewModel
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
