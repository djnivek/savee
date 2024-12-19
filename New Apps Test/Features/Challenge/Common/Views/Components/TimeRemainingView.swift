import SwiftUI

struct TimeRemainingView: View {
    let timeRemaining: String
    let progress: Double
    
    @State private var borderProgress: Double = 0
    @State private var showBorder: Bool = false
    @State private var animationTask: Task<Void, Never>?
    
    private let drawDuration: Double = 3
    private let displayDuration: Double = 10
    private let retractDuration: Double = 1.5
    private let cycleInterval: Double = 30
    
    var body: some View {
        HStack(spacing: 8) {
            Text(timeRemaining)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .monospacedDigit()
            Image(systemName: "clock.circle.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
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
            while !Task.isCancelled {
                await animateBorder()
                
                do {
                    try await Task.sleep(for: .seconds(cycleInterval))
                } catch {
                    break
                }
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
    TimeRemainingView(timeRemaining: "00:00:00", progress: 0.75)
}
