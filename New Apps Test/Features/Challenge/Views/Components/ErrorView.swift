import SwiftUI

struct ErrorView: View {
    let retryAction: () async -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.red)
            Text("Oops ! Impossible de charger le challenge")
                .font(.headline)
            Button("Réessayer") {
                Task {
                    await retryAction()
                }
            }
            .buttonStyle(.bordered)
        }
    }
} 