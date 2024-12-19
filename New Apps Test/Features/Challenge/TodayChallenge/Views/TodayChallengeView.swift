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
    @State private var shouldAnimate = false
    @State private var showConfetti = false
    
    
    let hapticManager: HapticManaging
    
    init(viewModel: TodayChallengeViewModel, hapticManager: HapticManaging) {
        self.viewModel = viewModel
        self.hapticManager = hapticManager
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                if showConfetti {
                    ConfettiFallView(isActive: $showConfetti)
                }
            }
        }
        .task {
            await viewModel.loadChallenge()
            try? await Task.sleep(for: .seconds(2.6))
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                shouldAnimate = true
            }
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
            .offset(y: shouldAnimate ? 0 : 50)
            .opacity(shouldAnimate ? 1 : 0)
            
            ParticipateButton(
                hasParticipated: viewModel.hasParticipated,
                showingSubmission: $showingSubmission
            )
            .offset(y: shouldAnimate ? 0 : 50)
            .opacity(shouldAnimate ? 1 : 0)
            
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
                    
                    if viewModel.hasParticipated {
                        showConfetti = true
                        hapticManager.playLandingSequence()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showConfetti = false
                        }
                    }
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
