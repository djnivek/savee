import SwiftUI

struct ParticipateButton: View {
    var body: some View {
        Button {
            // TODO: Implémenter la soumission de photo
        } label: {
            Label("Je participe", systemImage: "camera.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
} 