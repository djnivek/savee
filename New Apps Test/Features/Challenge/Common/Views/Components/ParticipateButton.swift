import SwiftUI

struct ParticipateButton: View {
    let hasParticipated: Bool
    @Binding var showingSubmission: Bool
    
    var body: some View {
        Button {
            showingSubmission = true
        } label: {
            if hasParticipated {
                Label("Participation envoyée !", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.gray.opacity(0.3))
                    .foregroundColor(.secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                Label("J'accepte le challenge !", systemImage: "camera.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .disabled(hasParticipated)
    }
}
