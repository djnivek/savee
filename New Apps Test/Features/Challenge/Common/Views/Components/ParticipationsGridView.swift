import SwiftUI

struct ParticipationsGridView: View {
    let participations: [ParticipationState]
    let hasParticipated: Bool
    let hapticManager: HapticManaging
    var onParticipate: (() -> Void)?
    var onPremiumAccess: (() -> Void)?
    
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
            
            ZStack {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(Array(participations.enumerated()), id: \.offset) { index, participation in
                        switch participation {
                        case .blurred:
                            BlurredImageCell()
                        case .visible(let imageData):
                            if let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
                
                LockedMosaicOverlay(
                    hasParticipated: hasParticipated,
                    hapticManager: hapticManager,
                    onParticipate: onParticipate,
                    onPremiumAccess: onPremiumAccess
                )
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
