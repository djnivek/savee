//
//  ChallengeView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import SwiftUI

struct TodayChallengeView: View {
    @State private var viewModel: TodayChallengeViewModel
    
    init(viewModel: TodayChallengeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    switch viewModel.state {
                    case .loading:
                        ProgressView()
                            .scaleEffect(1.5)
                    
                    case .loaded(let challenge):
                        challengeContent(challenge)
                        
                    case .error:
                        ErrorView {
                            await viewModel.loadChallenge()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Challenge du jour")
        }
        .task {
            await viewModel.loadChallenge()
        }
    }
    
    @ViewBuilder
    private func challengeContent(_ challenge: Challenge) -> some View {
        VStack(spacing: 32) {
            TimeRemainingView(timeRemaining: viewModel.formattedTimeRemaining)
            
            ChallengeInfoView(
                title: challenge.title,
                description: challenge.description
            )
            
            ParticipateButton(
                hasParticipated: viewModel.hasParticipated
            ) { imageData in
                Task {
                    await viewModel.submitParticipation(image: imageData)
                }
            }
            
            ParticipationsGridView(participations: viewModel.participations)
        }
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}


#Preview {
    TodayChallengeView(viewModel: TodayChallengeViewModel(
        challengeService: MockChallengeService()
    ))
}
