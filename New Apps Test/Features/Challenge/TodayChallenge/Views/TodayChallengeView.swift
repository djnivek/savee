//
//  ChallengeView.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 17/12/2024.
//

import SwiftUI

struct TodayChallengeView: View {
    @State private var viewModel: TodayChallengeViewModel
    @State private var showingSubmission = false
    
    let hapticManager: HapticManaging
    
    init(viewModel: TodayChallengeViewModel, hapticManager: HapticManaging) {
        self.viewModel = viewModel
        self.hapticManager = hapticManager
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
        }
        .task {
            await viewModel.loadChallenge()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
    
    @ViewBuilder
    private func challengeContent(_ challenge: Challenge) -> some View {
        VStack(spacing: 32) {
            ChallengeInfoCard(
                timeRemaining: viewModel.formattedTimeRemaining,
                progress: viewModel.progress,
                title: challenge.title,
                description: challenge.description
            )
            
            ParticipateButton(
                hasParticipated: viewModel.hasParticipated,
                showingSubmission: $showingSubmission
            )
            
            ParticipationsGridView(
                participations: viewModel.participations,
                hasParticipated: viewModel.hasParticipated,
                hapticManager: hapticManager,
                onParticipate: { showingSubmission = true },
                onPremiumAccess: {
                    print("Premium access required")
                }
            )
        }
        .sheet(isPresented: $showingSubmission) {
            ChallengeSubmissionView(
                isPresented: $showingSubmission
            ) { imageData in
                Task {
                    await viewModel.submitParticipation(image: imageData)
                }
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
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
    TodayChallengeView(
        viewModel: TodayChallengeViewModel(
            challengeService: MockChallengeService()
        ),
        hapticManager: DumbHapticManager())
}
