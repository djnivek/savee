//
//  ChallengeInfoCard.swift
//  New Apps Test
//
//  Created by Kevin MACHADO on 18/12/2024.
//

import SwiftUI

struct ChallengeInfoCard: View {
    let timeRemaining: String
    let progress: Double
    let title: String
    let description: String
    
    @State private var borderProgress: Double = 0
    @State private var showBorder: Bool = false
    @State private var animationTask: Task<Void, Never>?
    
    private let drawDuration: Double = 3
    private let displayDuration: Double = 10
    private let retractDuration: Double = 1.5
    private let cycleInterval: Double = 30
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 8) {
                Text(timeRemaining)
                    .font(.title2.bold())
                    .monospacedDigit()
                Image(systemName: "clock.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title.bold())
                Text(description)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
        .overlay {
            AnimatedBorder(
                progress: borderProgress,
                shouldShow: showBorder
            )
        }
        .task {
            await startAnimationCycle()
        }
        .onDisappear {
            animationTask?.cancel()
        }
    }
    
    private func startAnimationCycle() async {
        animationTask?.cancel()
        
        animationTask = Task {
            try? await Task.sleep(for: .seconds(2.8))
            
            while !Task.isCancelled {
                await animateBorder()
                try? await Task.sleep(for: .seconds(cycleInterval))
            }
        }
    }
    
    private func animateBorder() async {
        guard !Task.isCancelled else { return }
        
        await MainActor.run {
            borderProgress = 0
            showBorder = true
        }
        
        withAnimation(.easeInOut(duration: drawDuration)) {
            borderProgress = progress
        }
        
        try? await Task.sleep(for: .seconds(drawDuration + displayDuration))
        guard !Task.isCancelled else { return }
        
        withAnimation(.easeInOut(duration: retractDuration)) {
            borderProgress = 0
        }
        
        try? await Task.sleep(for: .seconds(retractDuration))
        guard !Task.isCancelled else { return }
        
        await MainActor.run {
            showBorder = false
        }
    }
}

#Preview {
    ChallengeInfoCard(
        timeRemaining: "00-00-00",
        progress: 0.8,
        title: "Test",
        description: "The description")
}
