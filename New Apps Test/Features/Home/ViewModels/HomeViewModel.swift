//
//  HomeViewModel.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

@Observable
final class HomeViewModel {
    private let challengeService: ChallengeService
    
    var selectedTab: HomeTab = .global
    
    init(challengeService: ChallengeService = MockChallengeService()) {
        self.challengeService = challengeService
    }
}
