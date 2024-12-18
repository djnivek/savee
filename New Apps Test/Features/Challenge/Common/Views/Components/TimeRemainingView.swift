import SwiftUI

struct TimeRemainingView: View {
    let timeRemaining: String
    
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
    }
}
