import SwiftUI

struct TimeRemainingView: View {
    let timeRemaining: String
    let progress: Double
    
    @State private var borderProgress: Double = 0
    @State private var showBorder: Bool = false
    
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
        .onAppear(perform: startAnimationCycle)
    }
    
    private func startAnimationCycle() {
        animateBorder()
        
        Timer.scheduledTimer(withTimeInterval: cycleInterval, repeats: true) { _ in
            animateBorder()
        }
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
    TimeRemainingView(timeRemaining: "00:00:00", progress: 0.75)
}
