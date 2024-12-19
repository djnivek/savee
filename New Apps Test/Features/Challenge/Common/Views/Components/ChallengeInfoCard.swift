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
    @State private var borderTimer: Timer?
    
    private let drawDuration: Double = 3
    private let displayDuration: Double = 10
    private let retractDuration: Double = 1.5
    
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
        .onAppear(perform: setupTimer)
        .onDisappear(perform: invalidateTimer)
    }
    
    private func setupTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            animateBorder()
        }
        
        borderTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            animateBorder()
        }
        
        if let borderTimer {
            RunLoop.main.add(borderTimer, forMode: .common)
        }
    }
    
    private func invalidateTimer() {
        borderTimer?.invalidate()
        borderTimer = nil
    }
    
    private func animateBorder() {
        borderProgress = 0
        showBorder = true
        
        withAnimation(.easeInOut(duration: drawDuration)) {
            borderProgress = progress
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + drawDuration + displayDuration) {
            withAnimation(.easeInOut(duration: retractDuration)) {
                borderProgress = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + retractDuration) {
                showBorder = false
            }
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
