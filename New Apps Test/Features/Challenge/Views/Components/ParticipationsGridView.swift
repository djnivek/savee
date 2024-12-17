import SwiftUI

struct ParticipationsGridView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4)
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Ça se passe en ce moment")
                    .font(.headline)
                Spacer()
                Text("🔒")
                    .font(.title3)
            }
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(0..<9) { _ in
                    BlurredImageCell()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct BlurredImageCell: View {
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                .overlay {
                    Color.random
                        .opacity(0.3)
                        .blur(radius: 20)
                }
                .overlay {
                    Rectangle()
                        .fill(.black.opacity(0.1))
                        .allowsHitTesting(false)
                }
        }
        .aspectRatio(1, contentMode: .fit)
        .allowsHitTesting(false)
    }
} 