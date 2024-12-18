//
//  HomeView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    private var challengeService = MockChallengeService()
    private var unsplashService = UnsplashService()
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CustomSegmentedControl(
                    items: [
                        (.today, "Aujourd'hui"),
                        (.global, "Global"),
                        (.friends, "Amis")
                    ],
                    selection: $viewModel.selectedTab
                )
                .padding(.horizontal)
                
                TabView(selection: $viewModel.selectedTab) {
                    TodayChallengeView(viewModel: .init(challengeService: challengeService))
                        .tag(HomeTab.today)
                    
                    DiscoverView(viewModel: .init(unsplashService: unsplashService))
                        .tag(HomeTab.global)
                    
                    DiscoverView(viewModel: .init(unsplashService: unsplashService))
                        .tag(HomeTab.friends)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }
}
