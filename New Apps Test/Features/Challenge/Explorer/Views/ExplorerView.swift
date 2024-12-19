//
//  ExplorerView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//


import SwiftUI

struct ExplorerView: View {
    @State private var viewModel: ExplorerViewModel
    private let unsplashService = UnsplashService()
    
    init(viewModel: ExplorerViewModel = .init(challengeService: MockChallengeService())) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                CustomSegmentedControl(
                    items: [
                        (.discover, ExplorerSection.discover.title),
                        (.circle, ExplorerSection.circle.title)
                    ],
                    selection: $viewModel.selectedSection
                )
                .padding(.horizontal)
                
                TabView(selection: $viewModel.selectedSection) {
                    DiscoverView(viewModel: .init(unsplashService: unsplashService))
                        .tag(ExplorerSection.discover)
                    
                    CircleView(viewModel: .init(unsplashService: unsplashService))
                        .tag(ExplorerSection.circle)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            FloatingActionButton {
                viewModel.isShowingChallengeDetails = true
            }
        }
        .sheet(
            isPresented: $viewModel.isShowingChallengeDetails,
            content: {
                if let challenge = viewModel.previousChallenge {
                    NavigationStack {
                        ChallengeDetailsView(challenge: challenge)
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                            .navigationTitle("Détails du challenge")
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
        )
        .task {
            await viewModel.loadPreviousChallenge()
        }
    }
}
